# Phase 3: Ralph Integration - Research

**Researched:** 2026-03-22
**Domain:** Chezmoi dotfiles, Claude Code CLI, Ralph agent loop, DevPod containers
**Confidence:** HIGH

## Summary

Phase 3 adds three capabilities to the dotfiles: (1) `ralph.sh` on the PATH so any container can run `ralph`; (2) setup.sh installs the Claude Code CLI so `claude --version` works after provisioning; (3) `~/.claude/CLAUDE.md` pre-populated with Ralph conventions so new projects start ready.

The architecture decisions from milestone setup are technically sound. The native Claude Code installer (`curl -fsSL https://claude.ai/install.sh | bash`) places the binary at `~/.local/bin/claude`, which is already on PATH in `dot_zshrc`. The existing `$SCRIPTS` path variable (`$DOTFILES/scripts`) means ralph.sh drops directly into `scripts/` and is immediately callable as `ralph`. The existing `dot_config/claude/CLAUDE.md` (which maps to `~/.config/claude/CLAUDE.md`) is the wrong location — Claude Code reads user-level instructions from `~/.claude/CLAUDE.md`, which requires a new `dot_claude/` directory in the chezmoi source.

**Primary recommendation:** Add `scripts/ralph.sh` (symlink-free, directly on `$SCRIPTS` PATH), install Claude Code via native installer in `setup`, and create `dot_claude/CLAUDE.md` with Ralph conventions. Three file changes total.

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| RALPH-01 | User can run `ralph` from any project directory inside a DevPod container | `$SCRIPTS` is already on PATH in dot_zshrc; placing ralph.sh in scripts/ satisfies this without any PATH changes |
| RALPH-02 | User can provision a container with Node and Claude Code CLI installed via setup script | Native installer places claude at `~/.local/bin/claude`; Node is already in mise/config.toml; setup.sh must run the native installer with a container guard |
| RALPH-03 | Claude Code auto-reads a global CLAUDE.md on every session start (mapped via chezmoi to ~/.claude/CLAUDE.md) | Confirmed: `~/.claude/CLAUDE.md` is the user-scope location; chezmoi source must be `dot_claude/CLAUDE.md` |
| RALPH-04 | CLAUDE.md is pre-populated with Ralph conventions so new projects need minimal setup | Ralph CLAUDE.md contains a 10-step workflow, progress reporting format, pattern consolidation rules, quality gates, and stop condition |
</phase_requirements>

## Standard Stack

### Core
| Library / Tool | Version | Purpose | Why Standard |
|----------------|---------|---------|--------------|
| Claude Code (native) | 2.1.81 | AI coding CLI that ralph.sh invokes | Official Anthropic installer; npm install deprecated |
| ralph.sh | main branch | Agent loop script | The sole implementation; no alternatives |
| chezmoi | latest (in mise) | Dotfile management | Already in use; maps `dot_claude/` to `~/.claude/` |
| jq | system | ralph.sh dependency — reads branchName from prd.json | Required by ralph.sh; already common in DevPod images |

### Supporting
| Library / Tool | Version | Purpose | When to Use |
|----------------|---------|---------|-------------|
| Node.js | latest (in mise) | Runtime for Claude Code (npm fallback path) | Already in mise/config.toml — leave it there |
| mise | latest | Manages Node version in containers | Already in setup flow; no changes needed |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Native installer (`install.sh`) | `npm install -g @anthropic-ai/claude-code` | npm path is deprecated as of early 2026; native installer auto-updates, no Node dependency at install time, places binary at `~/.local/bin/claude` |
| `scripts/ralph.sh` via `$SCRIPTS` | `dot_local/bin/ralph` symlink | `$SCRIPTS` path is already set in dot_zshrc and already works; no new PATH entry needed |
| `dot_claude/CLAUDE.md` | `dot_config/claude/CLAUDE.md` | `~/.config/claude/CLAUDE.md` is NOT read by Claude Code; must use `~/.claude/CLAUDE.md` |

**Installation (in setup script):**
```bash
# Native installer — places binary at ~/.local/bin/claude
curl -fsSL https://claude.ai/install.sh | bash
```

## Architecture Patterns

### Recommended Chezmoi Source Structure (additions only)
```
dotfiles/
├── scripts/
│   └── ralph.sh          # New: the ralph agent loop script
├── dot_claude/
│   └── CLAUDE.md         # New: maps to ~/.claude/CLAUDE.md (user-scope)
│   └── skills/           # New: maps to ~/.claude/skills/ (global Claude Code skills)
│       ├── prd/
│       │   └── SKILL.md
│       └── ralph/
│           └── SKILL.md
├── dot_config/
│   └── claude/
│       └── CLAUDE.md     # Existing: maps to ~/.config/claude/CLAUDE.md — NOT read by Claude Code; can be removed or left
└── setup                 # Modified: add native installer call
```

### Pattern 1: Ralph on PATH via $SCRIPTS

The existing `dot_zshrc` sets:
```bash
export DOTFILES="$HOME/.local/share/chezmoi"
export SCRIPTS="$DOTFILES/scripts"
```

And `$SCRIPTS` is in the `path=()` array. Chezmoi applies the source repo to `~/.local/share/chezmoi` via `chezmoi init --apply`. This means `scripts/ralph.sh` in the dotfiles repo becomes `~/.local/share/chezmoi/scripts/ralph.sh`, which is exactly `$SCRIPTS/ralph.sh` — callable as `ralph` with no further configuration.

ralph.sh must be executable (`chmod +x`). Chezmoi respects executable bits on source files.

### Pattern 2: Claude Code Native Installer in setup

The native installer:
- Downloads from `https://storage.googleapis.com` (not blocked in standard DevPod images)
- Places binary at `~/.local/bin/claude` — already on PATH in dot_zshrc
- Requires at least 4 GB RAM (standard DevPod containers)
- Hangs if run from `/` root directory — must be run from a working directory (`/tmp` or `$HOME`)
- Does NOT require sudo or root
- Alpine Linux needs `apk add libgcc libstdc++ ripgrep` first

Setup guard pattern (consistent with existing container guard):
```bash
if ! command -v claude >/dev/null; then
  cd /tmp && curl -fsSL https://claude.ai/install.sh | bash
fi
```

### Pattern 3: ~/.claude/CLAUDE.md User Scope

Claude Code reads CLAUDE.md files in this priority order:
1. `/etc/claude-code/CLAUDE.md` — org-managed (not relevant here)
2. `~/.claude/CLAUDE.md` — user scope, all projects (**this is what we need**)
3. `./CLAUDE.md` or `./.claude/CLAUDE.md` — project scope
4. Subdirectory CLAUDE.md files — loaded on demand

Chezmoi maps `dot_claude/` → `~/.claude/`. So:
- Source: `dot_claude/CLAUDE.md` → Target: `~/.claude/CLAUDE.md`
- Source: `dot_claude/skills/ralph/SKILL.md` → Target: `~/.claude/skills/ralph/SKILL.md`

The existing `dot_config/claude/CLAUDE.md` (→ `~/.config/claude/CLAUDE.md`) is NOT in the Claude Code load path. It should be removed or left empty — it will never be auto-read.

### Pattern 4: Ralph File Roles (global vs per-project)

| File | Location | Scope | Who creates it |
|------|----------|-------|----------------|
| `ralph.sh` | `~/.local/share/chezmoi/scripts/ralph.sh` (via dotfiles) | Global, all containers | Dotfiles (copy from ralph repo) |
| `CLAUDE.md` (user) | `~/.claude/CLAUDE.md` (via dotfiles) | Global, all projects | Dotfiles (pre-populated with Ralph conventions) |
| `skills/ralph/SKILL.md` | `~/.claude/skills/ralph/SKILL.md` (via dotfiles) | Global | Dotfiles (copy from ralph repo) |
| `skills/prd/SKILL.md` | `~/.claude/skills/prd/SKILL.md` (via dotfiles) | Global | Dotfiles (copy from ralph repo) |
| `prd.json` | `./prd.json` (project root) | Per-project | Developer creates per project |
| `progress.txt` | `./progress.txt` (project root) | Per-project | Ralph creates/appends |
| `CLAUDE.md` (project) | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Per-project | Developer creates per project |

### Pattern 5: ralph.sh Invocation

Ralph invokes Claude Code with:
```bash
claude --dangerously-skip-permissions --print < "$SCRIPT_DIR/CLAUDE.md"
```

`$SCRIPT_DIR` is resolved via `"${BASH_SOURCE[0]}"`. When ralph.sh lives in `$SCRIPTS`, `$SCRIPT_DIR` will be `~/.local/share/chezmoi/scripts/`. This means the CLAUDE.md that ralph.sh reads as its prompt template is NOT `~/.claude/CLAUDE.md` — it's a per-project CLAUDE.md that ralph.sh expects in its own directory OR the project directory.

**Key distinction:** There are two different CLAUDE.md files in play:
1. `~/.claude/CLAUDE.md` — auto-read by Claude Code at session start (global conventions)
2. `CLAUDE.md` passed as stdin to `claude --print` by ralph.sh — this is the per-invocation task prompt

The dotfiles provide #1. Each project provides #2 (or can default to ralph repo's template).

### Anti-Patterns to Avoid

- **Installing claude with sudo:** `sudo npm install -g` causes permission issues and installs to root-owned paths. Never use sudo for Claude Code install.
- **Running native installer from `/`:** Causes the installer to scan the entire filesystem, leading to hangs and excessive memory use. Always `cd /tmp` first.
- **Using dot_config/claude/ for global CLAUDE.md:** `~/.config/claude/CLAUDE.md` is not read by Claude Code. Only `~/.claude/CLAUDE.md` is the user-scope location.
- **Putting prd.json in dotfiles:** prd.json is per-project state — it MUST stay out of dotfiles.
- **Adding Claude Code to mise/config.toml:** Setup.sh handles it directly; mise is per-project tool management.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Agent loop iteration | Custom bash loop | `ralph.sh` from snarktank/ralph | Handles branch tracking, archive rotation, COMPLETE signal detection, iteration limits |
| PRD authoring | Custom template | `skills/prd/SKILL.md` Claude Code skill | Structured clarification flow, story sizing guidance built in |
| PRD-to-JSON conversion | Custom parser | `skills/ralph/SKILL.md` Claude Code skill | Handles dependency ordering, right-sizing stories to one context window |
| Claude Code installation | Compile from source | `curl -fsSL https://claude.ai/install.sh \| bash` | Native installer is self-contained, auto-updates, signed binary |
| PATH setup for ralph | Separate symlink or wrapper | `$SCRIPTS` path already in dot_zshrc | No new configuration needed |

**Key insight:** ralph.sh handles everything complex (branch detection, archive management, loop control). The dotfiles job is purely distribution — get the right files to the right locations.

## Common Pitfalls

### Pitfall 1: Wrong CLAUDE.md Location
**What goes wrong:** `dot_config/claude/CLAUDE.md` already exists in the repo but maps to `~/.config/claude/CLAUDE.md`, which Claude Code never reads. New containers will have an empty or absent `~/.claude/CLAUDE.md`.
**Why it happens:** The XDG config path looks plausible but Claude Code uses its own `~/.claude/` directory, not `~/.config/claude/`.
**How to avoid:** Create `dot_claude/CLAUDE.md` in chezmoi source. Remove or leave `dot_config/claude/CLAUDE.md` with a comment explaining it is not auto-read.
**Warning signs:** Running `/memory` in a Claude Code session and not seeing the user CLAUDE.md listed.

### Pitfall 2: Native Installer Hangs in Container
**What goes wrong:** Running `curl -fsSL https://claude.ai/install.sh | bash` from `/` (the default working directory when setup.sh is run as root in a container) causes the installer to scan the entire filesystem, hanging or OOM-killing.
**Why it happens:** The installer's file scan starts at the current directory.
**How to avoid:** Always `cd /tmp` before running the installer in setup.sh.
**Warning signs:** setup.sh hangs indefinitely on the curl|bash line.

### Pitfall 3: ralph.sh Not Executable
**What goes wrong:** `ralph` command gives "Permission denied" even though the script is on PATH.
**Why it happens:** Files added to git without `chmod +x` lose executable bit; chezmoi preserves the file mode from the source repo.
**How to avoid:** `chmod +x scripts/ralph.sh` before committing; verify with `ls -la scripts/ralph.sh`.
**Warning signs:** `which ralph` finds the file but `ralph` fails with permission error.

### Pitfall 4: jq Not Available in Container
**What goes wrong:** ralph.sh fails with `jq: command not found` when reading `prd.json`.
**Why it happens:** jq is a ralph.sh dependency but not in mise/config.toml and not guaranteed in all DevPod base images.
**How to avoid:** Either add jq to setup.sh (apt-get install jq) or document it as a requirement. Check if the DevPod Ubuntu base image includes it by default (it often does).
**Warning signs:** ralph.sh runs then immediately errors on the prd.json parsing line.

### Pitfall 5: Claude Code RAM Requirement
**What goes wrong:** Native installer is killed mid-install in a low-memory container.
**Why it happens:** Claude Code requires 4 GB RAM minimum; some DevPod configurations default lower.
**How to avoid:** Document the 4 GB requirement. Add swap space if needed (2 GB swapfile in setup.sh as fallback).
**Warning signs:** setup.sh shows `Killed` after the installer curl command.

### Pitfall 6: ralph.sh $SCRIPT_DIR Points to Wrong CLAUDE.md
**What goes wrong:** ralph.sh looks for CLAUDE.md relative to the script's own directory (`~/.local/share/chezmoi/scripts/CLAUDE.md`), not the project directory.
**Why it happens:** ralph.sh resolves its prompt template path from `"${BASH_SOURCE[0]}"`.
**How to avoid:** Each project that uses ralph must either have its own CLAUDE.md in the project root, or ralph.sh can be modified to fall back to the project directory. The global `~/.claude/CLAUDE.md` serves a different purpose (Claude Code auto-context) and is not the prompt template.
**Warning signs:** ralph loops but Claude Code output lacks project context.

## Code Examples

Verified patterns from official sources:

### setup.sh — Add Claude Code Native Installer
```bash
# Source: https://code.claude.com/docs/en/setup
# Must cd first to avoid filesystem scan hang in containers
if ! command -v claude >/dev/null; then
  cd /tmp && curl -fsSL https://claude.ai/install.sh | bash
fi
```

### dot_claude/CLAUDE.md — Ralph Conventions Template
Based on https://raw.githubusercontent.com/snarktank/ralph/main/CLAUDE.md (fetched 2026-03-22):
```markdown
# Ralph Agent Instructions

## Your Task
Read the PRD (prd.json) and progress log (progress.txt), then implement the highest-priority
incomplete user story. One story per iteration.

1. Read prd.json to find the highest-priority story where passes=false
2. Read progress.txt for context on what has already been done
3. Checkout or create the feature branch from prd.json branchName
4. Implement the story — one story only
5. Run quality checks: typecheck, lint, tests
6. Commit: "feat: [Story ID] - [Story Title]"
7. APPEND to progress.txt (never replace): date, story ID, files changed, learnings
8. If ALL stories pass: reply <promise>COMPLETE</promise>
9. If stories remain: stop and wait for next iteration

## Progress Report Format
Append to progress.txt (never replace):
- Date and story ID
- What was implemented
- Files changed
- Patterns discovered (add to Codebase Patterns section at top)

## Update CLAUDE.md Files
When editing a directory, add discoverable knowledge to the nearest CLAUDE.md:
API patterns, gotchas, dependencies — not story-specific details.

## Quality Requirements
- All commits must pass typecheck, lint, and tests
- No broken code merges

## Stop Condition
Reply with <promise>COMPLETE</promise> only when ALL stories in prd.json have passes=true.
```

### Chezmoi Source — Executable Script
```bash
# In dotfiles repo before committing ralph.sh:
chmod +x scripts/ralph.sh
git add scripts/ralph.sh
# Chezmoi preserves the executable bit
```

### Verify CLAUDE.md Location at Runtime
```bash
# Inside a Claude Code session:
/memory
# Should list ~/.claude/CLAUDE.md in the loaded files
```

### Alpine Linux Container Extra Steps
```bash
# Source: https://code.claude.com/docs/en/setup#alpine-linux-and-musl-based-distributions
apk add libgcc libstdc++ ripgrep
# Then install claude normally:
cd /tmp && curl -fsSL https://claude.ai/install.sh | bash
# Set in ~/.claude/settings.json:
# { "env": { "USE_BUILTIN_RIPGREP": "0" } }
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `npm install -g @anthropic-ai/claude-code` | `curl -fsSL https://claude.ai/install.sh \| bash` | Early 2026 | npm path deprecated; native installer is self-contained, auto-updates, no Node.js dependency |
| `~/.config/claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Claude Code design | `~/.config/claude/` was never the correct path; `~/.claude/` is the official user-scope location |
| ralph.sh must live in project | ralph.sh global + per-project CLAUDE.md | ralph README Option 1 vs Option 2 | Global install gives cross-project reuse; skills in `~/.claude/skills/` work the same way |

**Deprecated/outdated:**
- `npm install -g @anthropic-ai/claude-code`: deprecated as of early 2026; native installer recommended
- `dot_config/claude/CLAUDE.md`: never valid for Claude Code auto-read; should be removed or annotated

## Open Questions

1. **Does the DevPod Ubuntu base image include jq?**
   - What we know: ralph.sh requires jq to parse prd.json; jq is common in Ubuntu images but not guaranteed
   - What's unclear: whether DevPod's default devcontainer image ships with jq
   - Recommendation: Add `command -v jq >/dev/null || apt-get install -y jq` guard to setup.sh, or document as manual prereq

2. **Should dot_config/claude/CLAUDE.md be deleted?**
   - What we know: it maps to `~/.config/claude/CLAUDE.md` which Claude Code does not read
   - What's unclear: whether any other tool reads from `~/.config/claude/`
   - Recommendation: Either delete it (clean) or add a comment: "NOT read by Claude Code — use ~/.claude/CLAUDE.md via dot_claude/"

3. **Should skills/ be included in dotfiles?**
   - What we know: `~/.claude/skills/` is the global skills location; the ralph repo has `skills/prd/` and `skills/ralph/` SKILL.md files
   - What's unclear: whether the user wants these global skills or prefers to install per-project
   - Recommendation: Include both skills — they are lightweight (SKILL.md files only) and add PRD generation + conversion capabilities to all containers at zero cost

## Sources

### Primary (HIGH confidence)
- `https://code.claude.com/docs/en/memory` — CLAUDE.md load locations, `~/.claude/CLAUDE.md` confirmed as user-scope
- `https://code.claude.com/docs/en/setup` — Native installer command, PATH location (`~/.local/bin/claude`), Alpine Linux requirements, Docker container hang fix
- `https://raw.githubusercontent.com/snarktank/ralph/main/ralph.sh` — ralph.sh dependencies, invocation pattern, file expectations
- `https://raw.githubusercontent.com/snarktank/ralph/main/CLAUDE.md` — Ralph conventions content
- `https://raw.githubusercontent.com/snarktank/ralph/main/README.md` — Installation options, file layout

### Secondary (MEDIUM confidence)
- `https://github.com/anthropics/claude-code/issues/24568` and related issues — npm deprecation confirmed, native installer recommended for Docker
- `https://raw.githubusercontent.com/snarktank/ralph/main/skills/ralph/SKILL.md` — ralph skill purpose and behavior
- `https://raw.githubusercontent.com/snarktank/ralph/main/skills/prd/SKILL.md` — prd skill purpose and behavior

### Tertiary (LOW confidence)
- None — all critical claims verified against official sources

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — claude.ai official docs confirm native installer, npm deprecated; ralph.sh fetched directly from source
- Architecture: HIGH — chezmoi source-to-target mapping is deterministic; CLAUDE.md load path confirmed from official docs
- Pitfalls: HIGH — docker hang, executable bit, wrong CLAUDE.md path all verified from official documentation

**Research date:** 2026-03-22
**Valid until:** 2026-04-22 (Claude Code installer method stable; ralph.sh main branch may evolve)

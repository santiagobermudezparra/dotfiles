---
phase: 03-ralph-integration
plan: "01"
subsystem: dotfiles/ralph
tags: [ralph, claude-code, chezmoi, agent-loop, skills]
dependency_graph:
  requires: []
  provides: [scripts/ralph, dot_claude/CLAUDE.md, dot_claude/skills/ralph/SKILL.md, dot_claude/skills/prd/SKILL.md]
  affects: [chezmoi-apply, devpod-provisioning]
tech_stack:
  added: []
  patterns: [chezmoi-dot-prefix-mapping, executable-script-on-SCRIPTS-PATH]
key_files:
  created:
    - scripts/ralph
    - dot_claude/CLAUDE.md
    - dot_claude/skills/ralph/SKILL.md
    - dot_claude/skills/prd/SKILL.md
  modified: []
  deleted:
    - dot_config/claude/CLAUDE.md
decisions:
  - "Fetched ralph.sh directly from snarktank/ralph main branch — authoritative source, preserves all features including branch-archiving and amp/claude dual-tool support"
  - "dot_config/claude/CLAUDE.md was untracked (empty, never committed) — deletion required no git operation"
  - "skills placed at dot_claude/skills/ to map to ~/.claude/skills/ — global scope across all projects in all containers"
metrics:
  duration: "~5 minutes"
  completed_date: "2026-03-22"
  tasks_completed: 2
  files_changed: 5
---

# Phase 03 Plan 01: Ralph Script and Global CLAUDE.md Summary

Ralph agent loop script, global CLAUDE.md with Ralph conventions, and PRD skills added to dotfiles via chezmoi dot_claude/ mapping; wrong-path dot_config/claude/CLAUDE.md removed.

## What Was Built

Four files created in the chezmoi source tree that provision every DevPod container with Ralph capabilities:

1. **`scripts/ralph`** — The Ralph Wiggum agent loop script (from `snarktank/ralph` main branch). Fetched directly from GitHub. Executable bit set. Lives in `$SCRIPTS` so it is immediately callable as `ralph` in any container.

2. **`dot_claude/CLAUDE.md`** — Maps to `~/.claude/CLAUDE.md` via chezmoi's `dot_` prefix convention. Claude Code auto-reads this file at every session start. Contains the 9-step Ralph workflow, progress report format, CLAUDE.md update discipline, quality requirements, and the COMPLETE stop condition.

3. **`dot_claude/skills/ralph/SKILL.md`** — Ralph PRD Converter skill. Maps to `~/.claude/skills/ralph/SKILL.md`. Teaches Claude Code how to convert existing PRDs to prd.json format with correct story sizing, dependency ordering, and verifiable acceptance criteria.

4. **`dot_claude/skills/prd/SKILL.md`** — PRD Generator skill. Maps to `~/.claude/skills/prd/SKILL.md`. Provides the 3-step workflow: clarifying questions with lettered options, 9-section PRD structure, file output to `tasks/prd-[name].md`.

One file removed: `dot_config/claude/CLAUDE.md` — this was an empty untracked file that mapped to `~/.config/claude/CLAUDE.md`, a path Claude Code does NOT read. Deleted from filesystem; no git operation required as it was never tracked.

## Commits

| Task | Commit | Description |
|------|--------|-------------|
| Task 1 | 71c3e3d | feat(03-01): add ralph script, global CLAUDE.md, and claude skills |
| Task 2 | (no commit) | dot_config/claude/CLAUDE.md was untracked — filesystem delete only |

## Deviations from Plan

### Auto-fixed Issues

None.

### Observed Differences

**1. dot_config/claude/CLAUDE.md was untracked**
- **Found during:** Task 2
- **Issue:** The plan described deleting `dot_config/claude/CLAUDE.md` and committing the deletion. The file was an empty (0-byte), untracked file — it existed on the filesystem but had never been committed to git.
- **Fix:** Deleted from filesystem. No git staging or commit needed.
- **Files modified:** none (untracked file deleted)
- **Commit:** N/A

## Key Links (Chezmoi Mappings)

| Source (dotfiles repo) | Target (container home) | Via |
|------------------------|-------------------------|-----|
| `scripts/ralph` | `~/.local/share/chezmoi/scripts/ralph` → on PATH as `ralph` | `$SCRIPTS` in dot_zshrc |
| `dot_claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | chezmoi `dot_` prefix |
| `dot_claude/skills/ralph/SKILL.md` | `~/.claude/skills/ralph/SKILL.md` | chezmoi `dot_` prefix |
| `dot_claude/skills/prd/SKILL.md` | `~/.claude/skills/prd/SKILL.md` | chezmoi `dot_` prefix |

## Known Stubs

None — all files contain full production content fetched from authoritative sources.

## Self-Check: PASSED

- [x] scripts/ralph exists and is executable: confirmed (`-rwxr-xr-x`)
- [x] dot_claude/CLAUDE.md exists with prd.json, progress.txt, COMPLETE, quality checks, all 9 steps
- [x] dot_claude/skills/ralph/SKILL.md exists (258 lines, PRD-to-JSON conversion rules)
- [x] dot_claude/skills/prd/SKILL.md exists (241 lines, PRD generator workflow)
- [x] dot_config/claude/CLAUDE.md does not exist (verified with `test ! -f`)
- [x] Commit 71c3e3d verified in git log

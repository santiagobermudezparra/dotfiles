# Phase 1: Audit - Research

**Researched:** 2026-03-22
**Domain:** Dotfiles audit — shell scripts, zshrc, mise config, chezmoi structure
**Confidence:** HIGH (all findings from direct file inspection of the actual repo)

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Report structure:**
- D-01: Single file: `AUDIT-REPORT.md` at the repo root (not in .planning/)
- D-02: Organized in sections (not a flat table): Scripts → Tools/Config → Env Vars & Aliases → Missing Tools → Suggestions
- D-03: Each section uses a table with columns relevant to that section (e.g., scripts: Name | Classification | Reason | Notes)

**Script classification buckets:**
- D-04: Three buckets: **Keep** (generic/useful), **Remove** (YouTuber-specific or clearly not yours), **Review** (unclear — might be yours, needs your input)
- D-05: Scripts with hardcoded `/users/mischa/` paths are auto-classified as Remove
- D-06: Scripts using tools that don't exist in a container (pomo, newsboat, brightnessctl, osascript) are classified as Remove
- D-07: Generic shell utilities (urlencode, gendate, m, push, reprename, bulkreplace, jqedit) are Keep candidates

**YouTuber-specific tool flagging:**
- D-08: Flag tools across ALL files: zshrc aliases, mise config, setup script, and scripts/
- D-09: Known YouTuber tools to flag: pomo, newsboat, brightnessctl, osascript, vivaldi, lazygit (if not in mise), pass, dnd (macOS-only)
- D-10: K8s tools (kubectl, flux, k3d) are legitimate for the user — flag as Keep (user has a K8s homelab via DevPod)

**Env vars & aliases:**
- D-11: Flag these zshrc vars as personal/missing: $ICLOUD, $ZETTELKASTEN, $LAB, $REPOS (verify if user has this), GITUSER (has the YouTuber's username)
- D-12: Flag aliases pointing to YouTuber-specific dirs: cdblog, in, cdzk, cdgo, homelab, hl (verify homelab — user has K8s homelab)
- D-13: GITUSER is set to "santiagobermudezparra" — this is the user's own, mark as Keep but note it's hardcoded

**Missing tools suggestions:**
- D-14: Suggest additions the user explicitly wants: Node (via setup.sh, not mise global), Claude Code CLI (via setup.sh)
- D-15: Suggest useful DevPod additions: gh (GitHub CLI), lazygit, direnv, delta (better git diff)
- D-16: Note that Python will be handled per-project via mise locals — do NOT suggest adding to global mise config

**Suggestions scope:**
- D-17: Suggestions should be concrete and actionable, not vague ("add X by doing Y")
- D-18: Include a "DevPod readiness" section: what works today in a container vs what assumes macOS/desktop

### Claude's Discretion
- Exact wording and phrasing in the report
- Whether to include a summary section at the top
- How to handle edge cases (scripts that are generic but reference YouTuber tooling indirectly)

### Deferred Ideas (OUT OF SCOPE)
- CLAUDE.md path fix (dot_claude/ vs dot_config/claude/) — Phase 3
- Ralph integration (ralph.sh, skills/, CLAUDE.md template) — Phase 3
- Actual deletion of flagged files — Phase 2
- Adding Node + Claude Code CLI to setup.sh — Phase 3
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| AUDIT-01 | User can read a report classifying every script as generic, YouTuber-specific, or remove candidate | Full script inventory below — all 46 scripts classified |
| AUDIT-02 | User can see all YouTuber-specific tools flagged across all configs (newsboat, pomo, brightnessctl, osascript, etc.) | Tool flags found in zshrc aliases, tmux.conf status-right, scripts/ |
| AUDIT-03 | User can see all env vars and aliases in zshrc that reference non-existent or personal paths ($ICLOUD, $ZETTELKASTEN, $LAB, etc.) | Full zshrc inspection completed — all personal path refs identified |
| AUDIT-04 | User can see a list of missing tools for their workflow with suggested additions | Gaps in mise config vs. user's actual needs identified |
| AUDIT-05 | User can read concrete suggestions for improving this as a DevPod base image | Container vs. desktop analysis completed — specific items listed |
</phase_requirements>

---

## Summary

This phase produces a single `AUDIT-REPORT.md` at the repo root. The report is purely observational — no files are deleted or modified. The planner's job is to write tasks that read every relevant file in the repo and produce that report.

The repo is a chezmoi-managed dotfiles set inherited from Mischa van den Burg (YouTuber). The user has already made some personalizations (GITUSER, GitHub URL in setup, K8s tooling) but most content is still YouTuber-original. The audit must distinguish what belongs to the user, what belongs to the YouTuber, and what is genuinely generic.

**Primary recommendation:** The AUDIT-REPORT.md is written by Claude reading the actual files in the repo and applying the classification rules in CONTEXT.md. There are no external dependencies — no tools to run, no APIs to call. Every finding comes from direct file inspection.

---

## Complete File Inventory

### Scripts Directory (46 scripts)

Full classification of every script found in `scripts/`, verified by reading each file:

| Script | Classification | Reason |
|--------|---------------|--------|
| `0-cd` | Keep | Generic fzf-based directory navigation, no personal paths |
| `backup` | Remove | Hardcoded `/data-hdd/backups/arch-beast` — Mischa's server |
| `backup-weekly` | Remove | Hardcoded `/data-hdd/backups/arch-beast/weekly` — Mischa's server |
| `big` | Remove | Resizes alacritty font to "recording" size — YouTuber recording tool |
| `bulkappend` | Remove | Hardcoded Azure cluster names (AKS20VIRTUELETREIN02100-TA) — Mischa's client |
| `bulkreplace` | Keep | Generic recursive sed wrapper, useful utility |
| `cantsleep` | Remove | `sudo brightnessctl s 5%` — Linux desktop brightness tool |
| `center` | Review | tmux pane layout helper — generic but YouTuber workflow-specific |
| `curr` | Keep | Shows current kubectl context/namespace — useful for K8s work |
| `day_bash` | Remove | Opens daily note at `$ZETTELKASTEN/periodic-notes/` — Zettelkasten path |
| `delrg` | Remove | Deletes Azure resource groups — Mischa's client work, dangerous |
| `dnd` | Remove | `osascript` macOS "Do Not Disturb" toggle — macOS-only |
| `dndstatus` | Remove | Reads macOS Focus status via `defaults read com.apple.controlcenter` — macOS-only |
| `duck` | Review | DuckDuckGo search via w3m — useful but requires w3m |
| `focusstart` | Remove | Calls `pomo` and `dnd` — both YouTuber/macOS tools |
| `focusstop` | Remove | Calls `pomo` and `dnd` — both YouTuber/macOS tools |
| `gendate` | Keep | Generates YYYY-MM-DD dates, optionally as markdown heading — generic |
| `goentr` | Keep | `entr`-based Go hot-reload — generic dev utility |
| `goentrtest` | Keep | `entr`-based Go test runner — generic dev utility |
| `google` | Review | Google search via w3m — useful but requires w3m |
| `hellobash` | Remove | `echo "Hello from Bash"` — tutorial/demo leftover, no value |
| `iterator` | Remove | `("Car" "Monastic" "Muziek")` hardcoded — tutorial example, no value |
| `jqedit` | Keep | In-place JSON editing with jq — useful utility |
| `m` | Keep | `git checkout main/master && git pull` — generic Git utility |
| `multiedit` | Remove | Deletes `kvName`/`kvResourceGroupName` lines — Mischa's client Azure TF |
| `nb` | Remove | Opens newsboat in tmux — newsboat is Mischa's RSS reader |
| `newscript` | Keep | Creates new script file with shebang in `$SCRIPTS` — generic utility |
| `parameter_parsing` | Remove | Tutorial/demo of bash string replacement — no practical value |
| `path` | Keep | Prints PATH entries one per line — generic debug utility |
| `pomocalc` | Remove | Calculates Pomodoro study time — depends on `pomo` workflow |
| `postgres-db-list` | Keep | Lists PostgreSQL databases — generic DB utility |
| `present` | Remove | Hardcoded `/users/mischa/repos/...alacritty.toml` — Mischa's path |
| `pub` | Remove | Hardcoded `/home/mischa/git/testing` — Mischa's path |
| `push` | Keep | `git add . && git commit -m && git push` — generic Git utility |
| `reprename` | Keep | Strips `NSCO.Workload.` prefix from dirs — potentially generic |
| `scandisks` | Remove | Rescans SCSI/SATA hosts via `/sys/class/scsi_host` — bare-metal Linux |
| `shorts` | Remove | Hardcoded `/users/mischa/repos/...alacritty.toml` — Mischa's path |
| `small` | Remove | Resets alacritty font size — YouTuber recording tool workflow |
| `startbreak` | Remove | Calls `pomo` + `figlet` for Pomodoro break — YouTuber workflow |
| `stop.sh` | Remove | SSH to `ds@ds` to stop Docker containers — Mischa's homelab server |
| `sunrise` | Remove | Terminal rainbow animation — curiosity/demo, no practical value |
| `ticket` | Remove | Strips backslashes from `/tmp/test.md` — Mischa's client workflow |
| `transcode-audio` | Review | ffmpeg MKV→MP4 transcoder — generic but was likely for YouTuber content |
| `urlencode` | Keep | URL-encodes strings — used by duck/google, generic utility |
| `week` | Keep | Prints current ISO week number — generic utility |
| `welcome` | Keep | Greeting screen with date, cal, uptime — generic/harmless |
| `ytr` | Remove | YouTube transcript via `fabric` + `wl-copy` (Wayland) — desktop Linux |

**Classification summary:**
- Keep: 17 scripts
- Remove: 23 scripts
- Review: 6 scripts

---

### Root-Level Config Files

| File | Notes |
|------|-------|
| `dot_zshrc` | Main shell config — contains personal paths, YouTuber aliases, good container detection |
| `dot_zprofile` | macOS-only brew setup + XDG_CONFIG_HOME — safe, conditional |
| `dot_tmux.conf` | tmux config with `set -g status-right "#(pomo)"` — YouTuber tool in status bar |
| `setup` | Bootstrap script — installs chezmoi, pure prompt, alacritty themes (macOS GUI) |

### dot_config/ Subdirectories

| Directory | Classification | Notes |
|-----------|---------------|-------|
| `alacritty/` | Desktop-only | Terminal emulator config — irrelevant in headless containers |
| `claude/` | Keep (empty) | `CLAUDE.md` exists but is empty — placeholder for Phase 3 |
| `hypr/` | Desktop-only | Hyprland window manager — Linux desktop, not containers |
| `mise/` | Keep | Core tool management config — container-compatible |
| `nvim/` | Keep | Neovim config (via chezmoiexternals LazyVim starter) — useful in containers |
| `waybar/` | Desktop-only | Status bar for Hyprland — Linux desktop, not containers |

### .chezmoiexternals/

| File | What It Does |
|------|-------------|
| `mise.toml` | Downloads mise binary directly from mise.jdx.dev — container-compatible |
| `neovim.toml` | Downloads LazyVim starter config from GitHub — container-compatible |

---

## YouTuber-Specific Tool Flags (cross-file)

All files where YouTuber-specific tooling appears:

| Tool | Found In | Classification |
|------|---------|---------------|
| `pomo` | scripts/focusstart, scripts/focusstop, scripts/startbreak, scripts/pomocalc, dot_tmux.conf (`status-right`) | Remove |
| `newsboat` | scripts/nb | Remove |
| `brightnessctl` | scripts/cantsleep | Remove |
| `osascript` | scripts/dnd, scripts/dndstatus | Remove |
| `vivaldi` | dot_zshrc (`if command -v vivaldi`) | Remove (or neutralize — already conditional) |
| `pass` | dot_zshrc (`alias pc='pass show -c'`) | Remove alias |
| `lazygit` | dot_zshrc (`alias lg='lazygit'`) | Keep alias — user wants lazygit (D-15) |
| `w3m` | scripts/duck, scripts/google | Review — required for those scripts |
| `fabric` | scripts/ytr | Remove |
| `wl-copy` | scripts/ytr | Remove (Wayland clipboard — desktop Linux) |
| `figlet` | scripts/startbreak | Remove |
| `entr` | scripts/goentr, scripts/goentrtest | Keep — useful container dev tool |
| `gsed` | scripts/big, scripts/small, scripts/multiedit, scripts/ticket | Review — used in several scripts |
| `kubectl`, `flux`, `k3d` | dot_zshrc completions and aliases | Keep — user has K8s homelab |
| `devpod` | dot_zshrc (`alias ds='devpod ssh'`) | Keep — user's primary workflow |
| `direnv` | dot_zshrc (`eval "$(direnv hook zsh)"`) | Keep — already conditional, user wants it |
| `az` (Azure CLI) | dot_zshrc (`alias sub='az account set -s'`) | Remove alias — Mischa's client work |

---

## Env Vars and Aliases Analysis

### dot_zshrc — Environment Variables

| Variable | Current Value | Classification | Action |
|----------|--------------|---------------|--------|
| `REPOS` | `$HOME/Repos` | Keep | Generic, reasonable path |
| `GITUSER` | `santiagobermudezparra` | Keep (flag as hardcoded) | User's own username |
| `GHREPOS` | `$REPOS/github.com/$GITUSER` | Keep | Derived from above |
| `DOTFILES` | `$HOME/.local/share/chezmoi` | Keep | Correct chezmoi path |
| `SCRIPTS` | `$DOTFILES/scripts` | Keep | Correct scripts path |
| `GOBIN` | `$HOME/.local/bin` | Keep | Standard Go binary path |
| `GOPRIVATE` | `github.com/$GITUSER/*` | Keep | Derived from GITUSER |
| `GOPATH` | `$HOME/go/` | Keep | Standard path |
| `ICLOUD` | Not set (used in alias `icloud`) | Remove alias | Path doesn't exist in containers |
| `ZETTELKASTEN` | Not set (used in aliases `in`, `cdzk`, and scripts/day_bash) | Remove aliases | Personal note system |
| `LAB` | Not set (used in alias `lab`) | Remove alias | Unknown — likely Mischa's |
| `EDITOR` / `VISUAL` | Set to `nvim` if available | Keep | Correct |
| `BROWSER` | Set to `vivaldi` if available | Remove | Vivaldi not in containers |
| `LANG` | `en_US.UTF-8` | Keep | Correct |

### dot_zshrc — Aliases

| Alias | Current Definition | Classification | Reason |
|-------|-------------------|---------------|--------|
| `v` | `nvim` | Keep | Generic |
| `cat` → `bat` | conditional | Keep | Generic |
| `scripts` | `cd $SCRIPTS` | Keep | Generic |
| `cdblog` | `cd ~/websites/blog` | Remove | Mischa's blog path |
| `c` | `clear` | Keep | Generic |
| `icloud` | `cd $ICLOUD` | Remove | $ICLOUD not set |
| `ls`/`ll`/`la`/`lla`/`lt` | `lsd` variants | Keep | Generic (conditional) |
| `0` | `cd $HOME/0` | Review | Unknown directory purpose |
| `zo` | `eval "$($SCRIPTS/0-cd)"` | Review | Depends on 0-cd script |
| `lab` | `cd $LAB` | Remove | $LAB not set |
| `dot` | `cd $HOME/.local/share/chezmoi` | Keep | Generic |
| `repos` | `cd $REPOS` | Keep | Generic |
| `ghrepos` | `cd $GHREPOS` | Keep | Generic |
| `gr` | `ghrepos` | Keep | Generic |
| `cdgo` | `cd $GHREPOS/go/` | Review | Generic pattern but assumes Go repos exist |
| `homelab` | `cd $GHREPOS/homelab/` | Keep | User has K8s homelab repo |
| `hl` | `homelab` | Keep | Shorthand for above |
| `lastmod` | find + ls sort by mtime | Keep | Generic utility |
| `t` | `tmux` | Keep | Generic |
| `e` | `exit` | Keep | Generic |
| `syu` | `sudo pacman -Syu` | Review | Arch-specific but harmless to keep |
| `sub` | `az account set -s` | Remove | Azure CLI — Mischa's client work |
| `gp` | `git pull` | Keep | Generic |
| `gs` | `git status` | Keep | Generic |
| `lg` | `lazygit` | Keep | User wants lazygit (D-15) |
| `in` | `cd $ZETTELKASTEN/0\ Inbox/` | Remove | $ZETTELKASTEN not set |
| `cdzk` | `cd $ZETTELKASTEN` | Remove | $ZETTELKASTEN not set |
| `k` | `kubectl` | Keep | User has K8s homelab |
| `kgp` | `kubectl get pods` | Keep | K8s — user's homelab |
| `kc` | `kubectx` | Keep | K8s — user's homelab |
| `kn` | `kubens` | Keep | K8s — user's homelab |
| `fgk` | `flux get kustomizations` | Keep | K8s/Flux — user's homelab |
| `pc` | `pass show -c` | Remove | pass is Mischa's password manager |
| `ds` | `devpod ssh` | Keep | User's primary workflow |

### dot_tmux.conf — YouTuber Tool

| Item | Issue | Action |
|------|-------|--------|
| `set -g status-right "#(pomo)"` | Calls `pomo` binary — Mischa's Pomodoro tool | Flag — Phase 2 will remove |

---

## Current Tool Stack (mise config.toml)

| Tool | Version | Container-Compatible | Notes |
|------|---------|---------------------|-------|
| neovim | latest | Yes | Core editor |
| ripgrep | latest | Yes | Code search |
| lsd | latest | Yes | Enhanced ls |
| bat | latest | Yes | Enhanced cat |
| fzf | latest | Yes | Fuzzy finder |
| fd | latest | Yes | Enhanced find |
| node | latest | Yes | JavaScript runtime — already in mise! |
| chezmoi | latest | Yes | Dotfiles manager |
| usage | latest | Yes | mise completion helper |
| flux (commented out) | latest | Yes | K8s GitOps — can uncomment if desired |

**Important:** Node is already in mise global config. D-14 says to add Node via setup.sh, not mise. This needs clarification — the audit report should flag that Node currently exists in mise global.

---

## Missing Tools Analysis

### User's Stated Wants (D-14, D-15)

| Tool | Currently Present | How to Add | Notes |
|------|-----------------|-----------|-------|
| Node | Yes — in mise global config | Already there | Conflict with D-14: user wants it via setup.sh instead |
| Claude Code CLI | No | Add to setup.sh: `npm install -g @anthropic-ai/claude-code` | After Node is available |
| gh (GitHub CLI) | No | Add to mise config: `gh = "latest"` | Container-compatible |
| lazygit | No (alias exists but tool absent) | Add to mise config: `lazygit = "latest"` | Container-compatible |
| direnv | No (hook in zshrc but binary absent) | Add to mise config: `direnv = "latest"` | Already conditionally hooked |
| delta | No | Add to mise config: `delta = "latest"` | Better git diff output |

### Implicitly Used but Not in mise

| Tool | Used By | Container-Compatible | Notes |
|------|---------|---------------------|-------|
| tmux | dot_tmux.conf, several scripts | Yes | Not in mise — assumed present |
| git | scripts/m, scripts/push, zshrc aliases | Yes | Not in mise — assumed present |
| go | scripts/goentr, scripts/goentrtest | Per-project | Should be mise local, not global |
| kubectl | zshrc aliases and completions | Yes | Not in mise — assumed installed separately |
| entr | scripts/goentr, scripts/goentrtest | Yes | Not in mise |

---

## Setup Script Analysis

Current `setup` script:

```bash
sudo chsh -s "$(command -v zsh)" "$USER"           # chsh in containers — may fail or be unnecessary
sh -c "$(curl -fsLS get.chezmoi.io)" -- init ...   # Only runs if chezmoi absent — safe
git clone ...sindresorhus/pure.git                  # Prompt setup — container-compatible
git clone ...alacritty-theme                        # Only if alacritty present — already conditional
```

| Step | Container-Compatible | Issue |
|------|---------------------|-------|
| `sudo chsh -s zsh` | Partial | `sudo` may not be available; chsh may fail in containers with no shadow/passwd write access |
| chezmoi init | Yes | Already gated — only runs if not present |
| pure prompt clone | Yes | Generic zsh prompt — works in containers |
| alacritty-theme clone | Yes (conditional) | Already gated on `command -v alacritty` |

**Missing from setup:**
- No Node install (user wants this — D-14)
- No Claude Code CLI install (user wants this — D-14)
- No creation of `$HOME/Repos` or `$HOME/0` directories that zshrc assumes

---

## Architecture Patterns

### The Phase Produces One File

AUDIT-REPORT.md is the only output artifact. It lives at the repo root (not in `.planning/`). The planner should break this into logical tasks matching the report sections — each task audits one domain and contributes to the report.

### Task Structure (Recommended)

Because this is a pure read-and-report phase (no code execution, no external calls), tasks map directly to report sections:

1. **Audit scripts/** — Read all 46 scripts, apply classification rules from CONTEXT.md D-04 through D-07, produce Section 1 of report
2. **Audit configs** — Read dot_zshrc, dot_tmux.conf, dot_zprofile, mise/config.toml, setup; produce Section 2
3. **Audit env vars and aliases** — Extract all env vars and aliases from dot_zshrc, classify per D-11/D-12/D-13; produce Section 3
4. **Compile missing tools** — Cross-reference what's used vs. what's in mise, apply D-14/D-15/D-16; produce Section 4
5. **Write DevPod readiness suggestions** — Apply D-17/D-18; produce Section 5
6. **Assemble AUDIT-REPORT.md** — Combine all sections into the final file at repo root

Alternatively, these can be done in a single task since the work is pure file reading. The planner decides.

### Report Section Layout

Per D-02 and D-03, the report sections and their table columns:

```
# AUDIT REPORT

## 1. Scripts (scripts/)
Name | Classification | Reason | Notes

## 2. Tools & Config
File | Item | Classification | Reason

## 3. Env Vars & Aliases (dot_zshrc)
Item | Type | Classification | Reason

## 4. Missing Tools
Tool | Purpose | How to Add

## 5. DevPod Readiness Suggestions
Category | Issue | Suggested Action
```

---

## Common Pitfalls

### Pitfall 1: Assuming $ICLOUD/$ZETTELKASTEN/$LAB are defined
**What goes wrong:** The variables appear in aliases and are referenced in scripts, but they are never defined in dot_zshrc or dot_zprofile. They may be in `$HOME/.privaterc` (sourced at the bottom of zshrc) but that file is gitignored/personal.
**Why it happens:** Mischa sourced these from a private file; the user's private file likely doesn't define them.
**How to avoid:** Flag them as "undefined in public config" — the alias will silently fail or `cd` to an empty string.
**Warning signs:** If running the dotfiles in a fresh container, `lab`, `in`, `cdzk`, `icloud` will all fail immediately.

### Pitfall 2: Over-removing the `0` directory pattern
**What goes wrong:** `alias 0='cd $HOME/0'` and `alias zo='eval "$($SCRIPTS/0-cd)"` look personal but are generic patterns.
**Why it happens:** The `0` directory is a Zettelkasten entry-point concept from rwxrob's workflow (who Mischa followed). The user may or may not use this.
**How to avoid:** Classify as Review, not Remove. The user needs to decide if they use a `~/0` directory.

### Pitfall 3: Marking lazygit alias as Remove because tool isn't installed
**What goes wrong:** `alias lg='lazygit'` — lazygit binary not present in mise config, so one might remove it.
**Why it happens:** The alias exists without the tool.
**How to avoid:** The user explicitly wants lazygit (D-15). Keep the alias, flag that the tool needs to be added to mise.

### Pitfall 4: Missing pomo in tmux.conf
**What goes wrong:** Focus on scripts/ and zshrc might miss that `dot_tmux.conf` has `set -g status-right "#(pomo)"`. This calls the pomo binary every second from tmux's status bar.
**Why it happens:** Easy to miss a non-obvious location.
**How to avoid:** The audit of configs (Section 2) must include dot_tmux.conf explicitly.

### Pitfall 5: Node already in mise — conflicts with D-14
**What goes wrong:** D-14 says "add Node via setup.sh, not mise global." But node is already in `dot_config/mise/config.toml`. The audit must surface this conflict, not silently ignore it.
**Why it happens:** The mise config may have been updated after CONTEXT.md was written, or user wants to move Node out of mise.
**How to avoid:** Report Section 4 (Missing Tools) should note: "Node is currently in mise global — D-14 specifies it should be in setup.sh instead. Phase 2/3 will need to reconcile."

### Pitfall 6: reprename looks personal but is actually generic
**What goes wrong:** `reprename` strips `NSCO.Workload.` prefix from directories. The prefix looks client-specific.
**Why it happens:** The hardcoded string makes it look personal, but the script is a general-purpose batch rename wrapper.
**How to avoid:** Classify as Keep — the script itself is a generic pattern, even if the default prefix is from Mischa's client. User can simply edit the hardcoded string. Note in report.

---

## Don't Hand-Roll

This phase is entirely observational — there are no libraries, APIs, or frameworks involved. The "implementation" is Claude reading files and writing a structured markdown report.

| Problem | Don't Build | Use Instead |
|---------|-------------|-------------|
| Script classification logic | Complex classification algorithm | Read each script, apply the simple rule set in CONTEXT.md D-04 through D-07 |
| Tool presence detection | Scripted `command -v` checks | Inspect mise/config.toml and setup directly — static analysis is sufficient |
| Cross-file tool references | grep automation | Read each file directly — the set is small (< 10 files) |

---

## DevPod Readiness Assessment

What works vs. what breaks in a headless Linux container today:

### Works Today (container-compatible)
- mise for tool management (downloads via mise.jdx.dev)
- neovim via chezmoiexternals (LazyVim starter)
- zsh with pure prompt (cloned by setup.sh)
- Container detection in zshrc (`$REMOTE_CONTAINERS`, `$CODESPACES`, `$DEVCONTAINER_TYPE`) — GPG/SSH agent correctly skipped
- PATH configuration (already includes `/home/vscode/.local/bin`, `/root/.local/bin`)
- Linuxbrew detection (conditional)
- K8s tools (kubectl, flux, k3d) — if installed separately
- git, tmux, ripgrep, fzf, bat, lsd, fd — all via mise

### Breaks or Is Irrelevant in Containers
- alacritty themes (cloned by setup.sh) — terminal emulator, headless container has no display
- Hyprland/Waybar configs — Linux WM, irrelevant
- GPG+YubiKey SSH (correctly gated, but setup.sh doesn't skip it)
- `sudo chsh` in setup.sh — may fail in containers
- `$ICLOUD`, `$ZETTELKASTEN`, `$LAB` aliases — undefined
- pomo in tmux status bar — pomo binary not installed
- All macOS scripts (dnd, dndstatus, cantsleep) — `osascript`/`defaults` are macOS-only
- vivaldi browser detection in zshrc — irrelevant

---

## Validation Architecture

No automated tests apply to this phase. The deliverable is a markdown document produced by reading files. Validation is manual:

- The user reads AUDIT-REPORT.md and confirms it matches the repo
- Phase success criterion: all 5 success criteria from ROADMAP.md are satisfied
- Test command: N/A — open AUDIT-REPORT.md and verify

*(No test infrastructure needed for a read-only documentation phase.)*

---

## State of the Art

| Topic | Observation |
|-------|-------------|
| chezmoi conventions | `dot_` prefix for files, `.chezmoiexternals/` for binary downloads — this repo follows correct chezmoi patterns |
| mise vs. asdf | mise is the current standard (asdf successor with better performance) — correct choice |
| DevPod container detection | zshrc uses `$REMOTE_CONTAINERS || $CODESPACES || $DEVCONTAINER_TYPE` — this covers VS Code Dev Containers, GitHub Codespaces, and DevPod (which sets DEVCONTAINER_TYPE) |
| dot_config/claude vs dot_claude | Claude Code reads from `~/.claude/CLAUDE.md` — chezmoi should map `dot_claude/CLAUDE.md`, not `dot_config/claude/CLAUDE.md`. Currently the file is at `dot_config/claude/CLAUDE.md` which maps to `~/.config/claude/CLAUDE.md` — wrong path. Deferred to Phase 3. |

---

## Open Questions

1. **What is the `0` directory?**
   - What we know: `alias 0='cd $HOME/0'` and `alias zo='eval "$($SCRIPTS/0-cd)"` reference `~/0`
   - What's unclear: Is this the user's Zettelkasten inbox convention (rwxrob pattern) or unused?
   - Recommendation: Classify as Review in the audit report — ask user in Phase 2

2. **Should reprename keep its hardcoded NSCO prefix or be generalized?**
   - What we know: Script is generic rename logic; prefix `NSCO.Workload.` is Mischa's client
   - What's unclear: Does the user need this kind of batch rename at all?
   - Recommendation: Classify as Keep with a note that the prefix constant should be reviewed

3. **Node in mise vs. setup.sh — which wins?**
   - What we know: Node is in mise config.toml (`node = "latest"`), but D-14 says add it via setup.sh
   - What's unclear: Should the mise entry be removed when setup.sh is updated in Phase 3?
   - Recommendation: Surface in audit report's Missing Tools section — flag the discrepancy, defer resolution to Phase 3

4. **Does the user use `~/0` or Zettelkasten at all?**
   - What we know: `$ZETTELKASTEN` undefined, day_bash script references it
   - What's unclear: If user has no Zettelkasten, day_bash, `in`, `cdzk` aliases are all Remove
   - Recommendation: Classify all as Remove — if user has a Zettelkasten they'll restore them

---

## Sources

### Primary (HIGH confidence)
- Direct file reads: `scripts/*` (all 46 scripts), `dot_zshrc`, `dot_zprofile`, `dot_tmux.conf`, `dot_config/mise/config.toml`, `setup`, `.chezmoiexternals/*.toml`
- All classifications are from first-party inspection, not inference

### Secondary (MEDIUM confidence)
- CONTEXT.md decisions D-01 through D-18 — locked constraints from user discussion
- REQUIREMENTS.md — AUDIT-01 through AUDIT-05 requirements

### Tertiary (LOW confidence)
- None — no external sources required for an audit-only phase

---

## Metadata

**Confidence breakdown:**
- Script inventory: HIGH — every script read directly
- Alias/env var inventory: HIGH — full zshrc read
- DevPod readiness: HIGH — direct analysis of container detection code
- Missing tools list: HIGH — direct inspection of mise config vs. user wants in CONTEXT.md

**Research date:** 2026-03-22
**Valid until:** Until repo files change — re-read files before planning if significant time has passed

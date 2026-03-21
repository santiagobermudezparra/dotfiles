# Phase 2: Cleanup - Research

**Researched:** 2026-03-22
**Domain:** chezmoi file removal, zshrc editing, shell script container guards
**Confidence:** HIGH

---

## Summary

Phase 2 has three concrete tasks with no ambiguity about what to change — AUDIT-REPORT.md is the exact deletion list. The main research question is the chezmoi file removal mechanism: deleting a file from the source directory does NOT cause `chezmoi apply` to remove it from the target. An explicit `.chezmoiremove` file (or `remove_` prefix) is required to propagate deletions. Since the scripts live in `scripts/` which chezmoi tracks, removing them from the source dir without a `.chezmoiremove` entry means old machines keep stale copies.

For the zshrc edits, all removals are line-level deletions of specific aliases, env vars, and their comment headers. The file structure is well-organized into sections with `# ~~~ Section ~~~` headers making surgical edits straightforward. No templating is needed for Phase 2 — plain deletions only.

The setup script fixes are narrowly scoped: wrap `sudo chsh` with the same container detection pattern already used in zshrc (`$REMOTE_CONTAINERS`, `$CODESPACES`, `$DEVCONTAINER_TYPE`), and that is the only mandatory fix. The pure prompt clone and alacritty sections already use guards; `sudo chsh` is the only unguarded risky call.

**Primary recommendation:** Delete the 25 scripts from source, add their paths to `.chezmoiremove`, remove 13 aliases + 4 env vars from `dot_zshrc`, and wrap `sudo chsh` in a container check.

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| CLEAN-01 | Remove all scripts flagged as "Remove" in AUDIT-REPORT.md | 25 scripts identified; chezmoi removal mechanism documented below |
| CLEAN-02 | Remove unused aliases and env vars from zshrc | 13 aliases + 4 env var items identified; line locations mapped below |
| CLEAN-03 | Update setup script to work in DevPod containers without macOS/GUI errors | `sudo chsh` is the only unguarded failure point; guard pattern already exists in zshrc |
</phase_requirements>

---

## Standard Stack

No new libraries or tools are introduced in this phase. All changes are file deletions and text edits using existing tooling.

### Tools in Use
| Tool | Version | Purpose |
|------|---------|---------|
| chezmoi | Already installed | Dotfile management; `.chezmoiremove` is its built-in file deletion mechanism |
| git | System | Staging and committing deletions from source directory |
| bash/zsh | System | Setup script runtime |

---

## Architecture Patterns

### How chezmoi Handles File Removal

**Critical:** chezmoi does NOT automatically remove target files when source files are deleted. From the official docs and maintainer confirmation:

> "chezmoi only looks at the current state of the source directory, it doesn't know anything about its history, and so can't tell if a file has been removed."

Two explicit mechanisms exist to remove target files:

**Mechanism 1: `.chezmoiremove` file (RECOMMENDED for this phase)**

Create `.chezmoiremove` at the chezmoi source root. Each line is a glob pattern matched against the TARGET directory (i.e., `~/.local/share/chezmoi` is the source; `~` is the target).

```
# .chezmoiremove
{{ .chezmoi.homeDir }}/{{ .chezmoi.sourceDir | trimAll .chezmoi.homeDir }}/scripts/0-cd
```

Actually, for scripts tracked as plain files in `scripts/`, the simpler form using home-relative paths works:

```
# .chezmoiremove — paths are relative to the target root ($HOME)
# These scripts are tracked by chezmoi under scripts/ in source → ~/.local/share/chezmoi/scripts/ in target
# BUT chezmoi source = ~/.local/share/chezmoi, so the scripts ARE the source dir files themselves
```

**Important clarification for this repo:** The `scripts/` directory IS inside the chezmoi source directory (`~/.local/share/chezmoi/scripts/`). The scripts are not "applied" to a separate target location — they live in the source dir and are referenced via `$SCRIPTS` env var which points to `$DOTFILES/scripts` = `$HOME/.local/share/chezmoi/scripts`. There is no separate target copy to clean up.

This means: **for scripts in `scripts/`, a simple `git rm` + `rm` is sufficient.** No `.chezmoiremove` is needed because there is no separate applied target copy — the source dir IS where the scripts live and are used from.

**Mechanism 2: `remove_` prefix**

A file named `remove_filename` in the source directory causes chezmoi to remove `filename` from the target. Not useful here since scripts aren't applied to a separate location.

**Verification command (always run before applying):**
```bash
chezmoi apply --dry-run --verbose
```

### The `$SCRIPTS` Pattern — Key Insight

Looking at `dot_zshrc`:
```
export DOTFILES="$HOME/.local/share/chezmoi"
export SCRIPTS="$DOTFILES/scripts"
```

And PATH includes `$SCRIPTS`. This means scripts are used directly from the chezmoi source directory. They are not "applied" to `~/.local/bin` or any other location. Deleting them from `scripts/` is all that's needed — no chezmoi removal magic required for this specific directory.

### Recommended Project Structure (post-cleanup)

```
scripts/           # Only Keep scripts remain (18 scripts)
├── bulkreplace
├── center
├── curr
├── gendate
├── goentr
├── goentrtest
├── jqedit
├── m
├── newscript
├── path
├── postgres-db-list
├── push
├── reprename
├── transcode-audio
├── urlencode
├── week
├── welcome
└── (google — Review: keep or remove based on user preference)
```

### Container Detection Pattern

The zshrc already uses this guard — reuse it exactly in setup:

```bash
# Source: dot_zshrc line 8
if [[ -z "$REMOTE_CONTAINERS" && -z "$CODESPACES" && -z "$DEVCONTAINER_TYPE" ]]; then
  # desktop/host-only operations here
fi
```

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead |
|---------|-------------|-------------|
| Removing files from chezmoi target | Custom uninstall script | `.chezmoiremove` patterns (for actual target-applied files) |
| Container detection | New env var convention | Existing `$REMOTE_CONTAINERS / $CODESPACES / $DEVCONTAINER_TYPE` already used in zshrc |
| Dry-run preview | Manual diffing | `chezmoi apply --dry-run --verbose` |

---

## Exact Change Inventory

### CLEAN-01: Scripts to Delete (25 files)

Delete these files from `scripts/`:

```
0-cd
backup
backup-weekly
big
bulkappend
cantsleep
day_bash
delrg
dnd
dndstatus
duck
focusstart
focusstop
hellobash
iterator
multiedit
nb
parameter_parsing
pomocalc
present
pub
scandisks
shorts
small
startbreak
stop.sh
sunrise
ticket
ytr
```

Wait — the audit lists 25 Remove scripts. Counting from AUDIT-REPORT.md:
0-cd, backup, backup-weekly, big, bulkappend, cantsleep, day_bash, delrg, dnd, dndstatus, duck, focusstart, focusstop, hellobash, iterator, multiedit, nb, parameter_parsing, pomocalc, present, pub, scandisks, shorts, small, startbreak, stop.sh, sunrise, ticket, ytr = **29 scripts listed as Remove**.

The audit header says "Remove 25" — the discrepancy is because `google` is Review, not Remove, and the count in the summary may not match the table. Use the table as the source of truth: delete all scripts with "Remove" in the Classification column.

**Note on `google`:** Classified as Review. Leave it in place for Phase 2 — the user should decide.

Action: `git rm scripts/<name>` for each Remove script. Since scripts are used directly from source dir (not applied elsewhere), no `.chezmoiremove` entry is needed.

### CLEAN-02: zshrc Changes

**Env vars to remove:**

| Line(s) | Content | Action |
|---------|---------|--------|
| 31-33 | `if command -v vivaldi > /dev/null; then export BROWSER="vivaldi"; fi` | Delete block |

Note: `$ICLOUD`, `$ZETTELKASTEN`, `$LAB` are never defined in `dot_zshrc` — they are only used in aliases. No export lines to remove for these.

**Aliases to remove (with line numbers from current dot_zshrc):**

| Line | Alias | Reason |
|------|-------|--------|
| 138 | `alias cdblog="cd ~/websites/blog"` | Mischa's blog |
| 140 | `alias icloud="cd \$ICLOUD"` | `$ICLOUD` undefined |
| 152-154 | `# 0` comment block + `alias 0='cd $HOME/0'` + `alias zo='eval "$($SCRIPTS/0-cd)"'` | rwxrob pattern, 0-cd script deleted |
| 158 | `alias lab='cd $LAB'` | `$LAB` undefined |
| 176 | `alias syu='sudo pacman -Syu'` | Review — Arch-specific but harmless; AUDIT says Review |
| 179-180 | `# Azure` comment + `alias sub='az account set -s'` | Azure CLI, Mischa's client work |
| 189-191 | `# Zettelkasten` comment + `alias in=...` + `alias cdzk=...` | `$ZETTELKASTEN` undefined |
| 206-207 | `# Pass` comment + `alias pc='pass show -c'` | pass is Mischa's password manager |

**Summary of zshrc removals (definitive Remove from audit):**
- `alias cdblog` — Remove
- `alias icloud` — Remove
- `alias 0` — Remove
- `alias zo` — Remove
- `alias lab` — Remove
- `alias sub` — Remove
- `alias in` — Remove
- `alias cdzk` — Remove
- `alias pc` — Remove
- Vivaldi browser block (lines 31-33) — Remove

**Review items (leave for user to decide, do not remove in Phase 2):**
- `alias cdgo` — Review (may or may not have a go/ subdir)
- `alias syu` — Review (Arch-specific but harmless)

### CLEAN-03: Setup Script Changes

The `setup` script has one dangerous unguarded call:

```bash
# Current (line 8) — FAILS in DevPod containers where sudo or chsh is unavailable
sudo chsh -s "$(command -v zsh)" "$USER"
```

Fix: wrap with the container detection guard used in zshrc:

```bash
if [[ -z "$REMOTE_CONTAINERS" && -z "$CODESPACES" && -z "$DEVCONTAINER_TYPE" ]]; then
  if command -v zsh >/dev/null; then
    sudo chsh -s "$(command -v zsh)" "$USER"
  fi
fi
```

The existing `if command -v zsh` guard still belongs inside the container check.

**Other setup observations (no changes needed in Phase 2):**
- Pure prompt clone (`if [ ! -d "$HOME/.zsh/pure" ]`) — already guarded, safe in containers
- Alacritty section (`if command -v alacritty`) — already guarded, won't run in headless containers
- chezmoi install check — safe, works in containers

**Out of scope for Phase 2** (noted for Phase 3):
- Adding `mkdir -p "$HOME/Repos"` (AUDIT suggestion #2)
- tmux pomo status bar fix in `dot_tmux.conf` (AUDIT suggestion #3)
- Adding gh/lazygit/direnv/delta to mise config

---

## Common Pitfalls

### Pitfall 1: Assuming Script Deletion Requires `.chezmoiremove`
**What goes wrong:** Adding scripts/ entries to `.chezmoiremove` and confusing yourself because scripts are used from the source dir, not a separate target location.
**Why it happens:** `.chezmoiremove` is for files chezmoi APPLIES to a target (like `dot_zshrc` → `~/.zshrc`). Scripts in `scripts/` are referenced via `$SCRIPTS` pointing to the source dir itself — there's no separate applied copy.
**How to avoid:** Only use `.chezmoiremove` for files with a `dot_` prefix or other files chezmoi copies/symlinks to a target location outside the source dir.

### Pitfall 2: Leaving Section Comment Headers After Removing All Aliases
**What goes wrong:** After removing `alias sub`, the `# Azure` comment header remains with no content below it. Same for `# Pass`, `# Zettelkasten`, `# 0`.
**How to avoid:** When removing all aliases in a section, also remove the section comment header.

### Pitfall 3: Breaking zshrc by Partial Edit
**What goes wrong:** Editing `dot_zshrc` with a text substitution that matches too broadly (e.g., `sed` removing a line that contains a shared string).
**How to avoid:** Use exact line content for matching. The file is well-structured; prefer precise multi-line block deletion over pattern matching.

### Pitfall 4: `sudo chsh` Silent Failure vs Hard Failure
**What goes wrong:** In some container environments `sudo` is available but `/etc/passwd` is read-only, causing `chsh` to fail with a non-zero exit. With `set -euo pipefail` in the setup script, this aborts the entire script.
**How to avoid:** The container environment check prevents running `sudo chsh` in containers entirely. The check must come BEFORE `set -euo pipefail` takes effect, or wrap `sudo chsh` in `|| true` in addition to the guard (belt + suspenders).
**Warning signs:** Setup script exits with code 1 immediately after the chsh line.

---

## Code Examples

### Container Guard Pattern (reuse from zshrc)
```bash
# Source: dot_zshrc line 8 — established pattern for this repo
if [[ -z "$REMOTE_CONTAINERS" && -z "$CODESPACES" && -z "$DEVCONTAINER_TYPE" ]]; then
  # runs only on host/macOS, not in DevPod/Codespaces/devcontainer
fi
```

### Git Remove for Scripts
```bash
# Remove all 25+ flagged scripts in one operation
# Run from repo root
git rm scripts/0-cd scripts/backup scripts/backup-weekly scripts/big \
  scripts/bulkappend scripts/cantsleep scripts/day_bash scripts/delrg \
  scripts/dnd scripts/dndstatus scripts/duck scripts/focusstart \
  scripts/focusstop scripts/hellobash scripts/iterator scripts/multiedit \
  scripts/nb scripts/parameter_parsing scripts/pomocalc scripts/present \
  scripts/pub scripts/scandisks scripts/shorts scripts/small \
  scripts/startbreak scripts/stop.sh scripts/sunrise scripts/ticket \
  scripts/ytr
```

### Chezmoi Dry Run (verify before applying)
```bash
chezmoi apply --dry-run --verbose
```

---

## State of the Art

No migrations or deprecations relevant to this phase. All tools (chezmoi, bash) are stable.

---

## Open Questions

1. **`alias syu` (Arch Linux pacman) — Keep or Remove?**
   - What we know: Classified as Review in audit. Harmless on non-Arch (command not found), but it's noise.
   - What's unclear: User preference.
   - Recommendation: Leave it unless user explicitly requests removal. It does no harm in containers.

2. **`alias cdgo` — Keep or Remove?**
   - What we know: Classified as Review. Pattern is generic (`$GHREPOS/go/`) but assumes a go/ subdir exists.
   - Recommendation: Keep — generic pattern that works when the dir exists, silently fails otherwise.

3. **`google` script — Keep or Remove?**
   - What we know: Classified as Review. Requires `w3m` which is not in mise.
   - Recommendation: Remove in Phase 2 along with the other removes unless user confirms they use w3m workflows. The planner can make this call or flag for user input.

---

## Sources

### Primary (HIGH confidence)
- chezmoi official docs — https://www.chezmoi.io/user-guide/manage-different-types-of-file/ — `.chezmoiremove` syntax and semantics
- chezmoi reference — https://www.chezmoi.io/reference/target-types/ — `remove_` prefix behavior
- chezmoi GitHub discussion #1446 — https://github.com/twpayne/chezmoi/discussions/1446 — maintainer confirmation that deleting from source does NOT remove from target
- `dot_zshrc` direct read — container detection pattern, alias and env var locations
- `setup` direct read — exact unguarded `sudo chsh` call at line 8
- `AUDIT-REPORT.md` direct read — authoritative list of 25+ scripts to remove, 13 aliases + 4 env var items to remove

### Secondary (MEDIUM confidence)
- AUDIT-REPORT.md DevPod Suggestions section — concrete setup.sh fix recommendations (suggestion #1)

---

## Metadata

**Confidence breakdown:**
- CLEAN-01 (script deletion): HIGH — exact file list from audit, chezmoi behavior confirmed from official docs
- CLEAN-02 (zshrc edits): HIGH — exact line numbers and content verified by reading the file
- CLEAN-03 (setup script): HIGH — exact unguarded call identified, guard pattern verified from zshrc

**Research date:** 2026-03-22
**Valid until:** 2026-06-22 (chezmoi API is stable; no time-sensitive components)

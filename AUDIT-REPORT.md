# Audit Report

> Generated: 2026-03-22 | Phase 1 — Audit | All findings from direct file inspection.

---

## Scripts

All 46 scripts in `scripts/` classified per the rules in CONTEXT.md (D-04 through D-07).

| Name | Classification | Reason | Notes |
|------|----------------|--------|-------|
| 0-cd | Keep | Generic fzf-based directory navigator, outputs `cd` command for eval — no personal paths | Used by `zo` alias in zshrc |
| backup | Remove | Uses `/data-hdd/backups/arch-beast` — Mischa's server path; also backs up `/home/santiagobermudezparra` with a hardcoded username | Partial personalization but still tied to Mischa's server |
| backup-weekly | Remove | Hardcoded `/data-hdd/backups/arch-beast/weekly` and `/home/mischa` — definitively Mischa's setup | — |
| big | Remove | Resizes alacritty font for recording (`size = 38`) — YouTuber recording workflow; shows Keycastr checklist | References `$DOTFILES/alacritty.toml` via gsed |
| bulkappend | Remove | Hardcoded Azure cluster names (`AKS20VIRTUELETREIN02100-TA`, `RG20VIRTUELETREIN02BASE200-STAGING`) — Mischa's client work | Dangerous: appends to every file in CWD |
| bulkreplace | Keep | Generic recursive sed wrapper for find-and-replace across file types; comments show multiple usage patterns | Hardcoded example strings are just placeholders, edit before use |
| cantsleep | Remove | `sudo brightnessctl s 5%` — Linux desktop brightness tool, not available in containers (D-06) | Single-line script |
| center | Review | Generic tmux pane layout helper (splits right, resizes to 130 cols, clears) — no personal paths | Useful for any tmux workflow, not just YouTuber's |
| curr | Keep | Shows current kubectl context and namespace — directly useful for K8s homelab work (D-10) | Requires kubectl |
| day_bash | Remove | Opens daily note at `$ZETTELKASTEN/periodic-notes/` — `$ZETTELKASTEN` is undefined (D-06/D-11) | Also uses NoNeckPain nvim plugin |
| delrg | Remove | Deletes all Azure resource groups in a subscription via `az` CLI — Mischa's client work; dangerous | Do not keep — high risk of accidental data loss |
| dnd | Remove | Toggles macOS Do Not Disturb via `osascript` — macOS-only (D-06) | Called by focusstart/focusstop |
| dndstatus | Remove | Reads macOS Focus status via `defaults read com.apple.controlcenter` — macOS-only (D-06) | Called by focusstart/focusstop |
| duck | Review | DuckDuckGo search via `w3m` terminal browser — generic concept but requires `w3m` | `w3m` not in mise; useful if you use terminal browsers |
| focusstart | Remove | Calls `pomo start` and `dnd` — both YouTuber/macOS tools (D-06/D-09) | — |
| focusstop | Remove | Calls `pomo stop` and `dnd` — both YouTuber/macOS tools (D-06/D-09) | — |
| gendate | Keep | Generates YYYY-MM-DD date string, optionally as a markdown heading — pure bash, no deps (D-07) | Generic and useful |
| goentr | Keep | `entr`-based Go hot-reload runner (`go run .`) — generic dev utility (D-07) | Requires `entr` (not in mise) and Go |
| goentrtest | Keep | `entr`-based Go test watcher (`go test`) — generic dev utility (D-07) | Requires `entr` (not in mise) and Go |
| google | Review | Google search via `w3m` terminal browser — generic concept but requires `w3m` | Same caveat as `duck`; pair together |
| hellobash | Remove | `echo "Hello from Bash"` — tutorial/demo leftover with no practical value | Safe to delete immediately |
| iterator | Remove | Hardcoded list `("Car" "Monastic" "Muziek")` — bash tutorial/learning example, no value | Safe to delete immediately |
| jqedit | Keep | In-place JSON editing with jq — useful generic utility (D-07) | The hardcoded query is a template/example; the script pattern itself is reusable |
| m | Keep | `git checkout master || git checkout main && git pull` — generic Git utility (D-07) | Simple and useful |
| multiedit | Remove | Uses `gsed` to delete `kvName`/`kvResourceGroupName` lines — Mischa's client Azure Terraform workflow | Hardcoded variable names are client-specific |
| nb | Remove | Opens newsboat in a tmux pane — newsboat is Mischa's RSS reader, not available in containers (D-06/D-09) | — |
| newscript | Keep | Creates a new executable script with shebang in `$SCRIPTS` — generic utility (D-07) | Relies on `$SCRIPTS` env var which is correctly defined in zshrc |
| parameter_parsing | Remove | Tutorial demo of bash string replacement on a hardcoded string — no practical value | Safe to delete immediately |
| path | Keep | Prints PATH entries one per line via `${PATH//:/\\n}` — generic debug utility (D-07) | From rwxrob; commonly useful |
| pomocalc | Remove | Calculates total time from Pomodoro count — depends on `pomo` Pomodoro workflow (D-06/D-09) | — |
| postgres-db-list | Keep | Lists PostgreSQL databases via psql — generic DB utility (D-07) | Requires psql; useful for any Postgres work |
| present | Remove | Hardcoded `/users/mischa/repos/.../alacritty.toml` — Mischa's exact path (D-05) | gsed + tmux split for "presentation mode" |
| pub | Remove | Hardcoded `/home/mischa/git/testing` — Mischa's Git test repo (D-05) | Does `echo x >> README.md && git push` — useless here |
| push | Keep | Interactive git add+commit+push with prompt for message — generic Git utility (D-07) | Uses `git add .` which is broad but expected for this use case |
| reprename | Keep | Strips `NSCO.Workload.` prefix from directories via batch mv — generic pattern (D-07) | Hardcoded prefix is Mischa's client; edit the prefix constant to reuse |
| scandisks | Remove | Rescans SCSI/SATA hosts via `/sys/class/scsi_host` — bare-metal Linux kernel interface | Not relevant in VMs or containers |
| shorts | Remove | Hardcoded `/users/mischa/repos/.../alacritty.toml` — Mischa's exact path (D-05) | Also uses gsed + tmux split for YouTube Shorts recording layout |
| small | Remove | Resets alacritty font size for recording — YouTuber recording workflow via gsed on alacritty.toml | References `$DOTFILES/alacritty.toml` |
| startbreak | Remove | Calls `pomo start` and `figlet` for Pomodoro break display — YouTuber workflow (D-06/D-09) | Requires pomo and figlet |
| stop.sh | Remove | SSHes to `ds@ds` and stops hardcoded Docker containers (nginx, php, mysql) — Mischa's homelab server | Not the user's homelab; separate from DevPod |
| sunrise | Remove | Terminal rainbow animation using bc math and ANSI escape codes — curiosity/demo only | Requires setterm (Linux-only), no practical value |
| ticket | Remove | `gsed -i 's/\\//g' /tmp/test.md` — strips backslashes from a hardcoded temp file | Mischa's client ticket cleanup one-liner; no value |
| transcode-audio | Keep | Batch transcodes MKV to MP4 (copy video, ALAC audio) using ffmpeg — generic and well-written | No personal paths; includes error handling and dry-run checks |
| urlencode | Keep | URL-encodes strings or stdin — used by `duck` and `google`, generic utility (D-07) | From rwxrob; pure bash, no deps |
| week | Keep | Prints current ISO week number — simple, generic, no deps (D-07) | — |
| welcome | Keep | Greeting screen with date, cal, uptime — harmless, generic (D-07) | From TJDevries's config |
| ytr | Remove | Gets YouTube transcript via `fabric` and copies to clipboard via `wl-copy` (Wayland) — desktop Linux only | Both `fabric` and `wl-copy` are desktop Linux tools, not available in containers |

**Summary: Keep 18 | Remove 23 | Review 5**

---

## YouTuber-Specific Tools

Tools tied to Mischa van den Burg's personal workflow, found across ALL config files. K8s tools (D-10) are excluded — they are legitimate for this user's homelab.

| Tool | Found In | Classification | Notes |
|------|----------|----------------|-------|
| pomo | scripts/focusstart, scripts/focusstop, scripts/startbreak, scripts/pomocalc, **dot_tmux.conf** (`set -g status-right "#(pomo)"`) | Remove | Pomodoro timer binary; tmux status bar calls it every second — will show errors or empty string |
| newsboat | scripts/nb | Remove | Terminal RSS reader; Mischa's content research tool |
| brightnessctl | scripts/cantsleep | Remove | Linux desktop brightness control — not available in containers |
| osascript | scripts/dnd, scripts/dndstatus | Remove | macOS Apple Script runner — not available on Linux/containers |
| vivaldi | dot_zshrc (`if command -v vivaldi > /dev/null; then export BROWSER="vivaldi"`) | Remove | Mischa's preferred browser; already conditional but irrelevant in containers |
| pass | dot_zshrc (`alias pc='pass show -c'`) | Remove | Unix password manager — Mischa's personal password store |
| fabric | scripts/ytr | Remove | AI transcript tool — desktop Linux, Mischa's content workflow |
| wl-copy | scripts/ytr | Remove | Wayland clipboard utility — Linux desktop only |
| figlet | scripts/startbreak | Remove | ASCII art banner generator — used for Pomodoro break display |
| gsed | scripts/big, scripts/small, scripts/multiedit, scripts/ticket, scripts/shorts | Review | GNU sed wrapper (macOS needs gsed; Linux has sed). Used in some Remove scripts. `big`/`small` are YouTuber-specific; check if needed for Linux usage in kept scripts |
| w3m | scripts/duck, scripts/google | Review | Terminal web browser — not in mise; needed only if keeping duck/google scripts |
| az (Azure CLI) | dot_zshrc (`alias sub='az account set -s'`), scripts/delrg, scripts/bulkappend | Remove | Mischa's client Azure CLI work; dangerous scripts |
| entr | scripts/goentr, scripts/goentrtest | Keep | File watcher for hot-reload — useful dev tool; these scripts are Keep (D-10 rationale applies to generic tools too) |
| lazygit | dot_zshrc (`alias lg='lazygit'`) | Keep | TUI Git client — user explicitly wants this (D-15); alias exists, binary missing from mise |
| direnv | dot_zshrc (`eval "$(direnv hook zsh)"`) | Keep | Directory-based env vars — user explicitly wants this (D-15); hook is already conditional |
| devpod | dot_zshrc (`alias ds='devpod ssh'`) | Keep | User's primary development workflow tool |
| kubectl, flux, k3d | dot_zshrc (aliases and completions) | Keep | K8s tooling — user has a K8s homelab (D-10) |

---

## Env Vars & Aliases

All environment variables and aliases from `dot_zshrc`, classified per D-11 through D-13.

| Item | Type | Status | Notes |
|------|------|--------|-------|
| `REPOS=$HOME/Repos` | Env var | Keep | Defined; `$HOME/Repos` is a generic and reasonable path |
| `GITUSER="santiagobermudezparra"` | Env var | Keep | User's own GitHub username (D-13); hardcoded — note for templatization |
| `GHREPOS=$REPOS/github.com/$GITUSER` | Env var | Keep | Derived from defined vars; correct pattern |
| `DOTFILES=$HOME/.local/share/chezmoi` | Env var | Keep | Correct chezmoi path |
| `SCRIPTS=$DOTFILES/scripts` | Env var | Keep | Correct path to scripts directory |
| `GOBIN=$HOME/.local/bin` | Env var | Keep | Standard Go binary path |
| `GOPRIVATE=github.com/$GITUSER/*` | Env var | Keep | Derived from GITUSER; correct pattern |
| `GOPATH=$HOME/go/` | Env var | Keep | Standard Go workspace path |
| `ICLOUD` | Env var | Remove | Never defined in dot_zshrc or dot_zprofile; `icloud` alias silently fails |
| `ZETTELKASTEN` | Env var | Remove | Never defined in public config; `in`, `cdzk`, and scripts/day_bash all silently fail |
| `LAB` | Env var | Remove | Never defined in public config; `lab` alias silently fails |
| `BROWSER=vivaldi` | Env var | Remove | Set only if `vivaldi` detected; irrelevant in containers |
| `EDITOR=nvim` | Env var | Keep | Conditional on nvim presence; correct |
| `v=nvim` | Alias | Keep | Generic editor shortcut |
| `cat=bat` | Alias | Keep | Conditional on bat; generic enhancement |
| `scripts=cd $SCRIPTS` | Alias | Keep | Generic, points to a defined var |
| `cdblog=cd ~/websites/blog` | Alias | Remove | Mischa's blog directory — does not exist |
| `c=clear` | Alias | Keep | Generic |
| `icloud=cd $ICLOUD` | Alias | Remove | `$ICLOUD` undefined — silently fails |
| `ls/ll/la/lla/lt` (lsd) | Alias | Keep | Conditional on lsd; generic enhancement |
| `0=cd $HOME/0` | Alias | Review | `~/0` purpose unclear — rwxrob/Zettelkasten pattern; decide if you use a `~/0` entry point |
| `zo=eval "$(0-cd)"` | Alias | Review | Depends on 0-cd script (Keep) and `~/0` directory; useful if you use `~/0` |
| `lab=cd $LAB` | Alias | Remove | `$LAB` undefined — silently fails |
| `dot=cd $HOME/.local/share/chezmoi` | Alias | Keep | Generic, correct path |
| `repos=cd $REPOS` | Alias | Keep | Generic |
| `ghrepos=cd $GHREPOS` | Alias | Keep | Generic |
| `gr=ghrepos` | Alias | Keep | Generic shorthand |
| `cdgo=cd $GHREPOS/go/` | Alias | Review | Generic pattern but assumes a `go/` subdirectory exists in your GitHub repos |
| `homelab=cd $GHREPOS/homelab/` | Alias | Keep | User has K8s homelab repo (D-12); useful |
| `hl=homelab` | Alias | Keep | Shorthand for above |
| `lastmod` | Alias | Keep | Generic find+ls utility |
| `t=tmux` | Alias | Keep | Generic |
| `e=exit` | Alias | Keep | Generic |
| `syu=sudo pacman -Syu` | Alias | Review | Arch-specific package upgrade; harmless to keep if you ever use Arch, useless in Debian/Ubuntu containers |
| `sub=az account set -s` | Alias | Remove | Azure CLI — Mischa's client work |
| `gp=git pull` | Alias | Keep | Generic |
| `gs=git status` | Alias | Keep | Generic |
| `lg=lazygit` | Alias | Keep | User wants lazygit (D-15); tool missing from mise — add it |
| `in=cd $ZETTELKASTEN/0 Inbox/` | Alias | Remove | `$ZETTELKASTEN` undefined — silently fails |
| `cdzk=cd $ZETTELKASTEN` | Alias | Remove | `$ZETTELKASTEN` undefined — silently fails |
| `k=kubectl` | Alias | Keep | K8s homelab (D-10) |
| `kgp=kubectl get pods` | Alias | Keep | K8s homelab (D-10) |
| `kc=kubectx` | Alias | Keep | K8s homelab (D-10) |
| `kn=kubens` | Alias | Keep | K8s homelab (D-10) |
| `fgk=flux get kustomizations` | Alias | Keep | K8s/Flux homelab (D-10) |
| `pc=pass show -c` | Alias | Remove | pass is Mischa's password manager |
| `ds=devpod ssh` | Alias | Keep | User's primary DevPod workflow |

---

## Missing Tools

Tools the user explicitly wants (D-14, D-15) plus tools referenced in zshrc/scripts that are not in `dot_config/mise/config.toml`.

| Tool | Purpose | Install Method | Priority |
|------|---------|----------------|----------|
| Node | JavaScript runtime (user wants via setup.sh per D-14) | **Conflict:** already in `dot_config/mise/config.toml` as `node = "latest"`. User wants it in setup.sh instead. Flag for Phase 3 reconciliation: either remove from mise and add `npm install -g` step to setup, or keep in mise and document the choice. | High |
| Claude Code CLI | AI coding assistant (`claude` command) | After Node is available: add `npm install -g @anthropic-ai/claude-code` to `setup` script (D-14) | High |
| gh (GitHub CLI) | GitHub API, PRs, issues, releases from CLI | Add to mise: `gh = "latest"` in `dot_config/mise/config.toml` | Medium |
| lazygit | TUI Git client (`lg` alias already in zshrc) | Add to mise: `lazygit = "latest"` in `dot_config/mise/config.toml` (D-15) | Medium |
| direnv | Per-directory environment variables (hook already in zshrc) | Add to mise: `direnv = "latest"` in `dot_config/mise/config.toml` (D-15) | Medium |
| delta | Better git diff output with syntax highlighting | Add to mise: `delta = "latest"` in `dot_config/mise/config.toml` (D-15) | Medium |
| entr | File watcher for hot-reload (used by goentr/goentrtest) | Add to mise or install via package manager in container setup; not currently in mise | Medium |
| tmux | Terminal multiplexer (config exists, tool assumed present) | Typically pre-installed or added via package manager; not managed by mise — document the assumption | Low |

**Not suggested:** Python — per D-16, handle per-project via `mise locals`, not global mise config.

---

## DevPod Suggestions

Concrete, actionable improvements to make this a reliable DevPod base image (D-17, D-18).

1. **Guard `sudo chsh` with a container check in setup.sh.** The current `sudo chsh -s "$(command -v zsh)" "$USER"` may fail in DevPod containers where sudo is unavailable or `/etc/passwd` is read-only. Fix: wrap it with `if [ -z "$DEVCONTAINER_TYPE" ] && [ -z "$REMOTE_CONTAINERS" ]; then sudo chsh ...; fi` — reuses the existing container detection pattern from zshrc.

2. **Add `mkdir -p "$HOME/Repos"` to setup.sh.** The zshrc sets `export REPOS="$HOME/Repos"` and multiple aliases (`repos`, `ghrepos`, `gr`, `homelab`) assume it exists. A fresh container without this directory will silently have broken aliases. Add `mkdir -p "$HOME/Repos"` early in setup.

3. **Remove or replace `set -g status-right "#(pomo)"` in dot_tmux.conf.** The `pomo` binary is not installed. tmux calls this every second (per `status-interval 1`), causing repeated errors or an empty status bar. Replace with a generic alternative: `set -g status-right "%H:%M %Y-%m-%d"` for a simple clock.

4. **Remove the vivaldi browser detection block from dot_zshrc.** The `if command -v vivaldi > /dev/null; then export BROWSER="vivaldi"; fi` block is irrelevant in headless containers. The `BROWSER` env var is not needed for terminal-only workflows. Remove the block entirely.

5. **Add Node and Claude Code CLI installation to setup.sh.** Per D-14: decide whether Node lives in mise (current state) or setup.sh (user's stated preference). If moving to setup.sh, add a `curl`-based Node install (e.g., via fnm or nvm) followed by `npm install -g @anthropic-ai/claude-code`. If keeping in mise, add only the Claude Code CLI step after mise activates.

6. **Add gh, lazygit, direnv, delta to mise config.toml.** These tools are either explicitly wanted (D-15) or already hooked in zshrc (`direnv`, `lg` alias). Adding them to mise makes them available automatically in every container without extra setup steps.

7. **Remove or gate Zettelkasten and personal path aliases.** The aliases `in`, `cdzk`, `icloud`, `lab`, and `cdblog` all reference paths/variables that don't exist in a fresh container. They silently fail on use. Remove them in Phase 2 cleanup.

8. **Create a `.privaterc.example` template.** The zshrc sources `$HOME/.privaterc` at the bottom (for personal tokens, private paths, etc.) but this file is gitignored. New container users won't know it's expected. Add a `dot_privaterc.example` (chezmoi will ignore `.example` suffix by default) or document the expected structure in the README.

9. **Reconcile the Node install approach.** Node is currently in `dot_config/mise/config.toml` as `node = "latest"`, but the user wants it managed via setup.sh (D-14) to control the install location. Decide in Phase 3: keep in mise (simpler, container-compatible) or move to setup.sh with a dedicated Node version manager. Flag for the Phase 3 planner.

10. **Consider gating desktop-only config directories in chezmoi.** The `alacritty/`, `hypr/`, and `waybar/` directories under `dot_config/` are managed by chezmoi but irrelevant in headless containers. Use chezmoi templates (`{{ if .is_container }}...{{ end }}`) to skip applying these directories when provisioning containers, keeping the container filesystem clean.

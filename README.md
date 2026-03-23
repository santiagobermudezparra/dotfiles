# dotfiles-chezmoi

Personal dotfiles managed with [chezmoi](https://chezmoi.io), designed primarily for provisioning **DevPod containers** for development work (K8s homelab, general dev). Includes the [Ralph](https://github.com/snarktank/ralph) AI agent loop pre-configured for Claude Code.

---

## How It Works

### chezmoi

[chezmoi](https://chezmoi.io) is the dotfiles manager. It lives in `~/.local/share/chezmoi/` (the source directory) and applies files to their real locations on your system.

**File naming convention:**

| Source (this repo) | Applied location |
|---|---|
| `dot_zshrc` | `~/.zshrc` |
| `dot_tmux.conf` | `~/.tmux.conf` |
| `dot_config/nvim/` | `~/.config/nvim/` |
| `dot_config/mise/config.toml` | `~/.config/mise/config.toml` |
| `dot_claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `dot_claude/skills/` | `~/.claude/skills/` |
| `scripts/` | `~/.local/share/chezmoi/scripts/` (in place) |

The `scripts/` directory is **not copied** — it lives directly in the chezmoi source dir and is added to `$PATH` via `$SCRIPTS` in `.zshrc`. So any script you add to `scripts/` is immediately available as a command after `chezmoi apply`.

To apply changes after editing:
```bash
chezmoi apply
```

To see what would change before applying:
```bash
chezmoi diff
```

---

### mise

[mise](https://mise.jdx.dev) is the tool version manager (replaces nvm, pyenv, rbenv, etc.). Tools are defined in `dot_config/mise/config.toml` and installed on first use.

**Currently managed tools:**

| Tool | Purpose |
|---|---|
| `node` | JavaScript runtime |
| `neovim` | Editor |
| `ripgrep` | Fast grep |
| `lsd` | Better `ls` |
| `bat` | Better `cat` |
| `fzf` | Fuzzy finder |
| `fd` | Better `find` |
| `chezmoi` | Dotfiles manager |
| `usage` | mise completion support |

mise activates automatically in `.zshrc`:
```zsh
eval "$($HOME/.local/bin/mise activate zsh)"
```

To add a new tool globally, edit `dot_config/mise/config.toml`:
```toml
[tools]
python = "latest"
gh = "latest"
```

Then run `chezmoi apply && mise install`.

For **per-project** tools (e.g., a specific Python version for one repo), create a `.mise.toml` in that project — mise picks it up automatically.

---

### setup script

The `setup` script is the bootstrap entry point. Run it once on a fresh machine or container:

```bash
curl -fsSL https://raw.githubusercontent.com/santiagobermudezparra/dotfiles/main/setup | bash
```

**What it does, in order:**

1. Changes your default shell to zsh
2. Installs chezmoi and applies these dotfiles
3. Creates `~/.zsh/` and clones the [pure](https://github.com/sindresorhus/pure) prompt
4. Clones alacritty themes (only if alacritty is installed)
5. Installs `jq` (required by ralph)
6. Installs Claude Code CLI via the native installer

**Container detection:** Steps that don't work in containers (like changing the default shell) are guarded:
```bash
if [[ -z "$REMOTE_CONTAINERS" && -z "$CODESPACES" && -z "$DEVCONTAINER_TYPE" ]]; then
  # macOS / host machine only
fi
```

---

### DevPod

[DevPod](https://devpod.sh) is used to spin up development containers from any repo. The dotfiles are automatically applied inside each container, giving you the same shell, tools, and scripts everywhere.

To provision a container for a project:
```bash
devpod up .
```

Or from the DevPod UI, point it at any Git repo. The container runs the setup script on first boot, which installs chezmoi and applies these dotfiles automatically.

---

## Ralph — AI Agent Loop

[Ralph](https://github.com/snarktank/ralph) is an autonomous AI development loop. You give it a PRD (product requirements doc), and it implements stories one at a time using Claude Code, running until everything is done.

### How it's set up in these dotfiles

- `scripts/ralph` — the main loop script, available as `ralph` anywhere in your shell
- `dot_claude/CLAUDE.md` → `~/.claude/CLAUDE.md` — global instructions Claude Code reads on every session start
- `dot_claude/skills/ralph/SKILL.md` → `~/.claude/skills/ralph/SKILL.md` — skill for converting PRDs to `prd.json`
- `dot_claude/skills/prd/SKILL.md` → `~/.claude/skills/prd/SKILL.md` — skill for generating PRDs

### Using Ralph in a project

**Step 1: Create a PRD**

In your project directory, ask Claude Code to generate a PRD using the prd skill:
```
/prd Build a CLI tool that...
```
This creates a `PRD.md` in your project.

**Step 2: Convert the PRD to prd.json**

```
/ralph
```
This converts `PRD.md` into `prd.json` — a structured task list that ralph reads.

**Step 3: Run the loop**

```bash
ralph --tool claude
```

Ralph will:
1. Read `prd.json` to find the next incomplete story
2. Spawn a **fresh Claude Code subprocess** with `--no-session-persistence` for context isolation
3. Claude implements the story, runs quality checks, commits
4. Appends to `progress.txt`
5. Repeats until all stories are done or max iterations (default: 10) is reached

**Context isolation:** Each iteration is a completely fresh Claude Code process—no context carries over from previous iterations. This keeps token usage predictable and prevents stories from interfering with each other.

**Important — where ralph looks for files:**

Ralph resolves `prd.json`, `progress.txt`, and `CLAUDE.md` relative to the `scripts/` directory inside chezmoi (i.e., `~/.local/share/chezmoi/scripts/`), not your project directory. To use ralph per-project, copy or symlink those files:

```bash
# In your project root
cp ~/.local/share/chezmoi/scripts/prd.json . 2>/dev/null || touch prd.json
touch progress.txt
```

Or run ralph from the scripts dir while pointing it at your project — see the [upstream README](https://github.com/snarktank/ralph) for advanced usage.

**Options:**
```bash
ralph --tool claude        # use Claude Code (recommended)
ralph --tool amp           # use Amp (original default)
ralph --tool claude 20     # run up to 20 iterations
```

**Stop condition:** Ralph exits when Claude outputs `<promise>COMPLETE</promise>`, which happens when all stories in `prd.json` have `passes: true`.

---

## Shell Cheat Sheet

### Navigation

```zsh
dot       # cd to chezmoi source dir (~/.local/share/chezmoi)
scripts   # cd to scripts dir
repos     # cd to ~/Repos
ghrepos   # cd to ~/Repos/github.com/santiagobermudezparra
```

### Git

```zsh
gs        # git status
gp        # git pull
lg        # lazygit
```

### DevPod

```zsh
ds <name>  # devpod ssh into a running container
```

### Kubernetes

```zsh
k         # kubectl
kgp       # kubectl get pods
kc        # kubectx (switch cluster)
kn        # kubens (switch namespace)
fgk       # flux get kustomizations
```

---

## Neovim Tree Explorer

| Key | Action |
|---|---|
| `<Space> e` | Toggle tree view |
| `:Neotree reveal` | Show current file in tree |
| `h` | Collapse folder |
| `l` / `<CR>` | Expand folder / open file |
| `a` | Add new file |
| `d` | Delete file/folder |
| `r` | Rename |
| `y` | Copy file path |
| `q` / `<Esc>` | Close tree |

**Moving between windows:**

| Key | Action |
|---|---|
| `<C-w> h` | Focus tree pane |
| `<C-w> l` | Focus editor pane |
| `<C-w> j/k` | Move down/up |
| `H` | Move between tabs |
| `<Space> bd` | Close current tab |

**Search:**
- `<Space> /` → Global text search (grep)
  - `<Tab>` → Next result
  - `<S-Tab>` → Previous result
  - `<CR>` → Open file

# dotfiles-chezmoi

Personal dotfiles managed with [chezmoi](https://chezmoi.io), designed to work in two environments:

- **Plain Linux machines** (VMs, home servers, bare-metal) — provisioned with the `setup` script
- **DevPod containers** — dotfiles applied automatically on container creation

---

## How It Works

### chezmoi

[chezmoi](https://chezmoi.io) is the dotfiles manager. It lives in `~/.local/share/chezmoi/` (the source directory) and applies files to their real locations on your system.

**File naming convention:**

| Source (this repo) | Applied location |
|---|---|
| `dot_zshrc` | `~/.zshrc` |
| `dot_zprofile` | `~/.zprofile` |
| `dot_tmux.conf` | `~/.tmux.conf` |
| `dot_config/nvim/` | `~/.config/nvim/` |
| `dot_config/mise/config.toml` | `~/.config/mise/config.toml` |
| `dot_claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
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

---

## Setup — Plain Linux Machine

Use this for any plain Linux machine (VM, home server, Ubuntu SSH box, etc.) where you are **not** using DevPod.

**Prerequisites:** `curl`, `git`, and `zsh` must be available (`apt install -y curl git zsh`).

**One-liner bootstrap:**
```bash
curl -fsSL https://raw.githubusercontent.com/santiagobermudezparra/dotfiles/main/setup | bash
```

**What it does, in order:**

1. Sets zsh as your default shell (`chsh`)
2. Installs chezmoi (to `~/.local/bin/chezmoi`) and applies these dotfiles
3. Clones the [pure](https://github.com/sindresorhus/pure) prompt into `~/.zsh/pure`
4. Installs `jq` (via apt or brew, whichever is available)
5. Installs Claude Code CLI via the native installer

> **Note:** The chezmoi `run_once` script (`.chezmoiscripts/run_once_after_install_pure.sh`) also ensures pure is cloned whenever `chezmoi apply` is run on a fresh machine, so the prompt works even if you skip the `setup` script and bootstrap with chezmoi directly.

**After setup, open a new shell or run:**
```bash
source ~/.zshrc
```

**Verify everything loaded:**
```bash
prompt        # should show "pure" in the list
bat --version # should work (installed via mise)
lsd --version # should work (installed via mise)
```

**If mise-installed tools aren't found yet**, run:
```bash
~/.local/bin/mise install
```

---

## Setup — DevPod

[DevPod](https://devpod.sh) spins up development containers from any repo. The dotfiles are automatically applied inside each container on first boot.

To provision a container for a project:
```bash
devpod up .
```

Or point the DevPod UI at any Git repo. The setup script runs automatically, giving you the same shell, tools, and scripts inside every container.

---

## Shell Cheat Sheet

### Navigation

```zsh
dot       # cd to chezmoi source dir (~/.local/share/chezmoi)
scripts   # cd to scripts dir
repos     # cd to ~/Repos
ghrepos   # cd to ~/Repos/github.com/santiagobermudezparra
zo        # interactive directory jump (via 0-cd)
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

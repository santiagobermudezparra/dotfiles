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

## Ralph — Autonomous AI Development Loop

[Ralph](https://github.com/snarktank/ralph) is an autonomous AI development loop for multi-story feature development. You provide a PRD (Product Requirements Document) with user stories, and Ralph implements them one at a time using Claude Code until all work is complete.

Ralph achieves context isolation by spawning a fresh Claude Code process for each story (preventing earlier work from biasing later work) and persisting knowledge through git commits, progress.txt learnings, and CLAUDE.md instructions.

**Setup in these dotfiles:**
- `scripts/ralph` — main loop script, available as `ralph` command
- `dot_claude/CLAUDE.md` → `~/.claude/CLAUDE.md` — agent instructions
- `dot_claude/skills/ralph/SKILL.md` and `dot_claude/skills/prd/SKILL.md` — helper skills

### Quick Start (4 Steps)

**Step 1: Create a PRD**

```bash
claude code
# Inside Claude Code:
/prd Build a CLI tool that fetches weather data
```

This creates `PRD.md` with structured user stories.

**Step 2: Convert to prd.json**

```bash
/ralph
```

Creates `prd.json` with stories (each marked `passes: false` initially).

**Step 3: Initialize progress file**

```bash
touch progress.txt
```

Ralph uses this to accumulate learnings across iterations.

**Step 4: Run Ralph**

```bash
ralph --tool claude
```

Ralph spawns a fresh Claude instance for each story. Each iteration:
1. Reads prd.json to find next incomplete story
2. Spawns fresh Claude subprocess with clean context
3. Claude implements the story (checks out branch, writes code, runs checks, commits)
4. Appends learnings to progress.txt
5. Marks story as `passes: true`
6. Repeats until all stories complete

**Output example:**

```
===============================================================
  Ralph Iteration 1 of 10 (claude)
===============================================================
[Claude implements STORY-1, commits, appends to progress.txt]
Iteration 1 complete. Continuing...

===============================================================
  Ralph Iteration 2 of 10 (claude)
===============================================================
[Fresh Claude instance. Reads progress.txt. Implements STORY-2]
Iteration 2 complete. Continuing...

Ralph completed all tasks!
```

### Command Reference

```bash
ralph --tool claude          # Run with Claude Code (default 10 iterations)
ralph --tool claude 20       # Run with 20 iterations
ralph --tool amp             # Use Amp instead
cat progress.txt             # Check learnings accumulated
cat prd.json | jq '.userStories[] | {id, title, passes}'  # Story status
```

### How Ralph Learns: Progress.txt & Codebase Patterns

Ralph learns across iterations through **progress.txt**. At the start is a `## Codebase Patterns` section consolidating reusable conventions:

```
## Codebase Patterns

- When modifying API schema, update TypeScript types in types.ts to stay in sync
- Always use IF NOT EXISTS for database migrations
- Tests require NODE_ENV=test and dev server on PORT=3000
- The eval panel is in src/components/EvaluationPanel.tsx
```

Each iteration appends detailed learnings. Future Claude instances read these patterns first, so they understand conventions without re-learning them.

**Quality Assurance:** Ralph enforces quality checks before every commit. If typecheck, lint, or tests fail, Claude must fix issues before committing.

**File Resolution:** Ralph looks for prd.json and progress.txt in the directory where you run `ralph`. To use per-project:

```bash
cp ~/.local/share/chezmoi/scripts/prd.json .
touch progress.txt
ralph --tool claude  # Reads local files
```

### How it Works: Context Isolation & Knowledge Persistence

For detailed explanations of context isolation, knowledge persistence mechanisms, and codebase pattern guidance, see:

- **[scripts/RALPH.md](scripts/RALPH.md)** — Complete technical guide (context rooting problem, three-layer persistence model, pattern extraction criteria, verification steps)
- **[scripts/RALPH-ARCHITECTURE.md](scripts/RALPH-ARCHITECTURE.md)** — Industry patterns and architecture (sub-agent spawning, progressive disclosure, lab notebook pattern, state transitions)
- **[dot_claude/CLAUDE.md](dot_claude/CLAUDE.md)** — Agent instructions and step-by-step workflow

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

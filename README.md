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

[Ralph](https://github.com/snarktank/ralph) is an autonomous AI development loop. You give it a PRD (Product Requirements Document) with user stories, and it implements them one at a time using Claude Code until all work is complete.

**How it works:** Ralph spawns a fresh Claude Code instance for each story, ensuring clean context and preventing earlier work from influencing later stories. Knowledge persists through git history, `progress.txt`, and structured learnings.

### Setup in These Dotfiles

Ralph is pre-configured and ready to use:

- `scripts/ralph` — the main loop script, available as `ralph` anywhere in your shell
- `dot_claude/CLAUDE.md` → `~/.claude/CLAUDE.md` — agent instructions Ralph reads each iteration
- `dot_claude/skills/ralph/SKILL.md` → `~/.claude/skills/ralph/SKILL.md` — skill for converting PRDs to `prd.json`
- `dot_claude/skills/prd/SKILL.md` → `~/.claude/skills/prd/SKILL.md` — skill for generating PRDs

### Step-by-Step: Using Ralph in a Project

#### Step 1: Create a PRD (Product Requirements Document)

In your project directory, start a Claude Code session and generate a PRD:

```bash
claude code
```

Once in Claude Code, ask it to generate a PRD:

```
/prd Build a CLI tool that fetches and displays weather data
```

This creates `PRD.md` in your project with structured user stories.

#### Step 2: Convert PRD to prd.json

Convert your markdown PRD into the JSON format Ralph reads:

```bash
claude code --print --dangerously-skip-permissions < ~/.local/share/chezmoi/scripts/CLAUDE.md
# Or simpler: use the /ralph skill if you have it loaded
/ralph
```

This creates `prd.json` with structured stories including:
- Story ID, title, and description
- Priority level
- Branch name for the feature
- Initial `passes: false` for all stories

#### Step 3: Initialize Progress Files

In your project root, create the progress tracking file:

```bash
touch progress.txt
```

Ralph will use this to track learnings across iterations.

#### Step 4: Run Ralph

Start the autonomous loop:

```bash
ralph --tool claude
```

**What Ralph does each iteration:**

1. **Reads prd.json** to find the highest-priority story where `passes: false`
2. **Spawns fresh Claude Code subprocess** with clean context (no history from previous stories)
3. **Claude implements** that single story:
   - Checks out the feature branch
   - Writes code following quality standards
   - Runs typecheck, lint, and tests
   - Commits changes with proper message format
4. **Appends progress** — documents what was built and learnings for future iterations
5. **Updates prd.json** — marks the story as `passes: true`
6. **Repeats** — spawns next iteration for the next story
7. **Stops** — when all stories are complete or max iterations reached

**Output example:**

```
===============================================================
  Ralph Iteration 1 of 10 (claude)
===============================================================
[Claude implements story STORY-1]
[Commits, runs checks, appends to progress.txt]
Iteration 1 complete. Continuing...

===============================================================
  Ralph Iteration 2 of 10 (claude)
===============================================================
[Fresh Claude instance, clean context]
[Claude implements story STORY-2]
Iteration 2 complete. Continuing...

[...]

Ralph completed all tasks!
Completed at iteration 3 of 10
```

### Understanding Progress.txt and Codebase Patterns

Ralph learns across iterations through **progress.txt**. Each iteration appends a section like:

```
## 2026-03-24 - STORY-1

**Implemented:**
- Added authentication middleware
- JWT token validation on protected routes

**Files Changed:**
- `src/auth/middleware.ts`
- `tests/auth/middleware.test.ts`

**Learnings for Future Iterations:**
- Pattern: Always use `IF NOT EXISTS` for database migrations
- Gotcha: JWT header must be `Authorization: Bearer <token>` format
- Useful context: JWT secrets are in `process.env.JWT_SECRET`, never hardcode

---
```

At the **start of progress.txt**, a `## Codebase Patterns` section consolidates the most important reusable patterns:

```
## Codebase Patterns

- When modifying the API schema, update TypeScript types in `types.ts` to stay in sync
- Use `sql<number>` template syntax for all SQL aggregations
- Always use `IF NOT EXISTS` for database migrations
- Export types from `actions.ts` for UI components that need them
- The evaluation panel is in `src/components/EvaluationPanel.tsx`

---
```

**This is how Ralph preserves knowledge** — each iteration reads these patterns and understands the codebase conventions without re-learning them.

### Command Reference

```bash
# Run Ralph with Claude Code (recommended, default 10 iterations)
ralph --tool claude

# Run Ralph with up to 20 iterations
ralph --tool claude 20

# Use Amp instead (original tool, less recommended)
ralph --tool amp

# Check progress
cat progress.txt

# View story completion status
cat prd.json | jq '.userStories[] | {id, title, passes}'

# View commit history
git log --oneline -10
```

### Important Notes

**Where Ralph Looks for Files:**

Ralph resolves files relative to `~/.local/share/chezmoi/scripts/` (the chezmoi scripts directory), NOT your project root. To use Ralph per-project:

```bash
# In your project root, copy these files
cp ~/.local/share/chezmoi/scripts/prd.json . 2>/dev/null || echo '{
  "title": "My Project",
  "branchName": "ralph/feature-branch",
  "userStories": []
}' > prd.json

touch progress.txt
```

Now when you run `ralph --tool claude` from your project root, it will read these local files.

**Quality Checks:**

Ralph enforces quality before every commit. If typecheck, lint, or tests fail, Claude cannot commit and must fix the issues. This prevents broken code from accumulating across iterations.

**Context Isolation:**

Each iteration is a **completely fresh Claude Code process** with no memory of previous iterations. This keeps token usage predictable and prevents stories from interfering with each other. Knowledge persists only through git commits and progress.txt.

**Stop Condition:**

Ralph exits automatically when all stories in `prd.json` have `passes: true`, or when it reaches max iterations.

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

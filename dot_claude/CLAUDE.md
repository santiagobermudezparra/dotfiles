# Claude Code Instructions

These are personal dotfiles managed with chezmoi. When making changes here:

- Edit files in `~/.local/share/chezmoi/` (the source dir), then run `chezmoi apply`
- `dot_` prefix maps to `.` — e.g. `dot_zshrc` → `~/.zshrc`
- Scripts in `scripts/` are live on `$PATH` immediately after `chezmoi apply` (no copy step)
- The chezmoi source dir is aliased as `dot` in the shell

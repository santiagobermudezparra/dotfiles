# dotfiles-chezmoi

## What This Is

A chezmoi-managed dotfiles repository used to provision DevPod containers for development work, including a personal K8s homelab. Cleaned from an inherited YouTuber config — contains only generic, portable tooling plus a Ralph AI agent loop setup.

## Core Value

A clean, portable dotfiles base that provisions DevPod containers with exactly what's needed — no more, no less.

## Shipped: v1.0 Cleaning Up Dotfiles

**Phases:** 1-3 | **Plans:** 5 | **Shipped:** 2026-03-22

### Validated Requirements

- ✓ AUDIT-01: Report classifying every script (18 Keep / 25 Remove / 3 Review) — v1.0
- ✓ AUDIT-02: YouTuber-specific tools flagged across all configs (17 entries) — v1.0
- ✓ AUDIT-03: Env vars and aliases referencing undefined paths flagged — v1.0
- ✓ AUDIT-04: Missing tools listed with install methods — v1.0
- ✓ AUDIT-05: 9 concrete DevPod improvement suggestions documented — v1.0
- ✓ CLEAN-01: 29 YouTuber-specific scripts removed (18 remain) — v1.0
- ✓ CLEAN-02: Dead aliases and undefined vars removed from zshrc — v1.0
- ✓ CLEAN-03: setup script container-safe (DevPod/Codespaces guards) — v1.0
- ✓ RALPH-01: `scripts/ralph` on PATH — runs from any project directory — v1.0
- ✓ RALPH-02: setup installs Claude Code CLI (native installer + /tmp guard) + jq — v1.0
- ✓ RALPH-03: `dot_claude/CLAUDE.md` → `~/.claude/CLAUDE.md` via chezmoi — v1.0
- ✓ RALPH-04: CLAUDE.md has 9-step Ralph workflow, quality gates, stop condition — v1.0

## Current State

- 18 generic scripts in scripts/ (all useful, none YouTuber-specific)
- dot_zshrc: clean — no dead aliases, no undefined env vars
- mise manages: node, neovim, ripgrep, lsd, bat, fzf, fd, chezmoi, usage
- setup.sh: container-safe, installs Claude Code CLI + jq on provision
- Ralph: `ralph` on PATH, `~/.claude/CLAUDE.md` auto-read by Claude Code, skills at `~/.claude/skills/`
- 3 Review scripts remain for user decision: google, google (center, transcode-audio already Keep)

## Next Milestone Goals

- [ ] Validate Ralph loop works end-to-end in a live DevPod container
- [ ] Address 3 Review-status scripts (keep/remove: google)
- [ ] Consider adding gh CLI, lazygit, direnv, delta to mise (from AUDIT-04 suggestions)
- [ ] Review Hyprland/Waybar configs — remove if truly not needed

## Context

- Managed with chezmoi; `dot_` prefix maps files to target on apply
- Primary use: DevPod containers for development (K8s homelab, general dev)
- Secondary use: local macOS dev machine
- Tool manager: mise for dev tools; setup.sh for system-level installs
- Container-first: all config has DevPod detection guards

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Claude Code CLI via native installer | npm install deprecated early 2026; binary at ~/.local/bin | ✓ Good |
| Audit before delete | Don't lose anything until we understand what it does | ✓ Good |
| Node stays in mise (not setup.sh) | User confirmed mise-first approach | ✓ Good |
| Ralph files from snarktank/ralph source | Keeps upstream behavior | ✓ Good |
| dot_config/claude/CLAUDE.md deleted | Wrong path — Claude Code reads ~/.claude/CLAUDE.md | ✓ Good |

---
*Last updated: 2026-03-22 after v1.0 milestone*

# dotfiles-chezmoi

## What This Is

A chezmoi-managed dotfiles repository used primarily to provision DevPod containers for development work, including a personal K8s homelab. Originally forked from a YouTuber's config, it needs to be audited and cleaned up to match the owner's actual workflow.

## Core Value

A clean, portable dotfiles base that provisions DevPod containers with exactly what's needed — no more, no less.

## Current Milestone: v1.0 Cleaning Up Dotfiles

**Goal:** Audit the inherited dotfiles, identify what's generic vs YouTuber-specific, add missing tools (Python, Claude Code CLI), and prepare the repo for a follow-up cleanup pass.

**Target features:**
- Comprehensive audit report across scripts, configs, aliases, and env vars
- Setup script updated for DevPod container compatibility

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

- ✓ AUDIT-01: Report classifying every script (18 Keep / 25 Remove / 3 Review) — Phase 1
- ✓ AUDIT-02: YouTuber-specific tools flagged across all configs (17 entries) — Phase 1
- ✓ AUDIT-03: Env vars and aliases referencing undefined paths flagged ($ICLOUD, $ZETTELKASTEN, $LAB) — Phase 1
- ✓ AUDIT-04: Missing tools listed with install methods (gh, lazygit, direnv, delta, Claude Code CLI) — Phase 1
- ✓ AUDIT-05: 9 concrete DevPod improvement suggestions documented — Phase 1

### Active

<!-- Current scope. Building toward these. -->

- ✓ CLEAN-01: 29 YouTuber-specific scripts removed (18 remain) — Phase 2
- ✓ CLEAN-02: Dead aliases (icloud, cdblog, 0, zo, lab, in, cdzk, sub, pc) and undefined vars removed from zshrc — Phase 2
- ✓ CLEAN-03: setup script guarded with container detection — safe in DevPod/Codespaces — Phase 2
- ✓ RALPH-01: `scripts/ralph` on PATH — runs from any project directory — Phase 3
- ✓ RALPH-02: setup installs Claude Code CLI (native installer + /tmp guard) + jq — Phase 3
- ✓ RALPH-03: `dot_claude/CLAUDE.md` → `~/.claude/CLAUDE.md` via chezmoi — auto-read by Claude Code — Phase 3
- ✓ RALPH-04: CLAUDE.md has 9-step Ralph workflow, quality gates, stop condition — Phase 3

### Out of Scope

<!-- Explicit boundaries. -->

- Deleting any files without auditing first — done: audit + cleanup complete
- Hyprland/Waybar config changes — Linux WM configs, not relevant to DevPod
- Neovim plugin changes — separate concern

## Context

- Managed with chezmoi; files prefixed with `dot_` map to their target locations on apply
- Primary use: DevPod containers for development (K8s homelab, general dev)
- Secondary use: local macOS dev machine
- Cleaned from YouTuber's config — 29 scripts removed, dead aliases purged, 18 generic scripts remain
- mise manages: node, neovim, ripgrep, lsd, bat, fzf, fd, chezmoi, usage
- setup.sh installs: Claude Code CLI (native installer), jq — DevPod-safe with container guards
- Ralph AI loop: `scripts/ralph` on PATH, `dot_claude/CLAUDE.md` auto-read by Claude Code, skills at `dot_claude/skills/`

## Constraints

- **Tool manager**: mise for dev tools; setup.sh for system-level installs (Claude Code CLI, jq)
- **Container-first**: all changes work in a DevPod/Linux container context

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Claude Code CLI via native installer in setup.sh | npm install deprecated as of early 2026; binary lands at ~/.local/bin already on PATH | ✓ Good |
| Audit before delete | Don't lose anything until we understand what it does | ✓ Good — audit complete, 29 scripts removed |
| Node stays in mise (not setup.sh) | User confirmed mise-first approach; no conflict with Phase 3 | ✓ Good |
| Ralph files fetched from snarktank/ralph source | Keeps upstream behavior; skills and loop script match official implementation | ✓ Good |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd:transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd:complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-03-22 — Milestone v1.0 complete (all 3 phases)*

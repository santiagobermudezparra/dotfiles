# dotfiles-chezmoi

## What This Is

A chezmoi-managed dotfiles repository used primarily to provision DevPod containers for development work, including a personal K8s homelab. Originally forked from a YouTuber's config, it needs to be audited and cleaned up to match the owner's actual workflow.

## Core Value

A clean, portable dotfiles base that provisions DevPod containers with exactly what's needed — no more, no less.

## Current Milestone: v1.0 Cleaning Up Dotfiles

**Goal:** Audit the inherited dotfiles, identify what's generic vs YouTuber-specific, add missing tools (Python, Claude Code CLI), and prepare the repo for a follow-up cleanup pass.

**Target features:**
- Comprehensive audit report across scripts, configs, aliases, and env vars
- Python and Claude Code CLI added via mise
- Setup script updated for DevPod container compatibility

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

(None yet — ship to validate)

### Active

<!-- Current scope. Building toward these. -->

- [ ] AUDIT-01: Produce a report classifying every script (generic/YouTuber-specific/remove candidate)
- [ ] AUDIT-02: Flag YouTuber-specific tools referenced across all configs (newsboat, pomo, brightnessctl, osascript, etc.)
- [ ] AUDIT-03: Flag env vars and aliases in zshrc that reference non-existent or personal paths ($ICLOUD, $ZETTELKASTEN, $LAB, etc.)
- [ ] AUDIT-04: Identify missing tools for your workflow and suggest additions
- [ ] AUDIT-05: Suggest improvements to make this a better DevPod base image
- [ ] TOOL-01: Add python = "latest" to mise config
- [ ] TOOL-02: Add Claude Code CLI to mise config
- [ ] SETUP-01: Update setup script to work cleanly in a DevPod container

### Out of Scope

<!-- Explicit boundaries. -->

- Deleting any files — audit-first, delete in a follow-up milestone
- Hyprland/Waybar config changes — Linux WM configs, not relevant to DevPod
- Neovim plugin changes — separate concern

## Context

- Managed with chezmoi; files prefixed with `dot_` map to `~/.config/...`
- Primary use: DevPod containers for development (K8s homelab, general dev)
- Secondary use: local macOS dev machine
- Inherited from a YouTuber's config — many scripts and aliases reference tools/workflows that don't apply
- mise is the tool version manager (already has node, neovim, ripgrep, lsd, bat, fzf, fd)
- zshrc already has DevPod container detection logic (`$REMOTE_CONTAINERS`, `$DEVCONTAINER_TYPE`)
- ~40 scripts in the scripts/ folder, many of unknown purpose

## Constraints

- **Scope**: Audit only — no deletions this milestone
- **Tool manager**: mise (not homebrew) for adding new tools
- **Container-first**: all changes must work in a DevPod/Linux container context

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Python + Claude Code CLI via mise | Consistent with existing tool management pattern | — Pending |
| Audit before delete | Don't lose anything until we understand what it does | — Pending |

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
*Last updated: 2026-03-22 — Milestone v1.0 started*

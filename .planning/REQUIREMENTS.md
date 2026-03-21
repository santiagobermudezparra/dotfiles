# Requirements: dotfiles-chezmoi

**Defined:** 2026-03-22
**Core Value:** A clean, portable dotfiles base that provisions DevPod containers with exactly what's needed — no more, no less.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Audit

- [x] **AUDIT-01**: User can read a report classifying every script as generic, YouTuber-specific, or remove candidate
- [x] **AUDIT-02**: User can see all YouTuber-specific tools flagged across all configs (newsboat, pomo, brightnessctl, osascript, etc.)
- [x] **AUDIT-03**: User can see all env vars and aliases in zshrc that reference non-existent or personal paths ($ICLOUD, $ZETTELKASTEN, $LAB, etc.)
- [x] **AUDIT-04**: User can see a list of missing tools for their workflow with suggested additions
- [x] **AUDIT-05**: User can read concrete suggestions for improving this as a DevPod base image

### Cleanup

- [x] **CLEAN-01**: User can remove all flagged YouTuber-specific scripts (based on audit)
- [x] **CLEAN-02**: User can remove unused aliases and env vars from zshrc (based on audit)
- [x] **CLEAN-03**: User can update setup script to work in DevPod containers without macOS/GUI errors

### Ralph Integration

- [x] **RALPH-01**: User can run `ralph` from any project directory inside a DevPod container
- [x] **RALPH-02**: User can provision a container with Node and Claude Code CLI installed via setup script
- [x] **RALPH-03**: Claude Code auto-reads a global CLAUDE.md on every session start (mapped via chezmoi to ~/.claude/CLAUDE.md)
- [x] **RALPH-04**: CLAUDE.md is pre-populated with Ralph conventions so new projects need minimal setup

## Out of Scope

| Feature | Reason |
|---------|--------|
| Python via mise in dotfiles base | Handled per-project via mise locals, not dotfiles-level |
| Claude Code via mise in dotfiles base | Installed by setup.sh directly — mise is per-project |
| Neovim plugin changes | Separate concern, not part of this cleanup |
| Hyprland/Waybar config changes | Linux WM configs, not relevant to DevPod use case |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| AUDIT-01 | Phase 1 | Complete |
| AUDIT-02 | Phase 1 | Complete |
| AUDIT-03 | Phase 1 | Complete |
| AUDIT-04 | Phase 1 | Complete |
| AUDIT-05 | Phase 1 | Complete |
| CLEAN-01 | Phase 2 | Complete |
| CLEAN-02 | Phase 2 | Complete |
| CLEAN-03 | Phase 2 | Complete |
| RALPH-01 | Phase 3 | Complete |
| RALPH-02 | Phase 3 | Complete |
| RALPH-03 | Phase 3 | Complete |
| RALPH-04 | Phase 3 | Complete |

**Coverage:**
- v1 requirements: 12 total
- Mapped to phases: 12
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-22*
*Last updated: 2026-03-22 — Restructured: dropped mise tooling, added Cleanup phase and Ralph Integration phase*

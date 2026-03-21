# Requirements: dotfiles-chezmoi

**Defined:** 2026-03-22
**Core Value:** A clean, portable dotfiles base that provisions DevPod containers with exactly what's needed — no more, no less.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Audit

- [ ] **AUDIT-01**: User can read a report classifying every script as generic, YouTuber-specific, or remove candidate
- [ ] **AUDIT-02**: User can see all YouTuber-specific tools flagged across all configs (newsboat, pomo, brightnessctl, osascript, etc.)
- [ ] **AUDIT-03**: User can see all env vars and aliases in zshrc that reference non-existent or personal paths ($ICLOUD, $ZETTELKASTEN, $LAB, etc.)
- [ ] **AUDIT-04**: User can see a list of missing tools for their workflow with suggested additions
- [ ] **AUDIT-05**: User can read concrete suggestions for improving this as a DevPod base image

### Tooling

- [ ] **TOOL-01**: User can provision a container with Python managed via mise
- [ ] **TOOL-02**: User can provision a container with Claude Code CLI managed via mise

### Setup

- [ ] **SETUP-01**: User can run the setup script in a DevPod container without macOS/GUI errors

## v2 Requirements

Deferred to follow-up milestone.

### Cleanup

- **CLEAN-01**: User can remove all flagged YouTuber-specific scripts
- **CLEAN-02**: User can remove unused aliases and env vars from zshrc
- **CLEAN-03**: User can remove Hyprland/Waybar configs (Linux WM not needed in containers)

## Out of Scope

| Feature | Reason |
|---------|--------|
| Deleting any files | Audit-first milestone — deletions happen in v1.1 |
| Neovim plugin changes | Separate concern, not part of this cleanup |
| Hyprland/Waybar config changes | Linux WM configs, not relevant to DevPod use case |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| AUDIT-01 | Phase 1 | Pending |
| AUDIT-02 | Phase 1 | Pending |
| AUDIT-03 | Phase 1 | Pending |
| AUDIT-04 | Phase 1 | Pending |
| AUDIT-05 | Phase 1 | Pending |
| TOOL-01 | Phase 2 | Pending |
| TOOL-02 | Phase 2 | Pending |
| SETUP-01 | Phase 2 | Pending |

**Coverage:**
- v1 requirements: 8 total
- Mapped to phases: 8
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-22*
*Last updated: 2026-03-22 after initial definition*

# Roadmap: dotfiles-chezmoi

## Overview

Milestone v1.0 delivers two things in sequence: first, a comprehensive audit of the inherited dotfiles repo — classifying every script, flagging YouTuber-specific tools and personal paths, and surfacing concrete DevPod improvement suggestions — then, targeted tooling additions (Python and Claude Code CLI via mise) and a setup script fix for DevPod container compatibility. The audit informs everything that comes after.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 1: Audit** - Read the full repo and produce AUDIT-REPORT.md classifying all scripts, tools, env vars, and aliases
- [ ] **Phase 2: Tooling and Setup** - Add Python and Claude Code CLI via mise; fix setup script for DevPod container compatibility

## Phase Details

### Phase 1: Audit
**Goal**: User has a complete AUDIT-REPORT.md that gives a clear, actionable picture of the inherited dotfiles
**Depends on**: Nothing (first phase)
**Requirements**: AUDIT-01, AUDIT-02, AUDIT-03, AUDIT-04, AUDIT-05
**Success Criteria** (what must be TRUE):
  1. User can open AUDIT-REPORT.md and see every script classified as generic, YouTuber-specific, or remove candidate
  2. User can see a consolidated list of YouTuber-specific tools referenced across all configs (newsboat, pomo, brightnessctl, osascript, etc.)
  3. User can see all env vars and aliases in zshrc that reference non-existent or personal paths ($ICLOUD, $ZETTELKASTEN, $LAB, etc.)
  4. User can read a list of workflow tools not currently present with concrete suggestions for adding them
  5. User can read concrete, actionable suggestions for improving the repo as a DevPod base image
**Plans**: TBD

### Phase 2: Tooling and Setup
**Goal**: User can provision a DevPod container that includes Python and Claude Code CLI, and run the setup script without macOS/GUI errors
**Depends on**: Phase 1
**Requirements**: TOOL-01, TOOL-02, SETUP-01
**Success Criteria** (what must be TRUE):
  1. User can provision a container and run `python --version` with a mise-managed Python installed
  2. User can provision a container and run `claude --version` with Claude Code CLI installed via mise
  3. User can run the setup script inside a DevPod container without it failing on macOS-only or GUI-dependent steps
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Audit | 0/TBD | Not started | - |
| 2. Tooling and Setup | 0/TBD | Not started | - |

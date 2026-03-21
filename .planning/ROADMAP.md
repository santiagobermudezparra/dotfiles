# Roadmap: dotfiles-chezmoi

## Overview

Milestone v1.0 delivers three phases in sequence: (1) a comprehensive audit of the inherited dotfiles repo — classifying every script, flagging YouTuber-specific tools and personal paths, and surfacing concrete DevPod improvement suggestions; (2) cleanup — removing flagged items and fixing the setup script for DevPod containers; (3) Ralph integration — adding the Ralph AI agent loop (ralph.sh, skills/, global CLAUDE.md) so any DevPod container is instantly ready for Claude Code + Ralph-driven development.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Audit** - Read the full repo and produce AUDIT-REPORT.md classifying all scripts, tools, env vars, and aliases (completed 2026-03-21)
- [ ] **Phase 2: Cleanup** - Remove flagged YouTuber-specific scripts, aliases, and env vars; fix setup script for DevPod
- [ ] **Phase 3: Ralph Integration** - Add ralph.sh, skills/, and global CLAUDE.md to dotfiles; setup.sh installs Node + Claude Code CLI

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
**Plans:** 1/1 plans complete

Plans:
- [x] 01-01-PLAN.md — Read all repo files and write AUDIT-REPORT.md with all 5 sections

### Phase 2: Cleanup
**Goal**: The dotfiles repo contains only files and config relevant to the user's actual workflow
**Depends on**: Phase 1 (audit report must exist to guide deletions)
**Requirements**: CLEAN-01, CLEAN-02, CLEAN-03
**Success Criteria** (what must be TRUE):
  1. All scripts flagged as "remove" in AUDIT-REPORT.md are deleted
  2. All aliases and env vars flagged as personal/unused are removed from zshrc
  3. Setup script runs inside a DevPod container without failing on macOS/GUI-only steps
**Plans:** 2 plans

Plans:
- [ ] 02-01-PLAN.md — Delete 29 Remove scripts and guard sudo chsh in setup for containers
- [ ] 02-02-PLAN.md — Remove dead aliases, env vars, and section headers from dot_zshrc

### Phase 3: Ralph Integration
**Goal**: Any DevPod container provisioned from these dotfiles is instantly ready for Claude Code + Ralph-driven development
**Depends on**: Phase 2 (clean base before adding new structure)
**Requirements**: RALPH-01, RALPH-02, RALPH-03, RALPH-04
**Success Criteria** (what must be TRUE):
  1. User can run `ralph` from any project directory inside a DevPod container
  2. User can provision a container and run `node --version` and `claude --version` without additional setup
  3. Claude Code auto-reads ~/.claude/CLAUDE.md on session start (chezmoi maps dot_claude/CLAUDE.md)
  4. CLAUDE.md contains Ralph conventions so new projects need only swap project-specific details
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Audit | 1/1 | Complete    | 2026-03-21 |
| 2. Cleanup | 0/2 | In progress | - |
| 3. Ralph Integration | 0/TBD | Not started | - |

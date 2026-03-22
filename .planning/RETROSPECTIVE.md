# Retrospective

## Milestone: v1.0 — Cleaning Up Dotfiles

**Shipped:** 2026-03-22
**Phases:** 3 | **Plans:** 5

### What Was Built

- Comprehensive audit report classifying 47 scripts across inherited YouTuber dotfiles
- Deleted 29 YouTuber-specific scripts; cleaned zshrc of 9 dead aliases and 3 undefined env vars
- Added Ralph AI agent loop (scripts/ralph, CLAUDE.md, skills/) + Claude Code CLI install to setup

### What Worked

- Audit-first approach: having AUDIT-REPORT.md as source of truth made Phase 2 cleanup mechanical — no judgment calls during execution
- Parallel plan execution: Phase 2 and Phase 3 both ran 2 plans in parallel cleanly, no conflicts
- Research revealed npm deprecation for Claude Code install — caught before implementation

### What Was Inefficient

- CONTEXT.md was created for Phase 1 but not Phase 2/3 — the workflow skipped discuss-phase for those; worked fine but slightly less structured
- Milestone naming in STATE.md used "milestone" placeholder for the name — cosmetic but worth fixing in future

### Patterns Established

- Container detection pattern (`$REMOTE_CONTAINERS`, `$CODESPACES`, `$DEVCONTAINER_TYPE`) — reuse this for any macOS-only code in setup
- mise for dev tools, setup.sh for system-level installs — clear separation of concerns
- `dot_claude/` chezmoi prefix → `~/.claude/` for Claude Code global config

### Key Lessons

- Always check the official install method before planning — npm for Claude Code was deprecated and would have broken Phase 3
- The `cd /tmp` guard before the Claude Code installer is non-obvious but critical (prevents filesystem scan hang in containers)
- Inherited configs are messier than expected: 29/47 scripts (62%) were YouTuber-specific

### Cost Observations

- Model mix: ~80% sonnet, ~20% opus (planner only)
- All 3 phases completed in a single session
- Notable: research agents caught important architectural details (wrong CLAUDE.md path, installer deprecation) that saved rework

## Cross-Milestone Trends

| Milestone | Phases | Plans | Delete Ratio | Duration |
|-----------|--------|-------|--------------|----------|
| v1.0 | 3 | 5 | 29/47 scripts (62%) | 1 session |

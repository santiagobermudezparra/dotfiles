---
phase: 03-ralph-integration
plan: 02
subsystem: infra
tags: [claude-code, jq, devpod, setup, containers]

# Dependency graph
requires:
  - phase: 02-cleanup
    provides: "Container-guarded setup script baseline"
provides:
  - "setup script installs Claude Code CLI via native installer (claude.ai/install.sh)"
  - "setup script installs jq (ralph dependency) with apt-get/brew fallback"
  - "Idempotent guards prevent re-installation on re-runs"
  - "cd /tmp guard prevents installer hang in containers"
affects:
  - 03-ralph-integration

# Tech tracking
tech-stack:
  added:
    - "Claude Code CLI (native installer — https://claude.ai/install.sh)"
    - "jq (via apt-get or brew, idempotent)"
  patterns:
    - "command -v guard for idempotent tool installation"
    - "cd /tmp before curl|bash installer to prevent container filesystem scan hang"
    - "apt-get first, brew fallback, warn-only pattern for cross-platform installs"

key-files:
  created: []
  modified:
    - "setup — added jq install block and Claude Code CLI native installer block"

key-decisions:
  - "Use native claude.ai installer (not npm) — npm path deprecated early 2026; native installer is self-contained and auto-updating"
  - "cd /tmp before installer — prevents filesystem scan hang from container root directory"
  - "apt-get first, brew fallback for jq — DevPod containers are typically Debian/Ubuntu; brew covers macOS"
  - "warn-only if neither package manager available — non-fatal; user gets actionable message"

patterns-established:
  - "Pattern: cd /tmp before curl|bash installers in containers"
  - "Pattern: command -v guard makes all install blocks idempotent"

requirements-completed:
  - RALPH-02

# Metrics
duration: 5min
completed: 2026-03-22
---

# Phase 03 Plan 02: Claude Code CLI and jq Installation Summary

**setup script extended with idempotent jq and Claude Code native installer blocks, with cd /tmp guard preventing container filesystem scan hang**

## Performance

- **Duration:** ~5 min
- **Started:** 2026-03-22T00:00:00Z
- **Completed:** 2026-03-22T00:05:00Z
- **Tasks:** 1 of 1
- **Files modified:** 1

## Accomplishments

- Added jq installation block to setup (apt-get first, brew fallback, warn-only final)
- Added Claude Code CLI native installer block (command -v guard, cd /tmp guard)
- All existing blocks (chsh, chezmoi, zsh/pure, alacritty) preserved unchanged
- script still starts with `#!/bin/bash` + `set -euo pipefail`, ends with `exit 0`

## Task Commits

Each task was committed atomically:

1. **Task 1: Add Claude Code CLI and jq installation to setup script** - `ea0add2` (feat)

**Plan metadata:** (docs commit follows)

## Files Created/Modified

- `setup` — added 11 lines: jq install block + Claude Code native installer block with idempotency guards

## Decisions Made

- Native installer (`claude.ai/install.sh`) chosen over npm — npm path is deprecated as of early 2026
- `cd /tmp` added as a mandatory guard before the curl|bash command — installer scans from current directory and hangs when run from `/` in containers
- jq installed apt-get-first with brew fallback — containers are typically Debian/Ubuntu; echo warning is non-fatal so setup.sh doesn't fail on unsupported distros

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required. Installation runs automatically on next container provision.

## Known Stubs

None — both install blocks are functional. The native installer downloads a real binary; jq installs a real package.

## Next Phase Readiness

- RALPH-02 complete: new DevPod containers will have Claude Code CLI and jq after running setup
- Ready for Plan 03: ralph.sh on PATH (RALPH-01), and Plan 04: dot_claude/CLAUDE.md global conventions (RALPH-03, RALPH-04)

## Self-Check

- `ea0add2` commit exists: confirmed (committed above)
- `setup` file contains `claude.ai/install.sh`: PASS
- `setup` file contains `command -v jq`: PASS
- `setup` file contains `cd /tmp`: PASS
- `setup` file ends with `exit 0`: PASS
- git diff shows only additions (+11 lines, 0 deletions): PASS

## Self-Check: PASSED

---
*Phase: 03-ralph-integration*
*Completed: 2026-03-22*

---
phase: 02-cleanup
plan: 01
subsystem: infra
tags: [bash, scripts, chezmoi, devpod, cleanup]

# Dependency graph
requires: []
provides:
  - scripts/ directory reduced from 46 to 18 files (29 Remove-classified scripts deleted)
  - setup script with container-safe sudo chsh guard
affects: [02-cleanup]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - Container detection via REMOTE_CONTAINERS/CODESPACES/DEVCONTAINER_TYPE env vars in setup scripts

key-files:
  created: []
  modified:
    - setup
  deleted:
    - scripts/0-cd
    - scripts/backup
    - scripts/backup-weekly
    - scripts/big
    - scripts/bulkappend
    - scripts/cantsleep
    - scripts/day_bash
    - scripts/delrg
    - scripts/dnd
    - scripts/dndstatus
    - scripts/duck
    - scripts/focusstart
    - scripts/focusstop
    - scripts/hellobash
    - scripts/iterator
    - scripts/multiedit
    - scripts/nb
    - scripts/parameter_parsing
    - scripts/pomocalc
    - scripts/present
    - scripts/pub
    - scripts/scandisks
    - scripts/shorts
    - scripts/small
    - scripts/startbreak
    - scripts/stop.sh
    - scripts/sunrise
    - scripts/ticket
    - scripts/ytr

key-decisions:
  - "Deleted 29 scripts matching Remove classification in AUDIT-REPORT.md; AUDIT-REPORT summary said 25 but the table had 29 Remove rows — table is the source of truth"
  - "Container guard uses REMOTE_CONTAINERS && CODESPACES && DEVCONTAINER_TYPE check, reusing the same pattern already in dot_zshrc"

patterns-established:
  - "Container detection: wrap sudo/desktop operations with [[ -z $REMOTE_CONTAINERS && -z $CODESPACES && -z $DEVCONTAINER_TYPE ]]"

requirements-completed: [CLEAN-01, CLEAN-03]

# Metrics
duration: 5min
completed: 2026-03-22
---

# Phase 2 Plan 1: Script Cleanup and Container-Safe Setup Summary

**Deleted 29 YouTuber/personal/tutorial scripts from scripts/ leaving 18 generic Keep/Review scripts, and guarded sudo chsh in setup with REMOTE_CONTAINERS/CODESPACES/DEVCONTAINER_TYPE container detection**

## Performance

- **Duration:** ~5 min
- **Started:** 2026-03-22T06:55:33Z
- **Completed:** 2026-03-22T07:00:00Z
- **Tasks:** 2
- **Files modified:** 1 modified, 29 deleted

## Accomplishments

- Deleted all 29 Remove-classified scripts from scripts/ — only 18 Keep/Review scripts remain
- Wrapped `sudo chsh` in setup with container detection guard matching dot_zshrc pattern
- Setup script passes bash syntax check and preserves all other sections intact

## Task Commits

Each task was committed atomically:

1. **Task 1: Delete all Remove-classified scripts** - `db7bc85` (chore)
2. **Task 2: Guard sudo chsh with container detection in setup** - `ca162b6` (fix)

## Files Created/Modified

- `setup` - Added container detection guard around sudo chsh block
- `scripts/` - 29 Remove-classified scripts deleted via git rm; 18 Keep/Review scripts remain:
  - Keep: bulkreplace, center, curr, gendate, goentr, goentrtest, jqedit, m, newscript, path, postgres-db-list, push, reprename, transcode-audio, urlencode, week, welcome
  - Review: google

## Decisions Made

- The AUDIT-REPORT.md summary line says "Keep 18 | Remove 25 | Review 3" but the table itself has 29 Remove entries. The table is authoritative — all 29 were deleted as specified in the plan.
- Container guard pattern reuses the same three env vars already in dot_zshrc (`$REMOTE_CONTAINERS`, `$CODESPACES`, `$DEVCONTAINER_TYPE`) for consistency.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

The AUDIT-REPORT.md summary line incorrectly states "Remove 25" while the table has 29 Remove-classified rows. The plan's explicit list of 29 scripts was used as the authoritative deletion target — all 29 were confirmed present and deleted, leaving exactly 18 files.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- scripts/ directory is clean — only generic, portable scripts remain
- setup script is now safe to run in DevPod containers without failing on sudo chsh
- Ready for Plan 02 (zshrc cleanup: remove unused aliases and env vars)

## Self-Check: PASSED

- SUMMARY.md: FOUND
- setup (modified): FOUND
- Commit db7bc85 (Task 1): FOUND
- Commit ca162b6 (Task 2): FOUND

---
*Phase: 02-cleanup*
*Completed: 2026-03-22*

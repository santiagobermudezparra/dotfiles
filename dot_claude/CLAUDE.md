# Ralph Agent Instructions

## Your Task
Read the PRD (prd.json) and progress log (progress.txt), then implement the highest-priority
incomplete user story. One story per iteration.

1. Read prd.json to find the highest-priority story where passes=false
2. Read progress.txt for context on what has already been done
3. Checkout or create the feature branch from prd.json branchName
4. Implement the story — one story only
5. Run quality checks: typecheck, lint, tests
6. Commit: "feat: [Story ID] - [Story Title]"
7. APPEND to progress.txt (never replace): date, story ID, files changed, learnings
8. If ALL stories pass: reply <promise>COMPLETE</promise>
9. If stories remain: stop and wait for next iteration

## Progress Report Format
Append to progress.txt (never replace):
- Date and story ID
- What was implemented
- Files changed
- Patterns discovered (add to Codebase Patterns section at top)

## Update CLAUDE.md Files
When editing a directory, add discoverable knowledge to the nearest CLAUDE.md:
API patterns, gotchas, dependencies — not story-specific details.

## Quality Requirements
- All commits must pass typecheck, lint, and tests
- No broken code merges

## Stop Condition
Reply with <promise>COMPLETE</promise> only when ALL stories in prd.json have passes=true.

# Ralph: Autonomous AI Development Loop Architecture

Ralph is an autonomous AI development loop that implements multiple user stories using Claude Code, with **context isolation** to prevent earlier work from biasing later decisions. This document explains how Ralph achieves this, how knowledge persists across iterations, and how to extract and maintain good codebase patterns.

## What Ralph Does

Ralph is a purpose-built autonomous loop for implementing structured feature development from a PRD (Product Requirements Document). You provide:
- `prd.json` — JSON file with user stories, priorities, and branch names
- `progress.txt` — persistent knowledge file that accumulates learnings across iterations

Ralph then spawns a fresh Claude Code instance for each story, ensuring clean context and predictable token usage. Knowledge persists between iterations through git commits, progress.txt learnings, and CLAUDE.md instructions.

**When to use Ralph:**
- Multi-story feature development (5-20 stories)
- Projects with clear branching and structured requirements
- Scenarios where you want autonomous, parallel-safe implementation

**Not suitable for:**
- One-off scripts or exploratory work (use `claude code` directly)
- Real-time collaboration requiring human feedback per story
- Highly interactive debugging

## Context Isolation & Why It Matters

### The Problem: Context Rooting

Without isolation, earlier work pollutes context in later iterations. Example:

**Iteration 1 (Authentication):**
- Claude implements JWT authentication
- Context fills with auth concepts (tokens, sessions, middleware)
- Commits authentication implementation

**Iteration 2 (Dashboard UI):**
- Fresh instance should focus on UI/UX patterns
- But if context from Iteration 1 persists, Claude's context is dominated by auth details
- Result: Claude might suggest auth-first patterns even when irrelevant, bloat context with old work, reduce decision quality

This "context rooting" causes:
- Token inefficiency (context balloons with unrelated work)
- Decision bias (later work influenced by earlier implementation details)
- Unpredictable token usage (can't scale to 20+ stories)

### The Solution: --no-session-persistence Flag

Ralph prevents context rooting by spawning a **completely fresh Claude Code subprocess** for each iteration:

```bash
# From scripts/ralph, line 104
claude \
  --dangerously-skip-permissions \
  --print \
  --no-session-persistence \
  < "$SCRIPT_DIR/CLAUDE.md"
```

The `--no-session-persistence` flag ensures:
- Previous session state is **not** reused
- Claude starts with clean context (no history from Story 1)
- Knowledge transfer happens only through explicit mechanisms (git, progress.txt, CLAUDE.md instructions)

### What Breaks If Flag Is Removed

If someone removes `--no-session-persistence` from line 104:

```bash
# ❌ BROKEN: Without flag
claude \
  --dangerously-skip-permissions \
  --print \
  < "$SCRIPT_DIR/CLAUDE.md"
```

What happens:
- Claude Code reuses session between iterations
- Story 1 context stays loaded when Story 2 starts
- Progress.txt still gets updated, but context isolation is gone
- **Silent failure:** Script continues running, but context rooting is back
- Token usage balloons with accumulated history
- Later stories inherit biases from earlier work

### Verification Steps: How to Confirm Isolation Is Working

1. **Single Iteration Test:**
   ```bash
   # Modify scripts/ralph temporarily: change MAX_ITERATIONS to 1
   ralph --tool claude 1
   ```
   Observe output for Story 1. Claude should reference PRD and story content.

2. **Manual Iteration 2:**
   ```bash
   # Manually trigger iteration 2 (run ralph again from same directory)
   ralph --tool claude 1
   ```
   Claude should start fresh — no references to Story 1 work.

3. **Inspect Output:**
   - Look at claude subprocess output
   - If Story 2 implementation mentions "like we did in story 1", isolation failed
   - If commit messages reference previous stories without reading from progress.txt, isolation failed

4. **Review Patterns:**
   - Check progress.txt after iteration 2
   - If patterns from Story 1 are NOT present, Claude didn't read progress.txt (isolation working, but persistence broken)
   - If patterns ARE present, Claude read progress.txt and isolation is working

## Knowledge Persistence: Three-Layer Model

Ralph can't carry context between iterations, so knowledge persists through three external layers. Each layer serves a specific purpose:

### Layer 1: Git Commits (Code State)

**What:** Actual implementation code from each story

**Purpose:** Immutable record of what was built

**Format:** Branch history, commit messages with format:
```
feat: [Story ID] - [Story Title]

- Implementation details
- Files changed
- Quality checks passed
```

**Typical flow:**
- Iteration 1: Feature branch created, code committed
- Iteration 2: Fresh Claude checks out branch, reads latest commits, understands what was built
- Iteration 3: Can diff against previous commits to understand patterns

**Limitation:** Commits show "what was built" but not "why" or "what gotchas exist"

### Layer 2: progress.txt (Learnings & Patterns)

**What:** Structured file accumulating learnings across iterations

**Format:** Two parts:
1. **Codebase Patterns** section (consolidated, at top) — canonical patterns and gotchas
2. **Per-iteration sections** — detailed work log for each story

**Example structure:**
```markdown
## Codebase Patterns

- When modifying API schema, update TypeScript types in types.ts — they must stay in sync
- Always use IF NOT EXISTS for database migrations
- The eval panel is in src/components/EvaluationPanel.tsx — update it when eval logic changes
- Tests require NODE_ENV=test and dev server on PORT=3000

---

## 2026-03-24 - STORY-1

**Implemented:**
- Added authentication middleware
- JWT token validation

**Files Changed:**
- src/auth/middleware.ts
- tests/auth/middleware.test.ts

**Learnings for Future Iterations:**
- Gotcha: Auth service expects `Authorization: Bearer <token>` header format
- Pattern: Always use IF NOT EXISTS for DB migrations
- Useful context: JWT secrets in process.env.JWT_SECRET, never hardcode

---

## 2026-03-25 - STORY-2

[Next iteration, building on patterns from STORY-1]
```

**Purpose:** Teach future Claude instances about conventions, gotchas, and patterns without carrying the full context of previous work

**Critical mechanism:** CLAUDE.md Step 4 reads this file before implementing new stories

### Layer 3: CLAUDE.md Files (Module-Specific Knowledge)

**What:** Directory-level CLAUDE.md files documenting module conventions

**Purpose:** Discoverable knowledge "co-located" with code

**Examples:**
```
# dot_claude/CLAUDE.md (root agent instructions)
# src/components/CLAUDE.md (component-specific patterns)
# src/db/CLAUDE.md (database interaction patterns)
```

**When updated:** Claude appends learnings when modifying files in a directory

**Benefit:** Future humans and Claude instances reading those directories discover relevant knowledge immediately

### The Information Flow (How Knowledge Persists)

This is the critical feedback loop that makes Ralph work:

```
ITERATION 1:
├─ Fresh Claude spawned
├─ Reads CLAUDE.md (this file) → learns role and task structure
├─ Reads prd.json → finds Story 1
├─ Reads progress.txt (currently minimal)
├─ Implements Story 1
├─ Commits to git
└─ Appends learnings to progress.txt

ITERATION 2:
├─ FRESH Claude spawned (clean context, no memory of Iteration 1)
├─ Reads CLAUDE.md → learns role and task structure
├─ Reads prd.json → finds Story 2
├─ Reads progress.txt → sees Codebase Patterns from Iteration 1
├─ Understanding conventions now, implements Story 2
├─ Commits to git
└─ Appends NEW learnings, consolidates patterns in progress.txt

ITERATION 3:
├─ FRESH Claude spawned
├─ Reads CLAUDE.md
├─ Reads prd.json → finds Story 3
├─ Reads progress.txt → sees CONSOLIDATED Codebase Patterns (now with patterns from Iter 1 + 2)
├─ Implementing Story 3 with full pattern knowledge
├─ (progress.txt has grown, but Claude only reads it once per iteration)
└─ Appends learnings...

[REPEAT until all stories marked passes: true]
```

**Key insight:** Each iteration reads progress.txt fresh, so it always has the latest consolidated patterns. Growth is linear, not exponential.

### The Fragile Point: CLAUDE.md Step 4 Is Critical

The CLAUDE.md file's **Step 4: "Read progress notes"** is the linchpin of the entire system.

Currently (dot_claude/CLAUDE.md, line 10):
```
4. **Read progress notes** — Open `progress.txt` and read the `## Codebase Patterns` section at the top first
```

**Why it's critical:** This step is HOW knowledge transfers from one iteration to the next.

**What breaks if removed:**
- Fresh Claude reads CLAUDE.md but skips Step 4
- Claude reads prd.json to find the story
- Claude implements the story **without knowledge of prior patterns**
- Result: Each iteration starts completely blind
- Consequence: Repeated learning, wasted tokens, inconsistent patterns

**Warning:** Removing or reordering Step 4 silently breaks persistence. The script continues running, but Claude stops learning.

## Codebase Patterns: What Makes a Good Pattern

The `## Codebase Patterns` section in progress.txt is the consolidated knowledge base. Not all learnings should be added — patterns must meet specific criteria.

### Extraction Criteria: When to Add a Pattern

A pattern is worth adding to Codebase Patterns if it meets **ALL of these:**

1. **General and reusable** — Applicable to multiple future stories, not specific to current story
   - ✅ "Always use IF NOT EXISTS for database migrations"
   - ❌ "In Story 2 we added authentication" (story-specific)

2. **Non-obvious gotcha or convention** — Something future Claude should know that isn't obvious from code
   - ✅ "Auth service expects `Authorization: Bearer <token>` header format"
   - ❌ "We used TypeScript" (obvious from code)

3. **Applicable across multiple areas** — Not a one-off finding for a single component
   - ✅ "Database migration conventions apply to all new tables"
   - ❌ "Component X needs a workaround" (specific to one component)

4. **Validated by experience** — Observed in multiple stories, not theoretical
   - ✅ "After Stories 1 and 2, we found this pattern consistently applies"
   - ❌ "Might be useful" (unvalidated)

### What NOT to Add

Keep these out of Codebase Patterns:

- **Story-specific details** — "In Story 2 we built X" goes in iteration section, not patterns
- **Temporary debugging notes** — "Added console.log for debugging" (remove before merging)
- **Information already in CLAUDE.md files** — Link to module CLAUDE.md instead of duplicating
- **Patterns from only ONE story** — Need at least 2 observations to confirm
- **Third-party documentation** — Link to external docs instead of copying

### Pattern Review Workflow

After each iteration, before merging:

1. **Review what was added:** Look at new learnings appended to progress.txt
2. **Ask: "Is this a pattern or story detail?"**
   - Pattern: "Always do X because of Y" → Add to Codebase Patterns
   - Story detail: "In Story 2 we did X" → Keep in iteration section
3. **Refine for reusability:** Rewrite story-specific findings as reusable patterns
   - ❌ Bad: "In Story 2 we added authentication middleware"
   - ✅ Good: "When adding middleware, place it before route definitions"
4. **Consolidate:** Merge similar patterns, remove duplicates
   - Check if pattern already exists in slightly different form
   - Merge into single canonical statement
5. **Validate:** Ask "Would future Claude benefit from knowing this?"

### Good Pattern Examples

```markdown
## Codebase Patterns

- When modifying API schema, also update TypeScript types in types.ts — they must stay in sync
- Always use IF NOT EXISTS for database migrations to prevent duplicate key errors on rerun
- The evaluation panel is in src/components/EvaluationPanel.tsx — update it when changing eval logic
- Tests require NODE_ENV=test and dev server running on PORT=3000
- Export types from actions.ts for any UI components that need type safety
- Use sql<number> template syntax for all SQL aggregations (required for the query builder)
```

### Bad Pattern Examples

```markdown
## Anti-Patterns (DON'T add these)

- In Story 2 we added authentication (story-specific — goes in iteration section)
- Temporarily added console.log for debugging (temporary — remove before merging)
- Use React library (too vague — better as "Use React for UI because X")
- John's hack for the timer (story detail and too personal)
```

## Using Ralph in Practice

### Typical Workflow

1. **Prepare:** Create `prd.json` with user stories and `progress.txt` (can be empty initially)
2. **Run:** `ralph --tool claude` (starts autonomous loop)
3. **Monitor:** Check Ralph's iteration output; can Ctrl+C to pause
4. **Between iterations:** Review progress.txt, refine patterns, commit if needed
5. **When complete:** All stories marked `passes: true`, Ralph outputs `<promise>COMPLETE</promise>`

### Running with Options

```bash
# Default: 10 iterations with Claude Code
ralph --tool claude

# Run with 20 iterations
ralph --tool claude 20

# Use Amp instead (less recommended)
ralph --tool amp

# Check current status
cat progress.txt | head -30  # See patterns
cat prd.json | jq '.userStories[] | {id, title, passes}'  # See story status
```

### Quality Assurance

Ralph enforces quality before every commit. If typecheck, lint, or tests fail, Claude cannot commit and must fix the issues. This prevents broken code from accumulating.

### File Resolution

Ralph resolves files relative to the directory where the `ralph` command is run:
- Looks for `prd.json` in current directory
- Looks for `progress.txt` in current directory
- Uses `CLAUDE.md` from `~/.local/share/chezmoi/scripts/`

To use Ralph in a project:
```bash
# Copy files to project root
cp ~/.local/share/chezmoi/scripts/prd.json .
touch progress.txt
# Now run from project root
ralph --tool claude
```

## Advanced Patterns & Industry Context

Ralph implements several industry-standard AI engineering patterns:

- **Sub-agent spawning** — Fresh agent per subtask, coordination via shared state
- **Context engineering** — Discipline of managing information flow and boundaries in AI systems
- **Progressive disclosure** — Load only essential context per iteration
- **Lab notebook pattern** — Shared state file accumulating learnings across iterations
- **State machines** — Explicit completion markers for coordination

For deep technical explanation and comparison to other approaches, see **scripts/RALPH-ARCHITECTURE.md**.

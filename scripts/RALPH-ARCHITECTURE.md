# Ralph Architecture: Context Engineering & Multi-Agent Patterns

This document explains Ralph through the lens of AI systems architecture, industry patterns, and design tradeoffs. It's written for readers familiar with distributed systems or multi-agent concepts who want to understand "why" Ralph's architecture is effective.

## Ralph as a Context Engineering System

**Context engineering** is the emerging discipline of managing information flow, context boundaries, and knowledge persistence in AI systems (2025-2026 industry standard). Ralph implements context engineering through three key principles:

### Progressive Disclosure
- Each iteration receives only essential context (no session history from previous work)
- Agent loads base instructions (CLAUDE.md) → finds current story (prd.json) → reads relevant patterns (progress.txt Codebase Patterns section)
- Unused context is never loaded, keeping context window lean

### Identity Management
- Agent assumes specific role per iteration (via CLAUDE.md instructions)
- Each fresh subprocess knows: "You are implementing autonomous stories from a PRD"
- Role is consistent across iterations; only the story changes

### Persistent State (External to Prompts)
- Knowledge stored in files, not prompts
- Git commits (code), progress.txt (learnings), CLAUDE.md files (module knowledge)
- Prevents context window from growing with history

This three-part approach allows Ralph to scale to 20+ stories without token explosion.

## Sub-Agent Spawning Pattern

### Definition

The **sub-agent spawning pattern** is a multi-agent coordination technique:

1. Decompose large task into subtasks
2. Each subtask assigned to fresh agent (clean context)
3. Agents coordinate via shared state (files, messages)
4. Prevents "context drift" where earlier subtasks bias later work

### Why This Pattern Matters

**Token Efficiency:**
Without spawning: Agent context grows with each task
- Story 1: ~4K tokens of context
- Stories 1+2: ~8K tokens (Story 1 details still in context)
- Stories 1+2+3: ~12K tokens (quadratic bloat)

With spawning: Each agent starts lean
- Story 1: ~4K tokens (fresh agent)
- Story 2: ~4K tokens (fresh agent, reads progress.txt only)
- Story 3: ~4K tokens (fresh agent, reads progress.txt only)
- Linear growth, not exponential

**Decision Quality:**
- Fresh agent: Focuses on current story without bias from earlier work
- Contaminated agent: Context biased by earlier decisions, can miss better approaches
- Example: Auth story fills context with security patterns; fresh agent for UI story won't over-engineer auth in UI

**Scalability:**
- Single agent: ~10-15 stories before context limits
- Sub-agent spawning: Can chain 50+ subtasks theoretically
- Ralph uses: ~10-20 stories practical range

**Auditability:**
- Each agent's work isolated and traceable
- Failure in Story 5 doesn't affect Story 6 context
- Easier to debug (each iteration's output is independent)

### How Ralph Implements It

**Subtasks:** Individual user stories from prd.json

**Fresh spawning:** Line 104 in scripts/ralph:
```bash
claude \
  --dangerously-skip-permissions \
  --print \
  --no-session-persistence \
  < "$SCRIPT_DIR/CLAUDE.md"
```

The `--no-session-persistence` flag is the mechanism that creates a fresh context per iteration.

**Shared state:** Three coordination channels:
- `progress.txt` — Learnings and patterns accumulated across iterations
- `prd.json` — Task list (which stories done, which remain)
- Git history — Code state (Claude reads latest commits to understand what was built)

**Coordination flow:**
1. Ralph reads prd.json → finds next story where `passes: false`
2. Spawns fresh Claude with `--no-session-persistence`
3. Claude reads CLAUDE.md → instructed to read progress.txt
4. Claude reads progress.txt → learns Codebase Patterns
5. Claude implements story
6. Claude marks story done in prd.json (`passes: true`)
7. Claude appends learnings to progress.txt
8. Ralph detects `<promise>COMPLETE</promise>` sentinel or continues loop

### Comparison to Alternative Approaches

| Approach | Pros | Cons |
|----------|------|------|
| **Single long context** | Simple to implement | Context balloons, decisions degrade, token usage unpredictable |
| **Session reuse** | Reuses Claude's memory | Agent carries assumptions from earlier work, context rooting |
| **Sub-agent spawning ✅** | Fresh per subtask, lean context, scalable | Requires shared state coordination (solved by git + progress.txt + prd.json) |

Ralph chose sub-agent spawning because it's the only approach that scales to 20+ stories without decision degradation.

## Knowledge Persistence: Lab Notebook Pattern

### The Pattern (From Research)

**Multi-agent systems** maintain shared "lab notebook" — a state file that:
- Tracks: what was tried, what worked (patterns), what failed (gotchas), dependencies
- Is read by each agent before working
- Is updated by each agent after working
- Creates unified team knowledge without explicit communication

**Historical examples:**
- Traditional labs: Researchers maintain lab notebooks (what was tried, what worked, observations)
- Scientific papers: "Methods" section is shared knowledge for future researchers
- Open source: README, docs, CONTRIBUTING.md are lab notebooks for contributors

### How Ralph Implements It

**Lab notebook:** `progress.txt`

**Structure:**
```markdown
## Codebase Patterns
[Consolidated patterns from ALL iterations]

---

## [Date] - [Story ID]
[What was implemented, files changed, learnings]

---

## [Date] - [Story ID]
[Next iteration's work and learnings]
```

**Read step:** CLAUDE.md Step 4 (critical)
- Fresh Claude told: "Read progress.txt and the Codebase Patterns section first"
- This is the explicit mechanism that transfers knowledge

**Write step:** Claude appends learnings after each iteration
- Adds new iteration section
- Consolidates Codebase Patterns section
- Ralph script doesn't manage this; Claude is responsible

### Why This Works

**No external APIs:** File-based, works offline, no network calls needed

**Clear format:** Markdown readable by humans and AI, no parsing complexity

**Non-destructive:** Append-only structure preserves full history

**Self-documenting:** Patterns accumulate over time, forming organic knowledge base

**Scales indefinitely:** No limit to how many patterns can accumulate; Claude just reads Codebase Patterns section

### Fragility & Risk

**Single point of failure:** If Step 4 removed from CLAUDE.md, persistence breaks
- Script continues running (no error)
- Claude stops reading progress.txt
- Knowledge doesn't transfer to next iteration
- Each iteration starts blind (silent failure)

**Format sensitivity:** If format deviates, Claude might not parse Codebase Patterns correctly
- Missing `---` separator
- Malformed section headers
- Inconsistent indentation

**Manual maintenance:** Patterns need periodic review
- Can accumulate duplicates
- May become outdated
- Need consolidation after 5-10 iterations

**Mitigation:** CLAUDE.md includes explicit guidance on pattern format and criteria; validation checklist ensures quality.

## Progressive Disclosure & Selective Context Loading

### Principle

**Progressive disclosure** in UI means: show minimal interface, reveal details only when needed.

Applied to AI context: Load only necessary information per iteration, keep baseline lean.

### How Ralph Implements It

Rather than dumping all context upfront, Ralph loads selectively:

**Baseline (always loaded):** CLAUDE.md instructions
- Task: Implement a story from PRD
- Role: Autonomous agent
- Format: Commit message format, progress.txt structure
- ~2-3KB, tight and focused

**Per-story context (loaded when needed):** prd.json
- Which story to implement (top-priority incomplete story)
- Story description, acceptance criteria
- Branch name
- ~0.5-1KB per story

**Learnings context (loaded once per iteration):** progress.txt Codebase Patterns
- Only the `## Codebase Patterns` section, not full file history
- Patterns applicable to current story
- ~1-2KB (consolidates patterns from all prior iterations)

**Module context (loaded by Claude as needed):** CLAUDE.md files in directories
- Discoverable by Claude when modifying specific directories
- Colocated with code, found naturally
- Optional, contextual

**Result:**
- Iteration 1: 2KB baseline + 0.5KB story + 0KB patterns = 2.5KB
- Iteration 2: 2KB baseline + 0.5KB story + 1KB patterns = 3.5KB
- Iteration 3: 2KB baseline + 0.5KB story + 1.5KB patterns = 4KB
- Linear growth (K iterations = 2KB + 0.5KB + K×0.5KB)

### Comparison to Alternative

**❌ Dump all context:**
```
Here's progress.txt (entire history from all iterations)
Here's all git history
Here's all CLAUDE.md files from all directories
Here's the full prd.json with all stories
[Claude context: 20KB+, bloated with noise]
```

Problems:
- Token waste (carrying unrelated history)
- Context confusion (Claude unsure what's relevant)
- Harder to prioritize (so much information)
- Doesn't scale past 5-10 stories

**✅ Progressive disclosure:**
```
Here's your instructions (CLAUDE.md)
Read prd.json to find your story
Read the Codebase Patterns section of progress.txt
Update CLAUDE.md files in directories you modify
[Claude context: 3-5KB, lean and focused]
```

Benefits:
- Keeps context lean (token efficient)
- Clear priority (current story is front and center)
- Allows scaling (can accumulate many patterns without bloating)
- Self-service (Claude loads what it needs when it needs it)

## State Transitions & Completion Tracking

### Pattern

**State machines** in multi-agent systems use explicit markers to coordinate state:
- Initial state: `passes: false` for all stories
- Active state: One story being implemented
- Completion state: `passes: true` for completed stories
- Terminal state: All stories complete OR max iterations reached

Ralph uses explicit markers for unambiguous state transitions.

### How Ralph Uses It

**Story state:** prd.json marks each story
```json
{
  "userStories": [
    {"id": "STORY-1", "title": "Auth", "passes": false},
    {"id": "STORY-2", "title": "Dashboard", "passes": false}
  ]
}
```

**Progress:** Claude sets `passes: true` after completing a story
```json
{"id": "STORY-1", "title": "Auth", "passes": true}
```

**Overall completion:** `<promise>COMPLETE</promise>` sentinel in output
```bash
# scripts/ralph, line 112
if echo "$OUTPUT" | grep -q "<promise>COMPLETE</promise>"; then
  echo "Ralph completed all tasks!"
  exit 0
fi
```

**Why sentinels work:**
- Unambiguous: XML tag is explicit, no parsing confusion
- Parseable: Easy to grep for, reliable
- Works across tools: Doesn't depend on exit codes or file timestamps

### Why Not Use Alternative Approaches

| Alternative | Problem |
|-------------|---------|
| Exit codes | Unreliable — script exits for many reasons (connection error, user interrupt) |
| File timestamps | Ambiguous — many changes to files, hard to detect "completion moment" |
| Last line of output | Fragile — easy to add trailing text accidentally |
| Predefined completion markers | Easy to forget to output; no validation |
| **XML sentinel ✅** | Unambiguous, explicit, reliably parseable |

### Claude's Role

Claude must output `<promise>COMPLETE</promise>` when:
1. ALL stories in prd.json have `passes: true`
2. Ralph greps for this exact string to detect completion
3. If Claude doesn't output it, loop continues (max_iterations acts as safety brake)

This is Claude's final signal that all work is done.

## Architectural Tradeoffs & Design Decisions

### Why Not Store Knowledge in Fine-tuning?

**Fine-tuning:** Could update Claude's base model with learned patterns

**Why Ralph doesn't use it:**
- Too slow (fine-tuning takes hours)
- Too expensive (fine-tuning is costly)
- Not interactive (can't update between stories)
- Wrong level of abstraction (models aren't knowledge bases)

Ralph's approach (progress.txt) is instant, free, and flexible.

### Why Not Use Conversation History?

**Long context windows:** Could accumulate all prior conversation history

**Why Ralph doesn't:**
- Context window is expensive (token cost grows linearly with history)
- Attention degradation (older context gets deprioritized)
- No clear boundary (where does one story end, another begin?)

Ralph's approach (fresh context + selective loading) keeps costs predictable.

### Why Not Use Vector Embeddings?

**Semantic search:** Could embed all patterns and retrieve relevant ones

**Why Ralph doesn't:**
- Adds complexity (need embedding model, vector DB)
- Slower than file read (retrieval latency)
- Overkill for structured data (progress.txt is already structured)
- Failure risk (embedding might miss relevant patterns)

Ralph's approach (explicit file read) is simple, fast, and reliable.

## Summary: Why Ralph Works

Ralph's architecture succeeds because it:

1. **Isolates context** — Fresh subprocess per iteration prevents rooting
2. **Persists knowledge** — Three-layer model (git, progress.txt, CLAUDE.md) accumulates learnings
3. **Discloses progressively** — Loads only necessary context, keeps each iteration lean
4. **Coordinates explicitly** — prd.json and progress.txt are shared state; `<promise>COMPLETE</promise>` is explicit completion signal
5. **Scales linearly** — Token usage grows with iterations, not exponentially

These principles are proven patterns in distributed systems and multi-agent AI research. Ralph applies them to the specific domain of autonomous software development.

For practical usage and pattern guidance, see **scripts/RALPH.md**.

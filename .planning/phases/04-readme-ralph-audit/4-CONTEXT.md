# Phase 4: README Review & Ralph Documentation Audit - Context

**Gathered:** 2026-03-27
**Status:** Ready for planning

<domain>
## Phase Boundary

Review README.md for accuracy and completeness in documenting Ralph's autonomous loop, verify implementation matches documentation, audit knowledge persistence mechanisms, and reorganize Ralph documentation into dedicated architecture guide. Update main README with clearer explanations and cross-references to Ralph-specific guide.

</domain>

<decisions>
## Implementation Decisions

### Documentation Structure
- **D-01:** Create dedicated `scripts/RALPH.md` (Ralph Architecture Guide) for deep technical explanation
- **D-02:** Main README.md Ralph section becomes a quick-start guide with link to `scripts/RALPH.md` for detailed architecture
- **D-03:** `scripts/RALPH.md` covers full mechanism, context rooting problem, verification steps, and architecture patterns

### Gray Area 1: Context Isolation — Full Mechanism Explanation
- **D-04:** Main README briefly explains: "Each iteration spawns a fresh Claude Code process using `--no-session-persistence` flag"
- **D-05:** `scripts/RALPH.md` has dedicated subsection "Context Isolation & Why It Matters" that includes:
  - Explanation of `--no-session-persistence` flag and what it prevents
  - Definition and examples of "context rooting" problem
  - How sub-agent spawning solves it
  - What breaks if flag is removed
  - Verification steps to confirm isolation is working

### Gray Area 2: Knowledge Persistence — Architect's Best Approach (C)
- **D-06:** Clarify three-layer persistence model explicitly:
  - **Layer 1:** Git commits (what was built, immutable history)
  - **Layer 2:** progress.txt with Codebase Patterns section (learnings, patterns, gotchas)
  - **Layer 3:** CLAUDE.md files in directories (module-specific knowledge, discoverability)
- **D-07:** Emphasize that CLAUDE.md Step 4 is the critical mechanism: "Read progress.txt and read the Codebase Patterns section at the top first"
- **D-08:** Add explicit warning: Removing this step silently breaks persistence—knowledge won't carry forward
- **D-09:** Document the information flow: Fresh Claude reads CLAUDE.md → finds Step 4 → reads progress.txt → executes story with context

### Gray Area 3: Codebase Patterns — Comprehensive Guidance (B+C)
- **D-10:** Add subsection "What Makes a Good Pattern" in `scripts/RALPH.md` with extraction criteria:
  - General and reusable (not story-specific)
  - Non-obvious gotchas or conventions
  - Applicable across multiple areas of codebase
  - Examples of what NOT to add (story details, temp debugging, duplicates)
- **D-11:** Include workflow guidance: Pattern review/refinement process after each iteration
- **D-12:** Show example of good vs. bad patterns for clarity

### Gray Area 4: Ralph Architecture Document — Technical Depth (C)
- **D-13:** Create `scripts/RALPH-ARCHITECTURE.md` (or combined in `scripts/RALPH.md`) with industry terminology:
  - Sub-agent spawning pattern
  - Context engineering discipline approach
  - Progressive disclosure principle
  - Lab notebook pattern for knowledge persistence
  - Comparison to other agentic systems
- **D-14:** Frame technical explanation professionally while remaining practical

### Code Review & Updates
- **D-15:** Verify `scripts/ralph` implementation matches documentation (especially --no-session-persistence)
- **D-16:** Audit dot_claude/CLAUDE.md to ensure Step 4 is clear and cannot be accidentally removed
- **D-17:** Check for obsolete plugins or neovim config that should be renewed in related phase

### README.md Organization
- **D-18:** Main README Ralph section (simplified) includes:
  - One-paragraph overview of what Ralph does
  - When to use Ralph (autonomous multi-story development)
  - Quick link to `scripts/RALPH.md` for "how it works"
  - Command reference (existing)
  - Note about architecture explanation in separate doc
- **D-19:** Move detailed explanations (context isolation, persistence, patterns) to `scripts/RALPH.md`

### Claude's Discretion
- How much to simplify the main README (vs. keeping detail)
- Exact structure of scripts/RALPH.md subsections
- Whether to combine RALPH.md and RALPH-ARCHITECTURE.md or keep separate
- Code examples and visual diagrams if helpful for clarity

</decisions>

<specifics>
## Specific Ideas

- Current README explains *what* Ralph does well; phase should focus on explaining *how* and *why*
- "Context rooting" term should be defined clearly—users need to understand the problem being solved
- CLAUDE.md Step 4 is critical and fragile; needs explicit emphasis
- Consider adding a diagram showing iteration flow with context isolation boundaries
- Include example of what happens if --no-session-persistence is removed

</specifics>

<canonical_refs>
## Canonical References

### Ralph Implementation
- `scripts/ralph` — Main loop script; verify --no-session-persistence on line 104
- `dot_claude/CLAUDE.md` — Agent instructions; Step 4 is critical for knowledge persistence

### Documentation Standards
- Current README.md lines 114-310 — Ralph section to be reviewed and restructured
- `.planning/PROJECT.md` — Project goals and context
- `CLAUDE.md` (project root) — Workflow preferences, PR-first approach, model strategy

### Best Practices
- Industry research: Sub-agent spawning, context engineering, progressive disclosure patterns
- Lab notebook pattern: Using shared state files for multi-agent knowledge persistence

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- Current README structure and examples can be reused in `scripts/RALPH.md`
- CLAUDE.md instructions are already well-structured; clarify rather than rewrite
- scripts/ralph is well-implemented; just needs clearer documentation

### Established Patterns
- Chezmoi-based dotfiles with scripts in PATH
- Multi-file knowledge persistence (git + progress.txt + CLAUDE.md)
- Fresh subprocess spawning with --no-session-persistence
- Three-layer information architecture (implementation, codebase patterns, module-specific knowledge)

### Integration Points
- README.md sections will link to scripts/RALPH.md
- scripts/RALPH.md references CLAUDE.md for instruction details
- RALPH-ARCHITECTURE.md (if separate) references both

</code_context>

<deferred>
## Deferred Ideas

- Phase 5 will handle neovim setup and plugin review
- Plugin obsolescence checking deferred to Phase 5
- Salesforce tooling integration deferred to Phase 5
- Ralph loop end-to-end validation in live DevPod deferred to future phase

</deferred>

---

*Phase: 04-readme-ralph-audit*
*Context gathered: 2026-03-27*
*Decisions: 19 (D-01 through D-19)*

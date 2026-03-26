# Claude Code Instructions for Dotfiles Project

## Workflow & Review Process

### PR-First Approach (All Phases)
- **NEVER commit directly to main branch** — all work goes to feature branches
- **Always create PRs to main** for review before merging
- Implementation phases 4 & 5+ use dedicated phase branches: `phase/4-readme-review`, `phase/5-neovim-salesforce`, etc.
- PR includes comprehensive description of changes made
- User approves PR before merge to main
- All quality checks (tests, linting, typechecks) must pass before merge

### Model Selection Strategy
For efficient quota usage:
- **Research & Planning phases:** Use Haiku 4.5 (reasoning, cheaper cost)
- **Implementation & Execution:** Use Sonnet 4.6 (complex tasks, higher quality)
- Model switching happens automatically per phase via GSD configuration

## Ralph Implementation Notes

### Context Isolation & Agent Spawning
Ralph's core strength is **context rooting prevention** through autonomous parallel agent spawning:

**The Technique:**
- Each user story spawns a **completely fresh Claude Code subprocess** with `--no-session-persistence`
- Previous iterations' context is NOT carried forward in the subprocess
- Knowledge persists only through:
  - **Git commits** (what was built)
  - **progress.txt** (learnings, patterns, gotchas)
  - **CLAUDE.md files** (discoverable knowledge per directory)

**Why This Matters:**
- Prevents earlier stories from polluting later work (no attention spillover)
- Token usage stays predictable (no growing context window)
- Forces explicit knowledge capture (patterns documented in progress.txt are reusable)
- Scales to 20+ stories without exponential context bloat

**README Documentation Standard:**
The README must clearly explain:
1. How each iteration spawns fresh (--no-session-persistence flag)
2. How knowledge persists between iterations (git + progress.txt + CLAUDE.md)
3. The `## Codebase Patterns` section at the top of progress.txt
4. That spawning in parallel is the intended design, not a limitation

### For Phase 4
When auditing Ralph implementation:
- Verify `scripts/ralph` uses `--no-session-persistence` correctly (it does at line 104)
- Check that README explains this architectural choice
- Confirm progress.txt consolidation pattern matches CLAUDE.md instructions
- Review if CLAUDE.md files need updates for discoverability

## Quality Standards

- All commits must pass quality checks (tests, lint, typecheck where applicable)
- No broken code committed — failures compound across phases
- Code patterns documented in progress.txt are canonical knowledge source between iterations
- CLAUDE.md files in directories capture module-specific learnings

## Next Phases

- Phase 4: README review & Ralph implementation audit (branch: phase/4-readme-review)
- Phase 5: Neovim setup for work Mac (branch: phase/5-neovim-salesforce, new repo: dotfiles-work-mac)

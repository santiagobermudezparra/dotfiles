# Phase 1: Audit - Context

**Gathered:** 2026-03-22
**Status:** Ready for planning

<domain>
## Phase Boundary

Read every file in the dotfiles repo and produce a single `AUDIT-REPORT.md` at the repo root. The report classifies all ~40 scripts, flags YouTuber-specific tools across all config files, identifies personal/missing env vars and aliases in zshrc, lists missing tools the user needs, and provides concrete suggestions for improving this as a DevPod base image.

No files are deleted or modified in this phase — audit only.

</domain>

<decisions>
## Implementation Decisions

### Report structure
- **D-01:** Single file: `AUDIT-REPORT.md` at the repo root (not in .planning/)
- **D-02:** Organized in sections (not a flat table): Scripts → Tools/Config → Env Vars & Aliases → Missing Tools → Suggestions
- **D-03:** Each section uses a table with columns relevant to that section (e.g., scripts: Name | Classification | Reason | Notes)

### Script classification buckets
- **D-04:** Three buckets: **Keep** (generic/useful), **Remove** (YouTuber-specific or clearly not yours), **Review** (unclear — might be yours, needs your input)
- **D-05:** Scripts with hardcoded `/users/mischa/` paths are auto-classified as Remove
- **D-06:** Scripts using tools that don't exist in a container (pomo, newsboat, brightnessctl, osascript) are classified as Remove
- **D-07:** Generic shell utilities (urlencode, gendate, m, push, reprename, bulkreplace, jqedit) are Keep candidates

### YouTuber-specific tool flagging
- **D-08:** Flag tools across ALL files: zshrc aliases, mise config, setup script, and scripts/
- **D-09:** Known YouTuber tools to flag: pomo, newsboat, brightnessctl, osascript, vivaldi, lazygit (if not in mise), pass, dnd (macOS-only)
- **D-10:** K8s tools (kubectl, flux, k3d) are legitimate for the user — flag as Keep (user has a K8s homelab via DevPod)

### Env vars & aliases
- **D-11:** Flag these zshrc vars as personal/missing: $ICLOUD, $ZETTELKASTEN, $LAB, $REPOS (verify if user has this), GITUSER (has the YouTuber's username)
- **D-12:** Flag aliases pointing to YouTuber-specific dirs: cdblog, in, cdzk, cdgo, homelab, hl (verify homelab — user has K8s homelab)
- **D-13:** GITUSER is set to "santiagobermudezparra" — this is the user's own, mark as Keep but note it's hardcoded

### Missing tools suggestions
- **D-14:** Suggest additions the user explicitly wants: Node (via setup.sh, not mise global), Claude Code CLI (via setup.sh)
- **D-15:** Suggest useful DevPod additions: gh (GitHub CLI), lazygit, direnv, delta (better git diff)
- **D-16:** Note that Python will be handled per-project via mise locals — do NOT suggest adding to global mise config

### Suggestions scope
- **D-17:** Suggestions should be concrete and actionable, not vague ("add X by doing Y")
- **D-18:** Include a "DevPod readiness" section: what works today in a container vs what assumes macOS/desktop

### Claude's Discretion
- Exact wording and phrasing in the report
- Whether to include a summary section at the top
- How to handle edge cases (scripts that are generic but reference YouTuber tooling indirectly)

</decisions>

<specifics>
## Specific Ideas

- Known YouTuber: the config is from Mischa van den Burg's dotfiles repo — scripts with `/users/mischa/` are definitively his
- `pub` script: pushes to `/home/mischa/git/testing` — obviously his, Remove
- `present` and `shorts` scripts: modify `/users/mischa/repos/.../alacritty.toml` — his paths, Remove
- `backup` and `backup-weekly`: use `/data-hdd/backups/arch-beast` — his server path, Remove
- `bulkappend`: has hardcoded Azure cluster names (AKS20VIRTUELETREIN02100-TA) — YouTuber's client work, Remove
- `delrg`: deletes Azure resource groups — dangerous and YouTuber-specific client work, Remove
- `cantsleep`: `sudo brightnessctl s 5%` — Linux desktop tool, Remove
- `nb`: opens newsboat in tmux — newsboat is a terminal RSS reader he used, Remove
- The user has their own K8s homelab via DevPod, so kubectl/flux/k3d aliases are legitimate

</specifics>

<canonical_refs>
## Canonical References

No external specs — requirements are fully captured in decisions above and in:

### Planning artifacts
- `.planning/REQUIREMENTS.md` — AUDIT-01 through AUDIT-05 define what the report must cover
- `.planning/ROADMAP.md` — Phase 1 success criteria define what "done" looks like

### Files to audit
- `scripts/` — ~40 scripts to classify
- `dot_zshrc` — aliases and env vars to flag
- `dot_config/mise/config.toml` — current tool set
- `setup` — current setup script
- `.chezmoiexternals/` — external dependencies (neovim, mise)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- None — this phase produces a new file (AUDIT-REPORT.md), not code

### Established Patterns
- zshrc already has DevPod container detection: `if [[ -z "$REMOTE_CONTAINERS" && -z "$CODESPACES" && -z "$DEVCONTAINER_TYPE" ]]` — good pattern, reuse in Phase 2/3
- mise is used for tool management — established pattern for container-compatible tool installs
- chezmoi `dot_` prefix convention — all config files follow this

### Integration Points
- AUDIT-REPORT.md will be the input for Phase 2 (Cleanup) — the planner for Phase 2 must read it
- Suggestions section will inform Phase 3 (Ralph Integration) decisions

</code_context>

<deferred>
## Deferred Ideas

- CLAUDE.md path fix (dot_claude/ vs dot_config/claude/) — Phase 3
- Ralph integration (ralph.sh, skills/, CLAUDE.md template) — Phase 3
- Actual deletion of flagged files — Phase 2
- Adding Node + Claude Code CLI to setup.sh — Phase 3

</deferred>

---

*Phase: 01-audit*
*Context gathered: 2026-03-22*

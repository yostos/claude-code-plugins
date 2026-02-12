# Architecture Decision Records

This document records the architectural decisions made for the jrnl-tools Claude Code plugin.

---

## ADR-001: Migrate from MCP to Claude Code Plugin

**Date**: 2026-02-02

**Status**: Accepted

### Context

The jrnl-mcp project provided read-only access to jrnl journal entries via the Model Context Protocol (MCP). We needed to decide whether to continue developing the MCP server or migrate to a different approach.

### Decision

Migrate from MCP server to a Claude Code plugin.

### Rationale

1. **Target audience alignment**: jrnl is a CLI tool; its users are terminal/CLI users who are likely already using Claude Code
2. **Simpler installation**: MCP requires manual config file editing; plugins install with one command
3. **Reduced complexity**: jrnl is already a CLI tool; Claude Code can execute Bash directly, making MCP abstraction unnecessary
4. **Better development velocity**: Skills are simpler to develop, test, and iterate on
5. **Lower maintenance**: No need to track MCP SDK updates

### Consequences

- jrnl-mcp enters maintenance mode (security/critical fixes only)
- New features will be developed in jrnl-tools plugin
- Users need to migrate from MCP to plugin

---

## ADR-002: Exclude Delete Operations

**Date**: 2026-02-02

**Status**: Accepted

### Context

jrnl supports deleting entries via `jrnl --delete`. We needed to decide whether to expose this functionality through the plugin.

### Decision

Do not support delete operations in the plugin.

### Rationale

1. **Safety**: Accidental deletion of journal entries could result in permanent data loss
2. **Recovery difficulty**: jrnl does not have built-in undo or trash functionality
3. **Risk vs. benefit**: The risk of accidental deletion outweighs the convenience benefit
4. **Alternative available**: Users can still use `jrnl --delete` directly if needed

### Consequences

- Users cannot delete entries through Claude Code
- Users must use the jrnl CLI directly for deletion
- Reduced risk of accidental data loss

---

## ADR-003: Exclude Encryption Operations

**Date**: 2026-02-02

**Status**: Accepted

### Context

jrnl supports encrypting and decrypting journals via `jrnl --encrypt` and `jrnl --decrypt`. These operations require password input.

### Decision

Do not support encryption/decryption operations in the plugin.

### Rationale

1. **Security concern**: Handling passwords through Claude Code poses security risks
2. **Interactive requirement**: Encryption operations require interactive password input
3. **Sensitive operation**: Encryption changes are significant and should be done deliberately by the user
4. **Out of scope**: The primary use case is journaling, not key management

### Consequences

- Users cannot encrypt/decrypt journals through Claude Code
- Users must use the jrnl CLI directly for encryption operations
- Encrypted journals can still be read if jrnl is configured with the password

---

## ADR-004: Default Journal Only (v1.0)

**Date**: 2026-02-02

**Status**: Accepted

### Context

jrnl supports multiple journals (e.g., `jrnl work`, `jrnl personal`). We needed to decide whether to support multiple journals in the initial version.

### Decision

Support only the default journal in version 1.0. Multiple journal support is planned for a future version.

### Rationale

1. **Simplicity**: Single journal simplifies the initial implementation and user experience
2. **Common use case**: Many users only use the default journal
3. **Incremental delivery**: Allows faster initial release with core functionality
4. **Complexity deferral**: Multiple journal support adds complexity in journal selection and context management

### Consequences

- Users with multiple journals can only access their default journal through the plugin
- Users must use jrnl CLI directly to access other journals
- Multiple journal support is documented in the roadmap for future implementation

---

## ADR-005: Guide Users for Edit Operations

**Date**: 2026-02-02

**Status**: Accepted

### Context

jrnl's `--edit` flag opens an external editor for modifying entries. We needed to decide how to handle edit operations in the plugin.

### Decision

Guide users to use the `jrnl --edit` command rather than attempting to edit entries programmatically.

### Rationale

1. **jrnl architecture**: jrnl does not support direct programmatic editing; `--edit` opens an external editor
2. **Timestamp preservation**: Programmatic "edit" would require delete + recreate, changing timestamps
3. **User control**: Users should have full control over the editing experience
4. **Simplicity**: Avoiding complex workarounds keeps the plugin simple and reliable

### Alternatives Considered

- **Programmatic edit via delete + create**: Rejected due to timestamp changes and delete restriction (ADR-002)
- **Claude suggests edits, user applies**: Complex and error-prone

### Consequences

- Claude helps users identify entries to edit via search/filter
- Claude provides the exact `jrnl --edit` command with appropriate filters
- Users perform the actual edit in their configured editor

---

## ADR-006: Use JSON Export for Data Retrieval

**Date**: 2026-02-02

**Status**: Accepted

### Context

jrnl supports multiple export formats (json, txt, md, xml, yaml). We needed to decide which format to use for retrieving entries for analysis.

### Decision

Use `--format json` (or `--export json`) as the primary format for data retrieval.

### Rationale

1. **Structured data**: JSON provides structured, parseable data
2. **Completeness**: JSON export includes all entry metadata (timestamps, tags, starred status)
3. **Claude compatibility**: JSON is easy for Claude to parse and analyze
4. **Consistency**: Single format simplifies implementation

### Consequences

- All entry retrieval uses JSON format
- Claude can accurately parse and analyze entry data
- Other export formats may be supported for user-facing output if needed

---

## ADR-007: Plugin Component Structure

**Date**: 2026-02-03

**Status**: Accepted

### Context

After completing the requirements analysis and use case definition (30 use cases), we needed to determine which Claude Code plugin components to implement: skills, commands, agents, and/or hooks.

### Decision

Implement the following component structure for v1.0:

**Skill (1)**:
- `jrnl` - Core skill providing comprehensive knowledge about jrnl CLI, tag system, and Claude-assisted journaling

**Commands (4)**:
- `/jrnl-handoff` - Quick handoff creation for next session
- `/jrnl-restore` - Restore context from previous session
- `/jrnl-status` - Cross-project overview
- `/jrnl-log` - Record work log

**Agents**: None for v1.0

**Hooks**: None for v1.0

### Rationale

1. **Single skill approach**: One comprehensive skill can handle all 30 use cases through natural language interaction. Splitting into multiple skills would create ambiguity about which skill should activate.

2. **Commands for common operations**: The four commands provide quick shortcuts for the most frequent Claude-assisted journaling operations (handoff, restore, status, log). These are operations users will perform repeatedly with minimal variation.

3. **No agents**: The skill provides sufficient intelligence for all use cases. Agents would add complexity without clear benefit. Consider for v1.2 (nb integration) if cross-tool orchestration is needed.

4. **No hooks**: Automatic triggers (e.g., auto-handoff on session end) could be intrusive. Users should explicitly choose when to create journal entries. Consider for future versions based on user feedback.

### Alternatives Considered

- **Multiple skills** (e.g., jrnl-read, jrnl-write, jrnl-assist): Rejected due to potential triggering ambiguity and increased complexity
- **Commands only** (no skill): Rejected because natural language interaction is essential for many use cases
- **Stop hook for auto-handoff**: Deferred to future version; could be annoying if triggered unexpectedly

### Consequences

- Simple, focused plugin structure
- Natural language for complex operations via skill
- Quick shortcuts for repetitive operations via commands
- May need to add hooks in future versions based on user feedback
- Directory structure:
  ```
  jrnl-plugin/
  ├── .claude-plugin/plugin.json
  ├── skills/jrnl/SKILL.md
  ├── commands/
  │   ├── jrnl-handoff.md
  │   ├── jrnl-restore.md
  │   ├── jrnl-status.md
  │   └── jrnl-log.md
  ├── README.md
  ├── CHANGELOG.md
  └── LICENSE
  ```

---

## ADR-008: Cross-Project Status Scope and Period

**Date**: 2026-02-03

**Status**: Accepted

### Context

The `/jrnl-status` command shows project status across multiple projects. However, the user's jrnl journal contains not only Claude Code-managed project entries but also manually-created personal journal entries. We needed to define:
1. What constitutes a "project" in the status view
2. How far back to look for entries

### Decision

1. **Scope**: Use `@handoff` tag as the scope filter
   - Only entries with `@handoff` tag are included
   - Project tags are extracted from these entries (excluding @log, @handoff, @idea)
   - Manually-created entries without @handoff are not included

2. **Period**: Default 7 days, user-configurable
   - Default: past 7 days
   - User can override: `/jrnl-status 30` for past 30 days
   - Uses jrnl's `-from "X days ago"` syntax

### Rationale

1. **@handoff as scope**:
   - @handoff tag is specifically for Claude-assisted handoff entries
   - Clear separation from personal journal entries
   - User's manual entries remain private unless tagged with @handoff

2. **7-day default**:
   - Balances relevance (recent context) with coverage (weekly work cycle)
   - Prevents overwhelming output from years of journal history
   - Common work review period (weekly)

3. **User-configurable period**:
   - Different users have different review cadences
   - Monthly reviews possible with `/jrnl-status 30`
   - No arbitrary limit on maximum period

### Alternatives Considered

- **Explicit project list**: Rejected; requires additional configuration
- **Tag prefix convention** (e.g., @cc/project): Rejected; makes tags verbose
- **All entries with any project tag**: Rejected; would include personal entries
- **Fixed period**: Rejected; inflexible for different use cases

### Consequences

- Clear scope: only @handoff entries shown in status
- Users must use @handoff tag for entries to appear in status
- Personal journal entries remain separate
- Period is flexible but has sensible default

---

## ADR-009: Restore Command Design

**Date**: 2026-02-06

**Status**: Accepted

### Context

The `/jrnl-restore` command restores context from a previous session's handoff. We needed to define:
1. How many handoffs to retrieve
2. Whether to limit how far back to search
3. How to handle multiple concurrent tasks within a project

### Decision

1. **Retrieval**: Retrieve only the latest handoff per project (`-n 1`)
2. **Time limit**: No time limit on how old a handoff can be
3. **Task model**: Assume one active task per project at any given time

### Rationale

1. **Simplicity**: Single task model covers the majority of use cases
2. **No data loss**: Old handoffs remain accessible regardless of age
3. **User discretion**: Users decide whether old context is still relevant
4. **Minimal configuration**: No need for expiration settings or cleanup

### Alternatives Considered

- **Time-limited restore** (e.g., 7 days max): Rejected; arbitrary cutoff could discard useful context
- **Multiple task support**: Deferred; adds complexity with task identification/selection
- **Configurable expiration**: Rejected; adds configuration burden without clear benefit

### Consequences

- A handoff from 6 months ago can still be restored
- Users are responsible for judging if old context is still relevant
- One project cannot have multiple parallel tasks tracked via handoff
- Future versions may add time warnings (e.g., "This handoff is 180 days old")

---

## ADR-010: Handoff as Orientation Guide, Not State Dump

**Date**: 2026-02-12

**Status**: Accepted

### Context

Through real-world usage testing, we observed that handoff entries were expected to carry complete session state — progress details, file changes, decisions, and next steps all compressed into one entry. This created two problems:

1. Complex sessions produced overly compressed, hard-to-read handoffs
2. The assumption that handoff alone should restore full context led to proposals for git integration and other state-capture mechanisms, which introduced tool-specific dependencies

Meanwhile, users already maintain project documentation (TODO.md, architecture docs, CLAUDE.md, code comments) that contains detailed, up-to-date state.

### Decision

Position handoff/restore as **orientation guides (pointers)** to project documentation, not as complete state snapshots.

- Handoff entries should point to relevant files and briefly summarize what was in progress
- Detailed state belongs in persistent project files, maintained by the user throughout their work
- Restore provides a starting point; the AI then reads project files for detailed context

### Rationale

1. **Project files are the source of truth**: TODO.md, docs, and code already contain detailed state that persists across sessions
2. **No tool dependency**: This approach works regardless of whether the project uses git, specific editors, or any particular toolchain
3. **Lossy compression is acceptable**: Since the handoff is just a pointer, even a rough summary is sufficient — the details are in the files it points to
4. **Reduced fragility**: Forgetting to create a handoff is less critical when project docs are maintained, because the AI can still read those files
5. **Clear separation of concerns**: jrnl handles temporal flow information; project files handle persistent state

### Alternatives Considered

- **Git-integrated state capture**: Rejected; assumes git usage and ties handoff to a specific tool
- **Full conversation summary**: Rejected; lossy by nature and creates false sense of completeness
- **Automatic state snapshots**: Rejected; complex to implement and maintain, unclear what constitutes "state"

### Consequences

- Handoff entries are shorter and more focused (pointers, not encyclopedias)
- Users should maintain project documentation (TODO.md, etc.) for effective continuity
- Restore is a starting point, not a full context reload
- The plugin's value is in reducing friction of session transitions, not in replacing project documentation

---

## ADR-011: Optional Git Context in Handoff/Restore

**Date**: 2026-02-12

**Status**: Accepted

### Context

Handoff entries serve as orientation guides (ADR-010). In practice, when working in a git repository, two gaps remain:

1. **Handoff creation**: The AI summarizes the conversation but may not accurately recall which files were modified. `git diff --name-only` and `git status` provide a definitive list.
2. **Context restoration**: The handoff may be stale — other commits may have landed since it was created, or uncommitted changes may exist from the previous session. Without checking git state, the AI may suggest outdated next steps.

These gaps only exist in git repositories. Non-git projects are unaffected.

### Decision

Use git output as **intermediate input** during handoff creation and context restoration. Git information informs the AI's output but is not stored verbatim in jrnl entries.

**Handoff creation (git-enhanced)**:
1. If in a git repository, run `git diff --name-only` and `git status --short`
2. Use the file list to write more accurate file references in the handoff entry
3. Include a `Files changed:` section in the handoff with the digested file list
4. The jrnl entry remains human-readable — no raw git output

**Context restoration (git-enhanced)**:
1. Read the handoff entry (existing flow)
2. If in a git repository:
   - Run `git log --oneline --since="<handoff date>"` to see commits since the handoff
   - Run `git status --short` to detect uncommitted changes
3. Present the handoff summary alongside any post-handoff changes
4. If significant changes are found, warn the user that the handoff may be stale

**Detection**: Check for git repository with `git rev-parse --is-inside-work-tree 2>/dev/null`. If the command fails or returns false, skip all git steps silently.

### Rationale

1. **Accuracy without storage burden**: Git output improves handoff quality without bloating jrnl entries with ephemeral data
2. **Conditional execution**: Only runs in git repos — no tool dependency imposed on non-git projects
3. **Staleness detection**: `git log --since` reveals whether the handoff is still current, addressing a real-world problem observed during testing
4. **Complementary to ADR-010**: Git data enriches the "pointer" quality of handoffs by providing accurate file references

### Alternatives Considered

- **Store raw git output in jrnl entries**: Rejected; git status is ephemeral and clutters entries
- **Require git for all handoffs**: Rejected; violates the principle of no tool dependency (ADR-010)
- **Leave to user instruction**: Rejected; users would need to say "also check git" every time, adding friction

### Consequences

- Handoff file references are more accurate in git repositories
- Restore detects post-handoff changes and uncommitted work
- Non-git projects are completely unaffected (graceful fallback)
- Commands become slightly longer but remain simple conditional logic

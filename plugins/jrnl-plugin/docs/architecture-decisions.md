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

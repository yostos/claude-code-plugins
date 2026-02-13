# jrnl-tools Plugin Roadmap

This document outlines the planned features and improvements for future versions of the jrnl-tools plugin.

## Version 1.0 (Current Development)

Initial release with core functionality:

- [ ] Entry creation with timestamps and tags
- [ ] Entry search and filtering (date, tags, text)
- [ ] Tag management (list with counts)
- [ ] JSON export for analysis
- [ ] Edit guidance (provide commands for user)
- [ ] Default journal support only
- [ ] Claude-assisted journaling:
  - Conversation summarization
  - Work session handoffs
  - Context save/restore
  - Cross-project overview

### Tag System (v1.0)

- `@<project>` - Project identification (auto-assigned)
- `@log` - Past records (work, investigation, decisions)
- `@handoff` - Future handoff (context + next actions)
- `@idea` - Ideas for uncertain future

### Out of Scope (v1.0)

- Entry deletion (safety constraint)
- Encryption/decryption operations (security constraint)
- Multiple journal support (deferred to v1.1)
- Star feature support (user can use jrnl directly)

---

## Version 1.1 (Planned)

### Multiple Journal Support

**Priority**: High

**Description**: Enable users to work with multiple journals (e.g., `work`, `personal`, `ideas`).

**Features**:
- List available journals (`jrnl --list`)
- Specify journal for operations (`jrnl work: entry content`)
- Switch active journal context
- Journal-specific search and filtering

**Technical Considerations**:
- Need to track "active journal" in conversation context
- Commands should accept optional journal parameter
- Default behavior remains the default journal

**Related ADR**: ADR-004

---

## Version 1.2 (Planned)

### nb Integration

**Priority**: High

**Description**: Enable extraction of reusable knowledge from jrnl to nb.

**Features**:
- Extract learnings from journal entries to nb
- "This solution seems reusable, save it to nb"
- Suggest entries that might be worth converting to stock knowledge

**Rationale**:
- jrnl handles flow information (temporal)
- nb handles stock information (permanent, reusable)
- Integration allows natural workflow: journal -> extract -> knowledge base

### Enhanced Analytics

**Priority**: Medium

**Description**: Provide deeper insights into journaling patterns.

**Features**:
- Tag co-occurrence analysis
- Entry frequency statistics (daily/weekly/monthly)
- Word count trends

---

## Version 2.0 (Future)

### Advanced Features

**Priority**: Low

**Description**: Features requiring significant implementation effort.

**Potential Features**:
- Weekly/monthly automatic report generation
- Pattern analysis and trend visualization
- Template-based entry creation
- Integration with calendar applications

### Task Tool Integration

**Priority**: Medium

**Description**: Bridge between jrnl (flow) and task management tools (action).

**Features**:
- Extract action items from journal entries
- Create tasks from handoff entries
- Sync status between tools

---

## Design Philosophy

All future features should align with:

1. **jrnl's minimalist philosophy** - Keep it simple, text-based
2. **Security constraints** - No delete, no encryption handling
3. **Information type separation**:
   - Flow (temporal) -> jrnl
   - Stock (permanent) -> nb
   - Action (tasks) -> task tools
4. **Claude's value-add** - Intelligence and automation, not feature wrapping

---

## Contributing

Feature requests and suggestions are welcome. Please consider:

1. Alignment with the concept document (docs/concept.md)
2. Security implications
3. Practical value for daily development workflows
4. Whether the feature belongs in jrnl or another tool

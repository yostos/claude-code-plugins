# jrnl-tools Plugin Requirements

## Overview

This document defines the requirements for the jrnl-tools Claude Code plugin, which provides integration with [jrnl](https://jrnl.sh/) - a command-line journal application.

For the vision and philosophy behind this plugin, see [concept.md](./concept.md).

## Background

This plugin is a migration from jrnl-mcp (an MCP server) to a Claude Code plugin. The migration decision was made to:

- Better align with the target audience (CLI/terminal users)
- Simplify installation (one command vs. manual config editing)
- Reduce complexity (leverage jrnl CLI directly via Bash)
- Improve development velocity and lower maintenance burden

**Key Insight**: This is not merely a jrnl CLI wrapper. It leverages Claude's intelligence to reduce journaling friction and provide cross-project visibility.

---

## Functional Requirements

### FR-1: Entry Creation

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-1.1 | Create new journal entries with natural language timestamps | Must |
| FR-1.2 | Support inline tagging with @ symbol | Must |
| FR-1.3 | Automatically add project tag based on configuration | Must |
| FR-1.4 | Prompt user for project name if not configured | Must |
| FR-1.5 | Support entry creation via external editor | Could |

### FR-2: Entry Reading and Search

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-2.1 | Display recent entries (last N entries) | Must |
| FR-2.2 | Filter entries by date range (from/to) | Must |
| FR-2.3 | Filter entries by specific date (-on) | Must |
| FR-2.4 | Filter entries by tag | Must |
| FR-2.5 | Search entries by text content (-contains) | Must |
| FR-2.6 | Support "today-in-history" view | Should |
| FR-2.7 | Support natural language date parsing | Must |
| FR-2.8 | Combine multiple filters with AND logic | Must |

### FR-3: Entry Editing

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-3.1 | Guide users to use `jrnl --edit` command | Must |
| FR-3.2 | Help identify entries to edit via search/filter | Should |

Note: Direct editing by Claude is not supported due to jrnl's architecture (editing requires external editor).

### FR-4: Tag Management

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-4.1 | List all tags with usage counts | Must |
| FR-4.2 | Support standard content tags (@log, @handoff, @idea) | Must |

### FR-5: Export

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-5.1 | Export entries in JSON format for analysis | Must |
| FR-5.2 | Support other export formats (txt, md) | Could |

### FR-6: Claude-Assisted Journaling

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-6.1 | Summarize conversation and save to journal | Must |
| FR-6.2 | Generate handoff notes for next session | Must |
| FR-6.3 | Save work session context for later restoration | Must |
| FR-6.4 | Restore context from previous session | Must |
| FR-6.5 | Provide cross-project overview from any project | Must |
| FR-6.6 | Record work logs on user request | Must |

### FR-7: Cross-Project Visibility

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-7.1 | List status of all projects from journal | Must |
| FR-7.2 | Show recent activity across projects | Should |
| FR-7.3 | Filter cross-project view by tag | Should |

---

## Non-Functional Requirements

### NFR-1: Security

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-1.1 | Never delete journal entries | Must |
| NFR-1.2 | Never support encryption/decryption operations | Must |
| NFR-1.3 | Validate inputs to prevent command injection | Must |
| NFR-1.4 | Never expose file paths or system information | Should |

### NFR-2: Usability

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-2.1 | Support natural language interactions | Must |
| NFR-2.2 | Provide clear error messages when jrnl is not installed | Must |
| NFR-2.3 | Handle jrnl configuration errors gracefully | Should |
| NFR-2.4 | Work without user knowing jrnl commands | Must |

### NFR-3: Compatibility

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-3.1 | Work with default journal only (v1.0) | Must |
| NFR-3.2 | Support multiple journals (future version) | Won't (v1.0) |

### NFR-4: Tag Conventions

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-4.1 | Use `@<project>` for project identification | Must |
| NFR-4.2 | Use `@log` for past records | Must |
| NFR-4.3 | Use `@handoff` for future handoffs | Must |
| NFR-4.4 | Use `@idea` for uncertain future ideas | Must |
| NFR-4.5 | Automatically apply project tag on write | Must |

---

## Out of Scope (v1.0)

The following features are explicitly excluded from version 1.0:

1. **Entry Deletion** - Safety constraint to prevent accidental data loss
2. **Encryption/Decryption** - Security concern (password handling)
3. **Import** - Direct entry creation via `jrnl` command is sufficient
4. **Multiple Journals** - Planned for v1.1 (see roadmap.md)
5. **Star Feature** - User can use jrnl directly for important entries
6. **nb Integration** - Planned for v1.2 (see roadmap.md)
7. **Task Tool Integration** - Planned for v2.0 (see roadmap.md)

---

## Acceptance Criteria

1. Users can create journal entries using natural language
2. Project tag is automatically added to all entries
3. Users can summarize conversations and save to journal
4. Users can generate handoff notes for next session
5. Users can save and restore work session context
6. Users can view cross-project status from any project
7. Users can search and filter entries using various criteria
8. Users can view tag statistics
9. Users can export entries for analysis
10. The plugin provides clear guidance for edit operations
11. No destructive operations (delete) are possible through the plugin

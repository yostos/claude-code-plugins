# jrnl-tools Plugin - Development Handoff Document

**jrnl Project Tag:** jrnl-plugin

**Status: Deprecated (2026-07-19).** No further development is planned. See [ADR-012](docs/architecture-decisions.md#adr-012-deprecate-jrnl-tools) and the [Auto Memory vs jrnl Handoff addendum](docs/auto-memory-vs-jrnl-handoff.md#addendum-2026-07-19-decision-reversed). This document is retained for historical context only.

This document provides context for developing the jrnl-tools Claude Code plugin.

## Background

This plugin is a **migration from jrnl-mcp**, an MCP (Model Context Protocol) server that provided read-only access to [jrnl](https://jrnl.sh/) journal entries.

### Why Migrate from MCP to Claude Code Skill?

The decision was made on 2026-02-02 and documented in `jrnl-mcp` ADR-005. Key reasons:

1. **Target audience alignment**: jrnl is a CLI tool, so its users are terminal/CLI users who are likely already using Claude Code
2. **Simpler installation**: MCP requires manual config file editing; plugins install with one command
3. **Reduced complexity**: jrnl is already a CLI tool; Claude Code can execute Bash directly, making MCP abstraction unnecessary
4. **Better development velocity**: Skills are simpler to develop, test, and iterate on
5. **Lower maintenance**: No need to track MCP SDK updates

### Project Status

- **jrnl-mcp**: Entered maintenance mode (security/critical fixes only)
- **jrnl-tools**: Deprecated (2026-07-19), no further development (this plugin)

---

## What jrnl-mcp Provided (Reference)

The MCP server offered 6 tools. Consider these as reference for skill/command design:

### 1. search_entries
Search and filter journal entries with:
- `from` / `to`: Date range (supports natural language: "yesterday", "last monday")
- `tags`: Filter by tags
- `contains`: Full-text search
- `limit`: Max entries
- `starred`: Only starred entries
- `journal`: Specific journal name

### 2. list_tags
List all tags with usage counts.

### 3. analyze_tag_cooccurrence
Analyze which tags frequently appear together.
- Input: Array of tags (minimum 2)
- Output: Entries containing all specified tags

### 4. get_statistics
Journal analytics:
- `timeGrouping`: day/week/month/year
- `includeTopTags`: Include top tags in stats

### 5. list_journals
List all available journals from jrnl config.

### 6. set_journal
Set the active journal for subsequent operations.

---

## jrnl CLI Reference

The skill should leverage jrnl CLI directly. Key commands:

```bash
# List entries (JSON output for parsing)
jrnl --export json

# Filter by date
jrnl -from "yesterday" -to "today" --export json
jrnl -from "2024-01-01" --export json

# Filter by tag
jrnl @tag --export json

# Search text
jrnl -contains "search term" --export json

# Starred entries
jrnl -starred --export json

# Specific journal
jrnl work --export json

# List tags
jrnl --tags

# List journals (from config)
jrnl --list
```

---

## Recommended Plugin Structure

```
jrnl-tools/
├── CLAUDE.md          # This file
├── plugin.json        # Plugin manifest
├── skills/
│   └── jrnl.md        # Main skill for jrnl interaction
└── commands/
    ├── jrnl-search.md # Quick search command
    ├── jrnl-stats.md  # Statistics command
    └── jrnl-tags.md   # Tag analysis command
```

---

## Design Considerations

### Skill vs Commands

- **Skill**: Provides Claude with knowledge about jrnl and how to use it effectively
- **Commands**: User-invokable shortcuts for common operations (`/jrnl-search`, `/jrnl-stats`)

### Key Principles

1. **Append-only**: Create new entries but never delete or edit existing entries programmatically
2. **Natural language dates**: Leverage jrnl's flexible date parsing
3. **JSON output**: Use `--format json` for structured data Claude can analyze
4. **Error handling**: Handle cases where jrnl is not installed or configured
5. **No encryption handling**: Never handle encryption/decryption operations

### Security Note

- Validate inputs to prevent command injection
- Never expose file paths or system information
- Respect jrnl's encryption if configured

---

## Reference Links

- **jrnl-mcp repository**: https://github.com/yostos/jrnl-mcp
- **ADR-005 (migration decision)**: `jrnl-mcp/docs/ARCHITECTURE_DECISIONS.md`
- **jrnl official docs**: https://jrnl.sh/
- **Claude Code plugin docs**: Consult claude-code-guide agent

---

## Next Steps

1. Create `plugin.json` manifest
2. Design and implement the main jrnl skill
3. Create user-invokable commands
4. Test with actual jrnl installation
5. Update jrnl-mcp README to reference this plugin

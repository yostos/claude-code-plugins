# jrnl-tools

**Deprecated (2026-07-19).** This plugin is no longer maintained and has been removed from the marketplace listing, so new installs are no longer offered. Claude Code's built-in Auto Memory now covers the cross-session recall use case this plugin was built for, so a separate jrnl-based handoff mechanism is no longer needed. See [ADR-012](docs/architecture-decisions.md#adr-012-deprecate-jrnl-tools) for the full rationale.

If you still use jrnl and want Claude Code to run jrnl commands on your behalf, a lighter-weight skill for that is planned separately; this plugin's handoff/status/restore workflow will not receive further development.

The files below are kept for reference and for existing installs; no further changes are planned.

Claude Code plugin for intelligent journaling with [jrnl](https://jrnl.sh/).

## Overview

jrnl-tools integrates Claude Code with jrnl CLI, enabling:

- Session handoffs as **orientation guides** for work continuity
- Cross-project status visibility
- Automatic project tagging for journal entries
- Natural language journal interaction

Handoff entries are pointers that help the next session orient itself — they reference project files (TODO.md, docs, etc.) where the detailed state lives, rather than trying to capture everything.

## Requirements

- [jrnl](https://jrnl.sh/) installed and configured
- Claude Code

## Installation

```bash
claude plugin add yostos/claude-code-plugins/plugins/jrnl-plugin
```

## Commands

| Command | Description |
|---------|-------------|
| `/jrnl-handoff` | Create handoff notes for next session |
| `/jrnl-restore` | Restore context from previous session |
| `/jrnl-status` | Show cross-project overview (default: 7 days) |
| `/jrnl-log` | Record work log for current session |

### Usage Examples

```
/jrnl-handoff           # Create handoff for tomorrow
/jrnl-restore           # Continue from last session
/jrnl-status            # Show all projects (7 days)
/jrnl-status 30         # Show all projects (30 days)
/jrnl-log               # Record what was done today
```

## Natural Language

The jrnl skill also responds to natural language:

- "Add to my journal: completed the API refactoring"
- "Show my journal entries from last week"
- "What was I working on yesterday?"
- "Search my journal for authentication"

## Project Configuration

Add your project tag to CLAUDE.md:

```markdown
**jrnl Project Tag:** myproject
```

This tag is automatically applied to all journal entries.

## Tag System

| Tag | Purpose |
|-----|---------|
| `@<project>` | Project identifier (auto-applied) |
| `@log` | Past records (work done, decisions) |
| `@handoff` | Future context (for next session) |
| `@idea` | Ideas for uncertain future |

## Relationship with Auto Memory

Auto Memory (`~/.claude/projects/<project>/memory/`), introduced in Claude Code v2.1.32, automatically persists **stable knowledge** such as project patterns and settings across sessions. In contrast, jrnl-plugin handles **chronological work records** (work logs, handoffs, ideas).

| | Auto Memory | jrnl-plugin |
|---|---|---|
| Information type | Stable knowledge (Stock) | Chronological records (Flow) |
| Scope | Single project | Cross-project |
| Operation | Automatic (no explicit action needed) | Explicit (command execution) |
| Access | Within Claude Code | Independently accessible via jrnl CLI |

The two are complementary, not competing. Auto Memory remembers "project conventions," while jrnl records "what was done today and what to do tomorrow." See [Comparative Analysis: Auto Memory vs jrnl Handoff](docs/auto-memory-vs-jrnl-handoff.md) for details.

## Documentation

- [Usage Guide](docs/usage-guide.md) - Scenarios and workflows
- [Concept](docs/concept.md) - Vision and philosophy
- [Use Cases](docs/use-cases.md) - 30 detailed use cases
- [Architecture Decisions](docs/architecture-decisions.md) - Design rationale

## Security

- Read and write operations only (no delete)
- No encryption handling
- Default journal only (v1.0)

## License

MIT License - see [LICENSE](LICENSE)

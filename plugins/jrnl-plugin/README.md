# jrnl-tools

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

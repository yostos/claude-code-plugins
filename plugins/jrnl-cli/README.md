# jrnl-cli

A thin Claude Code skill that runs [jrnl](https://jrnl.sh/) CLI commands on request.

## Overview

jrnl-cli lets Claude Code create and search jrnl journal entries in natural language, by translating requests directly into `jrnl` commands. It has no opinionated tag scheme, no automatic project tagging, and no session-handoff workflow — it is a command translator, not a journaling framework.

If you are looking for the handoff/restore/status workflow that used to live in this repository, see the now-deprecated [jrnl-tools plugin](../jrnl-plugin/README.md). That functionality is superseded by Claude Code's Auto Memory for cross-session recall and is not part of jrnl-cli.

## Requirements

- [jrnl](https://jrnl.sh/) installed and configured
- Claude Code

## Installation

```bash
claude plugin add yostos/claude-code-plugins/plugins/jrnl-cli
```

## Usage

Ask Claude Code in natural language:

- "Add to my journal: finished the API refactoring"
- "Search my journal for authentication"
- "Show my journal entries from last week"
- "What tags do I have in jrnl?"
- "Show entries tagged @project-x"

Claude translates the request into the corresponding `jrnl` command and runs it.

## Constraints

- Default journal only — no multi-journal support
- No automatic tagging — only tags explicitly requested are applied
- Never deletes entries (`jrnl --delete` is left to the user)
- Never handles encryption/decryption

## Documentation

- [Skill: jrnl-cli](skills/jrnl-cli/SKILL.md)

## License

MIT License - see [LICENSE](LICENSE)

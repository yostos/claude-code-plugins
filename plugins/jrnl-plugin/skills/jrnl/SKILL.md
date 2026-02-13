---
name: jrnl
description: This skill should be used when the user asks to "add to journal", "save to journal", "journal this", "record in journal", "show journal", "search journal", "what's in my journal", "create handoff", "save context", "restore context", "what was I working on", "summarize conversation to journal", "record what we did", or mentions jrnl-related operations. Provides comprehensive knowledge about jrnl CLI integration and Claude-assisted journaling.
version: 1.0.0
---

# jrnl Integration for Claude Code

## Overview

This skill enables Claude to interact with jrnl, a command-line journal application, providing intelligent journaling capabilities for development workflows. The integration focuses on reducing journaling friction and enabling cross-project visibility.

**Key capabilities:**
- Create journal entries with automatic project tagging
- Search and filter entries using natural language
- Generate handoff notes for session continuity
- Save and restore work session context
- Provide cross-project status overview

## Tag System

Use these standard tags for consistent organization:

| Tag | Purpose | Example |
|-----|---------|---------|
| `@<project>` | Project identifier | `@myapp`, `@api-refactor` |
| `@log` | Past records (work done, decisions) | Work completed, investigation results |
| `@handoff` | Future context (for next session) | Progress + next steps |
| `@idea` | Ideas for uncertain future | Feature ideas, improvements |

**Rules:**
- Always include the project tag on write operations
- Use `@log` for recording what happened
- Use `@handoff` for session continuity
- Use `@idea` for capturing thoughts without commitment

## Project Configuration

Determine the project tag from the current project's CLAUDE.md file. Look for:

```markdown
**jrnl Project Tag:** myproject
```

If not configured, ask the user for the project name and suggest adding `**jrnl Project Tag:** <name>` to CLAUDE.md.

## Core Operations

### Creating Entries

Execute jrnl with the entry text and appropriate tags. Replace `<project>` with the actual project tag from CLAUDE.md (`**jrnl Project Tag:** name`):

```bash
jrnl "Entry content here @<project> @log"
```

For entries with specific timestamps:

```bash
jrnl "yesterday at 3pm: Entry content @<project> @log"
```

### Reading Entries

Always use `--format json` for structured output:

```bash
# Recent entries
jrnl -n 5 --format json

# Date range
jrnl -from "last monday" -to "today" --format json

# By tag (replace <project> with actual project tag)
jrnl @<project> --format json

# By multiple tags (AND) - requires -and for AND filtering
jrnl @<project> -and @handoff --format json

# Text search
jrnl -contains "search term" --format json

# Combined filters
jrnl -from "this week" @<project> -and @log --format json
```

### Listing Tags

```bash
jrnl --tags
```

## Claude-Assisted Features

### Conversation Summarization

When asked to save a conversation to the journal:

1. Extract key points from the conversation
2. Summarize decisions made and outcomes
3. Create entry with `@project @log` tags

### Handoff Generation

Handoff entries are **orientation guides** for the next session, not complete state dumps. Point to relevant project files rather than trying to capture everything.

When asked to create a handoff:

1. Identify what was in progress and which project files contain the details
2. If in a git repository, run `git diff --name-only` and `git status --short` to identify modified files
3. List pending items and blockers briefly
4. Define concrete next steps, referencing files where applicable
5. Create multi-line entry using heredoc with `@<project> @handoff` tags. Use git file list (if available) for accurate file references:

```bash
jrnl <<EOF
Handoff: [brief summary] @<project> @handoff
Progress:
- [what was accomplished, with file references]
Files changed:
- [modified files, informed by git if available]
Blockers:
- [issues, or "None"]
Next:
- [concrete next steps, referencing relevant files]
EOF
```

6. Verify with `jrnl -n 1 --format json` that tags are correct

Note: Do not include raw git output in the entry. Digest it into readable file references.

### Context Restoration

The handoff is a starting point for orientation. After reading it, follow its pointers to project files for detailed context.

When asked to restore context or continue previous work:

1. Retrieve latest handoff: `jrnl @<project> -and @handoff -n 1 --format json`
2. Parse the entry content
3. Present summary of previous context
4. If in a git repository, check for post-handoff changes:
   - `git log --oneline --since="<handoff date>"` for commits since the handoff
   - `git status --short` for uncommitted changes
   - If significant changes found, note that the handoff may be partially stale
5. Read project files referenced in the handoff (e.g., TODO.md, docs) for detailed state
6. Suggest next steps based on handoff content, git state (if available), and current project files

### Work Log Recording

When asked to record work done:

1. Summarize tasks completed in the session
2. Note any significant decisions or findings
3. Create multi-line entry using heredoc with `@<project> @log` tags:

```bash
jrnl <<EOF
Log: [brief summary] @<project> @log
Completed:
- [tasks and outcomes]
Decisions:
- [key decisions, or "None"]
EOF
```

4. Verify with `jrnl -n 1 --format json` that tags are correct

## jrnl CLI Quick Reference

| Command | Purpose |
|---------|---------|
| `jrnl "text"` | Create entry |
| `jrnl -n N` | Show last N entries |
| `jrnl -from DATE` | Entries from date |
| `jrnl -to DATE` | Entries until date |
| `jrnl @tag` | Filter by tag |
| `jrnl -and @tag2` | Additional tag filter |
| `jrnl -contains "text"` | Text search |
| `jrnl --format json` | JSON output |
| `jrnl --tags` | List all tags |
| `jrnl --edit` | Edit entries (external editor) |

**Date formats:** jrnl supports natural language dates like "yesterday", "last monday", "2 weeks ago", "january 15".

## Error Handling

### jrnl Not Installed

If jrnl command fails with "command not found":

```
jrnl is not installed. Install it with:
  pip install jrnl

Or see: https://jrnl.sh/
```

### Empty Results

When search returns no entries, inform the user clearly:

```
No journal entries found matching your criteria.
```

### Missing Project Configuration

If project tag is not configured:

1. Ask user for project name
2. Suggest adding to CLAUDE.md: `**jrnl Project Tag:** name`
3. Proceed with provided name

## Security Constraints

**Never:**
- Delete journal entries (use `jrnl --delete` directly if needed)
- Handle encryption operations (password security concern)
- Expose file paths or system information

**Always:**
- Validate inputs before constructing commands
- Use the default journal only (v1.0)
- Guide users to use `jrnl --edit` for modifications

---
name: jrnl-cli
description: This skill should be used when the user asks to "add to my journal", "journal this", "write a jrnl entry", "search my journal", "show my journal entries", "find journal entries about X", "what tags do I have in jrnl", "show entries tagged X", or "list entries from last week". Executes the jrnl CLI directly based on the request, with no opinionated tag scheme, no automatic project tagging, no session-handoff workflow, and no delete or encryption handling.
---

# jrnl CLI

## Overview

Translate the user's request directly into a `jrnl` CLI invocation and run it with Bash. Apply only the tags, dates, and filters the user explicitly asked for — invent no tagging convention and add no project tag automatically. Assume the default journal only; do not pass `-j <journal>` or otherwise manage multiple journals.

This skill is intentionally minimal: it is a command translator, not a workflow tool. It does not implement session handoffs, work logs, or any multi-step journaling process.

## Prerequisite Check

Before running a command for the first time in a session, confirm jrnl is installed and configured:

```bash
jrnl --version
```

If this fails with "command not found", tell the user:

```
jrnl is not installed. Install it with:
  pip install jrnl

Or see: https://jrnl.sh/
```

If jrnl is installed but no journal is configured yet, a plain `jrnl "..."` invocation may try to start an interactive setup wizard, which cannot be completed in a non-interactive Bash call and will hang or time out. If a command hangs or fails with a config-related error, stop and tell the user to run `jrnl` once manually in their own terminal to complete first-time setup, then retry.

## Creating Entries

Pass the entry text as a single argument. jrnl timestamps it with the current date/time unless a natural-language date is included in the text itself:

```bash
jrnl "Entry text here"
jrnl "yesterday at 3pm: Entry text here"
```

Only add tags (`@tag`) if the user explicitly mentioned them. Do not append a project tag, `@log`, `@handoff`, or any other tag on the user's behalf.

For multi-line entries, use a heredoc rather than embedding literal newlines in a quoted string:

```bash
jrnl <<'EOF'
First line of the entry
Second line with more detail
EOF
```

After creating an entry, optionally verify it with `jrnl -n 1 --format json` and report back what was recorded (date, tags, content) so the user can confirm it matches their intent.

## Searching and Reading Entries

Use `--format json` when the output needs to be parsed or filtered further before presenting it to the user; use plain `jrnl` output when just displaying entries directly.

```bash
# Most recent N entries
jrnl -n 5 --format json

# Date range (jrnl understands natural language: "yesterday", "last monday", "2 weeks ago")
jrnl -from "last monday" -to "today" --format json

# Filter by a single tag
jrnl @sometag --format json

# Filter by multiple tags (AND) — note: bare "jrnl @tag1 @tag2" is OR, not AND
jrnl @tag1 -and @tag2 --format json

# Full-text search
jrnl -contains "search term" --format json

# Combine filters freely
jrnl -from "this week" @sometag -contains "keyword" --format json

# Starred entries only
jrnl -starred --format json
```

## Listing Tags

```bash
jrnl --tags
```

Use this to answer "what tags do I have" or to help the user pick an existing tag rather than guessing one.

## What This Skill Does Not Do

- **No delete operations.** Never run `jrnl --delete` or any variant that removes entries. If the user wants to delete something, tell them to run `jrnl --delete` themselves in their terminal.
- **No encryption/decryption handling.** Never attempt to set up, unlock, or manage jrnl's encryption. If a journal is encrypted and a command fails because of it, tell the user to unlock it manually.
- **No automatic tagging scheme.** Do not invent or apply `@project`, `@log`, `@handoff`, or any other convention. Tag only what the user says to tag.
- **No multi-journal support.** Always operate on the default journal. Do not use `-j <name>` or `jrnl <name>:`.
- **No session-handoff or work-log workflow.** This skill only translates requests into `jrnl` commands; it does not summarize conversations, generate handoffs, or track cross-project status.

## Error Handling

**Empty results**: If a search returns nothing, say so plainly — "No journal entries found matching that." Do not guess or fabricate entries.

**Ambiguous request**: If it's unclear whether the user wants to create an entry or search for one (e.g., a short phrase that could be either), ask before running a command that writes data.

**Command fails**: Show the actual jrnl error output to the user rather than paraphrasing it — jrnl's own error messages are usually specific enough to act on.

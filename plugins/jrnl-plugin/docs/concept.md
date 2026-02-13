# jrnl-tools Concept

## Vision

**Organically integrate Claude Code and jrnl to support developers' continuous workflows.**

This is not merely a jrnl CLI wrapper. By combining Claude Code's context understanding capabilities with jrnl's chronological recording abilities, we enable:

- Work continuity across sessions
- Cross-project situational awareness
- Recording of thought processes and decisions

---

## Problems to Solve

### 1. Context Fragmentation

Developers often work on multiple projects in parallel. Claude Code operates on a per-project (directory) basis, so context is not shared between projects.

**Problem**: It takes time to remember "what I was doing in that project."

### 2. Session Discontinuity

Claude Code sessions are temporary. When interrupting long work sessions and resuming the next day, you need to re-explain the previous situation. Project state exists in TODO.md, docs, and code, but the AI needs a starting point to know where to look.

**Problem**: Even when project files exist, the AI doesn't know which files are relevant or what was in progress.

### 3. Handoff Burden

Handing off to yourself (tomorrow's you) or sharing status with team members requires work logs. However, writing logs while working is tedious.

**Problem**: Maintaining logs while working creates high cognitive load.

### 4. Scattered Information

Investigation results, trial and error, and reasons for decisions are scattered in your head or chat history, making them impossible to reference later.

**Problem**: You forget "why I made this design decision."

---

## Solution Approach

### Using jrnl as a "Flow Information Hub"

```
+-----------------------------------------------------+
|                       User                          |
+-----------------------------------------------------+
                         |
         +---------------+---------------+
         v               v               v
   +----------+    +----------+    +----------+
   |Project A |    |Project B |    |Project C |
   |(Claude   |    |(Claude   |    |(Claude   |
   | Code)    |    | Code)    |    | Code)    |
   +----+-----+    +----+-----+    +----+-----+
        |               |               |
        +---------------+---------------+
                        v
              +-----------------+
              |      jrnl       |
              |   (Global)      |
              |                 |
              | - Work logs     |
              | - Context       |
              | - Handoffs      |
              | - Decisions     |
              +-----------------+
                        |
                        v
              +-----------------+
              | Accessible from |
              | any project     |
              +-----------------+
```

### Claude Code's Role

1. **Automatic work summarization**: Summarize conversation content on behalf of the user and record to jrnl
2. **Session orientation**: Provide handoff notes as a guide to help the next session know where to look in project files (TODO.md, docs, code)
3. **Cross-project overview**: Retrieve status from multiple projects via jrnl and display unified view
4. **Natural language operation**: Operate jrnl through natural conversation without knowing commands

### Relationship Between jrnl and Project Documents

```
Project Documents (primary state)     jrnl (orientation guide)
+---------------------------+         +---------------------------+
| TODO.md                   |         | Handoff entries           |
| docs/architecture.md      |  <---   | "Check TODO.md Phase 9,   |
| CLAUDE.md                 |  guide  |  working on issue #2"     |
| Source code               |         |                           |
+---------------------------+         +---------------------------+
       (detailed state)                   (pointer / breadcrumb)
```

**Key principle**: Project documentation holds the detailed state. Handoff entries are guides that help the next session quickly orient itself — they point to the right files and summarize what was in progress. The handoff does not need to capture everything because the project files persist.

---

## Information Classification Model

Classify information into "Flow," "Stock," and "Action," and manage with appropriate tools.

| Type | Characteristics | Examples | Tool |
|------|-----------------|----------|------|
| **Flow** | Chronological, temporary, daily context | Work logs, investigation notes, thought process | jrnl |
| **Stock** | Reusable, permanent, structured | Technical knowledge, procedures, configurations | nb (future) |
| **Action** | Tasks to execute, state management | TODOs, tasks, reminders | Task tools (future) |

### "Flow" Information Handled by jrnl

- **Work logs**: What was done today, progress status
- **Investigation records**: What was researched, tried, and results
- **Thought process**: Why that decision was made, options considered
- **Handoffs**: Guide to what to do next, pointers to relevant project files
- **Session breadcrumbs**: What was in progress, where to resume

### Information NOT Handled by jrnl

- Reusable technical knowledge -> nb
- Permanent documentation -> nb
- Task management -> Dedicated tools

---

## Tag System

Use jrnl's tag functionality to classify and enable searching of entries.

### Project Identification

```
@<project-name>    Project name (e.g., @webapp, @api-server)
```

**Auto-assignment rule**: When writing to jrnl, Claude automatically adds the project tag from CLAUDE.md or project configuration. If not configured, Claude asks the user.

### Content Tags

| Tag | Meaning | Time Orientation |
|-----|---------|------------------|
| `@log` | Past records | What happened (work, investigation, decisions, learnings) |
| `@handoff` | Future handoff | What to do next, context for tomorrow |
| `@idea` | Uncertain future | Ideas to consider someday |

### Tag Usage Examples

```bash
# Work log
jrnl "Completed API design, decided to implement with REST @webapp @log"

# Investigation record
jrnl "Auth bug investigation: token verification OK, refresh process suspicious @api @log"

# Handoff to tomorrow
jrnl "Today's work done. Continue auth bug fix tomorrow, check refresh logic @api @handoff"

# Idea for later
jrnl "Consider adding GraphQL support in future @api @idea"
```

---

## Design Principles

### 1. Safety First

- **No delete operations**: Prevent data loss from accidental operations
- **No encryption operations**: Avoid security risks of password handling
- **Read and append as basics**: Minimize changes to existing entries

### 2. Natural Dialogue

- Usable without knowing jrnl commands
- Operate with natural language like "record this to journal" or "show me yesterday's status"
- Claude generates and executes appropriate commands

### 3. Context Utilization

- Leverage Claude Code's conversation history for summarization and recording
- Users don't need to write content from scratch
- Logs are automatically maintained while working

### 4. Cross-Project Access

- Access all project status from any project
- Filter by tag for per-project display

### 5. Maintain Simplicity

- Respect jrnl's philosophy (minimalist, text-based)
- Avoid excessive feature additions
- Claude adds value through intelligence, not through wrapping every jrnl feature

### 6. Handoff as Guide, Not State Dump

- Handoff entries are **orientation guides** for the next session, not complete state snapshots
- Detailed state belongs in project files (TODO.md, docs, CLAUDE.md, code)
- A good handoff points to where to look, not tries to replicate what's already written
- Users should maintain project documentation alongside jrnl for effective continuity

### 6. Automatic Project Tagging

- Project tag is automatically assigned based on configuration
- Ensures consistency across entries
- User is prompted if project is not configured

---

## Target Users

### Primary

- Developers who use Claude Code daily
- Working on multiple projects in parallel
- Feel the need for work logs and handoffs

### Secondary

- Already using jrnl but want to leverage it more
- Experience challenges with work continuity between sessions
- Have habits of personal reflection and introspection

---

## Scope Boundaries

### What This Plugin Does

- Leverages Claude's intelligence to reduce journaling friction
- Provides cross-project visibility through jrnl
- Automates routine logging (summaries, handoffs, context)

### What This Plugin Does NOT Do

- Replace task management tools (use dedicated tools)
- Replace knowledge bases (use nb for stock information)
- Make importance judgments for users (stars are user's choice)
- Provide state management (jrnl is append-only)

---

## Glossary

| Term | Definition |
|------|------------|
| Flow Information | Temporary information recorded chronologically. Work logs, thought processes, etc. |
| Stock Information | Reusable permanent information. Knowledge, procedures, etc. |
| Context | Current state of work. Primarily lives in project files; handoff provides a guide to locate it. |
| Handoff | Orientation guide for next session. Points to relevant project files and summarizes what was in progress. |

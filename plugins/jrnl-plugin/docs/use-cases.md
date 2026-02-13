# jrnl-tools Plugin Use Cases

This document describes concrete use cases for the jrnl-tools plugin in Claude Code.

For the vision and philosophy, see [concept.md](./concept.md).

## Format

Each use case follows this structure:

- **ID**: Unique identifier
- **Goal**: What the user wants to accomplish
- **Precondition**: Required state before the use case
- **User Request**: Example of what the user might say in Claude Code
- **Claude Action**: How Claude handles the request
- **Expected Result**: What the user receives
- **Related Requirement**: Link to requirements.md

**Note**: All write operations automatically include the project tag (e.g., `@myproject`) based on configuration.

---

## Basic Entry Operations

### UC-01: Create a Simple Entry

- **Goal**: Record a thought or event quickly
- **Precondition**: jrnl is installed; project configured
- **User Request**: "Add to my journal: Had a productive meeting with the design team today"
- **Claude Action**: Execute `jrnl "Had a productive meeting with the design team today @myproject @log"`
- **Expected Result**: Entry created with project tag and @log tag
- **Related Requirement**: FR-1.1, FR-1.3

### UC-02: Create an Entry with Custom Tags

- **Goal**: Create an entry with additional categorization
- **Precondition**: jrnl is installed; project configured
- **User Request**: "Journal this: Completed the API refactoring"
- **Claude Action**: Execute `jrnl "Completed the API refactoring @myproject @log"`
- **Expected Result**: Entry created with project and log tags
- **Related Requirement**: FR-1.2, FR-1.3

### UC-03: Create an Entry with Specific Timestamp

- **Goal**: Record an event that happened at a specific time
- **Precondition**: jrnl is installed; project configured
- **User Request**: "Add to my journal for yesterday at 3pm: Finished reading the architecture book"
- **Claude Action**: Execute `jrnl "yesterday at 3pm: Finished reading the architecture book @myproject @log"`
- **Expected Result**: Entry created with specified timestamp
- **Related Requirement**: FR-1.1

### UC-04: Create Entry Without Project Configuration

- **Goal**: Handle missing project configuration gracefully
- **Precondition**: jrnl is installed; project NOT configured
- **User Request**: "Record in journal: Started new feature development"
- **Claude Action**:
  1. Detect missing project configuration
  2. Ask user: "What project name should I use for tagging?"
  3. After user provides name, execute `jrnl "Started new feature development @providedname @log"`
- **Expected Result**: Entry created after user provides project name
- **Related Requirement**: FR-1.4

---

## Entry Reading and Search

### UC-05: View Recent Entries

- **Goal**: See the latest journal entries
- **Precondition**: Journal has entries
- **User Request**: "Show me my last 5 journal entries"
- **Claude Action**: Execute `jrnl -n 5 --format json`, parse and display entries
- **Expected Result**: Last 5 entries displayed in readable format
- **Related Requirement**: FR-2.1

### UC-06: Search Entries by Date Range

- **Goal**: Find entries within a specific period
- **Precondition**: Journal has entries
- **User Request**: "Show my journal entries from last week"
- **Claude Action**: Execute `jrnl -from "last monday" -to "last sunday" --format json`
- **Expected Result**: Entries from the specified week displayed
- **Related Requirement**: FR-2.2

### UC-07: Search Entries by Project

- **Goal**: Find all entries for a specific project
- **Precondition**: Journal has tagged entries
- **User Request**: "Show all my entries for the webapp project"
- **Claude Action**: Execute `jrnl @webapp --format json`
- **Expected Result**: All entries with @webapp tag displayed
- **Related Requirement**: FR-2.4

### UC-08: Search Entries by Content Tag

- **Goal**: Find entries by content type
- **Precondition**: Journal has tagged entries
- **User Request**: "Show all my handoff notes"
- **Claude Action**: Execute `jrnl @handoff --format json`
- **Expected Result**: All handoff entries displayed
- **Related Requirement**: FR-2.4

### UC-09: Search Entries by Multiple Tags (AND)

- **Goal**: Find entries matching multiple criteria
- **Precondition**: Journal has tagged entries
- **User Request**: "Find handoff notes for the api project"
- **Claude Action**: Execute `jrnl @api -and @handoff --format json`
- **Expected Result**: Entries with both tags displayed
- **Related Requirement**: FR-2.8

### UC-10: Search Entries by Text Content

- **Goal**: Find entries containing specific words
- **Precondition**: Journal has entries
- **User Request**: "Search my journal for entries mentioning 'authentication'"
- **Claude Action**: Execute `jrnl -contains "authentication" --format json`
- **Expected Result**: Entries containing "authentication" displayed
- **Related Requirement**: FR-2.5

### UC-11: View Today in History

- **Goal**: See what was written on this day in previous years
- **Precondition**: Journal has multi-year entries
- **User Request**: "What did I journal on this day in previous years?"
- **Claude Action**: Execute `jrnl -today-in-history --format json`
- **Expected Result**: Entries from this date across all years displayed
- **Related Requirement**: FR-2.6

### UC-12: Combined Search

- **Goal**: Find specific entries using multiple criteria
- **Precondition**: Journal has entries
- **User Request**: "Find log entries from this month for the webapp project that mention 'bug'"
- **Claude Action**: Execute `jrnl -from "first day of this month" @webapp -and @log -contains "bug" --format json`
- **Expected Result**: Matching entries displayed
- **Related Requirement**: FR-2.2, FR-2.4, FR-2.5, FR-2.8

---

## Tag Management

### UC-13: List All Tags

- **Goal**: See all tags used in the journal
- **Precondition**: Journal has tagged entries
- **User Request**: "What tags do I use in my journal?"
- **Claude Action**: Execute `jrnl --tags`
- **Expected Result**: List of tags with usage counts displayed
- **Related Requirement**: FR-4.1

### UC-14: List Projects

- **Goal**: See all projects recorded in journal
- **Precondition**: Journal has tagged entries
- **User Request**: "What projects do I have in my journal?"
- **Claude Action**: Execute `jrnl --tags`, filter for project-like tags
- **Expected Result**: List of project tags with entry counts
- **Related Requirement**: FR-4.1

---

## Export and Analysis

### UC-15: Export Entries for Analysis

- **Goal**: Get structured data for further analysis
- **Precondition**: Journal has entries
- **User Request**: "Export my journal entries from this year as JSON"
- **Claude Action**: Execute `jrnl -from "january 1" --format json`
- **Expected Result**: JSON output provided for analysis
- **Related Requirement**: FR-5.1

### UC-16: Summarize Journal Period

- **Goal**: Get a summary of journal activity
- **Precondition**: Journal has entries
- **User Request**: "Summarize what I journaled about last month"
- **Claude Action**: Execute `jrnl -from "last month" -to "end of last month" --format json`, analyze content
- **Expected Result**: Summary of themes, projects, entry count provided
- **Related Requirement**: FR-5.1

---

## Edit Guidance

### UC-17: Guide User to Edit an Entry

- **Goal**: Help user modify an existing entry
- **Precondition**: Journal has entries
- **User Request**: "I need to fix a typo in yesterday's entry"
- **Claude Action**:
  1. Execute `jrnl -on yesterday --format json` to show the entry
  2. Provide command: `jrnl -on yesterday --edit`
- **Expected Result**: User receives the command to edit in their configured editor
- **Related Requirement**: FR-3.1, FR-3.2

### UC-18: Find Entry to Edit

- **Goal**: Locate a specific entry for editing
- **Precondition**: Journal has entries
- **User Request**: "I want to edit the entry where I wrote about the Paris trip"
- **Claude Action**:
  1. Execute `jrnl -contains "Paris" --format json` to find entries
  2. Show matching entries
  3. Provide command: `jrnl -contains "Paris" --edit`
- **Expected Result**: User can identify the entry and receives edit command
- **Related Requirement**: FR-3.1, FR-3.2

---

## Error Handling

### UC-19: Handle jrnl Not Installed

- **Goal**: Gracefully handle missing jrnl installation
- **Precondition**: jrnl is not installed
- **User Request**: "Show my journal entries"
- **Claude Action**: Detect jrnl is not installed, provide installation guidance
- **Expected Result**: Clear error message with installation instructions
- **Related Requirement**: NFR-2.2

### UC-20: Handle Empty Results

- **Goal**: Inform user when no entries match criteria
- **Precondition**: Journal exists but no matching entries
- **User Request**: "Show entries tagged @nonexistent"
- **Claude Action**: Execute search, detect empty results
- **Expected Result**: Clear message that no entries match the criteria
- **Related Requirement**: NFR-2.1

---

## Claude-Assisted Journaling

These use cases leverage Claude's intelligence to generate content, rather than simply executing user-specified commands.

### UC-21: Save Conversation Summary

- **Goal**: Preserve key points from a Claude Code conversation
- **Precondition**: Active conversation with meaningful content; project configured
- **User Request**: "Save this conversation to my journal"
- **Claude Action**:
  1. Summarize the conversation content
  2. Execute `jrnl "Summary: [conversation summary] @myproject @log"`
- **Expected Result**: Conversation summary saved with project and log tags
- **Related Requirement**: FR-6.1

### UC-22: Generate Handoff Notes

- **Goal**: Create handoff for next session
- **Precondition**: Work session with progress made; project configured
- **User Request**: "Create a handoff for tomorrow"
- **Claude Action**:
  1. Summarize current progress and pending items
  2. Identify next steps
  3. Execute `jrnl "Handoff: [progress summary]. Next: [next steps] @myproject @handoff"`
- **Expected Result**: Handoff entry saved for future reference
- **Related Requirement**: FR-6.2

### UC-23: Save Work Session Context

- **Goal**: Preserve current work context for later resumption
- **Precondition**: Ongoing work session with Claude Code; project configured
- **User Request**: "Save the current work state so I can resume tomorrow"
- **Claude Action**:
  1. Summarize current progress, decisions made, and context
  2. Include relevant file paths and next steps
  3. Execute `jrnl "Context: [work state summary] @myproject @handoff"`
- **Expected Result**: Work state saved as handoff entry
- **Related Requirement**: FR-6.3

### UC-24: Restore Work Session Context

- **Goal**: Resume work from a previously saved state
- **Precondition**: Previous handoff saved in journal
- **User Request**: "What was I working on in this project? Let's continue from there"
- **Claude Action**:
  1. Execute `jrnl @myproject @handoff -n 1 --format json`
  2. Parse the saved context
  3. Present summary and suggest next steps
- **Expected Result**: Previous context restored, ready to continue work
- **Related Requirement**: FR-6.4

### UC-25: Record Work Log

- **Goal**: Record what was accomplished
- **Precondition**: Work completed; project configured
- **User Request**: "Record what we did today"
- **Claude Action**:
  1. Summarize work completed in this session
  2. Execute `jrnl "Log: [work summary] @myproject @log"`
- **Expected Result**: Work log entry created
- **Related Requirement**: FR-6.6

### UC-26: Record an Idea

- **Goal**: Capture an idea for future consideration
- **Precondition**: project configured
- **User Request**: "I have an idea - we should add GraphQL support. Save it for later"
- **Claude Action**: Execute `jrnl "Idea: Add GraphQL support for better API flexibility @myproject @idea"`
- **Expected Result**: Idea saved with @idea tag
- **Related Requirement**: FR-1.2

---

## Cross-Project Visibility

### UC-27: View All Projects Status

- **Goal**: See status of all projects from any location
- **Precondition**: Journal has entries from multiple projects
- **User Request**: "Show me the status of all my projects"
- **Claude Action**:
  1. Execute `jrnl @handoff -n 20 --format json`
  2. Group by project tag
  3. Display latest handoff for each project
- **Expected Result**: Overview of all projects with their latest status
- **Related Requirement**: FR-7.1

### UC-28: View Recent Activity Across Projects

- **Goal**: See what was done across all projects recently
- **Precondition**: Journal has entries from multiple projects
- **User Request**: "What did I work on yesterday across all projects?"
- **Claude Action**:
  1. Execute `jrnl -on yesterday @log --format json`
  2. Group by project tag
  3. Display summary
- **Expected Result**: Yesterday's work across all projects displayed
- **Related Requirement**: FR-7.2

### UC-29: Find Pending Work Across Projects

- **Goal**: Find all handoffs/pending items across projects
- **Precondition**: Journal has handoff entries
- **User Request**: "What are my pending items across all projects?"
- **Claude Action**:
  1. Execute `jrnl @handoff --format json`
  2. Extract pending items from recent handoffs
  3. Group by project
- **Expected Result**: Pending items listed by project
- **Related Requirement**: FR-7.1

### UC-30: View Ideas Across Projects

- **Goal**: Review all captured ideas
- **Precondition**: Journal has idea entries
- **User Request**: "Show me all the ideas I've captured"
- **Claude Action**: Execute `jrnl @idea --format json`, display organized list
- **Expected Result**: All ideas displayed, grouped by project if applicable
- **Related Requirement**: FR-2.4

---

## Summary

| Category | Use Cases | Count |
|----------|-----------|-------|
| Basic Entry Operations | UC-01 to UC-04 | 4 |
| Entry Reading/Search | UC-05 to UC-12 | 8 |
| Tag Management | UC-13 to UC-14 | 2 |
| Export/Analysis | UC-15 to UC-16 | 2 |
| Edit Guidance | UC-17 to UC-18 | 2 |
| Error Handling | UC-19 to UC-20 | 2 |
| Claude-Assisted Journaling | UC-21 to UC-26 | 6 |
| Cross-Project Visibility | UC-27 to UC-30 | 4 |
| **Total** | | **30** |

---
description: Show cross-project overview from journal
argument-hint: [days]
allowed-tools: Bash(jrnl:*)
---

Show status of projects from journal handoffs.

1. Determine the period:
   - If argument provided: use $ARGUMENTS days
   - Otherwise: default to 7 days

2. Retrieve handoff entries (note: @handoff only, no project filter - this is intentionally cross-project):
   ```
   jrnl @handoff -from "X days ago" --format json
   ```

3. Extract project tags from entries:
   - Look for @ tags that are not @log, @handoff, or @idea
   - Group entries by project tag

4. For each project found:
   - Show project name
   - Date of latest handoff
   - Summary of current status
   - Pending next steps

5. Present as a concise overview table or list

If no handoffs found in the period, suggest extending the period or inform that no recent handoffs exist.

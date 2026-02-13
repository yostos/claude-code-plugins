---
description: Record work log for current session
allowed-tools: Read, Bash(jrnl:*)
---

Record a log of work completed in this session.

1. Read the project's CLAUDE.md to find the project tag (look for `**jrnl Project Tag:** name`)
2. If not found, ask the user for the project name

3. Summarize work completed in this session:
   - Tasks completed
   - Files created or modified
   - Problems solved
   - Decisions made

4. Create the journal entry using heredoc for multi-line format (replace `<project-tag>` with the actual project name found in step 1):
   ```bash
   jrnl <<EOF
   Log: [brief one-line summary] @<project-tag> @log
   Completed:
   - [task or outcome 1]
   - [task or outcome 2]
   Files changed:
   - [file list, if relevant]
   Decisions:
   - [key decisions, or "None"]
   EOF
   ```
   Example: If CLAUDE.md contains `**jrnl Project Tag:** myapp`, use `@myapp @log`

   Note: The first line becomes the jrnl entry title. Subsequent lines become the body.

5. Verify the entry was saved correctly:
   ```bash
   jrnl -n 1 --format json
   ```
   Check that:
   - The entry exists with the expected title
   - Both `@<project-tag>` and `@log` tags are present
   - If verification fails, inform the user and show the jrnl output

Keep the log concise but informative - focus on outcomes rather than detailed steps.

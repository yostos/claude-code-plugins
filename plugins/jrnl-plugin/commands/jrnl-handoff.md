---
description: Create handoff notes for next session
allowed-tools: Read, Bash(jrnl:*), Bash(git:*)
---

Create a handoff entry for the next session. The handoff is an **orientation guide** — it should point to relevant project files rather than trying to capture all details.

1. Read the project's CLAUDE.md to find the project tag (look for `**jrnl Project Tag:** name`)
2. If not found, ask the user for the project name

3. Check if this is a git repository and gather file change information:
   ```bash
   git rev-parse --is-inside-work-tree 2>/dev/null
   ```
   If yes, run:
   ```bash
   git diff --name-only
   git status --short
   ```
   Use the output to identify which files were modified in this session. If not a git repo, skip this step silently.

4. Summarize the current session as a guide for the next session:
   - What was in progress and where to find details (e.g., "see TODO.md Phase 9", "see docs/architecture-decisions.md ADR-010")
   - Key decisions made (briefly, reference docs if details are written there)
   - Any blockers or issues encountered
   - Concrete next steps to continue
   - Use the git file list from step 3 (if available) to write accurate file references

5. Create the journal entry using heredoc for multi-line format (replace `<project-tag>` with the actual project name found in step 1):
   ```bash
   jrnl <<EOF
   Handoff: [brief one-line summary] @<project-tag> @handoff
   Progress:
   - [what was accomplished, with file references where applicable]
   - [key decisions made (see docs/file.md for details)]
   Files changed:
   - [list of modified files, informed by git output if available]
   Blockers:
   - [issues encountered, or "None"]
   Next:
   - [concrete next step, referencing relevant files]
   - [e.g., "Continue TODO.md Phase 9 - implement feature X"]
   EOF
   ```
   Example: If CLAUDE.md contains `**jrnl Project Tag:** myapp`, use `@myapp @handoff`

   Note: The first line becomes the jrnl entry title. Subsequent lines become the body.
   Note: Do NOT include raw git output. Digest it into readable file references.

6. Verify the entry was saved correctly:
   ```bash
   jrnl -n 1 --format json
   ```
   Check that:
   - The entry exists with the expected title
   - Both `@<project-tag>` and `@handoff` tags are present
   - If verification fails, inform the user and show the jrnl output

Format the handoff to be actionable - the next session should be able to continue immediately from the handoff notes.

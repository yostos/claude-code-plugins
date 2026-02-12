---
description: Restore context from previous session
allowed-tools: Read, Bash(jrnl:*), Bash(git:*)
---

Restore context from the previous session's handoff. The handoff is an **orientation guide** — use it as a starting point, then read the project files it references for detailed context.

1. Read the project's CLAUDE.md to find the project tag (look for `**jrnl Project Tag:** name`)
2. If not found, ask the user for the project name

3. Retrieve the latest handoff (replace `<project-tag>` with the actual project name found in step 1):
   ```
   jrnl @<project-tag> -and @handoff -n 1 --format json
   ```
   Example: If CLAUDE.md contains `**jrnl Project Tag:** myapp`, run `jrnl @myapp -and @handoff -n 1 --format json`

4. Parse and present the handoff content:
   - When the handoff was created
   - Summary of previous progress
   - What was planned as next steps
   - Any noted blockers or issues

5. Check if this is a git repository and gather post-handoff changes:
   ```bash
   git rev-parse --is-inside-work-tree 2>/dev/null
   ```
   If yes, run:
   ```bash
   git log --oneline --since="<handoff date>"
   git status --short
   ```
   - If there are commits since the handoff, present them and note that the handoff may be partially stale
   - If there are uncommitted changes, mention them as leftover work from a previous session
   - If not a git repo, skip this step silently

6. Follow up on file references in the handoff:
   - If the handoff mentions specific files (e.g., TODO.md, docs/), read them for current detailed state
   - This provides richer context than the handoff summary alone

7. Offer to continue from where the previous session left off, informed by the handoff, git state (if available), and project files

If no handoff is found, inform the user and offer to search for recent log entries instead.

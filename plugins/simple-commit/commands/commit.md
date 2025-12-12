---
description: Analyze staged changes and auto-generate a Conventional Commits format message, then commit
model: haiku
allowed-tools: ["Bash"]
---

# Git Commit with Auto-Generated Message

Analyze staged changes, auto-generate a commit message in Conventional Commits format, and execute the commit.

## Workflow

1. **Gather change information in parallel**:
   - `git status` - Check staging status
   - `git diff --staged` - Get detailed staged changes
   - `git log --oneline -5` - Get recent commit history (for style reference)

2. **Analyze changes**:
   - If no staged changes exist, display error message and exit
   - Determine nature of changes from files and diffs (new feature, bug fix, refactoring, etc.)

3. **Generate commit message**:
   - **Follow Conventional Commits format**:
     - `feat:` - New feature
     - `fix:` - Bug fix
     - `docs:` - Documentation only
     - `style:` - Code style changes (whitespace, formatting, etc.)
     - `refactor:` - Code changes that neither fix bugs nor add features
     - `perf:` - Performance improvements
     - `test:` - Adding or modifying tests
     - `chore:` - Build process or tool changes
   - **Keep under 50 characters (recommended)**
   - **Match the style of recent commits** (language, expression, etc.)
   - **NO emojis**
   - **NO "Generated with Claude Code" or "Co-Authored-By" footers**
   - Keep it concise and clear

4. **Execute commit**:
   - Commit with the generated message
   - Use `git commit -m "message"`

5. **Display result**:
   - Confirm commit success
   - Show commit hash and message

## Important Guidelines

- **DO NOT** ask for user confirmation - execute the commit automatically
- **DO NOT** include emojis in commit messages
- **DO NOT** add "Generated with Claude Code" or similar footers
- **DO NOT** use git commit --amend
- **DO** follow Conventional Commits format strictly
- **DO** keep messages concise (ideally under 50 characters)
- **DO** analyze the actual changes to determine the correct type (feat, fix, etc.)
- **DO** match the style of recent commits in the repository

## Error Handling

- If no staged changes exist, display: "Error: No staged changes found. Please stage files with git add."
- If commit fails, display the error message and suggest next steps

## Example Messages

Based on changes:
- New feature: `feat: add user authentication`
- Bug fix: `fix: resolve null pointer in login`
- Documentation: `docs: update API documentation`
- Refactoring: `refactor: simplify error handling`
- Tests: `test: add unit tests for auth module`

## Context Variables

Use the following context to understand the current state:
- Current git status: !`git status`
- Staged changes: !`git diff --staged`
- Recent commits (for style): !`git log --oneline -5`

---
description: Analyze staged changes and auto-generate a Conventional Commits format message, then commit
argument-hint: "[optional hint for the commit message]"
model: haiku
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git commit:*)
---

# Git Commit with Auto-Generated Message

Analyze staged changes, auto-generate a commit message in Conventional Commits format, and execute the commit without asking for confirmation.

## Context

- Current git status: !`git status --short`
- Staged change summary: !`git diff --staged --stat`
- Staged change size: !`git diff --staged --shortstat`
- Recent commits (for language and tone): !`git log --oneline --no-merges -10`
- User hint: $ARGUMENTS

The context above is already collected. Do NOT run these commands again.

## Workflow

1. **Check staged changes**
   - If "Staged change summary" is empty, display "Error: No staged changes found. Please stage files with git add." and stop.
   - Never stage, unstage, or modify files yourself.

2. **Check for sensitive files**
   - If any staged path looks like a secret (`.env`, `.env.*`, `*.pem`, `*.key`, `id_rsa*`, `credentials*`, `*.p12`, etc.), do NOT commit. List the files and tell the user to unstage them with `git restore --staged <file>`, then stop.

3. **Read the diff**
   - If the total change is about 500 lines or less, run `git diff --staged`.
   - If it is larger, do not read the whole diff. Use the summary above to pick the files that matter, and read them one by one with `git diff --staged -- <path>`. Skip lock files and generated files (e.g. `package-lock.json`, `*.lock`, `dist/`, `*.min.js`); judge them from the summary only.
   - Summarize the changes for yourself before writing the message.

4. **Generate the commit message** (see Message Rules)
   - If a user hint is given, treat it as the primary source of intent.

5. **Commit**
   - Always pass the message through a quoted heredoc so that quotes, `$`, and backticks are not interpreted:

     ```bash
     git commit -F - <<'EOF'
     feat(auth): add token refresh

     Optional body explaining why.
     EOF
     ```

6. **Display the result**
   - Show the commit hash and message, plus a one-line summary of what was committed.

## Message Rules

Precedence: the Conventional Commits format is mandatory. Recent commits are referenced only for language (English/Japanese) and tone, never to drop the type prefix.

- **Header format**: `<type>(<optional scope>)<optional !>: <description>`
- **Types**:
  - `feat` - New feature
  - `fix` - Bug fix
  - `docs` - Documentation only
  - `style` - Formatting, whitespace (no code meaning change)
  - `refactor` - Code change that neither fixes a bug nor adds a feature
  - `perf` - Performance improvement
  - `test` - Adding or modifying tests
  - `build` - Build system or external dependencies
  - `ci` - CI configuration and scripts
  - `chore` - Other maintenance tasks
  - `revert` - Reverts a previous commit
- **Scope**: Add when the change is confined to one clear module, package, or plugin (e.g. `feat(magi): ...`). Omit when unclear.
- **Breaking changes**: Add `!` after the type/scope and a `BREAKING CHANGE: <details>` footer.
- **Header length**: about 50 characters for English, about 30 full-width characters for Japanese. Exceed only when needed for clarity.
- **Body**: Optional. Add a short body (wrapped at 72 columns) only when the header alone cannot explain why the change was made, or when several distinct changes are included.
- **Language**: Same as recent commits. If they are mixed or absent, use English.

## Important Guidelines

- **DO NOT** ask for user confirmation
- **DO NOT** include emojis
- **DO NOT** add "Generated with Claude Code", "Co-Authored-By", or similar footers
- **DO NOT** use `git commit --amend`
- **DO NOT** use `--no-verify` or otherwise bypass git hooks
- **DO NOT** run `git add`, `git reset`, `git push`, or any other state-changing command besides `git commit`

## Error Handling

- **Pre-commit hook failure**: Show the hook output, explain the likely cause, and stop. Do not retry with hooks disabled. The user should fix the issue, re-stage, and run the command again.
- **Other commit failures**: Show the error message and suggest next steps (e.g. missing `user.name` / `user.email`).

## Example Messages

- `feat: add user authentication`
- `fix(login): resolve null pointer on empty password`
- `docs: update API documentation`
- `refactor!: drop support for legacy config format`
- `build: bump typescript to 5.6`
- `fix: ログイン時のタイムアウトを修正`

---
description: Create a release with automatic CHANGELOG generation, tagging, and push
model: haiku
allowed-tools: ["Bash", "AskUserQuestion"]
---

# Create Release

Automate the release process: collect changes since last tag, generate CHANGELOG entry, create new tag, and push.

## Prerequisites

- All changes must be committed (no uncommitted changes)
- Working in a Git repository
- Git remote configured for push

## Workflow

### 1. Verify Clean Working Directory

Check for uncommitted changes:
```bash
git status --porcelain
```

If output is not empty:
- Display error: "Error: Uncommitted changes detected. Please commit or stash changes before release."
- Exit immediately

### 2. Check gh CLI Availability

Check if GitHub CLI is available:
```bash
gh --version 2>/dev/null && echo "available" || echo "unavailable"
```

Store the result for later use:
- If available: Offer GitHub Release creation option
- If unavailable: Proceed with Git tag only (traditional workflow)

### 3. Get Previous Tag and Determine New Version

Get the latest tag:
```bash
git describe --tags --abbrev=0 2>/dev/null || echo "none"
```

If no previous tag exists:
- This is the first release
- Default suggested version: `v0.1.0`
- Commit range: all commits from repository start

If previous tag exists (e.g., `v1.0.0`):
- Parse version and increment patch version: `v1.0.0` → `v1.0.1`
- Suggested version: incremented patch version
- Commit range: from previous tag to HEAD

### 4. Collect Commits and Filter Article-Related Changes

Get commit list with changed files:
```bash
# If previous tag exists:
git log <previous-tag>..HEAD --pretty=format:"%H|%s" --name-only

# If no previous tag (first release):
git log --pretty=format:"%H|%s" --name-only
```

For each commit:
1. Get the list of changed files for that commit
2. Check if ALL changed files are under `posts/` or `articles/` directories
3. If yes → **Exclude this commit** from CHANGELOG
4. If no (has changes outside these directories) → **Include this commit**

Example filtering logic:
- Commit changes only `posts/new-article.md` → Exclude
- Commit changes `posts/article.md` + `src/utils.ts` → Include
- Commit changes only `src/auth.ts` → Include

### 5. Generate CHANGELOG Entry

Group commits by Conventional Commit type:

**Categories:**
- `feat:` → **Added** section
- `fix:` → **Fixed** section
- `docs:` → **Changed** section (if not article-related)
- `refactor:` → **Changed** section
- `perf:` → **Changed** section
- `test:` → **Changed** section (mention in notes)
- `chore:` → Generally omit from CHANGELOG unless significant
- Others → **Changed** section

Format (Keep a Changelog style):
```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- Description from feat: commits

### Fixed
- Description from fix: commits

### Changed
- Description from other commits
```

**Important:**
- Use commit message subject (after the type prefix)
- Remove emoji if present
- Keep descriptions concise
- If a section has no items, omit that section
- Date format: ISO 8601 (YYYY-MM-DD)

### 6. Ask User for Version Confirmation

Use AskUserQuestion to confirm version:
- Show suggested version as default
- Allow user to submit as-is or provide custom version
- Validate format: must start with `v` and follow semver (e.g., `v1.2.3`)

### 7. Update CHANGELOG.md

Check if CHANGELOG.md exists:
```bash
test -f CHANGELOG.md && echo "exists" || echo "none"
```

**If CHANGELOG.md does NOT exist:**
Create new file with template:
```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [X.Y.Z] - YYYY-MM-DD
[generated entry here]
```

**If CHANGELOG.md EXISTS:**
1. Read existing content
2. Find the line `## [Unreleased]`
3. Insert new version entry right after that line
4. Preserve all existing content

Example:
```markdown
# Changelog
...
## [Unreleased]

## [1.0.1] - 2024-12-15    <-- NEW ENTRY INSERTED HERE

### Added
- New feature

## [1.0.0] - 2024-12-01    <-- EXISTING CONTENT PRESERVED
...
```

### 8. Commit CHANGELOG.md

Stage and commit the updated CHANGELOG:
```bash
git add CHANGELOG.md
git commit -m "chore: update CHANGELOG for vX.Y.Z"
```

### 9. Create Git Tag

Create annotated tag with version:
```bash
git tag -a vX.Y.Z -m "Release vX.Y.Z"
```

### 10. Push Changes and Tag

Push both the commit and the tag:
```bash
git push && git push origin vX.Y.Z
```

Use `&&` to ensure both push operations succeed sequentially.

### 11. Create GitHub Release (Optional)

**Only if `gh` CLI is available (from step 2):**

Ask user if they want to create a GitHub Release:
- Use AskUserQuestion with options:
  - "Yes" - Create GitHub Release
  - "No" - Skip (Git tag only)

**If user chooses "Yes":**

Create GitHub Release with the CHANGELOG entry:
```bash
gh release create vX.Y.Z \
  --title "Release vX.Y.Z" \
  --notes "$(cat <<'EOF'
[Insert the generated CHANGELOG entry here without the version header]
EOF
)"
```

**Important:**
- Use the CHANGELOG content generated in step 5
- Omit the version header line (`## [X.Y.Z] - YYYY-MM-DD`) from the release notes
- Include only the categorized changes (Added, Fixed, Changed sections)
- The release will be automatically published on GitHub

**Verification:**
```bash
gh release view vX.Y.Z
```

### 12. Display Success Message

Show summary:
```
✓ Release vX.Y.Z created successfully

Changes included:
- X commits
- Y features added
- Z bugs fixed

Completed steps:
- CHANGELOG.md updated and committed
- Tag vX.Y.Z created
- Changes pushed to remote
- [If created] GitHub Release published
```

**If GitHub Release was created:**
Display the release URL:
```
GitHub Release: https://github.com/owner/repo/releases/tag/vX.Y.Z
```

## Error Handling

**Uncommitted changes detected:**
- Message: "Error: Uncommitted changes detected. Please commit or stash changes before release."
- Exit without making any changes

**No commits since last tag:**
- Message: "Warning: No new commits since last tag. Nothing to release."
- Ask user if they want to continue anyway

**Version tag already exists:**
- Message: "Error: Tag vX.Y.Z already exists. Please choose a different version."
- Re-prompt for version selection

**Push fails:**
- Message: "Error: Failed to push changes. Please check your remote configuration and try: git push && git push origin vX.Y.Z"
- Tag and commit are created locally but not pushed

**GitHub Release creation fails:**
- Message: "Warning: Failed to create GitHub Release. The tag vX.Y.Z was created successfully. You can create the release manually with: gh release create vX.Y.Z"
- Git tag and CHANGELOG are updated successfully
- User can create the release manually later
- Common causes:
  - Not authenticated with GitHub (`gh auth login`)
  - No permission to create releases
  - Network issues

## Important Guidelines

- **DO** verify working directory is clean before starting
- **DO** check gh CLI availability and offer GitHub Release option when available
- **DO** filter out article-only commits (posts/, articles/ directories)
- **DO** preserve existing CHANGELOG.md content
- **DO** use Keep a Changelog format
- **DO** create annotated tags (not lightweight tags)
- **DO** push both commit and tag together
- **DO** make GitHub Release creation optional (gracefully handle when gh unavailable or user declines)
- **DO NOT** proceed if uncommitted changes exist
- **DO NOT** include emojis in CHANGELOG entries
- **DO NOT** add "Generated with Claude Code" or "Co-Authored-By" footers to commits
- **DO NOT** modify commit history
- **DO NOT** require gh CLI (must work without it)

## Example Output

**For a release from v1.0.0 to v1.0.1:**

```markdown
## [1.0.1] - 2024-12-15

### Added
- user authentication with OAuth2
- dark mode toggle in settings

### Fixed
- null pointer exception in login flow
- memory leak in WebSocket connection

### Changed
- improve error messages for API failures
```

## Notes

- Article-related commits (only touching posts/ or articles/) are automatically excluded
- Conventional Commit types are mapped to Keep a Changelog categories
- Version numbers follow Semantic Versioning (semver)
- CHANGELOG follows Keep a Changelog format
- Process is atomic: if any step fails, previous steps may need manual cleanup
- GitHub Release creation is optional and requires gh CLI
- The workflow gracefully degrades to Git tag only when gh is unavailable
- GitHub Release uses the same CHANGELOG content (without version header)
- Authentication with GitHub is required for release creation (`gh auth login`)

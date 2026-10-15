---
description: Prepare a release with a Keep a Changelog 2.0.0 entry, version bump, release PR, tag, and optional GitHub Release
argument-hint: "[version] [--direct | --tag-only]"
model: sonnet
allowed-tools: Read, Edit, Write, AskUserQuestion, Bash(git status:*), Bash(git branch:*), Bash(git symbolic-ref:*), Bash(git describe:*), Bash(git remote:*), Bash(git fetch:*), Bash(git rev-list:*), Bash(git log:*), Bash(git diff:*), Bash(git tag:*), Bash(git ls-files:*), Bash(git switch:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*), Bash(gh auth status:*), Bash(gh pr create:*), Bash(gh release create:*), Bash(gh release view:*)
---

# Create Release

Prepare and publish a release: draft a CHANGELOG entry following [Keep a Changelog 2.0.0](https://keepachangelog.com/en/2.0.0/), bump version files, and either open a release PR or tag and push.

## Context

- Working tree status: !`git status --porcelain`
- Current branch: !`git branch --show-current`
- Default branch (remote HEAD): !`git symbolic-ref --short refs/remotes/origin/HEAD`
- Previous tag: !`git describe --tags --abbrev=0`
- Remote URL: !`git remote get-url origin`
- Arguments: $ARGUMENTS

The context above is already collected. Do NOT run these commands again. A "fatal" message for the previous tag means there is no tag yet.

## Modes

Choose the mode from the arguments:

| Mode | Argument | What it does |
| --- | --- | --- |
| Release PR (default) | none | Commit CHANGELOG and version bumps on `release/<tag>`, push, open a PR, and stop. No tag is created. |
| Direct | `--direct` | Commit on the current branch, tag, and push. Use only for repositories that allow direct pushes. |
| Tag only | `--tag-only` | After the release PR is merged, tag the merged commit and push the tag. |

A version given in the arguments (e.g. `1.4.0` or `v1.4.0`) is used as the suggested version.

The default is the release PR mode because many repositories forbid direct pushes to the default branch by policy even when GitHub branch protection is not enabled.

## Shared Checks (all modes)

1. **Clean working tree**: If the working tree status is not empty, display "Error: Uncommitted changes detected. Please commit or stash changes before release." and stop.
2. **Default branch**: Strip `origin/` from the default branch. If it could not be determined, assume `main` if it exists, otherwise `master`. If the current branch is not the default branch, display "Error: Run /release on <default branch>." and stop.
3. **Up to date**: Run `git fetch origin --tags`, then `git rev-list --count HEAD..@{u}`. If the count is not 0, tell the user to pull first and stop.
4. **Tag format**: If a previous tag exists, reuse its prefix (`v` or none). Otherwise use `v`. CHANGELOG headings never include the prefix (`## [1.4.0]`), tags do (`v1.4.0`).
5. **Repository URL**: Convert the remote URL to `https://<host>/<owner>/<repo>` (handle `git@host:owner/repo.git`, `ssh://git@host/owner/repo.git`, and `https://...`). Used for CHANGELOG link references.
6. **GitHub CLI**: If the host is `github.com`, run `gh auth status`. GitHub features (PR, Release) are available only when it succeeds. If not, fall back to plain git and print the manual steps instead.

## Release PR Mode / Direct Mode

### 1. Collect changes

```bash
# With a previous tag
git log <previous-tag>..HEAD --no-merges --pretty=format:"%h %s%n%b" --name-only
# First release
git log --no-merges --pretty=format:"%h %s%n%b" --name-only
```

If there are no commits since the previous tag, display "Warning: No new commits since <previous-tag>. Nothing to release." and ask whether to continue.

Also read the current `[Unreleased]` section of CHANGELOG.md, if any. Entries already written there are human-curated and take priority over anything drafted from commits.

### 2. Suggest the next version

Based on Conventional Commits since the previous tag:

| Commits contain | 1.0.0 or later | 0.x |
| --- | --- | --- |
| `!` or `BREAKING CHANGE:` | major | minor |
| `feat` | minor | minor |
| anything else | patch | patch |

First release with no tag: suggest `0.1.0`. A version from the arguments overrides the suggestion.

### 3. Find version files

List candidates:

```bash
git ls-files '*package.json' '*pyproject.toml' '*Cargo.toml' '*plugin.json' '*marketplace.json'
```

Exclude files under `node_modules/`, `vendor/`, and test fixtures. Read each candidate's current version. For each, check with `git diff <previous-tag>..HEAD -- <file>` whether the version was already changed since the previous tag.

In a monorepo the repository version and component versions are independent. Do not assume every file gets the release version. In step 5, show each candidate with its current version and whether it was already bumped, and let the user choose which files to update and to what version.

### 4. Draft the CHANGELOG entry (Keep a Changelog 2.0.0)

Machines draft, humans curate. Produce a draft for the user to approve, not a commit log.

**Structure**

```markdown
## [X.Y.Z] - YYYY-MM-DD

Optional one or two sentence summary for notable releases.

### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security
```

- Use only these six types, in this order. Omit empty sections.
- Date in `YYYY-MM-DD` (today).

**Mapping from commits**

- `feat` -> Added (or Changed when it modifies existing behavior)
- `fix` -> Fixed, or Security when it fixes a vulnerability
- `perf`, `refactor` -> Changed only when users notice the effect; otherwise omit
- `revert` -> describe the user-visible result under the fitting type, or omit if the reverted change was never released
- Deprecations -> Deprecated; removals of features, options, or support -> Removed
- `docs`, `test`, `style`, `ci`, `build`, `chore` -> omit unless users are affected (e.g. a dropped runtime version)
- Dependency updates are not a type: describe the effect under the fitting type if it matters to users, otherwise omit

**Writing rules**

- Write for the people who use the software, in plain and concise language
- Summarize across commits from the reader's point of view; one entry may cover several commits
- Breaking changes: prefix the entry with `**Breaking:**` inside its type (usually Changed or Removed) and state what breaks. Do not create a separate section
- Security entries lead with the CVE identifier when one exists: `- CVE-2026-12345: ...`
- No commit hashes, no bare `(#123)` references, no emojis, no author handles
- If a component directory with its own CHANGELOG.md was changed, keep the root entry as a summary and remind the user to check the component changelog

### 5. Confirm with the user

Show in one message:

- Version and tag
- The full draft entry
- Version file changes proposed
- What will happen next (release PR or direct push)

Then use AskUserQuestion:

- **Approve** - proceed
- **Revise** - the user describes changes; apply them and confirm again
- **Cancel** - stop without changing anything

Also confirm the version files to update (multiSelect) in the same AskUserQuestion call. If the tag already exists (`git tag -l <tag>`), say so and ask for another version.

### 6. Update files

**CHANGELOG.md does not exist:** create it.

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/2.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [X.Y.Z] - YYYY-MM-DD

...

[Unreleased]: <repo-url>/compare/<tag>...HEAD
[X.Y.Z]: <repo-url>/releases/tag/<tag>
```

**CHANGELOG.md exists:** edit it with Read and Edit.

1. Replace the contents of `## [Unreleased]` with the approved entry under the new version heading, and leave a fresh, empty `## [Unreleased]` above it.
2. Keep every older version, including `[YANKED]` markers, unchanged.
3. Link references at the bottom of the file:
   - `[Unreleased]: <repo-url>/compare/<new-tag>...HEAD`
   - `[X.Y.Z]: <repo-url>/compare/<previous-tag>...<new-tag>` (first release: `<repo-url>/releases/tag/<new-tag>`)
   - If older versions lack link references, add them for versions whose tags exist.
   - Skip link references only when the repository URL is unknown.

Update the approved version files with Edit. Change only the version field.

### 7a. Release PR mode

```bash
git switch -c release/<tag>
git add CHANGELOG.md <version files>
git commit -m "chore(release): <tag>"
git push -u origin release/<tag>
```

If GitHub CLI is available, open the PR with the approved entry (without its version heading) as the body:

```bash
gh pr create --base <default branch> --title "chore(release): <tag>" --body-file - <<'EOF'
<entry>
EOF
```

Otherwise print the compare URL `<repo-url>/compare/<default branch>...release/<tag>?expand=1`.

Then stop and tell the user: "After the PR is merged, switch to <default branch>, pull, and run /release --tag-only."

### 7b. Direct mode

```bash
git add CHANGELOG.md <version files>
git commit -m "chore(release): <tag>"
git tag -a <tag> -m "Release <tag>"
git push --atomic origin HEAD <tag>
```

`--atomic` pushes the branch and the tag together or not at all. Continue with "GitHub Release" below.

## Tag Only Mode

1. Run the shared checks.
2. Read CHANGELOG.md and take the first released version heading below `[Unreleased]` as the version. Build the tag with the prefix.
3. If `git tag -l <tag>` returns the tag (remote tags are included after the fetch in the shared checks), display "Error: Tag <tag> already exists." and stop.
4. Confirm the version and the commit to tag (`git log -1 --oneline`) with AskUserQuestion.
5. Create and push the tag:

   ```bash
   git tag -a <tag> -m "Release <tag>"
   git push origin <tag>
   ```

6. Continue with "GitHub Release" below.

## GitHub Release (Direct and Tag Only modes)

Only when GitHub CLI is available. Ask with AskUserQuestion whether to create a GitHub Release (Yes / No).

```bash
gh release create <tag> --verify-tag --title "<tag>" --notes-file - <<'EOF'
<entry without the version heading>
EOF
```

Then show the URL from `gh release view <tag> --json url --jq .url`.

## Result

Show a plain-text summary (no emojis or symbols):

```
Release <tag> prepared            (release PR mode)
Release <tag> published           (direct / tag only mode)

- CHANGELOG.md: updated
- Version files: <list or "none">
- Commit: <hash> chore(release): <tag>
- PR: <url>                       (release PR mode)
- Tag: <tag> pushed               (direct / tag only mode)
- GitHub Release: <url or "skipped">
Next step: <what the user should do next, if anything>
```

## Error Handling

- **Push rejected in direct mode** (e.g. protected branch): the commit and tag exist only locally. Explain this, and suggest deleting the local tag with `git tag -d <tag>` and rerunning without `--direct`. Do not reset or rewrite history.
- **Push fails for other reasons**: show the error and the exact command to retry.
- **PR creation fails**: the branch is already pushed; show the compare URL so the user can open the PR manually.
- **GitHub Release creation fails**: the tag is already pushed; show `gh release create <tag>` for a manual retry and mention common causes (`gh auth login`, permissions, network).

Each step changes state that later steps depend on. If a step fails, stop and report exactly which steps completed.

## Important Guidelines

- **DO** confirm the draft entry, version, and version files before any commit, tag, or push
- **DO** move the `[Unreleased]` contents into the new version and leave an empty `[Unreleased]`
- **DO** create annotated tags
- **DO** work without GitHub CLI (plain git fallback)
- **DO NOT** push to the default branch unless `--direct` is given
- **DO NOT** use `--force`, `--no-verify`, `git reset`, `git commit --amend`, or rebase
- **DO NOT** include emojis anywhere
- **DO NOT** add "Generated with Claude Code", "Co-Authored-By", or similar footers to commits, PRs, or releases

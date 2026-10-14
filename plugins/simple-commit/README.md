# simple-commit

A Claude Code plugin with two commands:

- `/commit` - analyzes staged changes, generates a Conventional Commits message, and commits them in one step
- `/release` - drafts a [Keep a Changelog 2.0.0](https://keepachangelog.com/en/2.0.0/) entry, bumps version files, and opens a release PR or tags and pushes

## Features (/commit)

- Analyzes staged changes and generates a Conventional Commits message (`feat:`, `fix:`, `feat(scope)!:` and more)
- Summarizes large diffs file by file instead of loading everything at once
- Follows the language and tone of recent commits (merge commits are ignored)
- Accepts an optional hint as an argument
- Refuses to commit files that look like secrets (`.env`, keys, credentials)
- Never bypasses git hooks and never stages, amends, or pushes on its own
- No emojis and no "Generated with Claude Code" footers
- Runs on the fast Haiku model

## Prerequisites

- [Claude Code](https://claude.com/claude-code)
- Git 2.0 or higher
- Must be run within a Git repository

## Installation

Add the marketplace and install the plugin from within Claude Code:

```
/plugin marketplace add yostos/claude-code-plugins
/plugin install simple-commit@yostos-marketplace
```

To try it locally without installing:

```bash
claude --plugin-dir /path/to/claude-code-plugins/plugins/simple-commit
```

## Usage

1. Stage your changes:

   ```bash
   git add src/auth.ts
   ```

2. Run the command:

   ```
   /commit
   ```

   Optionally pass a hint describing the intent:

   ```
   /commit fix login timeout reported in issue 42
   ```

The command then:

1. Reads the staged file list, change size, and recent commit history
2. Stops if nothing is staged or if a secret-like file is staged
3. Reads the diff (per file when the change exceeds about 500 lines, skipping lock and generated files)
4. Generates a Conventional Commits message
5. Commits via `git commit -F -` with a quoted heredoc, so quotes and `$` in the message are safe

## Commit Message Format

```
<type>(<optional scope>)<optional !>: <description>

<optional body>

<optional BREAKING CHANGE footer>
```

| Type       | Use for                                        |
| ---------- | ---------------------------------------------- |
| `feat`     | New feature                                    |
| `fix`      | Bug fix                                        |
| `docs`     | Documentation only                             |
| `style`    | Formatting, whitespace                         |
| `refactor` | Code change that neither fixes nor adds        |
| `perf`     | Performance improvement                        |
| `test`     | Adding or modifying tests                      |
| `build`    | Build system or external dependencies          |
| `ci`       | CI configuration and scripts                   |
| `chore`    | Other maintenance                              |
| `revert`   | Reverting a previous commit                    |

- The type prefix is always required. Recent commits only influence language and tone.
- Header length: about 50 characters in English, about 30 full-width characters in Japanese.
- A body is added only when the header alone cannot explain the change.
- Breaking changes use `!` and a `BREAKING CHANGE:` footer.

### Examples

```
feat: add user authentication
fix(login): resolve null pointer on empty password
refactor!: drop support for legacy config format
build: bump typescript to 5.6
fix: ログイン時のタイムアウトを修正
```

## Release (/release)

`/release` runs on the default branch with a clean, up-to-date working tree. It has three modes:

| Command | What it does |
| --- | --- |
| `/release [version]` | Commits CHANGELOG and version bumps on `release/<tag>`, pushes it, opens a PR, and stops. No tag yet. |
| `/release --tag-only` | After the PR is merged: tags the merged commit with the latest CHANGELOG version and pushes the tag. |
| `/release [version] --direct` | Commits on the default branch, tags, and pushes together with `git push --atomic`. Only for repositories that allow direct pushes. |

The release PR flow is the default because many repositories forbid direct pushes to the default branch by policy, even when GitHub branch protection is not enabled.

### Typical flow

```
/release              # review and approve the draft; a release PR is opened
# merge the PR on GitHub, then locally:
git switch main && git pull
/release --tag-only   # tag, push, and optionally create a GitHub Release
```

### What it does

1. Collects non-merge commits since the previous tag and the current `[Unreleased]` section
2. Suggests the next version from Conventional Commits (breaking -> major, `feat` -> minor, otherwise patch; in 0.x, breaking and `feat` both bump minor)
3. Lists version files (`package.json`, `pyproject.toml`, `Cargo.toml`, `plugin.json`, `marketplace.json`) and lets you choose which to bump. Component versions in a monorepo are not forced to the release version.
4. Drafts the CHANGELOG entry following Keep a Changelog 2.0.0:
   - Six types only: Added, Changed, Deprecated, Removed, Fixed, Security
   - Breaking changes marked with `**Breaking:**` inside their type
   - Written for users; internal commits (`docs`, `test`, `ci`, `chore`, etc.) are left out unless users are affected
   - Hand-written `[Unreleased]` entries take priority over the draft
5. Shows the draft and asks you to approve, revise, or cancel before anything is committed
6. Moves `[Unreleased]` into the new version, leaves a fresh `[Unreleased]`, and updates link references at the bottom of the file
7. Opens the release PR, or tags and pushes, and optionally creates a GitHub Release

GitHub features need an authenticated GitHub CLI (`gh auth login`). Without it, the command falls back to plain git and prints the remaining manual steps.

## Troubleshooting

### Command not found

1. Restart Claude Code
2. Check that the plugin is installed: `/plugin`
3. Check that the marketplace is added: `/plugin marketplace list`

### "Error: No staged changes found"

Stage files with `git add <file>` and run `/commit` again.

### Commit refused because of a sensitive file

Unstage the file with `git restore --staged <file>`, add it to `.gitignore` if appropriate, and run `/commit` again.

### Pre-commit hook failed

The command shows the hook output and stops without retrying. Fix the reported problem, re-stage, and run `/commit` again.

### Commit fails for other reasons

Check your Git identity:

```bash
git config user.name
git config user.email
```

### Message does not match expectations

Pass a hint (`/commit <hint>`), or edit the message afterwards with `git commit --amend`.

### /release push was rejected in --direct mode

The default branch does not accept direct pushes. Delete the local tag with `git tag -d <tag>` and rerun `/release` without `--direct`. The local release commit remains on the default branch; move it to a branch yourself if needed.

## FAQ

**Q: What is Conventional Commits?**
A: A specification for commit messages that uses prefixes such as `feat:` and `fix:` to make the type of change explicit. See https://www.conventionalcommits.org/.

**Q: How does it pick the language?**
A: It looks at the last 10 non-merge commits. If they are mixed or there are none, it uses English.

**Q: What happens with multiple change types?**
A: It picks the most significant change and may describe the rest in the body. For finer control, stage and commit changes separately.

**Q: Does it push?**
A: No. It only creates a local commit.

## Customization

Edit `commands/commit.md` to change the message rules, the model (`model: sonnet`, etc.), or the large-diff threshold. Edit `commands/release.md` to change the version file patterns or the CHANGELOG rules.

## License

MIT License - See LICENSE file for details

## Author

yostos

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- simple-commit plugin v0.2.0: `/commit` command overhaul
  - Conventional Commits prefix is now mandatory; recent commits only set language and tone (merge commits ignored)
  - Restrict allowed tools to `git status`, `git diff`, `git log`, and `git commit`
  - Commit via quoted heredoc so quotes and `$` in messages are safe
  - Read large diffs per file and skip lock and generated files instead of loading the whole diff
  - Refuse to commit secret-like files and never bypass git hooks
  - Add `build`, `ci`, `revert` types, scope, breaking change, and optional body rules
  - Accept an optional hint via command arguments
  - Language-aware header length (about 50 English characters or 30 Japanese characters)
- simple-commit plugin v0.2.0: `/release` command overhaul
  - **Breaking:** on the default branch, `/release` now opens a release PR instead of pushing; tag after merge with `/release --tag-only`, or use `--direct` for the previous behavior
  - CHANGELOG entries follow Keep a Changelog 2.0.0: six types, `**Breaking:**` markers, `[Unreleased]` contents moved into the new version, link references maintained
  - Suggest major, minor, or patch from Conventional Commits instead of always bumping patch
  - Offer to bump version files (`package.json`, `plugin.json`, etc.) chosen by the user
  - Show the draft entry and ask for approval before any commit, tag, or push
  - Push branch and tag atomically in direct mode; check `gh auth status` before using GitHub features
  - Restrict allowed tools and switch the model to Sonnet
- simple-commit plugin: README documents `/release`
- simple-commit plugin: README rewritten in English with marketplace installation steps; plugin.json description translated to English

### Removed
- simple-commit plugin: `/release` no longer excludes commits that only touch `posts/` or `articles/`
- jrnl-tools plugin removed from marketplace listing (deprecated, no longer developed). Auto Memory now covers the cross-session recall use case it was built for. Plugin files remain in the repository for existing installs; see `plugins/jrnl-plugin/docs/architecture-decisions.md` ADR-012.

## [0.6.0] - 2026-02-13

### Added
- MAGI plugin v2.0.0: deliberation phase (Super MAGI) with structured debate and revoting when votes split 2-1
- MAGI plugin: CHANGELOG.md and specification documents in `docs/`

### Changed
- MAGI plugin: all documentation consolidated in English with FR/NFR requirements format
- Root README updated with MAGI deliberation phase and Agent Teams prerequisites

## [0.5.0] - 2026-02-13

### Added
- jrnl-plugin for intelligent journaling with jrnl CLI integration
  - Session handoff and context restore commands
  - Cross-project status overview
  - Work log recording
  - Natural language journal interaction via skill
- Auto Memory vs jrnl Handoff comparative analysis document

### Changed
- Rewrite top-level README for clarity and conciseness

## [0.4.0] - 2026-01-02

### Added
- pdf-processor plugin for PDF merging and OCR processing with table of contents generation

## [0.3.0] - 2025-12-31

### Changed
- enhance release command documentation with GitHub CLI workflow
- add simple-commit plugin to README with installation and usage examples

## [0.2.0] - 2025-12-15

### Changed
- add Co-Authored-By guideline to release command
- add development guidelines and plugin metadata

## [0.1.0] - 2025-12-15

### Added
- /release command for automated release workflow
- simple-commit plugin with automated changelog generation and tagging

### Fixed
- restore commands directory structure

### Changed
- Add Evangelion MAGI system inspiration to README

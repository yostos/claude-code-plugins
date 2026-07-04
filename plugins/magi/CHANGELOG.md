# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.1] - 2026-07-05

### Fixed

- Phase 2 and Phase 3 agent launches now use each agent's registered `subagent_type` (`magi:melchior`, `magi:balthasar`, `magi:casper`) instead of manually reading `agents/*.md` into the prompt or falling back to `subagent_type: general-purpose`. This ensures each agent's frontmatter (including its `model` setting) is actually applied when launched
- Updated `Claude.md` and `docs/` specification files to match the corrected invocation mechanism

## [2.0.0] - 2026-02-13

### Added

- **Deliberation phase (Super MAGI)**: When initial votes split 2-1, the system can now enter a structured deliberation phase where majority and minority agents debate before revoting
- **Phase 2.5 - Vote Analysis**: Automatic detection of split votes with user prompt to enter deliberation
- **Phase 3 - Deliberation**: 4-round structured debate protocol using Agent Teams
  - Round 1: Majority agents present arguments to minority
  - Round 2: Minority agent sends counterarguments
  - Round 3: Majority agents respond
  - Round 4: Minority agent sends final rebuttal (guaranteed last word)
- **Vote tracking**: When deliberation occurs, the final output shows vote changes with reasoning
- **Graceful fallback**: If deliberation encounters errors, the system falls back to Phase 2 votes
- Concept and requirements documentation in `docs/` directory
- Base MAGI specification (`docs/magi-specification.md`)
- CHANGELOG.md

### Changed

- Phase 3 (Final Arbitration) renamed to Phase 4 to accommodate new deliberation phase
- Final output format enhanced to include deliberation summary and vote transition tracking
- ARBITRATOR role expanded to include deliberation orchestration
- All documentation consolidated in English with FR/NFR requirements format
- `SPECIFICATION.md` replaced by `docs/magi-specification.md`
- `docs/super-magi-concept.md` translated to English
- All docs linked via Related Documents sections

## [1.0.0] - 2024-12-11

### Added

- Initial release of MAGI plugin
- Three specialized agents: MELCHIOR (scientific), BALTHASAR (legal/ethical), CASPER (emotional/trends)
- ARBITRATOR agent for problem structuring and final arbitration
- Parallel agent execution with real-time progress monitoring
- Binary choice decision support with majority voting
- Web search integration for evidence-based analysis
- Session state management with interruption/resumption support
- `/magi` slash command (interactive and direct modes)
- `/magi-help` slash command for system information

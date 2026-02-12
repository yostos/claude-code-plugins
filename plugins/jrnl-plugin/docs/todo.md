# jrnl-tools Plugin Development Tasks

## Current Status

**Phase 8 Complete** - Documentation done, entering long-term testing.

**Current Phase**: Long-term testing (started 2026-02-03)

---

## Completed

- [x] Discovery - plugin purpose and requirements
- [x] Create concept.md - vision, philosophy, tag system
- [x] Create requirements.md - functional/non-functional requirements
- [x] Create use-cases.md - 30 use cases defined
- [x] Create architecture-decisions.md - ADRs
- [x] Create roadmap.md - future versions planned

---

## Phase 2: Component Planning

- [x] Load plugin-structure skill
- [x] Determine required components (skills, commands, agents, hooks)
- [x] Create component plan table
- [x] Get user approval on component plan

### Component Analysis (2026-02-03)

Based on use-cases.md analysis:

#### Skill (1)

| Name | Purpose | Trigger Examples |
|------|---------|------------------|
| jrnl | Core jrnl knowledge and operations | "add to journal", "save to journal", "show journal", "search journal", "summarize conversation", "create handoff" |

**Rationale**: A single skill provides Claude with comprehensive knowledge about jrnl CLI, tag system, and Claude-assisted journaling. This allows natural language interaction for all 30 use cases.

#### Commands (4)

| Command | Purpose | Use Cases |
|---------|---------|-----------|
| `/jrnl-handoff` | Quick handoff creation | UC-22, UC-23 |
| `/jrnl-restore` | Restore previous context | UC-24 |
| `/jrnl-status` | Cross-project overview | UC-27, UC-29 |
| `/jrnl-log` | Record work log | UC-25 |

**Rationale**: Commands provide quick shortcuts for the most common Claude-assisted journaling operations. Users don't need to explain intent - just invoke the command.

#### Agents (0)

Not needed for v1.0. Skill + Commands cover all use cases. Consider for v1.2 (nb integration) if needed.

#### Hooks (0)

Not needed for v1.0. Consider for future:
- Stop hook: Auto-suggest handoff on session end
- SessionStart hook: Auto-load recent context

#### Documentation (3)

| File | Purpose |
|------|---------|
| `README.md` | Installation, usage, command reference |
| `CHANGELOG.md` | Version history |
| `LICENSE` | MIT License |

### Component Decision Summary

```
jrnl-plugin/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest
├── skills/
│   └── jrnl/
│       └── SKILL.md        # Core jrnl skill
├── commands/
│   ├── jrnl-handoff.md     # Quick handoff
│   ├── jrnl-restore.md     # Restore context
│   ├── jrnl-status.md      # Cross-project status
│   └── jrnl-log.md         # Record work log
├── docs/                   # Design documents (existing)
├── README.md               # User documentation
├── CHANGELOG.md            # Version history
└── LICENSE                 # MIT License
```

## Phase 3: Detailed Design

- [x] Define jrnl skill structure and content
- [x] Design command interfaces (frontmatter, arguments)
- [x] Document project tag configuration approach

### Skill Design: jrnl

**Location**: `skills/jrnl/SKILL.md`

**Frontmatter**:
```yaml
---
name: jrnl
description: This skill should be used when the user asks to "add to journal", "save to journal", "journal this", "record in journal", "show journal", "search journal", "what's in my journal", "create handoff", "save context", "restore context", "what was I working on", "summarize conversation to journal", "record what we did", or mentions jrnl-related operations. Provides comprehensive knowledge about jrnl CLI integration and Claude-assisted journaling.
version: 1.0.0
---
```

**SKILL.md Body Structure** (~1,500 words):
1. Overview - Purpose and philosophy
2. Tag System - @project, @log, @handoff, @idea
3. Project Configuration - How to configure project name
4. Core Operations - Create, search, export
5. Claude-Assisted Features - Summarization, handoff, context
6. jrnl CLI Quick Reference - Common commands
7. Error Handling - Missing jrnl, empty results

**References** (if needed):
- `references/jrnl-cli-reference.md` - Full CLI documentation

### Command Design

#### /jrnl-handoff

```yaml
---
description: Create handoff notes for next session
allowed-tools: Bash(jrnl:*)
---
```

**Body**:
```
Summarize the current conversation and create a handoff entry.

1. Identify the project tag from current directory or ask if not configured
2. Summarize: progress made, decisions, and pending items
3. Identify concrete next steps
4. Execute: jrnl "Handoff: [summary]. Next: [steps] @project @handoff"
5. Confirm entry created
```

#### /jrnl-restore

```yaml
---
description: Restore context from previous session
allowed-tools: Bash(jrnl:*)
---
```

**Body**:
```
Retrieve and present the latest handoff for this project.

1. Determine project tag from current directory or ask
2. Execute: jrnl @project @handoff -n 1 --format json
3. Parse the handoff content
4. Present: previous context, progress, and suggested next steps
5. Offer to continue from where left off
```

#### /jrnl-status

```yaml
---
description: Show cross-project overview from journal
argument-hint: [days]
allowed-tools: Bash(jrnl:*)
---
```

**Body**:
```
Show status of projects from journal handoffs.

1. Determine period: $1 days (default: 7)
2. Execute: jrnl @handoff -from "X days ago" --format json
3. Extract project tags (exclude @log, @handoff, @idea)
4. Group entries by project tag
5. For each project, show: latest handoff date, summary, pending items
```

**Scope**: Only entries with @handoff tag within the specified period.
Does not include manually-created journal entries without @handoff.

#### /jrnl-log

```yaml
---
description: Record work log for current session
allowed-tools: Bash(jrnl:*)
---
```

**Body**:
```
Record a log of work completed in this session.

1. Identify the project tag from current directory or ask if not configured
2. Summarize work completed: tasks done, files changed, outcomes
3. Execute: jrnl "Log: [work summary] @project @log"
4. Confirm entry created
```

### Project Tag Configuration

**Approach**: Use existing `.claude/settings.local.json` or project CLAUDE.md

**Option A - settings.local.json**:
```json
{
  "jrnl": {
    "projectTag": "myproject"
  }
}
```

**Option B - CLAUDE.md convention** (adopted, updated in v1.0.1):
```markdown
**jrnl Project Tag:** myproject
```

**Fallback**: Ask user on first use, suggest storing in CLAUDE.md

**Decision**: Use Option B (CLAUDE.md explicit text) for v1.0
- Visible and readable in CLAUDE.md
- No HTML comment parsing needed
- Clear to both human and AI

## Phase 4: Plugin Structure Creation

- [x] Create directory structure (skills/, commands/, .claude-plugin/)
- [x] Create `.claude-plugin/plugin.json` manifest
- [x] Create `LICENSE` file

## Phase 5: Component Implementation

### Skill
- [x] Load skill-development skill
- [x] Create `skills/jrnl/SKILL.md`

### Commands
- [x] Load command-development skill
- [x] Create `commands/jrnl-handoff.md`
- [x] Create `commands/jrnl-restore.md`
- [x] Create `commands/jrnl-status.md`
- [x] Create `commands/jrnl-log.md`

## Phase 6: Validation

- [x] Run plugin-validator agent
- [x] Run skill-reviewer agent
- [x] Fix any critical issues (none found)

## Phase 7: Testing

- [x] Test skill triggering (verified CLI commands work)
- [x] Test command execution (verified jrnl CLI syntax)
- [x] Test with actual jrnl installation (v4.2.1 confirmed)
- [x] Verify error handling (jrnl returns proper JSON)

### Test Results (2026-02-03)

- jrnl v4.2.1 installed at /opt/homebrew/bin/jrnl
- Default journal configured
- `--tags`: 170 entries, tags listed correctly
- `--format json`: Valid JSON output
- `-from "7 days ago"`: Date filter works
- `@handoff` search: Found Phase 1 handoff entry

## Phase 8: Documentation

- [x] Create README.md (installation, usage, command reference)
- [x] Create docs/usage-guide.md (scenario-based guide)
- [ ] Create CHANGELOG.md (deferred - separate task)
- [ ] Update repository README.md (deferred - separate task)
- [x] Plugin registered in yostos-marketplace
- [x] Plugin enabled in user settings

## Phase 9: Long-term Testing

**Started**: 2026-02-03

- [ ] Real-world usage across multiple projects
- [ ] Collect feedback and issues
- [x] MAGI document inspection (completed 2026-02-03)
- [ ] Iterate based on findings

## Phase 10: プロモーション記事作成

**目的**: Claude Codeユーザーへの訴求、zenn.dev・ブログで公開

- [ ] 記事作成: `docs/article-claude-code-memory.md`
  - Claude Codeの「忘却」問題（ペインポイント）
  - jrnl-toolsによる解決策
  - 具体的なシナリオ（Before/After）
  - 使い方（簡潔に）
  - 「昨日の自分が今日の自分を助ける」ストーリー
- [ ] zenn.devに投稿
- [ ] ブログに投稿
- [ ] README.mdを記事内容に基づいて改善

### Issues Found (2026-02-12)

Discovered during real-world usage testing:

- [x] `@project` placeholder ambiguity in commands - AI executes literal `@project` instead of substituting actual project tag (fixed: use `<project-tag>` with examples)
- [x] `-and` missing in tag filters - `jrnl @tag1 @tag2` is OR, not AND; `-and` required for correct filtering (fixed: added `-and` to all multi-tag commands)
- [x] CLAUDE.md "read-only" contradiction - stated "never write" but `/jrnl-handoff` and `/jrnl-log` write entries (fixed: changed to "append-only")
- [x] Multi-line handoff format - complex sessions produce overly compressed single-line entries (fixed: heredoc format with structured Progress/Blockers/Next sections)
- [x] Write verification step - no confirmation that entries were saved with correct tags (fixed: added `jrnl -n 1 --format json` read-back verification to handoff and log commands)

### Design Improvements (2026-02-12)

- [x] Project tag notation changed from HTML comment (`<!-- jrnl-project: name -->`) to explicit text (`**jrnl Project Tag:** name`)
- [x] Handoff/restore positioned as "orientation guide / pointer" to project documentation, not complete state dump (ADR-010)
- [x] Optional git context integration for handoff/restore - uses git output as intermediate input, not stored verbatim (ADR-011)

### Verification Points for Continued Testing

The following should be validated through real-world usage:

- [ ] Heredoc multi-line entries work correctly across different shell environments
- [ ] Git steps skip silently in non-git projects
- [ ] `git log --since` during restore effectively detects stale handoffs
- [ ] `Files changed:` section in handoffs is useful for next-session orientation
- [ ] New `**jrnl Project Tag:**` notation is reliably found by AI across projects

### Testing Log

| Date | Activity | Notes |
|------|----------|-------|
| 2026-02-03 | Plugin deployed | Registered in yostos-marketplace, enabled globally |
| 2026-02-03 | MAGI inspection | Document review scheduled |
| 2026-02-12 | Real-world usage review | 5 issues found, all 5 fixed |
| 2026-02-12 | Design improvements | Handoff positioning (ADR-010), git integration (ADR-011), tag notation change |

---

## Key Design Decisions

- **Tag system**: @<project>, @log, @handoff, @idea
- **Auto project tagging**: Claude automatically adds project tag
- **No delete/encryption**: Safety constraints
- **Default journal only**: v1.0 scope
- **Star feature**: Not supported (user can use jrnl directly)

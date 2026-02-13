# Comparative Analysis: Auto Memory vs jrnl Handoff

## Background

Claude Code provides a persistent auto memory directory at `~/.claude/projects/<project>/memory/` that persists across sessions. With the introduction of this feature, it is necessary to reassess the role of jrnl-based handoff.

## When Auto Memory Was Introduced

Auto Memory was introduced in **Claude Code v2.1.32 (released February 5, 2026)**.

Changes in this version:
- Addition of automatic memory recording and recall during sessions
- Support for `memory` frontmatter field for agents (`user`, `project`, `local` scopes)

Due to a gradual rollout, opt-in is available via the environment variable `CLAUDE_CODE_DISABLE_AUTO_MEMORY=0`.

### Evidence

- **CHANGELOG**: [claude-code/CHANGELOG.md (GitHub)](https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md) -- documented in the v2.1.32 section
- **Releases page**: [claude-code/releases (GitHub)](https://github.com/anthropics/claude-code/releases) -- released at 2026-02-05 17:47 UTC
- **Official documentation**: [Manage Claude's memory (Claude Code Docs)](https://code.claude.com/docs/en/memory) -- Auto Memory specification and usage

## Auto Memory Availability

No plan-specific restrictions for Auto Memory are documented in the official documentation. However, since Auto Memory is a Claude Code feature, it is **only available on plans that support Claude Code**.

| Plan | Claude Code | Auto Memory |
|------|:-----------:|:-----------:|
| Free ($0) | Not available | Not available |
| Pro ($20/mo) | Available | Available (*) |
| Max ($100-$200/mo) | Available | Available (*) |
| Team Standard ($25/user) | Not available | Not available |
| Team Premium ($150/user) | Available | Available (*) |
| API credits | Available | Available (*) |

(*) Gradual rollout in progress. Opt-in via environment variable `CLAUDE_CODE_DISABLE_AUTO_MEMORY=0`.

Since jrnl-plugin is also a Claude Code plugin, it is subject to the same plan restrictions. Plan differences are not a differentiating factor between the two.

### Evidence

- **Official documentation**: [Manage Claude's memory (Claude Code Docs)](https://code.claude.com/docs/en/memory) -- no plan restrictions mentioned; gradual rollout documented
- **Plan information**: [Using Claude Code with your Pro or Max plan (Claude Help Center)](https://support.claude.com/en/articles/11145838-using-claude-code-with-your-pro-or-max-plan)
- **Plan comparison**: [Claude AI Plans 2026 Guide](https://www.glbgpt.com/hub/claude-ai-plans-2026/)

## Feature Characteristics

### Auto Memory (`~/.claude/projects/.../memory/`)

- **Nature**: Knowledge base ("what is known")
- `MEMORY.md` is automatically loaded into the system prompt at session start
- Stores stable patterns, conventions, user preferences, and architectural decisions
- Concise and structured (MEMORY.md limited to approximately 200 lines)
- Can create topic-specific files and link them from MEMORY.md
- **Available at session start with no explicit action required**

### jrnl Handoff

- **Nature**: Work record ("what was being done")
- Records work logs, progress, and blockers during sessions
- Captures **transient context** such as "Feature X implementation is in progress; need to investigate Y next"
- Provides cross-project situational awareness
- Chronological work history (what was done when)
- **Requires explicit restore** action

## Functional Overlap

With the introduction of Auto Memory, the need for handoff has decreased for certain use cases.

| Use Case | Auto Memory | jrnl Handoff |
|----------|:-----------:|:------------:|
| Next steps | o | o |
| Current branch information | o | o |
| Architectural decisions | o (recommended) | - |
| User settings and conventions | o (recommended) | - |
| Detailed work history | - | o (recommended) |
| Cross-project overview | - | o (recommended) |
| Chronological work records | - | o (recommended) |
| Team handoff documentation | - | o (recommended) |

## Cases Where jrnl Remains Valuable

1. **Detailed work logs** -- Recording detailed context and trial-and-error that exceeds Auto Memory's capacity
2. **Cross-project overview** -- Viewing status across multiple projects with `/jrnl-status`
3. **Team sharing** -- Handoff documentation for others (or your future self)
4. **Audit and retrospective** -- Chronological record of "what was done last week"

## Recommended Usage

- **Session context persistence** -- Use Auto Memory (automatically loaded, more efficient)
- **Work history recording and retrospective** -- Use jrnl (specialized for chronological records)

## Architecture Change Assessment

Following the introduction of Auto Memory, we assessed whether jrnl-plugin's specification or architecture requires changes.

### Assessment Result: No Changes Required

The current design is maintained for the following reasons.

#### 1. Information classification model provides clear separation

Against the information classification model in concept.md (Flow / Stock / Action), Auto Memory handles **Stock** (stable knowledge) while jrnl handles **Flow** (chronological records). This classification was correctly designed before Auto Memory was introduced.

| | Auto Memory | jrnl-plugin |
|---|---|---|
| Information type | Stock (stable knowledge) | Flow (chronological records) |
| Author | Claude (automatic) | Claude + User (explicit) |
| Storage | Local files (per-project) | jrnl (global, external tool) |
| Scope | Single project | Cross-project |
| Portability | Confined to Claude Code | Independently accessible via jrnl CLI |

#### 2. Auto Memory does not record "what was being done"

Auto Memory stores stable patterns such as "this project uses pnpm" or "run tests with `npm test`". Transient work context like "Feature X implementation is in progress; need to investigate Y next" is outside Auto Memory's scope. The role of handoff/restore remains valid.

#### 3. ADR-010 design decision is effective

ADR-010 (Handoff as Orientation Guide, Not State Dump) positioned handoff as a lightweight "pointer to project files." The "state dump" approach that would overlap with Auto Memory was avoided from the outset. This design decision has naturally achieved separation from Auto Memory.

#### 4. Cross-project functionality cannot be replaced by Auto Memory

The cross-project overview provided by `/jrnl-status` cannot be achieved with Auto Memory. Auto Memory is scoped to individual projects and cannot address the need to "view the status of all projects at a glance."

#### 5. jrnl is accessible outside Claude Code

Information recorded in jrnl can be accessed directly from the terminal with `jrnl @handoff` and similar commands. Auto Memory resides in files under `~/.claude/` and is not designed as a mechanism for systematic access outside Claude Code sessions.

### Assessment Date

2026-02-13

## Conclusion

Since Auto Memory now largely covers day-to-day session context persistence, the relative importance of handoff has decreased. However, jrnl retains its unique value as a "work diary and history," and the two are complementary. Future development of jrnl-plugin should focus on feature enhancements that emphasize differentiation from Auto Memory: chronological records, cross-project overview, and team sharing.

At this time, no changes to the specification or architecture are required. The existing design -- particularly ADR-010's "handoff as pointer" approach -- naturally achieves separation from Auto Memory.

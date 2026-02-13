# jrnl-tools Usage Guide

This guide demonstrates how jrnl-tools enhances your development workflow through concrete scenarios.

## The Problem

Developers face common challenges:

1. **Context Loss**: "What was I doing on this project last week?"
2. **Session Discontinuity**: Picking up where you left off takes time — even when TODO.md and docs exist, the AI doesn't know where to start
3. **Cross-Project Blindness**: Hard to track progress across multiple projects
4. **Knowledge Evaporation**: Decisions and learnings fade from memory

jrnl-tools solves these by providing **orientation guides** (handoffs) that point to the right project files, making session transitions frictionless. Detailed state lives in your project documentation — jrnl provides the breadcrumbs.

---

## Scenario 1: End of Day Handoff

**Situation**: You've been working on an API refactoring project. It's 6 PM and you need to stop, but you're mid-task.

**Without jrnl-tools**:
- You might forget where you were tomorrow
- Context is lost in chat history or your head
- Tomorrow starts with "What was I doing?"

**With jrnl-tools**:

```
> /jrnl-handoff
```

Claude analyzes your session and creates an orientation guide:

```
Handoff: Auth middleware refactoring complete @api-refactor @handoff
Progress:
- Fixed token refresh logic (see auth.ts:45-78)
- Tests passing for login/logout flows
Blockers:
- None
Next:
- Implement rate limiting on /api/users (see TODO.md item 3)
- Update API documentation (see docs/api-spec.md)
```

**Value**: The next session knows exactly where to look — in the code, TODO.md, and docs.

---

## Scenario 2: Starting a New Day

**Situation**: Monday morning. You worked on three different projects last week and can't remember the state of each.

**Without jrnl-tools**:
- Check git logs, tickets, chat history
- Try to remember what was "in progress"
- Waste 30+ minutes reconstructing context

**With jrnl-tools**:

```
> /jrnl-status
```

Output:
```
Projects (last 7 days):

@api-refactor (2026-02-02)
  Status: Authentication middleware complete
  Next: Rate limiting on /api/users

@mobile-app (2026-01-31)
  Status: Push notification integration done
  Next: Fix iOS badge count bug

@docs-site (2026-01-29)
  Status: Migration to new theme blocked
  Next: Waiting for design team assets
```

**Value**: Full situational awareness in seconds.

---

## Scenario 3: Resuming a Specific Project

**Situation**: You switch to the mobile-app project after a week away.

**Without jrnl-tools**:
- "What was the last thing I did here?"
- Check commit history, tickets, notes
- Slowly rebuild mental model

**With jrnl-tools**:

```
> /jrnl-restore
```

Output:
```
Last handoff (2026-01-31):

Progress:
- Push notification integration complete
- Tested on Android, working correctly
- iOS has badge count display issue (see TODO.md #12)

Next steps:
1. Debug iOS badge count in NotificationService.swift
2. Add notification preferences screen (see docs/ui-spec.md)
3. Update user documentation

Let me read the referenced files for details...
[reads TODO.md and relevant docs for current state]

Shall I help continue from here?
```

**Value**: Instant orientation — the handoff points to the right files, and the AI reads them for full context.

---

## Scenario 4: Recording a Discovery

**Situation**: While debugging, you discover an undocumented API behavior that cost you 2 hours.

**Without jrnl-tools**:
- Knowledge stays in your head
- Next time (or a teammate) hits the same issue
- Time wasted again

**With jrnl-tools**:

```
> Add to my journal: The payment API returns 200 even on
  validation errors - check response.status field, not
  HTTP status. Wasted 2 hours on this.
```

Creates:
```
The payment API returns 200 even on validation errors -
check response.status field, not HTTP status.
Wasted 2 hours on this. @api-refactor @log
```

**Value**: Searchable knowledge preserved forever.

Later:
```
> Search my journal for payment API
```

---

## Scenario 5: Capturing an Idea

**Situation**: During code review, you think of a better architecture approach, but it's not the current task.

**Without jrnl-tools**:
- Idea forgotten by next week
- Or you get distracted pursuing it now

**With jrnl-tools**:

```
> Save this idea to my journal: We should consider
  GraphQL subscriptions for real-time updates instead
  of polling. Would reduce server load significantly.
```

Creates:
```
Idea: Consider GraphQL subscriptions for real-time
updates instead of polling. Would reduce server load
significantly. @api-refactor @idea
```

**Value**: Ideas captured without derailing current work.

Review later:
```
> Show me all my ideas
```

---

## Scenario 6: Work Session Summary

**Situation**: End of a productive session. You want to record what was accomplished.

```
> /jrnl-log
```

Claude summarizes:
```
Log: Fixed 3 authentication bugs (issues #45, #47, #48).
Refactored token refresh to use exponential backoff.
Added integration tests for OAuth flow.
Code review requested from @alice. @api-refactor @log
```

**Value**: Automatic work documentation for reviews, standups, or personal tracking.

---

## Scenario 7: Cross-Project Planning

**Situation**: Weekly planning - you need to know what's pending across all projects.

```
> /jrnl-status 14
```

Output shows all projects with handoffs from last 2 weeks:
```
Projects (last 14 days):

@api-refactor (2026-02-02)
  Next: Rate limiting, API docs

@mobile-app (2026-01-31)
  Next: iOS badge bug, notification preferences

@docs-site (2026-01-29)
  Next: Blocked - waiting for design assets

@internal-tools (2026-01-25)
  Next: Deploy dashboard v2 to staging
```

**Value**: Single view for prioritization and planning.

---

## Scenario 8: Searching Past Work

**Situation**: "How did I solve that caching issue last month?"

```
> Search my journal for caching
```

Output:
```
2026-01-15 @api-refactor @log
Implemented Redis caching for user sessions.
Key pattern: user:{id}:session, TTL 24h.
Reduced DB queries by 40%.

2026-01-10 @mobile-app @log
Added local caching for API responses using SQLite.
Cache invalidation on app foreground.
```

**Value**: Your past solutions are searchable knowledge.

---

## Daily Workflow Summary

**Start of day**:
```
/jrnl-status        # What's pending across projects?
/jrnl-restore       # Get context for today's project
```

**During work**:
```
"Add to journal: discovered X"     # Log findings
"Save idea: we should try Y"       # Capture ideas
```

**End of day**:
```
/jrnl-handoff       # Prepare for tomorrow
/jrnl-log           # Record accomplishments (optional)
```

---

## Tips

1. **Maintain project docs alongside jrnl**: Keep TODO.md, architecture docs, and CLAUDE.md up to date — handoffs point to these files
2. **Reference files in handoffs**: Include file paths like "see TODO.md Phase 3" or "see docs/api-spec.md" so the next session knows where to look
3. **Use @idea for non-urgent thoughts**: Review them during planning sessions
4. **Search before solving**: Your past self may have already solved it
5. **Extend status period for planning**: `/jrnl-status 30` for monthly review

---

## Integration with jrnl

jrnl-tools leverages your existing jrnl installation. You can still use jrnl directly:

```bash
jrnl --tags                    # See all your tags
jrnl @api-refactor             # Browse project entries
jrnl -from "last monday"       # Recent entries
jrnl --edit                    # Edit entries in your editor
```

The plugin adds intelligence on top of jrnl's reliable storage.

# Super MAGI - Requirements Definition

**Version**: 1.0
**Date**: 2026-02-13
**Status**: Draft
**Based on**: super-magi-concept.md, super-magi-concept-inspection.md

---

## Related Documents

- [MAGI Specification](magi-specification.md) - Base MAGI system specification
- [Super MAGI Concept](super-magi-concept.md) - Design concept for the deliberation phase
- [Super MAGI Concept Inspection](super-magi-concept-inspection.md) - MAGI review of the concept
- [Super MAGI Requirements Inspection](super-magi-requirements-inspection.md) - MAGI review of this requirements document
- [Claude.md](../Claude.md) - Canonical runtime specification (integrated v2.0)

---

## 1. Introduction

### 1.1 Purpose

This document defines the requirements for Super MAGI, an extension of the existing MAGI plugin that adds a structured deliberation phase when agents' votes are split. The goal is to evolve MAGI from a "voting democracy" to a "deliberative democracy" model.

### 1.2 Relationship Between MAGI and Super MAGI

Super MAGI is not a replacement for MAGI. It is a **conditional extension** that adds a deliberation phase to the existing system when votes are split.

#### Existing MAGI Architecture

```
Phase 1: Problem Structuring
  ARBITRATOR structures the problem into 命題/前提/A案/B案

Phase 2: Independent Analysis
  Task ──→ MELCHIOR ──→ Vote ──→ Tally ──→ Conclusion
  Task ──→ BALTHASAR ──→ Vote ─┘
  Task ──→ CASPER    ──→ Vote ─┘

Phase 3: Final Arbitration
  ARBITRATOR tallies votes (majority wins) and presents conclusion
```

- 3-phase execution with majority voting
- Agents analyze independently using Task tool (`run_in_background`)
- No inter-agent communication; minority opinion is recorded but passive

#### Super MAGI Extension

```
Phase 1: Problem Structuring (UNCHANGED)
Phase 2: Independent Analysis (UNCHANGED)

  Vote result:
    3-0 (unanimous)  ──→ Phase 4 (same as existing Phase 3)
    2-1 (split)       ──→ User confirmation ──→ Phase 3 (NEW)

Phase 3: Deliberation (NEW - conditional)
  TeamCreate("magi-deliberation")
       │
  Minority ←── SendMessage ── Majority   (Round 1: present arguments)
  Minority ──  SendMessage ──→ Majority  (Round 2: counterarguments)
  Minority ←── SendMessage ── Majority   (Round 3: response)
  Minority ──  SendMessage ──→ Majority  (Round 4: final rebuttal)
       │
  All agents revote
       │
  TeamDelete("magi-deliberation")

Phase 4: Final Arbitration (RENAMED)
  ARBITRATOR tallies final votes and presents conclusion with deliberation record
```

#### Key Differences

| Aspect | Existing MAGI | Super MAGI Extension |
|---|---|---|
| Decision model | Voting democracy | Deliberative democracy (when split) |
| Phases | 3 | 4 (Phase 3 is conditional) |
| Split decisions | Accepted as-is | Challenged through structured debate |
| Minority voice | Recorded passively | Active counterargument with final rebuttal |
| Inter-agent communication | None | SendMessage during deliberation |
| Agent Team API | Not used | Used in Phase 3 only |
| Unanimous decisions | Same output | Identical behavior (no change) |

Super MAGI preserves the core strength of MAGI -- independent, diverse analysis -- while adding a deliberation layer only when it is needed. For unanimous decisions, behavior is identical to existing MAGI.

### 1.3 Scope

Super MAGI is implemented as an in-place extension of the existing MAGI plugin (`plugins/magi/`). No separate plugin is created. The `/magi` command remains the single entry point.

### 1.4 Design Decisions

The following decisions were confirmed during requirements gathering:

| Decision | Choice | Rationale |
|---|---|---|
| Plugin structure | Extend existing MAGI | Avoid duplication; reuse Phases 1-2 |
| Command interface | Unified `/magi` | Single entry point; deliberation activates conditionally |
| Deliberation activation | User confirmation | Ask user before entering deliberation; respect user's time |
| Deliberation disclosure | Full display | Show all deliberation rounds for maximum transparency |
| Document language | English | Consistent with public documentation policy |

---

## 2. Functional Requirements

### FR-1: Selective Deliberation Activation

- **FR-1.1**: After Phase 2 vote collection, if the result is 2-1 (split), ARBITRATOR SHALL present the initial vote results and ask the user whether to proceed to the deliberation phase.
- **FR-1.2**: If the result is 3-0 (unanimous), ARBITRATOR SHALL skip the deliberation phase and proceed directly to final arbitration (Phase 4).
- **FR-1.3**: If the user declines deliberation, ARBITRATOR SHALL proceed to final arbitration using the Phase 2 votes.

### FR-2: Deliberation Phase (Phase 3)

- **FR-2.1**: ARBITRATOR SHALL create an Agent Team using `TeamCreate` with team name `"magi-deliberation"`.
- **FR-2.2**: ARBITRATOR SHALL spawn three teammate agents (MELCHIOR, BALTHASAR, CASPER) into the team using the `Task` tool with `team_name` parameter.
- **FR-2.3**: Each teammate SHALL receive their original agent role definition, the structured problem, and their own Phase 2 analysis result.
- **FR-2.4**: The minority agent SHALL additionally receive the majority agents' analysis results at the start of deliberation.

### FR-3: Structured Debate Protocol

The deliberation SHALL follow a strict 4-round protocol:

- **FR-3.1 Round 1 - Majority Presentation**: Each majority agent sends their analysis and vote reasoning to the minority agent via `SendMessage`. The minority agent learns the majority's arguments for the first time.
- **FR-3.2 Round 2 - Minority Counterargument**: The minority agent sends counterarguments addressing each majority agent's specific reasoning via `SendMessage` to both majority agents.
- **FR-3.3 Round 3 - Majority Response**: Each majority agent sends a response to the minority's counterarguments via `SendMessage` to the minority agent.
- **FR-3.4 Round 4 - Minority Final Rebuttal**: The minority agent sends a final rebuttal via `SendMessage` to both majority agents. This guarantees the minority the last word for procedural fairness.

### FR-4: Revoting

- **FR-4.1**: After the 4-round debate, all three agents SHALL cast a second vote (A or B) with updated reasoning.
- **FR-4.2**: Agents MAY change their vote if persuaded by the deliberation.
- **FR-4.3**: Each agent SHALL provide a brief statement explaining whether and why their position changed.

### FR-5: Deliberation Display

- **FR-5.1**: ARBITRATOR SHALL display each deliberation round to the user in real-time as it completes.
- **FR-5.2**: Each round SHALL be displayed with a clear header identifying the round number, speaker, and target.
- **FR-5.3**: Progress status SHALL be shown between rounds (e.g., "Round 2/4: Minority counterargument in progress...").

### FR-6: Final Arbitration (Phase 4)

- **FR-6.1**: ARBITRATOR SHALL tally the final votes (second vote if deliberation occurred, first vote otherwise).
- **FR-6.2**: If deliberation occurred, the output SHALL include:
  - Initial vote results (from Phase 2)
  - Deliberation summary (key arguments from each round)
  - Final vote results (from revoting)
  - Vote change tracking (which agents changed and why)
- **FR-6.3**: ARBITRATOR SHALL dissolve the Agent Team using `TeamDelete`.

### FR-7: Team Lifecycle Management

- **FR-7.1**: The Agent Team SHALL exist only during Phase 3.
- **FR-7.2**: If any error occurs during deliberation, ARBITRATOR SHALL attempt to clean up the team via `TeamDelete`.
- **FR-7.3**: Team state SHALL NOT persist between MAGI sessions.

### FR-8: Backward Compatibility

- **FR-8.1**: The existing `/magi` command interface SHALL remain unchanged.
- **FR-8.2**: The existing `/magi-help` command SHALL be updated to describe the deliberation phase.
- **FR-8.3**: Phases 1 and 2 behavior SHALL remain identical to the current implementation.
- **FR-8.4**: Unanimous (3-0) decisions SHALL produce output identical to the current MAGI format.

---

## 3. Non-Functional Requirements

### NFR-1: Performance

- **NFR-1.1**: Phases 1 and 2 SHALL have no additional latency compared to current MAGI.
- **NFR-1.2**: The deliberation phase (Phase 3) is expected to add 2-5 minutes of additional processing time. This is acceptable given that it only triggers for split decisions.
- **NFR-1.3**: The 4-round debate protocol SHALL NOT be extended beyond the specified rounds to control token consumption.

### NFR-2: Token Efficiency

- **NFR-2.1**: Agent Team deliberation consumes approximately 3-4x the tokens of a single session. The selective activation design (2-1 only) mitigates this cost.
- **NFR-2.2**: Deliberation prompts SHALL be concise and focused to minimize unnecessary token usage.

### NFR-3: Reliability

- **NFR-3.1**: If a teammate agent fails during deliberation, ARBITRATOR SHALL report the failure and fall back to Phase 2 results for final arbitration.
- **NFR-3.2**: If `TeamCreate` fails, ARBITRATOR SHALL inform the user and proceed with final arbitration using Phase 2 votes.

### NFR-4: User Experience

- **NFR-4.1**: All user-facing output SHALL be in Japanese.
- **NFR-4.2**: Clear progress indicators SHALL be displayed during each deliberation round.
- **NFR-4.3**: The deliberation display SHALL be structured and readable, not a raw dump of agent messages.

---

## 4. Updated Execution Flow

```
Phase 1: Problem Structuring (UNCHANGED)
  ARBITRATOR receives user's question
  Structures into: 命題, 前提, A案, B案
  Confirms with user

Phase 2: Independent Analysis (UNCHANGED)
  Launch MELCHIOR, BALTHASAR, CASPER in parallel (Task tool, run_in_background)
  Monitor progress, collect results
  Each agent votes A or B independently

  ┌─────────────────────────────────────────────────┐
  │ Vote Result Check                               │
  │                                                 │
  │  3-0 (Unanimous) ──→ Skip to Phase 4            │
  │  2-1 (Split)     ──→ Ask user: Deliberate?      │
  │                       ├─ Yes ──→ Phase 3        │
  │                       └─ No  ──→ Phase 4        │
  └─────────────────────────────────────────────────┘

Phase 3: Deliberation (NEW - conditional)
  3.0  ARBITRATOR displays initial vote results
  3.1  TeamCreate("magi-deliberation")
  3.2  Spawn 3 teammates with roles + Phase 2 results
  3.3  Round 1: Majority → Minority (present arguments)
  3.4  Round 2: Minority → Majority (counterarguments)
  3.5  Round 3: Majority → Minority (response)
  3.6  Round 4: Minority → Majority (final rebuttal)
  3.7  All agents revote with updated reasoning
  3.8  ARBITRATOR collects revote results
  3.9  Shutdown teammates, TeamDelete("magi-deliberation")

Phase 4: Final Arbitration (RENAMED from Phase 3)
  Tally final votes
  Present conclusion with full deliberation record (if applicable)
  Include vote change tracking (if deliberation occurred)
```

---

## 5. Component Specifications

### 5.1 Files to Modify

#### 5.1.1 `commands/magi.md`

**Changes**:
- After Phase 2 result collection, add vote-split detection logic
- Add user confirmation prompt for deliberation
- Add Phase 3 deliberation orchestration instructions
- Rename current "Phase 3: Final Arbitration" to "Phase 4: Final Arbitration"
- Update Phase 4 to handle both deliberated and non-deliberated paths
- Add error handling for team creation/deliberation failures

**New Sections to Add**:

```
### Phase 2.5: Vote Analysis and Deliberation Decision

After collecting all Phase 2 results:

1. Count votes: tally A案 and B案 votes
2. If 3-0 (unanimous):
   - Display: "全会一致のため、議論フェーズをスキップします。"
   - Proceed to Phase 4
3. If 2-1 (split):
   - Display initial vote results to user
   - Identify majority agents and minority agent
   - Ask user: "意見が割れました（2対1）。議論フェーズに進みますか？"
   - If user approves: proceed to Phase 3
   - If user declines: proceed to Phase 4 with Phase 2 votes

### Phase 3: Deliberation

[Full deliberation orchestration instructions - see Section 6]

### Phase 4: Final Arbitration

[Updated to handle both paths]
```

#### 5.1.2 `Claude.md`

**Changes**:
- Add Phase 3 (Deliberation) to Execution Flow section
- Add deliberation output format to Output Format section
- Update Phase numbering (current Phase 3 becomes Phase 4)
- Add Agent Team lifecycle documentation to Implementation Details
- Add deliberation examples to Usage Examples
- Update Update History

#### 5.1.3 `commands/magi-help.md`

**Changes**:
- Add deliberation phase description to the help output
- Describe the 2-1 split trigger condition
- Explain the 4-round debate protocol

#### 5.1.4 `docs/magi-specification.md`

**Changes**:
- Add note referencing Super MAGI requirements for the extended execution flow
- Maintain consistency with Claude.md

### 5.2 Files to Create

None. All changes are extensions to existing files. The deliberation prompts are constructed dynamically by ARBITRATOR within `commands/magi.md`.

### 5.3 Files Unchanged

- `agents/melchior.md` - Phase 2 agent definition (unchanged)
- `agents/balthasar.md` - Phase 2 agent definition (unchanged)
- `agents/casper.md` - Phase 2 agent definition (unchanged)
- `.claude-plugin/plugin.json` - Plugin metadata (unchanged, version bump handled at release)
- `.gitignore` - Already excludes state files
- `LICENSE` - Unchanged

---

## 6. Deliberation Protocol Specification

### 6.1 Team Setup

ARBITRATOR creates the deliberation team and spawns teammates:

```
Step 1: TeamCreate("magi-deliberation")

Step 2: Spawn teammates using Task tool with team_name="magi-deliberation"
  - Teammate "melchior-deliberation" (subagent_type: magi:melchior)
  - Teammate "balthasar-deliberation" (subagent_type: magi:balthasar)
  - Teammate "casper-deliberation" (subagent_type: magi:casper)

Each teammate's role definition is applied automatically via subagent_type. Each teammate additionally receives:
  - The structured problem (命題, 前提, A案, B案)
  - Their own Phase 2 analysis and vote
  - Their role in deliberation (majority or minority)
  - The debate protocol instructions
```

### 6.2 Teammate Prompts

Each teammate agent SHALL receive a deliberation-specific prompt that includes:

1. Their original role identity (MELCHIOR/BALTHASAR/CASPER)
2. The structured problem context
3. Their Phase 2 analysis result
4. Their deliberation role (majority or minority)
5. The specific round instructions
6. Output format requirements

**Majority Agent Prompt Template** (for Round 1):
```
You are [AGENT_NAME] in the MAGI deliberation phase.

Your Phase 2 analysis:
[Phase 2 result]

You voted [VOTE] as part of the majority (2-1 split).
The minority agent ([MINORITY_NAME]) voted [OPPOSITE_VOTE].

Your task in Round 1:
Send your analysis and vote reasoning to [MINORITY_NAME] using SendMessage.
Explain why you chose [VOTE] and address the key factors that informed your decision.
Focus on your strongest arguments.

After sending, wait for further instructions.
```

**Minority Agent Prompt Template** (for Round 2):
```
You are [AGENT_NAME] in the MAGI deliberation phase.

Your Phase 2 analysis:
[Phase 2 result]

You voted [VOTE] as the minority (2-1 split).
The majority agents ([MAJORITY_1], [MAJORITY_2]) voted [OPPOSITE_VOTE].

You have now received the majority agents' reasoning.

Your task in Round 2:
Send counterarguments to both majority agents using SendMessage.
Address their specific reasoning points.
Explain why your perspective should carry more weight despite being the minority.

After sending, wait for further instructions.
```

### 6.3 Round Orchestration

ARBITRATOR coordinates the rounds by sending messages to teammates:

```
Round 1: ARBITRATOR → majority agents: "Present your arguments to the minority"
  Majority agents → SendMessage → minority agent
  ARBITRATOR waits for completion, displays results

Round 2: ARBITRATOR → minority agent: "Present your counterarguments"
  Minority agent → SendMessage → majority agents
  ARBITRATOR waits for completion, displays results

Round 3: ARBITRATOR → majority agents: "Respond to the counterarguments"
  Majority agents → SendMessage → minority agent
  ARBITRATOR waits for completion, displays results

Round 4: ARBITRATOR → minority agent: "Present your final rebuttal"
  Minority agent → SendMessage → majority agents
  ARBITRATOR waits for completion, displays results

Revote: ARBITRATOR → all agents: "Cast your final vote with reasoning"
  All agents respond with final vote
  ARBITRATOR collects results
```

### 6.4 Round Timeout

- Each round SHALL have an implicit timeout governed by the agent's execution limit.
- If a teammate fails to respond within a round, ARBITRATOR SHALL:
  1. Note the failure in the deliberation record
  2. Continue to the next round with available responses
  3. The non-responding agent's Phase 2 vote is preserved for the final tally

---

## 7. Output Format Specifications

### 7.1 Phase 2.5: Vote Analysis (New)

When votes split 2-1:

```
【Phase 2: 初回投票結果】

投票結果: A案 2票 vs B案 1票

- MELCHIOR: A案
- BALTHASAR: A案
- CASPER: B案（少数派）

意見が割れました。議論フェーズに進みますか？
議論フェーズでは、多数派と少数派が構造化された議論を行い、再投票します。
```

### 7.2 Phase 3: Deliberation Display (New)

Each round is displayed as it completes:

```
【Phase 3: 議論フェーズ開始】
多数派: MELCHIOR, BALTHASAR (A案)
少数派: CASPER (B案)

---

【Round 1/4: 多数派の意見提示】

MELCHIOR → CASPER:
[MELCHIOR's argument presentation]

BALTHASAR → CASPER:
[BALTHASAR's argument presentation]

---

【Round 2/4: 少数派の反論】

CASPER → MELCHIOR, BALTHASAR:
[CASPER's counterarguments]

---

【Round 3/4: 多数派の再応答】

MELCHIOR → CASPER:
[MELCHIOR's response to counterarguments]

BALTHASAR → CASPER:
[BALTHASAR's response to counterarguments]

---

【Round 4/4: 少数派の最終反駁】

CASPER → MELCHIOR, BALTHASAR:
[CASPER's final rebuttal]

---

【再投票】
議論を踏まえた最終投票を行います...
```

### 7.3 Phase 4: Final Arbitration with Deliberation (Updated)

When deliberation occurred:

```
【MAGI システム 最終結論】

初回投票: A案 2票 vs B案 1票
再投票:   A案 X票 vs B案 Y票

採択: [A案/B案]

投票推移:
- MELCHIOR: A案 → [A案/B案] - [変更理由 or "立場維持"]
- BALTHASAR: A案 → [A案/B案] - [変更理由 or "立場維持"]
- CASPER: B案 → [A案/B案] - [変更理由 or "立場維持"]

議論の要約:
[Summary of key arguments exchanged during deliberation]

結論の要約:
[Final conclusion integrating both voting rounds and deliberation insights]

参照情報:
- MELCHIOR: [References]
- BALTHASAR: [References]
- CASPER: [References]
```

When no deliberation (3-0 unanimous or user declined):

```
【MAGI システム 最終結論】

投票結果: [A案/B案] 3票 vs [B案/A案] 0票

採択: [A案/B案]

各エージェントの判断:
- MELCHIOR: [Vote] - [Brief reasoning]
- BALTHASAR: [Vote] - [Brief reasoning]
- CASPER: [Vote] - [Brief reasoning]

結論の要約:
[Summary]

参照情報:
[References]
```

---

## 8. State Management Updates

### 8.1 Extended State Schema

```json
{
  "session_id": "unique-id",
  "current_phase": 1 | 2 | 2.5 | 3 | 4,
  "problem": {
    "proposition": "string",
    "prerequisites": ["string"],
    "option_a": "string",
    "option_b": "string"
  },
  "agent_ids": {
    "melchior": "agent_id",
    "balthasar": "agent_id",
    "casper": "agent_id"
  },
  "phase2_results": {
    "melchior": { "vote": "A|B", "reasoning": "string", "references": "string" },
    "balthasar": { "vote": "A|B", "reasoning": "string", "references": "string" },
    "casper": { "vote": "A|B", "reasoning": "string", "references": "string" }
  },
  "vote_split": {
    "is_split": true | false,
    "majority_vote": "A|B",
    "majority_agents": ["agent_name", "agent_name"],
    "minority_agent": "agent_name",
    "user_approved_deliberation": true | false | null
  },
  "deliberation": {
    "team_name": "magi-deliberation",
    "teammate_ids": {
      "melchior": "teammate_id",
      "balthasar": "teammate_id",
      "casper": "teammate_id"
    },
    "current_round": 0 | 1 | 2 | 3 | 4,
    "rounds": [
      { "round": 1, "type": "majority_presentation", "messages": [] },
      { "round": 2, "type": "minority_counterargument", "messages": [] },
      { "round": 3, "type": "majority_response", "messages": [] },
      { "round": 4, "type": "minority_final_rebuttal", "messages": [] }
    ],
    "revote_results": {
      "melchior": { "vote": "A|B", "changed": true|false, "reasoning": "string" },
      "balthasar": { "vote": "A|B", "changed": true|false, "reasoning": "string" },
      "casper": { "vote": "A|B", "changed": true|false, "reasoning": "string" }
    }
  },
  "final_decision": {
    "vote_a": 0,
    "vote_b": 0,
    "adopted": "A|B",
    "summary": "string"
  }
}
```

---

## 9. Error Handling

### 9.1 Team Creation Failure

```
Trigger: TeamCreate("magi-deliberation") fails
Action:
  1. Display error to user: "議論フェーズの初期化に失敗しました。初回投票結果で最終判定を行います。"
  2. Proceed to Phase 4 using Phase 2 votes
  3. Note the failure in the final output
```

### 9.2 Teammate Spawn Failure

```
Trigger: One or more teammates fail to spawn
Action:
  1. If all teammates fail: treat as Team Creation Failure
  2. If one teammate fails:
     - Note which agent could not join deliberation
     - Continue deliberation with remaining agents
     - Failed agent's Phase 2 vote is preserved for final tally
```

### 9.3 SendMessage Failure

```
Trigger: A message fails to deliver during a round
Action:
  1. Log the failure
  2. Skip the failed message and continue to the next round
  3. Note incomplete deliberation in the final output
```

### 9.4 Teammate Timeout/Crash

```
Trigger: A teammate stops responding mid-deliberation
Action:
  1. Wait for reasonable implicit timeout
  2. Note the agent's non-response
  3. Continue deliberation with remaining agents
  4. Non-responding agent's Phase 2 vote is preserved
```

### 9.5 Team Cleanup Failure

```
Trigger: TeamDelete fails after deliberation
Action:
  1. Log warning but do not block final output
  2. Proceed to Phase 4 normally
  3. Team resources will be cleaned up by session end
```

---

## 10. Testing Strategy

### 10.1 Scenario Matrix

| Scenario | Phase 2 Result | User Choice | Expected Behavior |
|---|---|---|---|
| Unanimous agreement | 3-0 | N/A | Skip deliberation, proceed to Phase 4 |
| Split with deliberation | 2-1 | Yes | Full 4-round deliberation + revote |
| Split without deliberation | 2-1 | No | Proceed to Phase 4 with Phase 2 votes |
| Split with vote change | 2-1 → 1-2 | Yes | Track vote reversal in output |
| Split with no change | 2-1 → 2-1 | Yes | Note maintained positions |
| Split reaching consensus | 2-1 → 3-0 | Yes | Note consensus achieved through deliberation |

### 10.2 Error Scenarios

| Scenario | Expected Behavior |
|---|---|
| TeamCreate fails | Fallback to Phase 2 results |
| One teammate crashes | Continue with remaining agents |
| All teammates crash | Fallback to Phase 2 results |
| SendMessage failure | Skip message, continue protocol |
| TeamDelete fails | Log warning, continue to output |

### 10.3 Validation Criteria

- Phase 1-2 behavior is identical to current MAGI for all scenarios
- Deliberation only triggers on 2-1 split AND user approval
- All 4 rounds execute in correct order
- Minority agent always gets the final word (Round 4)
- Vote changes are tracked and displayed
- Team is cleaned up after deliberation
- Errors degrade gracefully to Phase 2 results

---

## 11. Migration Notes

### 11.1 No Breaking Changes

Super MAGI is a backward-compatible extension. Existing MAGI behavior is preserved:
- `/magi` command syntax is unchanged
- 3-0 unanimous results produce identical output
- Phase 1-2 execution is unmodified

### 11.2 Version Strategy

- Plugin version bump from 1.0.0 to 2.0.0 (major: new deliberation capability)
- Update CHANGELOG.md at release time

### 11.3 Feature Flag

Super MAGI does not require a feature flag. The deliberation phase is gated by two conditions:
1. Vote split (2-1) - structural condition
2. User approval - explicit consent

This provides natural opt-in behavior without configuration.

### 11.4 Documentation Updates

At release:
- Update README.md with deliberation phase description
- Update Claude.md with full Phase 3 specification
- Update docs/magi-specification.md with cross-reference to Super MAGI requirements
- Update magi-help.md command output

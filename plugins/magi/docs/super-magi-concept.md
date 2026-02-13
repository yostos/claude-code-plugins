# Super MAGI - Concept

**Version**: 1.0
**Date**: 2026-02-13
**Status**: Approved (see [Concept Inspection](super-magi-concept-inspection.md))

---

## Related Documents

- [MAGI Specification](magi-specification.md) - Base MAGI system specification
- [Super MAGI Concept Inspection](super-magi-concept-inspection.md) - MAGI review of this concept
- [Super MAGI Requirements](super-magi-requirements.md) - Detailed requirements based on this concept
- [Super MAGI Requirements Inspection](super-magi-requirements-inspection.md) - MAGI review of the requirements
- [Claude.md](../Claude.md) - Canonical runtime specification (integrated v2.0)

---

## 1. Overview

Super MAGI is an evolution of the MAGI decision-support system. While the conventional MAGI relies on independent analysis and majority voting, Super MAGI introduces a **deliberation phase** after the initial vote. By leveraging Claude Code's Agent Team feature, it achieves a transition from "voting democracy" to "deliberative democracy".

## 2. Design Principles

### 2.1 Hybrid Architecture

Super MAGI combines two distinct coordination models:

- **Independent evaluation (existing)**: Each agent analyzes the problem independently using the Task tool. This preserves the purity of independent judgment.
- **Deliberation (new)**: Agents engage in structured debate using Agent Team messaging. This allows the minority perspective to challenge the majority.

### 2.2 Selective Activation

Deliberation does not occur for every decision. It triggers only when the initial vote is **split (2-1)**. Unanimous decisions (3-0) proceed directly to the final conclusion without deliberation.

This selective activation provides efficiency for unanimous decisions and deeper analysis for contentious ones.

## 3. Execution Flow

```
Phase 1: Problem Structuring (unchanged)
  ARBITRATOR dialogues with the user and structures the problem into binary choice format.
  Output: Proposition, Prerequisites, Option A, Option B

Phase 2: Independent Analysis (unchanged)
  Three agents analyze independently using Task tool (run_in_background).
  Each agent votes for Option A or Option B.
  No inter-agent communication. Independence is guaranteed.

Phase 3: Deliberation (new - split decisions only)
  3-1. Create Agent Team (TeamCreate).
  3-2. Majority agents present their reasoning to the minority agent (SendMessage).
       The minority learns the majority's arguments for the first time.
  3-3. Minority agent presents counterarguments to the majority's reasoning (SendMessage).
  3-4. Majority agents present their views in response to the counterarguments.
  3-5. Minority agent presents a final rebuttal.
       Giving the minority the last word ensures fairness against numerical disadvantage.
  3-6. All agents consolidate their views and revote.

Phase 4: Final Conclusion
  ARBITRATOR tallies votes (second vote if deliberation occurred).
  Presents the final decision with the complete reasoning trail.
  Dissolves the Agent Team (TeamDelete).
```

## 4. Architecture Comparison

```
Conventional MAGI:
  Task --> MELCHIOR  --> Vote --> Tally --> Conclusion
  Task --> BALTHASAR --> Vote --+
  Task --> CASPER    --> Vote --+

Super MAGI (when split):
  Task --> MELCHIOR  --> Vote --> Tally (2-1)
  Task --> BALTHASAR --> Vote --+     |
  Task --> CASPER    --> Vote --+     v
                              TeamCreate("magi-deliberation")
                                      |
                              Minority <--SendMessage-- Majority
                              Majority <--SendMessage-- Minority
                                      |
                                  Revote --> Final Tally --> Conclusion
                                      |
                              TeamDelete("magi-deliberation")
```

## 5. Key Design Decisions

### 5.1 Independence First, Collaboration Second

The deliberation phase is strictly separated from the initial analysis. Agents form their initial opinions without external influence. Only after voting do they participate in deliberation. This preserves MAGI's core strength: diverse, independent perspectives.

### 5.2 Structured Debate Protocol

In Phase 2, each agent has no visibility into other agents' analyses. The deliberation phase begins by sharing the majority's reasoning with the minority, then follows a strict protocol:

1. **Majority Presentation**: Each majority agent presents their analysis and vote reasoning to the minority. The minority learns the majority's arguments for the first time here.
2. **Minority Counterargument**: The minority agent develops counterarguments addressing the majority's specific reasoning.
3. **Majority Response**: Each majority agent presents their views in response to the counterarguments.
4. **Minority Final Rebuttal**: The minority agent delivers a final response. Giving the minority the last word ensures fairness against numerical disadvantage.
5. **Revote**: All agents consolidate their views and revote. They may change their position if persuaded.

This structure prevents unproductive exchanges and guarantees that all perspectives are heard.

### 5.3 Agent Team Lifecycle

The Agent Team exists only during Phase 3. It is created at the start of deliberation and destroyed upon completion. This minimizes resource usage and prevents state leakage between sessions.

### 5.4 Vote Change Rules

In the revote, agents may change their vote if persuaded by the deliberation. The final result is determined by the second vote tally. Expected outcomes:

- **3-0**: Consensus achieved through deliberation (minority was persuaded or persuaded the majority).
- **2-1 (same)**: Majority maintained despite the challenge.
- **2-1 (reversed)**: The minority's arguments persuaded one majority agent, reversing the decision.

## 6. Value Proposition

| Aspect | Conventional MAGI | Super MAGI |
|---|---|---|
| Decision model | Voting democracy | Deliberative democracy |
| Split decisions | Accepted as-is | Challenged through debate |
| Minority voice | Recorded passively | Active counterargument |
| Decision confidence | Vote count only | Vote count + deliberation trail |
| Efficiency | Fast (single round) | Fast for unanimous, thorough for split |

## 7. Scope and Constraints

- Super MAGI adds complexity only when needed (split decisions).
- The deliberation phase adds latency, but this is acceptable since split decisions warrant deeper analysis.
- Agent Team messaging is used exclusively for structured debate, not general-purpose collaboration.
- ARBITRATOR consistently maintains neutrality and does not participate in deliberation.

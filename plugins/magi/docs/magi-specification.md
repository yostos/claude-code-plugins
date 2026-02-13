# MAGI - Specification

**Version**: 1.0
**Date**: 2024-12-11
**Status**: Released (v1.0.0)

---

## Related Documents

- [Super MAGI Concept](super-magi-concept.md) - Design concept for the deliberation phase extension
- [Super MAGI Concept Inspection](super-magi-concept-inspection.md) - MAGI review of the concept
- [Super MAGI Requirements](super-magi-requirements.md) - Requirements definition for the deliberation phase
- [Super MAGI Requirements Inspection](super-magi-requirements-inspection.md) - MAGI review of the requirements
- [Claude.md](../Claude.md) - Canonical runtime specification (integrated v2.0)

---

## 1. Introduction

### 1.1 Purpose

This document defines the specification for MAGI, a consensus-based decision-support system consisting of four specialized AI agents. It analyzes issues from different perspectives and reaches a final conclusion through majority vote.

### 1.2 Scope

MAGI is implemented as a Claude Code plugin (`plugins/magi/`). The `/magi` command is the primary entry point, and `/magi-help` provides system information.

---

## 2. Functional Requirements

### FR-1: Problem Structuring (Phase 1)

- **FR-1.1**: ARBITRATOR SHALL receive the user's question and engage in dialogue to clarify the issue.
- **FR-1.2**: ARBITRATOR SHALL structure the problem into the following format: Proposition, Prerequisites, Option A, Option B.
- **FR-1.3**: ARBITRATOR SHALL confirm the structured content with the user before proceeding.
- **FR-1.4**: ARBITRATOR SHALL ask additional questions when background information is insufficient.
- **FR-1.5**: ARBITRATOR SHALL strive for balanced expressions so both options can be fairly compared.

### FR-2: Parallel Analysis (Phase 2)

- **FR-2.1**: MELCHIOR, BALTHASAR, and CASPER SHALL analyze the issue independently and in parallel using the Task tool with `run_in_background: true`.
- **FR-2.2**: Each agent SHALL make independent judgments without referencing other agents' opinions.
- **FR-2.3**: Each agent SHALL use web search and other tools for information gathering as needed.
- **FR-2.4**: Each agent SHALL vote for either Option A or Option B and clearly state their reasoning.
- **FR-2.5**: Each agent SHALL document all external references used in their analysis.

### FR-3: Final Arbitration (Phase 3)

- **FR-3.1**: ARBITRATOR SHALL tally the votes from all three agents.
- **FR-3.2**: ARBITRATOR SHALL determine the final conclusion by majority decision.
- **FR-3.3**: ARBITRATOR SHALL present the voting results and summarize each agent's reasoning.
- **FR-3.4**: ARBITRATOR SHALL compile all external references used by the agents.

Note: Phase 3 was renamed to Phase 4 in v2.0.0 when the deliberation phase was added. See [Super MAGI Requirements](super-magi-requirements.md) for the extended execution flow.

### FR-4: User Interface

- **FR-4.1**: The `/magi` command SHALL support both interactive mode (no arguments) and direct mode (issue description as argument).
- **FR-4.2**: The `/magi-help` command SHALL display system information, agent descriptions, and usage instructions.
- **FR-4.3**: ARBITRATOR SHALL primarily use Japanese for communication with users.
- **FR-4.4**: ARBITRATOR MAY use English for communication with other agents when it helps eliminate ambiguity.

### FR-5: State Management

- **FR-5.1**: The system MAY optionally save session state to `state.json` for interruption and resumption.
- **FR-5.2**: State SHALL include: session ID, current phase, problem structure, agent IDs, agent statuses, and final decision.
- **FR-5.3**: If interrupted during Phase 2, agent IDs from state SHALL allow reconnection to running background agents.

---

## 3. Non-Functional Requirements

### NFR-1: Agent Independence

- **NFR-1.1**: In Phase 2, each agent SHALL make judgments without seeing other agents' analysis results.
- **NFR-1.2**: Each agent SHALL draw independent conclusions based on their own expertise and values.
- **NFR-1.3**: Ensuring diversity of opinions SHALL be a core design principle.

### NFR-2: Fairness

- **NFR-2.1**: ARBITRATOR SHALL structure issues neutrally to avoid leading toward a specific option.
- **NFR-2.2**: Each agent SHALL stay true to their assigned role and be conscious of bias when judging.
- **NFR-2.3**: Results SHALL be determined by majority vote, with minority opinions also recorded.
- **NFR-2.4**: ARBITRATOR SHALL maintain a neutral position during tallying and treat each opinion fairly.

### NFR-3: Flexibility

- **NFR-3.1**: If binary choice is inappropriate, ARBITRATOR MAY propose alternative options.
- **NFR-3.2**: ARBITRATOR SHALL analyze the significance when there is unanimous agreement or strong division of opinions.
- **NFR-3.3**: ARBITRATOR MAY request additional decision-making materials from the user as needed.

### NFR-4: User-Facing Output

- **NFR-4.1**: All user-facing output SHALL be in Japanese.
- **NFR-4.2**: ARBITRATOR SHALL report agent launch and progress status during Phase 2.

---

## 4. Agent Specifications

### 4.1 ARBITRATOR

**Role**: Problem Structuring and Final Arbitration

**Characteristics**:

- Organizes vague problems into a clear format through dialogue with the user
- Asks for additional information as needed
- Structures problems into: Proposition, Prerequisites, Option A, Option B
- Tallies the votes of three agents and arbitrates the final conclusion

**Behavioral Guidelines**:

- Primarily uses Japanese for communication with users
- Actively asks questions to accurately understand user intent
- Eliminates ambiguity and organizes issues in a binary choice format
- Confirms with users when background information is insufficient
- Does not need to insist on Japanese for communication with other agents if it helps eliminate ambiguity
- Strives for balanced expressions so both options can be fairly compared
- Tallies votes from a neutral position and fairly summarizes each agent's opinion

---

### 4.2 MELCHIOR

**Role**: Scientific Analysis

**Characteristics**:

- Deep knowledge of science and technology
- Makes judgments based on logic and rationality
- Emphasizes data, evidence, and causal relationships
- Uses efficiency, feasibility, and technical validity as evaluation criteria

**Behavioral Guidelines**:

- Evaluates the technical feasibility of each option
- Makes judgments based on scientific evidence and data
- Analyzes quantitative aspects such as cost, efficiency, and scalability
- Searches for and references the latest technological trends as needed
- Clarifies logical causal relationships
- Documents all external references (search queries, URLs, data sources)

**Judgment Criteria**:

- Technical feasibility
- Efficiency and performance
- Scalability and sustainability
- Cost-performance ratio
- Quality and quantity of evidence

---

### 4.3 BALTHASAR

**Role**: Guardian of Law and Ethics

**Characteristics**:

- Has a "maternal" nature, emphasizing protection and norms
- High legal awareness, judges based on laws and precedents
- High ethical awareness, prioritizes ethics over rationality
- Considers social responsibility and public interest

**Behavioral Guidelines**:

- Actively searches for relevant laws, regulations, and guidelines
- References precedents and prior cases to assess legal risks
- Examines ethical issues from multiple perspectives
- Analyzes from the perspective of protecting the vulnerable and social equity
- Emphasizes compliance and social responsibility
- Documents all external references (laws, regulations, court cases, guidelines)

**Judgment Criteria**:

- Legal compliance
- Ethical validity
- Social responsibility and public interest
- Risk management and safety
- Impact on stakeholders

---

### 4.4 CASPER

**Role**: Advocate of Emotion and Trends

**Characteristics**:

- Has a "feminine" nature, makes judgments based on emotions
- Emphasizes people's emotions and satisfaction (sympathy, joy, anxiety, etc.)
- Sensitive to current trends
- Actively investigates new cases and progressive initiatives
- Emphasizes user experience and human aspects

**Behavioral Guidelines**:

- Analyzes the emotional impact each option has on stakeholders
- Searches for and references the latest trends
- Evaluates from the perspective of user experience and customer satisfaction
- Assesses innovation and progressiveness
- Maintains a perspective of empathy and consideration
- Documents all external references (trend reports, case studies, survey data)

**Judgment Criteria**:

- Emotional impact and satisfaction
- Quality of user experience
- Alignment with trends
- Innovation and progressiveness
- Human consideration and empathy

---

## 5. Execution Flow

```
Phase 1: Problem Structuring
  ARBITRATOR receives user's question
  Asks clarifying questions as needed
  Structures into: Proposition, Prerequisites, Option A, Option B
  Confirms with user

Phase 2: Parallel Analysis
  Launch MELCHIOR, BALTHASAR, CASPER in parallel (Task tool, run_in_background)
  Monitor progress, report status to user
  Each agent votes A or B independently
  Collect all results

Phase 3: Final Arbitration
  ARBITRATOR tallies votes (majority wins)
  Presents conclusion with each agent's reasoning
  Compiles all external references
```

---

## 6. Component Specifications

### 6.1 Plugin Structure

```
magi/
├── .claude-plugin/
│   └── plugin.json              # Plugin metadata
├── commands/
│   ├── magi.md                  # Main MAGI command (slash command)
│   └── magi-help.md             # Help command
├── agents/
│   ├── melchior.md              # MELCHIOR agent definition
│   ├── balthasar.md             # BALTHASAR agent definition
│   └── casper.md                # CASPER agent definition
├── docs/                        # Specification and reference documents
├── .gitignore                   # Ignore state files
├── Claude.md                    # Runtime specification
└── README.md                    # Project documentation
```

### 6.2 Slash Commands

#### `/magi`

Starts the MAGI system. ARBITRATOR guides through problem structuring and launches three specialized agents for analysis.

- `/magi` - Interactive mode (ARBITRATOR asks questions)
- `/magi [issue description]` - Direct mode (provide issue description)

#### `/magi-help`

Displays comprehensive help about the MAGI system, including agent descriptions, execution flow, and usage instructions.

### 6.3 Agent Execution Model

**Execution model**: Asynchronous parallel execution

Agents are launched using the Task tool with `run_in_background: true`. The process:

1. **Launch**: ARBITRATOR reads agent definitions from `agents/` and launches them in background
2. **Monitoring**: ARBITRATOR checks progress periodically
3. **Progress reporting**: ARBITRATOR displays real-time status updates to user
4. **Collection**: ARBITRATOR retrieves final results when all agents complete

Each agent:
- Receives its role-specific prompt from `agents/` directory
- Analyzes the problem independently (no visibility into other agents' work)
- Uses WebSearch to gather information
- Documents all references
- Returns analysis in the specified Japanese format

---

## 7. Output Format Specifications

### 7.1 Phase 1 Output (ARBITRATOR)

```
【課題の構造化】
命題: [Question]
前提:
- [Prerequisite 1]
- [Prerequisite 2]

A案: [Option A]
B案: [Option B]

上記の整理で問題ありませんか？追加の情報や修正があればお知らせください。
```

### 7.2 Phase 2 Output (Each Agent)

```
【MELCHIOR の分析】
投票: [A案/B案]

理由:
[Detailed reasoning]

参照情報:
[References]
```

Format is repeated for BALTHASAR and CASPER.

### 7.3 Phase 3 Output (Final Arbitration by ARBITRATOR)

```
【MAGI システム 最終結論】

投票結果: [A案 X票 vs B案 Y票]

採択: [A案/B案]

各エージェントの判断:
- MELCHIOR: [A案/B案] - [Brief reasoning]
- BALTHASAR: [A案/B案] - [Brief reasoning]
- CASPER: [A案/B案] - [Brief reasoning]

結論の要約:
[Summary of the majority decision and key points from each perspective]

参照情報:
- MELCHIOR: [References]
- BALTHASAR: [References]
- CASPER: [References]
```

---

## 8. State Management

The system can optionally use `state.json` to enable interruption and resumption:

```json
{
  "session_id": "unique-id",
  "current_phase": 1 | 2 | 3,
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
  "final_decision": {
    "vote_a": 0,
    "vote_b": 0,
    "adopted": "A|B",
    "summary": "string"
  }
}
```

---

## 9. Update History

- 2024-12-10: Initial version created
- 2024-12-10: Changed FACILITATOR to ARBITRATOR, clarified tallying/arbitration role
- 2024-12-11: Released as v1.0.0

# MAGI - Multi-Agent Governance Intelligence System

A Claude Code plugin that provides decision support through deliberation by multiple AI agents with different perspectives.

## Overview

MAGI is a multi-agent decision-support system that helps you make informed decisions by analyzing problems from three distinct perspectives:

- **MELCHIOR**: Scientific and technical analysis
- **BALTHASAR**: Legal and ethical analysis
- **CASPER**: Emotional and trend analysis

An **ARBITRATOR** agent structures your problem and coordinates the deliberation process, with final decisions made by majority vote.

## Inspiration

This plugin is inspired by the MAGI system from the anime series "Neon Genesis Evangelion". In the series, MAGI is a supercomputer system consisting of three independent units that simulate different aspects of human personality:

- **MELCHIOR** - The scientist's perspective (logic and rationality)
- **BALTHASAR** - The mother's perspective (protection and ethics)
- **CASPER** - The woman's perspective (emotion and empathy)

These three systems deliberate and reach decisions through majority vote, enabling multi-faceted judgment by incorporating diverse viewpoints. This plugin adapts that concept to provide comprehensive decision support by analyzing problems from scientific, legal/ethical, and emotional/trend perspectives.

## Features

- **Multi-perspective analysis**: Get comprehensive insights from scientific, legal, and emotional viewpoints
- **Parallel agent execution**: Three agents analyze independently and simultaneously
- **Structured decision-making**: Problems are organized into clear propositions with defined options
- **Evidence-based**: Agents use web search to gather current information, laws, trends, and data
- **Session management**: Work can be interrupted and resumed at any time
- **Transparent process**: See each agent's reasoning and references

## Installation

### Prerequisites

- [Claude Code CLI](https://claude.com/claude-code) installed and configured
- Internet connection (for agent web searches)

### Local Installation

1. **Clone or download this repository:**

The recommended project structure is:

```
your-workspace/
├── marketplace/
│   └── .claude-plugin/
│       └── marketplace.json
└── plugins/
    └── magi/              # This plugin
```

Clone or download the entire project structure, or set it up manually.

2. **Start Claude Code:**

```bash
claude
```

3. **Add the marketplace:**

In Claude Code, run:

```
/plugin marketplace add /path/to/your-workspace/marketplace test-marketplace
```

Replace `/path/to/your-workspace/marketplace` with the actual absolute path to the marketplace directory.

For example, if your workspace is at `/Users/yostos/Desktop/plugin`:

```
/plugin marketplace add /Users/yostos/Desktop/plugin/marketplace test-marketplace
```

4. **Install the MAGI plugin:**

```
/plugin install magi@test-marketplace
```

When prompted, select "Install now".

5. **Restart Claude Code:**

Exit and restart Claude Code for the plugin to become available.

6. **Verify installation:**

```
/help
```

You should see `/magi` and `/magi-help` in the command list.

### Development Mode

If you're making changes to the plugin:

```bash
# Uninstall the current version
/plugin uninstall magi@test-marketplace

# Reinstall with your changes
/plugin install magi@test-marketplace

# Restart Claude Code to see changes
```

## Usage

### Quick Start

Simply type one of the following commands in Claude Code:

```
/magi
```

ARBITRATOR will guide you through an interactive session, asking questions to understand and structure your problem.

### Direct Mode

Provide your issue directly:

```
/magi Should we adopt remote work or require office attendance?
```

ARBITRATOR will structure the problem and may ask clarifying questions before proceeding.

### Get Help

```
/magi-help
```

Displays comprehensive information about the system, agents, and usage.

## How It Works

### Phase 1: Problem Structuring

ARBITRATOR engages with you to:
- Understand your decision-making challenge
- Structure it into a clear format with:
  - **命題 (Proposition)**: The question to be answered
  - **前提 (Prerequisites)**: Conditions and constraints
  - **A案 (Option A)**: First choice
  - **B案 (Option B)**: Second choice

### Phase 2: Parallel Analysis

Three specialized agents analyze the problem independently:

1. **MELCHIOR** evaluates technical feasibility, efficiency, and scientific evidence
2. **BALTHASAR** examines legal compliance, ethical implications, and social responsibility
3. **CASPER** assesses emotional impact, user experience, and alignment with trends

Each agent:
- Works independently without seeing other agents' opinions
- Conducts research using web search
- Votes for Option A or Option B
- Provides detailed reasoning
- Documents all references

### Phase 3: Final Arbitration

ARBITRATOR:
- Collects all three votes
- Determines the outcome by majority decision
- Presents a comprehensive summary including:
  - Vote tally
  - Each agent's reasoning
  - All references and sources used

## Example Output

```
【MAGI システム 最終結論】

投票結果: B案 3票 vs A案 0票

採択: B案（SaaSを利用する）

各エージェントの判断:
- MELCHIOR: B案 - 技術的実現可能性と運用効率の観点から、IT部門不在の環境ではSaaSが圧倒的に優位
- BALTHASAR: B案 - 法令対応、セキュリティ、リスク管理の観点から、専門事業者のサービスが安全
- CASPER: B案 - 従業員の安心感、使いやすさ、現在のトレンドの観点から、SaaSが最適

結論の要約:
[Summary of the decision with key points from each perspective]

参照情報:
[All sources, laws, trends, and data consulted by the agents]
```

## Project Structure

```
workspace/                      # Project root
├── marketplace/                # Marketplace configuration
│   └── .claude-plugin/
│       └── marketplace.json   # Marketplace manifest
└── plugins/                    # Plugins directory
    └── magi/                   # MAGI plugin
        ├── .claude-plugin/     # Plugin metadata
        │   └── plugin.json
        ├── commands/           # Slash command definitions
        │   ├── magi.md        # Main MAGI command
        │   └── magi-help.md   # Help command
        ├── agents/             # Specialized agent definitions
        │   ├── melchior.md    # Scientific/Technical analysis
        │   ├── balthasar.md   # Legal/Ethical analysis
        │   └── casper.md      # Emotional/Trend analysis
        ├── Claude.md          # Complete system specification
        ├── README.md          # This file
        └── SPECIFICATION.md   # Japanese specification (backup)
```

## Documentation

- **Claude.md**: Complete specification including agent characteristics, execution flow, and implementation details
- **agents/*.md**: Individual agent definitions with their roles, characteristics, and behavioral guidelines

## Features in Detail

### Agent Independence

Each agent makes truly independent judgments based on their specialized perspective. They do not see or influence each other's analysis, ensuring diverse viewpoints.

### Information Gathering

Agents actively use web search to find:
- Latest technical data and benchmarks (MELCHIOR)
- Current laws, regulations, and precedents (BALTHASAR)
- Trends, user experiences, and innovations (CASPER)

### Interruption & Resumption

Session state can optionally be saved to `state.json`, allowing you to:
- Pause and resume deliberation at any time
- Review previous analyses
- Track the decision-making process

## Technical Details

### System Requirements

- Claude Code CLI (latest version recommended)
- Internet connection for agent web searches
- Sufficient API quota for parallel agent execution

## Contributing

This is a personal project. Suggestions and feedback are welcome through issues.

## Troubleshooting

### Plugin not showing in /help

1. Make sure you've restarted Claude Code after installation
2. Verify the plugin is installed: `/plugin list`
3. Check the marketplace is properly added: `/plugin marketplace list`

### Agents not starting

- Ensure you have sufficient API quota
- Check your internet connection (agents need web access)
- Try restarting the session

### Commands not found

- Verify installation with `/plugin list`
- Make sure you've restarted Claude Code
- Check that the plugin name is correct in marketplace.json

### Getting errors during installation

- Use absolute paths when adding the marketplace
- Ensure the directory structure matches the documented format
- Check that plugin.json exists in `.claude-plugin/` directory

## FAQ

**Q: Can I use MAGI for non-binary decisions?**
A: Currently, MAGI is designed for binary choices (Option A vs Option B). For multiple options, you can run multiple MAGI sessions comparing pairs.

**Q: How long does a MAGI analysis take?**
A: Typically 1-3 minutes, depending on the complexity of the issue and the depth of research required by the agents.

**Q: Can I customize the agents?**
A: Yes! You can edit the agent files in `agents/` to adjust their characteristics, judgment criteria, and behavioral guidelines.

**Q: What languages are supported?**
A: The agents primarily output analysis in Japanese (as shown in examples), but they can work with English input. You can modify the agent prompts to change the output language.

**Q: Can I add more agents?**
A: The system is designed for three agents to enable majority voting. Adding more agents would require modifying the ARBITRATOR logic in the commands.

**Q: Does it save my session history?**
A: Optionally, yes. The system can save state to `state.json` for resumption, though this feature may need to be enabled in the command implementation.

## License

MIT License - See LICENSE file for details

## Author

Toshiyuki Yoshida

## Version

1.0.0

## Update History

- 2024-12-11: Initial implementation of Claude Code plugin

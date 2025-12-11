# Claude Code Plugins Repository

A collection of custom plugins for Claude Code CLI, featuring advanced multi-agent systems and productivity tools.

## Overview

This repository serves as a local marketplace for Claude Code plugins. It provides a structured way to develop, organize, and distribute custom plugins that extend Claude Code's capabilities.

## Repository Structure

```
plugin/
├── .claude-plugin/
│   └── marketplace.json        # Marketplace configuration
├── plugins/                    # Plugin collection
│   └── magi/                  # MAGI plugin
│       ├── .claude-plugin/
│       ├── commands/
│       ├── agents/
│       └── ...
└── README.md                  # This file
```

## Available Plugins

### MAGI - Multi-Agent Governance Intelligence System

A sophisticated decision-support system that analyzes problems from multiple perspectives using specialized AI agents.

**Features:**
- Multi-perspective analysis (scientific, legal, emotional)
- Parallel agent execution
- Evidence-based decision making with web search
- Structured deliberation process with majority voting

[View MAGI Documentation](./plugins/magi/README.md)

## Installation

### Prerequisites

- [Claude Code CLI](https://claude.com/claude-code) installed and configured
- Internet connection (for plugins that use web search)

### Setup Instructions

1. **Clone this repository:**

```bash
git clone <repository-url>
cd plugin
```

2. **Start Claude Code:**

```bash
claude
```

3. **Add this marketplace to Claude Code:**

In Claude Code, run:

```
/plugin marketplace add /path/to/plugin test-marketplace
```

Replace `/path/to/plugin` with the absolute path to this repository.

For example:
```
/plugin marketplace add /Users/username/Desktop/plugin test-marketplace
```

4. **Install a plugin:**

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

You should see the plugin's commands in the command list.

## Using Plugins

### MAGI System

Start a decision-making session:

```
/magi
```

Or provide an issue directly:

```
/magi Should we adopt remote work or require office attendance?
```

Get help:

```
/magi-help
```

## Development

### Adding New Plugins

1. Create a new directory under `plugins/`:

```bash
mkdir -p plugins/your-plugin-name/.claude-plugin
```

2. Create the plugin manifest (`plugins/your-plugin-name/.claude-plugin/plugin.json`):

```json
{
  "name": "your-plugin-name",
  "description": "Brief description of your plugin",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  }
}
```

3. Add plugin components as needed:
   - `commands/` - Slash commands
   - `agents/` - Specialized agents
   - `hooks/` - Event hooks
   - `skills/` - Reusable skills

4. Register in marketplace (`/.claude-plugin/marketplace.json`):

```json
{
  "plugins": [
    {
      "name": "your-plugin-name",
      "source": "./plugins/your-plugin-name",
      "description": "Brief description"
    }
  ]
}
```

5. Reinstall the marketplace:

```
/plugin marketplace remove test-marketplace
/plugin marketplace add /path/to/plugin test-marketplace
/plugin install your-plugin-name@test-marketplace
```

### Plugin Development Best Practices

- Keep plugins focused on specific tasks
- Document all commands and features clearly
- Use descriptive names for commands and agents
- Include examples in documentation
- Test thoroughly before publishing
- Follow Claude Code plugin conventions

## Contributing

This is a personal plugin collection. Suggestions and feedback are welcome through issues.

## License

[Specify your license here]

## Author

Toshiyuki Yoshida

## Resources

- [Claude Code Documentation](https://claude.com/claude-code)
- [Claude Code Plugin Development Guide](https://docs.anthropic.com/claude-code)

## Version History

- 2024-12-11: Initial repository setup with MAGI plugin

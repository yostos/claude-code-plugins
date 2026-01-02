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

### simple-commit - Auto-Generated Conventional Commits

A streamlined plugin that analyzes staged changes and automatically generates commit messages in Conventional Commits format.

**Features:**
- Automatic analysis of staged changes
- Conventional Commits format (feat:, fix:, docs:, etc.)
- Learns style from recent commit history
- Concise messages under 50 characters
- No emojis or decorations
- Fast and simple operation

[View simple-commit Documentation](./plugins/simple-commit/README.md)

### pdf-processor - Scanned PDF Processing Tool

A comprehensive tool for processing scanned PDFs with merge, OCR, and table of contents generation capabilities.

**Features:**
- PDF merging and preprocessing
- OCR processing with Tesseract
- Table of contents creation
- Bookmark extraction and management
- Integration with pdftk and gs (Ghostscript)

[View pdf-processor Documentation](./plugins/pdf-processor/README.md)

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

4. **Install plugins:**

Install MAGI plugin:
```
/plugin install magi@test-marketplace
```

Install simple-commit plugin:
```
/plugin install simple-commit@test-marketplace
```

Install pdf-processor plugin:
```
/plugin install pdf-processor@test-marketplace
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

### simple-commit

Auto-generate and commit with Conventional Commits format:

```bash
# 1. Stage your changes
git add .

# 2. Run the commit command
/commit
```

The command automatically:
- Analyzes staged changes
- Generates appropriate Conventional Commits message
- Executes the commit

Create a release:

```
/release
```

This automates the entire release process including CHANGELOG generation, tagging, and pushing.

### pdf-processor

Preprocess scanned PDFs (merge and OCR):

```
/preprocess
```

Apply table of contents to a PDF:

```
/apply-toc
```

The plugin guides you through the process of creating and applying bookmarks to your PDF files.

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
      "name": "magi",
      "source": "./plugins/magi",
      "description": "Multi-Agent Governance Intelligence System"
    },
    {
      "name": "simple-commit",
      "source": "./plugins/simple-commit",
      "description": "Auto-generate Conventional Commits messages"
    },
    {
      "name": "pdf-processor",
      "source": "./plugins/pdf-processor",
      "description": "Scanned PDF processing tool"
    },
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

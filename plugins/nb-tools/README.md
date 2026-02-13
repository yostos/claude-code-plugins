# nb-tools

A Claude Code plugin for command-line note-taking, task management, and knowledge organization using [nb](https://xwmx.github.io/nb/).

## Overview

nb-tools provides comprehensive guidance for using the nb command-line tool to:

- 📝 Create, edit, and manage notes in Markdown (and other formats)
- ✅ Track and manage TODO tasks (stored in `tasks/` folder)
- 🔍 Search and reference your knowledge base
- 📚 Organize notes with notebooks, folders, and tags
- 🔖 Bookmark and archive web content
- 🐟 Integrate seamlessly with Fish shell

**Local Rules**:
1. **TODO Storage**: All TODO tasks must be stored in a `tasks/` folder within each notebook.
2. **Note Frontmatter**: All notes (except TODOs) must include YAML frontmatter:
   ```yaml
   ---
   Created: YYYY-MM-DD
   Updated: YYYY-MM-DD HH:MM:SS.
   Tags: #tag1, #tag2
   Status: #draft
   ---
   ```
   **Note**: The period (.) after the Updated timestamp is required.

## Features

### Note Management
- Quick note creation with templates
- Interactive search and editing
- Daily and meeting note templates
- Wiki-style linking between notes
- Full-text search with context

### Task Management
- Create and track TODO items in `tasks/` folder (local rule)
- Mark tasks as complete/incomplete
- Tag-based task organization
- Quick todo creation helpers

### Knowledge Organization
- Multiple notebooks for different topics
- Hierarchical folder structures
- Tag-based categorization
- Cross-referencing with wiki links
- Project notebook templates

### Fish Shell Integration
- Convenient abbreviations
- Helper functions for common operations
- Interactive selection interfaces
- Tab completions (from nb)

## Installation

### Prerequisites

1. Install nb:
   ```fish
   brew install nb
   ```

2. Install Claude Code (if not already installed)

3. Install the plugin:
   ```fish
   # Clone or link this plugin to your Claude Code plugins directory
   # The plugin will be auto-discovered by Claude Code
   ```

### Optional Setup

Source the Fish helper functions in your `~/.config/fish/config.fish`:

```fish
# Add nb-tools helpers
if test -f ~/.claude/plugins/nb-tools/skills/nb/examples/nb-helpers.fish
    source ~/.claude/plugins/nb-tools/skills/nb/examples/nb-helpers.fish
end
```

## Usage

The nb skill is automatically triggered when you ask Claude Code to:

- "Create a note"
- "Add a todo task"
- "Search my notes"
- "List todos"
- "Manage my knowledge base"
- And other related operations

### Example Interactions

**Creating Notes:**
```
You: Create a note about Docker best practices
Claude: [Uses nb to create a note with required frontmatter including Created, Updated, Tags, and Status]
```

**Task Management:**
```
You: Add a todo to review pull requests
Claude: [Creates todo item in tasks/ folder with nb]
```

**Searching:**
```
You: Search my notes for docker information
Claude: [Performs nb search and shows results]
```

**Project Setup:**
```
You: Set up a project notebook for my new app
Claude: [Creates structured notebook with folders]
```

## Skill Components

### SKILL.md
Main skill file with:
- Core concepts and workflows
- Common operations and patterns
- Fish shell integration guidance
- Best practices and troubleshooting

### references/commands.md
Comprehensive command reference covering:
- All nb commands with options
- Detailed usage examples
- Advanced features
- Integration patterns

### examples/nb-helpers.fish
Fish shell helper functions:
- Quick note creation (`nn`, `nb-daily`, `nb-meeting`)
- Task management (`nt`, `ntl`, `ntd`)
- Interactive search (`nse`)
- Project setup (`nb-project`)
- Statistics and utilities

## Helper Functions

After sourcing `nb-helpers.fish`, you get these convenient commands:

| Command | Description |
|---------|-------------|
| `nn "Title"` | Quick note creation |
| `nb-daily` | Create/open daily note |
| `nb-meeting "Title"` | Create meeting note with template |
| `nt "Task"` | Quick todo addition |
| `ntl` | List open todos |
| `ntd <id>` | Mark todo as done |
| `nse "query"` | Search and edit interactively |
| `nb-recent [n]` | List recent notes |
| `nb-tag <tag>` | Search by tag |
| `nb-stats` | Show statistics |
| `nb-project "name"` | Create structured project notebook |
| `nb-select` | Interactive notebook selection |
| `nb-sync` | Sync with remote |

## Quick Start

1. Install nb and this plugin
2. Ask Claude Code to create a note:
   ```
   "Create a note called 'Ideas' with some initial content"
   ```
3. Claude will use nb to create and manage your note
4. Source the helper functions for direct CLI use
5. Start organizing your knowledge!

## Documentation

- **SKILL.md**: Main skill documentation
- **references/commands.md**: Detailed command reference
- **examples/nb-helpers.fish**: Helper function implementations
- [Official nb documentation](https://xwmx.github.io/nb/)

## Common Workflows

### Daily Journaling
```fish
nb-daily  # Creates or opens today's note with frontmatter
```

### Project Documentation
```fish
cd ~/projects/myproject
nb init  # Initialize local notebook
# Note: All notes must include frontmatter (Created, Updated, Tags, Status)
nb add "Architecture Overview"
```

### Task Tracking
```fish
# Todos are stored in tasks/ folder (local rule)
nt "Complete documentation"  # Creates todo in tasks/
ntl  # List open todos from tasks/
ntd 5  # Mark todo 5 as done
```

### Knowledge Management
```fish
nb-project "research"  # Create structured notebook
nb research:add "Topic Notes" "#important"
nb search "#important"
```

## Configuration

### Environment Variables

```fish
# Set in ~/.config/fish/config.fish
set -x EDITOR vim       # Default editor
set -x NB_DIR "$HOME/.nb"  # Notes directory
set -x NB_AUTO_SYNC 1   # Auto-sync with remote
```

### nb Settings

```fish
# Configure nb defaults
nb settings set editor vim
nb settings set color-theme ocean
nb settings set default_extension md
```

## Troubleshooting

### Skill Not Triggering
- Ensure plugin is properly installed
- Use explicit phrases like "create a note with nb"
- Check Claude Code plugin directory

### Helper Functions Not Available
- Verify you sourced `nb-helpers.fish`
- Check file path in your config.fish
- Reload shell: `exec fish`

### nb Command Not Found
```fish
# Install nb
brew install nb

# Or follow installation instructions at:
# https://github.com/xwmx/nb#installation
```

## Contributing

Contributions welcome! Please:
1. Test changes with Fish shell
2. Follow existing code style
3. Update documentation
4. Submit pull requests

## License

MIT License - See LICENSE file

## Resources

- [nb Official Site](https://xwmx.github.io/nb/)
- [nb GitHub Repository](https://github.com/xwmx/nb)
- [Fish Shell Documentation](https://fishshell.com/docs/current/)
- [Claude Code Documentation](https://github.com/anthropics/claude-code)

## Author

Toshiyuki Yoshida

## Version

0.1.0

---

Built for Claude Code with ❤️

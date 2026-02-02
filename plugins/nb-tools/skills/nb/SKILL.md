---
name: nb
description: This skill should be used when the user asks to "create a note", "add a note with nb", "create a todo task", "add todo", "search notes", "search my knowledge base", "list notes", "list todos", "edit a note", "manage knowledge base", "take notes", "bookmark a URL", or mentions nb command operations. Provides comprehensive guidance for using nb command-line tool for note-taking, task management, and knowledge organization in Fish shell.
version: 0.1.0
---

# nb: Command-line Note-taking and Knowledge Management

## Overview

nb is a command-line and local web note-taking, bookmarking, archiving, and knowledge management tool. It stores data as plain text files (Markdown, Org, AsciiDoc, LaTeX) with Git-backed versioning, encryption support, and extensive organization features.

This skill provides guidance for using nb with Fish shell to:

- Create, edit, and manage notes in Markdown format
- Track and manage TODO tasks
- Search and reference knowledge base
- Organize notes with notebooks, folders, and tags
- Bookmark and archive web content

**IMPORTANT: Non-Interactive Environment Considerations**

When using nb in automated or non-interactive environments (like Claude Code):

1. **Always use `--print` flag** with `nb show` command to avoid TTY errors
2. **Avoid interactive commands** like `nb edit` that require TTY access
3. **Use `--list` flag** with `nb search` when you only need file paths, not content preview
4. **Prefer non-interactive operations**: reading, searching, listing, creating notes via heredoc

Commands that work well in non-interactive mode:
- `nb add` (with heredoc or content)
- `nb show --print`
- `nb search` (displays matches by default, use `--list` for file paths only)
- `nb list` / `nb ls`
- `nb delete --force` (skips confirmation)

Commands that require interactive mode:
- `nb edit` (requires editor)
- `nb show` without `--print` (launches TUI viewer)
- `nb delete` without `--force` (requires confirmation)

## Core Concepts

### Storage and Organization

nb stores notes as plain text files in `~/.nb/` (global) or local `.nb/` directories:

- **Notebooks**: Separate collections (default: "home")
- **Folders**: Directory structure within notebooks
- **Tags**: Hierarchical categorization using `#tag` or `#parent/child` syntax
- **Links**: Wiki-style cross-references using `[[note-title]]` or `[[id]]`

**Local Rules**:

1. **TODO Storage**: All TODO tasks must be stored in a `tasks/` folder within the notebook. When creating todos, always specify the `tasks/` folder path.
2. **Note Frontmatter**: All notes (except TODOs) must include YAML frontmatter at the beginning with the following format:

   ```yaml
   ---
   Created: YYYY-MM-DD
   Updated: YYYY-MM-DD HH:MM:SS.
   Tags: #tag1, #tag2
   Status: #draft
   ---
   ```

   **CRITICAL - Updated field format**:
   - The period (`.`) after the Updated timestamp is **REQUIRED**
   - nb automatically manages this field, but when editing files directly (via Write/Edit tools), you MUST preserve the trailing period
   - Example: `Updated: 2026-01-21 13:01:19.` (correct) vs `Updated: 2026-01-21` (incorrect - missing period)
   - If you remove the period, nb may not recognize the file correctly

All changes are automatically versioned with Git, enabling history tracking and synchronization with remote repositories.

### Note Formats

Default format is Markdown (.md), but nb supports:

- Markdown (.md) - Recommended for general use
- Org mode (.org) - For Emacs users
- AsciiDoc (.adoc) - For technical documentation
- LaTeX (.tex) - For academic writing

Specify format with `--type` flag or configure default in settings.

## Creating and Managing Notes

### Quick Note Creation

Create notes using various approaches. **Remember**: All notes (except TODOs) must include the required frontmatter:

```fish
# Create note with frontmatter (following local rule)
nb add "Meeting Notes" <<EOF
---
Created: $(date +%Y-%m-%d)
Updated: $(date +%Y-%m-%d\ %H:%M:%S).
Tags: #meeting, #work
Status: #draft
---

# Meeting Notes

Content here...
EOF

# Using heredoc with variables
set -l today (date +%Y-%m-%d)
set -l now (date +%Y-%m-%d\ %H:%M:%S)
nb add "Project Ideas" <<EOF
---
Created: $today
Updated: $now.
Tags: #ideas, #project
Status: #draft
---

# Project Ideas

Content here...
EOF
```

For Fish shell, use the helper functions from `examples/nb-helpers.fish`:

```fish
# Quick note creation
nn "Note Title"

# Daily note with date
nb-daily

# Meeting note with template
nb-meeting "Project Planning"
```

### Editing Notes

Edit notes by ID or title:

```fish
# Edit by ID (interactive shell only)
nb edit 3
nb e 3

# Edit by title (supports partial matching)
nb edit "meeting"

# Edit with specific editor
nb edit 3 --editor vim
```

**IMPORTANT for Automated/Non-Interactive Environments (like Claude Code):**
- `nb edit` command requires an interactive editor and TTY, which is not available in Claude Code
- To modify notes in non-interactive environments:
  1. First read the note content: `nb show note-id --print`
  2. Use other tools to modify the content
  3. Update the note using alternative methods (e.g., direct file manipulation)

Use the search-and-edit helper for interactive editing:

```fish
# Search and select note to edit (interactive shell only)
nse "keyword"
```

### Viewing Notes

Display note content in various ways:

```fish
# Print raw content (RECOMMENDED for non-interactive environments)
nb show 3 --print

# View by title
nb show "note-title" --print

# View with syntax highlighting (still requires --print in non-interactive mode)
nb show 3 --render --print
```

**IMPORTANT for Automated/Non-Interactive Environments (like Claude Code):**
- Always use `--print` flag with `nb show` command
- Without `--print`, nb will try to open an interactive TUI viewer which requires TTY
- This will fail with error: "unable to run tui program: could not open a new TTY"

```fish
# Interactive shell only (will fail in Claude Code)
nb show 3
nb 3
```

### Listing Notes

List notes with filtering and sorting:

```fish
# List all notes
nb ls
nb list

# List with details
nb ls --long

# List recent notes (newest first)
nb ls --reverse

# Limit results
nb ls --reverse --limit 10

# List specific notebook
nb notebook-name:ls
```

Use the helper function for recent notes:

```fish
# Show 10 most recent notes
nb-recent

# Show 5 most recent notes
nb-recent 5
```

### Deleting Notes

Remove notes with confirmation:

```fish
# Delete with prompt
nb delete 3

# Force delete without confirmation
nb delete 3 --force

# Delete by title
nb delete "old-note"
```

## TODO Task Management

### Creating TODOs

Add TODO items for task tracking. **Important**: All todos must be stored in the `tasks/` folder:

```fish
# Add todo in tasks folder (required by local rule)
nb add tasks/ "TODO: Complete project documentation"
nb add tasks/ "TODO: Review pull requests"

# Add todo with tags in tasks folder
nb add tasks/ "TODO: Finish report #urgent #work"

# Using nb todo command (ensure it goes to tasks folder)
nb todo add "Complete project documentation"
# Note: Configure nb to store todos in tasks/ folder

# Quick todo with helper (configured to use tasks folder)
nt "Task description"
```

### Listing TODOs

View tasks with status filtering. Todos are stored in the `tasks/` folder:

```fish
# List all todos from tasks folder
nb ls tasks/
nb list tasks/

# List with search pattern
nb search "TODO" tasks/

# List open todos only
nb todo list --open
ntl  # Using helper

# List completed todos
nb todo list --closed

# List todos with grep
nb ls tasks/ | grep TODO
```

### Managing TODO Status

Mark tasks as complete or reopen:

```fish
# Mark as done
nb todo do 5
nb todo done 5
ntd 5  # Using helper

# Mark as undone
nb todo undo 5
nb todo undone 5

# Edit todo content
nb todo edit 5
```

## Searching and Referencing

### Full-Text Search

Search note content using keywords or patterns. By default, search displays matching lines with context:

```fish
# Basic search (displays matches with context)
nb search "keyword"
nb q "keyword"

# Regex search
nb search "pattern.*expression"

# List matching files only (without content)
nb search "keyword" --list
nb search "keyword" -l

# Search in specific notebook or folder
nb search notebook-name: "keyword"
nb search folder/ "keyword"

# AND search (all terms must match)
nb search "term1" "term2"
nb search "term1" --and "term2"

# OR search (any term matches)
nb search "term1|term2"
nb search "term1" --or "term2"

# NOT search (exclude terms)
nb search "include" --not "exclude"
```

### Tag-Based Search

Filter notes by tags:

```fish
# Search by tag
nb search "#project"
nb search --tag project
nb q "#urgent"

# Search hierarchical tags
nb search "#work/meetings"

# Using helper function
nb-tag project
nb-tag "work/meetings"
```

### Interactive Search and Edit

Combine search with editing using the helper:

```fish
# Search and interactively select note to edit
nse "meeting notes"

# Grep search with context
nb-grep "pattern"
```

## Notebook Management

### Creating and Switching Notebooks

Organize notes into separate notebooks:

```fish
# Create new notebook
nb notebooks add project-name

# List all notebooks
nb notebooks
nb notebooks list

# Switch to notebook
nb use project-name

# Show current notebook
nb notebooks current
```

### Local Notebooks

Create project-specific notebooks:

```fish
# Initialize local notebook in current directory
cd ~/projects/myproject
nb init

# Add notes to local notebook
nb add "Project Architecture"
```

### Project Notebook Setup

Use the helper to create structured project notebooks:

```fish
# Create project with folder structure
nb-project "my-project"

# Creates:
# - docs/ folder for documentation
# - meetings/ folder for meeting notes
# - tasks/ folder for TODO task lists (required by local rule)
# - references/ folder for reference materials
# - README index note with structure overview
```

## Bookmarking Web Content

### Creating Bookmarks

Save and archive web pages:

```fish
# Add bookmark from URL
nb https://example.com
nb bookmark https://example.com

# Add with title
nb bookmark https://example.com --title "Example Site"

# Add with comment and tags
nb bookmark https://example.com --comment "Useful resource" --tags "reference,documentation"

# Quick bookmark with helper
nb-bookmark "https://example.com" "reference" "documentation"
```

### Managing Bookmarks

Work with saved bookmarks:

```fish
# List bookmarks
nb bookmarks

# Open in browser
nb open 10

# View cached content
nb peek 10

# Search bookmarks
nb bookmark search "keyword"
```

## Advanced Organization

### Folder Structure

Organize notes hierarchically:

```fish
# Create folder
nb add folder project/documentation/

# Add note to folder
nb add project/documentation/ "API Guide"

# List folder contents
nb ls project/

# Move note to folder
nb move 3 project/documentation/
```

### Wiki-Style Linking

Create connections between notes:

```fish
# In note content, use:
[[Note Title]]  # Link by title
[[123]]         # Link by ID

# View note with links highlighted
nb show 3 --links

# Browse linked notes in web interface
nb browse --links
```

### Tagging Strategy

Implement effective tagging:

```fish
# Add tags in note content
#project #urgent #work

# Use hierarchical tags
#work/projects/client-x
#personal/health/fitness

# Search multiple tags
nb search "#work #urgent"
```

## History and Syncing

### Version History

Access Git-backed versioning:

```fish
# View note history
nb history 3

# Show detailed git log
nb git log -- path/to/note.md

# Restore previous version
nb history 3 --restore <commit-hash>
```

### Remote Synchronization

Sync with remote repository:

```fish
# Set remote for current notebook
nb remote set https://github.com/user/notes.git

# Push changes
nb sync
nb push

# Pull changes
nb sync
nb pull

# Using helper
nb-sync
```

## Fish Shell Integration

### Setting Up Helpers

Load helper functions for enhanced productivity:

```fish
# Source helper functions
source ${CLAUDE_PLUGIN_ROOT}/examples/nb-helpers.fish

# Or add to ~/.config/fish/config.fish
source /path/to/nb-tools/skills/nb/examples/nb-helpers.fish
```

Available helper functions:

- `nn` - Quick note creation
- `nb-daily` - Create/open daily note
- `nb-meeting` - Create meeting note with template
- `nt` - Quick todo addition
- `ntl` - List open todos
- `ntd` - Mark todo as done
- `nse` - Search and edit interactively
- `nb-recent` - List recent notes
- `nb-tag` - Search by tag
- `nb-stats` - Show statistics
- `nb-project` - Create structured project notebook
- `nb-select` - Interactive notebook selection
- `nb-sync` - Sync with remote

### Abbreviations

Set up convenient abbreviations:

```fish
abbr -a n nb
abbr -a na 'nb add'
abbr -a nl 'nb ls'
abbr -a ns 'nb search'
abbr -a ne 'nb edit'
```

## Common Workflows

### Daily Note-Taking

Maintain daily notes for journaling:

```fish
# Create today's daily note
nb-daily

# If note exists, opens for editing
# If not, creates new note with date
```

### Project Documentation

Document project work:

```fish
# Initialize project notebook
cd ~/projects/myproject
nb init

# Add documentation notes with frontmatter (local rule)
set -l today (date +%Y-%m-%d)
set -l now (date +%Y-%m-%d\ %H:%M:%S)
nb add "Architecture Overview" <<EOF
---
Created: $today
Updated: $now.
Tags: #architecture, #docs
Status: #draft
---

# Architecture Overview
EOF

nb add docs/ "API Documentation" <<EOF
---
Created: $today
Updated: $now.
Tags: #api, #docs
Status: #draft
---

# API Documentation
EOF

# Add todos to tasks folder (local rule - no frontmatter for TODOs)
nb add tasks/ "TODO: Update documentation #docs"
nb add tasks/ "TODO: Write unit tests #testing"
```

### Meeting Notes

Capture meeting information:

```fish
# Create meeting note with template
nb-meeting "Weekly Standup"

# Template includes:
# - Date and time
# - Attendees list
# - Agenda items
# - Notes section
# - Action items
# - Next steps
```

### Knowledge Management

Build a personal knowledge base:

```fish
# Create topical notebooks
nb notebooks add tech
nb notebooks add personal
nb notebooks add work

# Add notes with tags and links (with frontmatter)
set -l today (date +%Y-%m-%d)
set -l now (date +%Y-%m-%d\ %H:%M:%S)
nb tech:add "Docker Best Practices" <<EOF
---
Created: $today
Updated: $now.
Tags: #devops, #containers
Status: #draft
---

# Docker Best Practices
EOF

nb work:add "Project X Notes" <<EOF
---
Created: $today
Updated: $now.
Tags: #project-x, #planning
Status: #draft
---

# Project X Notes

See also [[Docker Best Practices]]
EOF

# Search across notebooks
nb search "docker"
nb tech:search "containers"
```

### Research and Bookmarking

Collect and organize research:

```fish
# Bookmark resources
nb bookmark https://docs.example.com --tags "reference,documentation"

# Add research notes with frontmatter
set -l today (date +%Y-%m-%d)
set -l now (date +%Y-%m-%d\ %H:%M:%S)
nb add "Research Findings" <<EOF
---
Created: $today
Updated: $now.
Tags: #research, #topic
Status: #draft
---

# Research Findings

Link bookmarks: [[bookmark-title]] or [[bookmark-id]]
EOF

# Search bookmarked content
nb bookmark search "keyword"
```

## Utility Commands

### Statistics and Overview

View notebook information:

```fish
# Show statistics
nb-stats

# Count items
nb count

# Show current status
nb status
```

### Import and Export

Transfer notes between systems:

```fish
# Import file
nb import /path/to/file.md

# Import multiple files
nb import /path/to/folder/*.md

# Export note
nb export 3 /path/to/export.md

# Copy to clipboard (macOS)
nb show 3 --print | pbcopy
```

### Web Interface

Use GUI for browsing:

```fish
# Start web server
nb browse
nb b

# Browse specific notebook
nb notebook:browse

# Browse on custom port
nb browse --port 8080
```

## Additional Resources

### Reference Files

For detailed command reference and advanced features:

- **`references/commands.md`** - Comprehensive nb command documentation with all options, flags, and detailed examples

### Example Files

Working Fish shell scripts and functions:

- **`examples/nb-helpers.fish`** - Helper functions and abbreviations for Fish shell integration

### External Documentation

Official nb documentation:

- Homepage: <https://xwmx.github.io/nb/>
- GitHub: <https://github.com/xwmx/nb>

## Best Practices

### Note Organization

- Use descriptive titles for easy searching
- Implement consistent tagging strategy
- Create folder hierarchy for complex topics
- Use wiki links to connect related notes
- Maintain README/index notes for notebooks

### Task Management

- Add tags to todos for categorization
- Review open todos regularly with `ntl`
- Archive completed todos periodically
- Use specific, actionable todo descriptions
- Include due dates for time-sensitive tasks

### Search Efficiency

- Use specific keywords for better results
- Leverage tags for categorical searches
- Combine full-text and tag searches
- Use regex patterns for complex queries
- Create index notes with important search terms

### Backup and Sync

- Set up remote repository for backup
- Sync regularly with `nb-sync`
- Use separate notebooks for different sync needs
- Review sync status before important changes
- Keep local and remote in sync

### Fish Shell Tips

- Source helper functions in config.fish
- Set up abbreviations for common commands
- Create custom functions for workflows
- Use Fish completions (included with nb)
- Leverage Fish's interactive features

## Troubleshooting

### Common Issues

**Note not found:**

- Verify note ID or title with `nb ls`
- Check current notebook with `nb notebooks current`
- Search for note with `nb search "keyword"`

**Sync conflicts:**

- Pull changes before editing: `nb pull`
- Review conflicts with `nb status`
- Resolve manually in Git if needed

**Editor not opening:**

- Check EDITOR environment variable: `echo $EDITOR`
- Set editor: `set -x EDITOR vim`
- Or use `nb settings set editor vim`

**Performance issues:**

- Limit search results: `nb search "query" --limit 10`
- Archive old notes to separate notebook
- Use specific notebook for operations

## Summary

Use nb for command-line knowledge management with these key operations:

**Interactive Shell:**
- **Create**: `nb add "Title"` or `nn "Title"`
- **Edit**: `nb edit 3` or `nse "keyword"`
- **View**: `nb show 3` or `nb ls`
- **Search**: `nb search "query"` or `nb-tag tag`
- **TODO**: `nb todo add "Task"` or `nt "Task"`
- **Organize**: Use notebooks, folders, tags, and links
- **Sync**: `nb sync` or `nb-sync`

**Non-Interactive Environments (Claude Code):**
- **Create**: `nb add "Title" <<EOF\n...\nEOF`
- **View**: `nb show 3 --print` (always use --print)
- **Search**: `nb search "query"` (works as-is) or `nb search "query" --list` (for file paths only)
- **List**: `nb ls` or `nb list`
- **TODO**: `nb add tasks/ "TODO: Task"`
- **Delete**: `nb delete 3 --force` (use --force to skip confirmation)

Consult `references/commands.md` for complete command documentation and `examples/nb-helpers.fish` for Fish shell integration.

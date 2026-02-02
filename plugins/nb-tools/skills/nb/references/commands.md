# nb Command Reference

This reference provides detailed information about nb commands for note-taking, task management, and knowledge organization.

## Core Concepts

### Storage
- Notes are stored as plain text files (Markdown, Org, AsciiDoc, LaTeX)
- Data location: `~/.nb/` (global notebooks) or local `.nb/` directories
- Git-backed versioning for all changes
- Encrypted notes supported via OpenSSL or GPG

### Organization
- **Notebooks**: Separate collections of notes (default: "home")
- **Folders**: Directory structure within notebooks
- **Tags**: Hierarchical categorization (#tag, #parent/child)
- **Links**: Wiki-style cross-references [[note-title]]

## Note Management Commands

### Creating Notes

```fish
# Create a new note with editor
nb add

# Create note with title
nb add "Note Title"

# Create note from stdin/pipe
echo "Content" | nb add

# Create note with specific format
nb add --type org "Org Note"

# Create note in folder
nb add folder/subfolder/ "Title"

# Create note in specific notebook
nb notebook:add "Title"
```

### Listing Notes

```fish
# List all items
nb ls
nb list

# List with more details
nb ls --long
nb ls -l

# List specific notebook
nb notebook:ls

# List folder contents
nb ls folder/

# List with filtering
nb ls --type markdown
nb ls --tags

# Reverse order (newest first)
nb ls --reverse
```

### Viewing Notes

```fish
# View note by ID
nb show 3
nb 3

# View by title
nb show "note-title"

# Print raw content
nb show 3 --print
nb print 3

# View in pager
nb show 3 --pager

# View with syntax highlighting
nb show 3 --render
```

### Editing Notes

```fish
# Edit note by ID
nb edit 3
nb e 3

# Edit by title
nb edit "note-title"

# Edit with specific editor
nb edit 3 --editor vim

# Overwrite content
echo "New content" | nb edit 3 --overwrite
```

### Deleting Notes

```fish
# Delete note (with confirmation)
nb delete 3
nb d 3

# Force delete without confirmation
nb delete 3 --force
nb delete 3 -f

# Delete by title
nb delete "note-title"
```

### Searching Notes

```fish
# Full-text search
nb search "query"
nb q "query"

# Search with regex
nb search "pattern.*"

# Search in specific notebook
nb notebook:search "query"

# Search and show context
nb search "query" --context 3

# List files matching query
nb search "query" --list
```

## TODO Task Management

### Creating TODOs

```fish
# Add a todo item
nb todo add "Task description"
nb todo a "Task description"

# Add todo with due date
nb todo add "Task" --due "2024-12-31"

# Add todo with tags
nb todo add "Task #project #urgent"
```

### Listing TODOs

```fish
# List all todos
nb todo
nb todos
nb todo list

# List open todos
nb todo list --open

# List completed todos
nb todo list --closed
```

### Managing TODOs

```fish
# Mark todo as done
nb todo do 5
nb todo done 5

# Mark todo as undone
nb todo undo 5
nb todo undone 5

# Edit todo
nb todo edit 5
```

## Bookmark Management

### Creating Bookmarks

```fish
# Add bookmark from URL
nb https://example.com
nb bookmark https://example.com

# Add bookmark with title
nb bookmark https://example.com --title "Example Site"

# Add bookmark with comment
nb bookmark https://example.com --comment "Useful resource"

# Add bookmark with tags
nb bookmark https://example.com --tags "reference,documentation"
```

### Managing Bookmarks

```fish
# List bookmarks
nb bookmarks
nb bookmark list

# Open bookmark in browser
nb open 10
nb o 10

# Search bookmarks
nb bookmark search "query"

# Peek at cached content
nb peek 10
```

## Notebook Management

### Creating and Switching

```fish
# Create new notebook
nb notebooks add project-name
nb notebooks new project-name

# List notebooks
nb notebooks
nb notebooks list

# Switch to notebook
nb use project-name
nb notebook use project-name

# Show current notebook
nb notebooks current
```

### Notebook Operations

```fish
# Create local notebook in current directory
nb notebooks init
nb init

# Archive notebook
nb notebooks archive old-project

# Delete notebook
nb notebooks delete old-project
```

## Advanced Features

### Folders

```fish
# Create folder
nb add folder folder-name/

# List folder contents
nb ls folder-name/

# Move note to folder
nb move 3 folder-name/

# Copy note to folder
nb copy 3 folder-name/
```

### Tagging

```fish
# Add tags to note (in content as #tag)
nb edit 3  # Add #tag in content

# Search by tag
nb search "#project"
nb q "#urgent"

# List all tags
nb search --tags
```

### Linking

```fish
# Create wiki-style link in note content
# Use [[title]] or [[id]] format

# Show backlinks to note
nb show 3 --links

# Browse linked notes
nb browse --links
```

### History and Versions

```fish
# Show note history
nb history 3
nb h 3

# Show git log for note
nb git log -- path/to/note.md

# Restore previous version
nb history 3 --restore <commit-hash>
```

### Syncing

```fish
# Set remote for notebook
nb remote set https://github.com/user/notes.git

# Push changes
nb sync
nb push

# Pull changes
nb sync
nb pull

# Show sync status
nb status
```

## Utility Commands

### Search and Filter

```fish
# Count items
nb count
nb ls --count

# Filter by type
nb ls --type markdown
nb ls --type todo

# Filter by date
nb ls --sort modified
nb ls --after "2024-01-01"
nb ls --before "2024-12-31"
```

### Import and Export

```fish
# Import file
nb import /path/to/file.md

# Import multiple files
nb import /path/to/folder/*.md

# Export note
nb export 3 /path/to/export.md

# Copy note content to clipboard
nb show 3 --print | pbcopy
```

### Web Interface

```fish
# Start web server (GUI interface)
nb browse
nb b

# Browse specific notebook
nb notebook:browse

# Browse on specific port
nb browse --port 8080
```

## Configuration

### Settings

```fish
# Show configuration
nb settings

# Set default editor
nb settings set editor vim

# Set color theme
nb settings set color-theme ocean

# Set default extension
nb settings set default_extension md
```

### Environment Variables

```fish
# Set in Fish shell config
set -x EDITOR vim
set -x NB_DIR "$HOME/.nb"
set -x NB_AUTO_SYNC 1
```

## Common Workflows

### Quick Note Taking

```fish
# Quick note from command line
nb add "Meeting Notes" << EOF
# Meeting with Team
- Discussed project timeline
- Action items: ...
EOF
```

### Daily Notes

```fish
# Create daily note
nb add "Daily-"(date +%Y-%m-%d)".md"

# Or use a function in Fish
function nb-daily
    nb add "Daily-"(date +%Y-%m-%d)".md"
end
```

### Project-Specific Notes

```fish
# Initialize local notebook in project directory
cd ~/projects/myproject
nb init

# Add project notes
nb add "Architecture Notes"
nb todo add "Implement feature X"
```

### Knowledge Base

```fish
# Create topical notebooks
nb notebooks add tech
nb notebooks add personal
nb notebooks add work

# Use tags for cross-cutting themes
nb tech:add "Docker Tips #devops #containers"
nb work:add "Meeting Notes #project-x #planning"
```

## Tips and Best Practices

### File Naming
- Use descriptive titles for easy searching
- Leverage folders for hierarchical organization
- Use consistent date formats (YYYY-MM-DD)

### Tagging Strategy
- Use hierarchical tags: #project/subproject
- Keep tags lowercase and hyphenated
- Create a tagging convention document

### Linking Notes
- Use wiki links [[title]] for cross-references
- Create index notes with links to related content
- Use backlinks to discover connections

### Search Effectively
- Use specific keywords for better results
- Leverage regex for complex patterns
- Combine tags and full-text search

### Sync and Backup
- Set up remote git repository for backup
- Use `nb sync` regularly
- Consider separate notebooks for different sync needs

## Integration with Fish Shell

### Useful Abbreviations

```fish
# Add to ~/.config/fish/config.fish
abbr -a n nb
abbr -a na 'nb add'
abbr -a nl 'nb ls'
abbr -a ns 'nb search'
abbr -a ne 'nb edit'
abbr -a nt 'nb todo'
abbr -a nta 'nb todo add'
abbr -a ntl 'nb todo list'
```

### Custom Functions

```fish
# Quick note function
function nn
    nb add $argv
end

# Quick todo function
function nt
    nb todo add $argv
end

# Search and edit function
function nse
    set -l results (nb search --list $argv)
    if test (count $results) -eq 1
        nb edit $results[1]
    else
        echo $results
    end
end
```

### Completions

nb includes Fish shell completions automatically when installed via:
- Homebrew
- Manual installation to `/usr/local/bin/`

Completions provide tab completion for commands, notebooks, and note IDs.

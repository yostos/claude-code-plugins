#!/usr/bin/env fish
# nb helper functions for Fish shell
# Source this file or add these functions to your ~/.config/fish/config.fish

# Quick abbreviations for common nb commands
abbr -a n nb
abbr -a na 'nb add'
abbr -a nl 'nb ls'
abbr -a ns 'nb search'
abbr -a ne 'nb edit'
abbr -a nt 'nb todo'
abbr -a nta 'nb todo add'
abbr -a ntl 'nb todo list'
abbr -a nb 'nb browse'

# Create a new note with a title
function nn --description 'Quick note creation'
    if test (count $argv) -eq 0
        echo "Usage: nn <title>"
        return 1
    end
    nb add "$argv"
end

# Create a daily note
function nb-daily --description 'Create daily note with today\'s date'
    set -l date_str (date +%Y-%m-%d)
    set -l title "Daily-$date_str"

    # Check if daily note already exists
    if nb list | grep -q $title
        echo "Daily note for $date_str already exists. Opening..."
        nb edit $title
    else
        echo "Creating daily note for $date_str..."
        nb add $title
    end
end

# Create a meeting note
function nb-meeting --description 'Create meeting note with template'
    if test (count $argv) -eq 0
        echo "Usage: nb-meeting <meeting-title>"
        return 1
    end

    set -l date_str (date +%Y-%m-%d)
    set -l title "Meeting-$date_str-$argv"

    # Create note with template
    nb add $title <<EOF
# $argv

**Date:** $date_str
**Time:** (time)

## Attendees
-

## Agenda
1.

## Notes


## Action Items
- [ ]

## Next Steps

EOF

    echo "Created meeting note: $title"
end

# Quick todo addition
function nt --description 'Quick todo creation'
    if test (count $argv) -eq 0
        echo "Usage: nt <task-description>"
        return 1
    end
    nb todo add "$argv"
end

# List open todos
function ntl --description 'List open todos'
    nb todo list --open
end

# Mark todo as done by searching
function ntd --description 'Mark todo as done'
    if test (count $argv) -eq 0
        echo "Usage: ntd <todo-id>"
        return 1
    end
    nb todo do $argv[1]
end

# Search notes and open in editor
function nse --description 'Search and edit note'
    if test (count $argv) -eq 0
        echo "Usage: nse <search-query>"
        return 1
    end

    set -l results (nb search --list "$argv")
    set -l count (count $results)

    if test $count -eq 0
        echo "No results found for: $argv"
        return 1
    else if test $count -eq 1
        echo "Opening: $results[1]"
        nb edit $results[1]
    else
        echo "Multiple results found:"
        for i in (seq (count $results))
            echo "[$i] $results[$i]"
        end
        echo ""
        read -P "Select number to edit (or Enter to cancel): " -l selection
        if test -n "$selection"; and test $selection -ge 1; and test $selection -le $count
            nb edit $results[$selection]
        end
    end
end

# Quick bookmark with tags
function nb-bookmark --description 'Quick bookmark creation with tags'
    if test (count $argv) -lt 1
        echo "Usage: nb-bookmark <url> [tags...]"
        return 1
    end

    set -l url $argv[1]
    set -l tags ""

    if test (count $argv) -gt 1
        set tags (string join "," $argv[2..-1])
        nb bookmark $url --tags $tags
    else
        nb bookmark $url
    end
end

# List recent notes
function nb-recent --description 'List recent notes'
    set -l limit 10
    if test (count $argv) -gt 0
        set limit $argv[1]
    end
    nb ls --reverse --limit $limit
end

# Search notes by tag
function nb-tag --description 'Search notes by tag'
    if test (count $argv) -eq 0
        echo "Usage: nb-tag <tag-name>"
        return 1
    end

    set -l tag $argv[1]
    if not string match -q "#*" $tag
        set tag "#$tag"
    end

    nb search $tag
end

# Show note statistics
function nb-stats --description 'Show notebook statistics'
    echo "=== Notebook Statistics ==="
    echo ""
    echo "Total notes: "(nb count)
    echo "Notebooks: "(nb notebooks list | wc -l)
    echo "Open todos: "(nb todo list --open | wc -l)
    echo "Completed todos: "(nb todo list --closed | wc -l)
    echo ""
    echo "Recent activity:"
    nb ls --reverse --limit 5
end

# Archive old notes to specific notebook
function nb-archive --description 'Archive old notes to archive notebook'
    if test (count $argv) -eq 0
        echo "Usage: nb-archive <note-id>"
        return 1
    end

    # Create archive notebook if it doesn't exist
    if not nb notebooks list | grep -q "archive"
        echo "Creating archive notebook..."
        nb notebooks add archive
    end

    # Move note to archive
    set -l note_id $argv[1]
    echo "Archiving note $note_id..."
    nb move $note_id archive:
end

# Sync notebook with remote
function nb-sync --description 'Sync notebook with remote repository'
    echo "Syncing notebook..."
    nb sync
    if test $status -eq 0
        echo "Sync completed successfully"
    else
        echo "Sync failed"
        return 1
    end
end

# Create project notebook with structure
function nb-project --description 'Create project notebook with folder structure'
    if test (count $argv) -eq 0
        echo "Usage: nb-project <project-name>"
        return 1
    end

    set -l project_name $argv[1]

    echo "Creating project notebook: $project_name"
    nb notebooks add $project_name

    # Switch to new notebook
    nb use $project_name

    # Create folder structure
    echo "Creating folder structure..."
    nb add folder docs/
    nb add folder meetings/
    nb add folder tasks/
    nb add folder references/

    # Create initial index note
    nb add "README" <<EOF
# $project_name

## Overview
Project overview and description

## Structure
- **docs/**: Documentation and technical notes
- **meetings/**: Meeting notes and minutes
- **tasks/**: Task lists and action items
- **references/**: Reference materials and links

## Quick Links
- [[docs/index]]
- [[meetings/index]]
- [[tasks/index]]

## Tags
#$project_name
EOF

    echo "Project notebook '$project_name' created successfully"
    echo "Current notebook: "(nb notebooks current)
end

# Export notes to different formats (requires pandoc)
function nb-export --description 'Export note to different format'
    if test (count $argv) -lt 2
        echo "Usage: nb-export <note-id> <format> [output-file]"
        echo "Formats: pdf, html, docx, org"
        return 1
    end

    set -l note_id $argv[1]
    set -l format $argv[2]
    set -l output ""

    if test (count $argv) -gt 2
        set output $argv[3]
    else
        set output "note-$note_id.$format"
    end

    # Check if pandoc is installed
    if not command -v pandoc >/dev/null
        echo "Error: pandoc is required for export. Install with: brew install pandoc"
        return 1
    end

    echo "Exporting note $note_id to $format..."
    nb show $note_id --print | pandoc -f markdown -t $format -o $output

    if test $status -eq 0
        echo "Exported to: $output"
    else
        echo "Export failed"
        return 1
    end
end

# Interactive notebook selection
function nb-select --description 'Interactively select and switch notebook'
    set -l notebooks (nb notebooks list)
    set -l current (nb notebooks current)

    echo "=== Select Notebook ==="
    echo "Current: $current"
    echo ""

    set -l i 1
    for notebook in $notebooks
        if test $notebook = $current
            echo "[$i] * $notebook (current)"
        else
            echo "[$i]   $notebook"
        end
        set i (math $i + 1)
    end

    echo ""
    read -P "Select notebook number (or Enter to cancel): " -l selection

    if test -n "$selection"; and test $selection -ge 1; and test $selection -le (count $notebooks)
        set -l selected $notebooks[$selection]
        echo "Switching to: $selected"
        nb use $selected
    end
end

# Quick grep search in notes content
function nb-grep --description 'Grep search in all notes'
    if test (count $argv) -eq 0
        echo "Usage: nb-grep <pattern>"
        return 1
    end

    nb search "$argv" --context 2
end

# Show note with formatting
function nb-show --description 'Show note with formatting'
    if test (count $argv) -eq 0
        echo "Usage: nb-show <note-id>"
        return 1
    end

    nb show $argv[1] --render
end

echo "nb helper functions loaded successfully"
echo "Available commands: nn, nb-daily, nb-meeting, nt, ntl, ntd, nse, nb-bookmark, nb-recent, nb-tag, nb-stats, nb-archive, nb-sync, nb-project, nb-export, nb-select, nb-grep, nb-show"

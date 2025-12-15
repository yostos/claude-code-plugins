# Claude Code Plugins Repository - Development Guidelines

Important rules and guidelines when developing Claude Code plugins in this repository.

## Critical Rules and Guidelines

### Judging File Importance

**CRITICAL**: The `.claude-plugin/` directory and its contents are essential metadata required for plugin installation and distribution.

- `.claude-plugin/plugin.json` is a mandatory file for plugin installation
- Do NOT treat these files as "temporary files" or "cache"
- Do NOT add them to `.gitignore`
- ALWAYS include them in version control

**Decision Criteria**:
- If the purpose of a file is unclear, investigate first before suggesting deletion or exclusion
- `.claude-plugin/` directories inside plugin directories are ALWAYS important
- Check git history to verify if the file was intentionally added
- When in doubt, ask the user before making assumptions about file importance

### Documentation File Format

**NO Emojis in README.md and CHANGELOG.md**:
- Do not use emojis in README.md or CHANGELOG.md
- Describe clearly with text only
- Maintain professional and readable documentation

**Examples**:
```markdown
# Good
## Features
- Automated commit message generation
- Conventional Commits format support

# Bad
## Features
- 🚀 Automated commit message generation
- ✨ Conventional Commits format support
```

### Author Information in Git Commits

**Do NOT include Claude Code as author or co-author**:
- Do not include `Co-Authored-By: Claude` or similar attribution in commit messages
- Using Claude Code is a personal choice and does not need to be recorded in commit history
- Commits should be recorded as contributions by individual developers only

**Examples**:
```bash
# Good
git commit -m "feat: add simple-commit plugin"

# Bad
git commit -m "feat: add simple-commit plugin

Co-Authored-By: Claude Code <noreply@anthropic.com>"
```

### Pre-Change Verification

Before making any changes:

1. **Read existing files**: Always read the relevant files to understand their content before proposing changes
2. **Check git history**: Verify whether files were intentionally added
3. **Understand project structure**: Understand the role of files within the project

## Plugin Development Best Practices

### Plugin Structure

Each plugin follows this structure:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Required: Plugin metadata
├── commands/                # Slash command definitions
├── agents/                  # Agent definitions (optional)
├── skills/                  # Skill definitions (optional)
├── hooks/                   # Hook definitions (optional)
├── .gitignore              # Plugin-specific exclusions
├── Claude.md               # Plugin specification (optional)
├── README.md               # Plugin documentation
└── LICENSE                 # License information
```

### .claude-plugin/plugin.json

This file is mandatory for plugin distribution and installation:

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Plugin description",
  "author": {
    "name": "Author name"
  },
  "keywords": ["keyword1", "keyword2"]
}
```

## Release Process

1. Implement and test changes
2. Update CHANGELOG.md (no emojis)
3. Update version
4. Create git tag
5. Push to remote

See each plugin's README.md for detailed instructions.

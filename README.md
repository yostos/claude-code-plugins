# Claude Code Plugins

[![GitHub Release](https://img.shields.io/github/v/release/yostos/claude-code-plugins)](https://github.com/yostos/claude-code-plugins/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Plugins](https://img.shields.io/badge/plugins-5-green.svg)](#plugins)

A collection of plugins that extend Claude Code with decision support, journaling, commit automation, and PDF processing.

## Plugins

### MAGI - Multi-Agent Decision Support

Analyzes problems from three independent perspectives -- scientific/technical, legal/ethical, and emotional/trend -- then synthesizes them into a structured recommendation with majority voting. When opinions split 2-1, an optional deliberation phase enables structured debate between agents before revoting.

The deliberation phase uses Agent Teams (experimental, requires Max plan as of February 2026, disabled by default). See the [MAGI documentation](./plugins/magi/README.md) for setup instructions. Without it, the plugin still works with standard majority voting.

Useful when you need to evaluate trade-offs from multiple angles before making a decision.

[Documentation](./plugins/magi/README.md)

### simple-commit - Conventional Commits Automation

Reads your staged changes and generates a commit message in Conventional Commits format. Also automates the release process (CHANGELOG generation, tagging, push).

Eliminates the friction of writing commit messages while keeping them consistent.

[Documentation](./plugins/simple-commit/README.md)

### jrnl-tools - Developer Work Journal

Integrates Claude Code with [jrnl](https://jrnl.sh/) to provide session handoffs, work logging, and cross-project status tracking. Records what you did, what you decided, and what to do next -- as chronological journal entries accessible from any project or directly via the jrnl CLI.

Complementary to Claude Code's Auto Memory: Auto Memory remembers stable project knowledge; jrnl-tools records the flow of your daily work.

[Documentation](./plugins/jrnl-plugin/README.md)

### pdf-processor - Scanned PDF Processing

Merges multiple PDFs, runs OCR with Tesseract, and applies table of contents / bookmarks. Handles the entire workflow from raw scanned pages to a searchable, navigable PDF.

[Documentation](./plugins/pdf-processor/README.md)

## Installation

Requires [Claude Code](https://claude.com/claude-code).

```bash
# Install individual plugins directly from GitHub
claude plugin add yostos/claude-code-plugins/plugins/magi
claude plugin add yostos/claude-code-plugins/plugins/simple-commit
claude plugin add yostos/claude-code-plugins/plugins/jrnl-plugin
claude plugin add yostos/claude-code-plugins/plugins/pdf-processor
```

See each plugin's README for prerequisites and detailed usage.

## Development

See [CLAUDE.md](./CLAUDE.md) for development guidelines.

## Author

Toshiyuki Yoshida

## License

MIT

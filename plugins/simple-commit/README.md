# simple-commit

ステージされた変更を分析してConventional Commits形式のコミットメッセージを自動生成し、コミットを実行するClaude Codeプラグイン。

## 特徴

- ステージされた変更を自動分析
- Conventional Commits形式（`feat:`, `fix:`など）のメッセージを自動生成
- 最近のコミット履歴からスタイルを学習
- 50文字以内の簡潔なメッセージ
- 絵文字や装飾なし
- シンプルで素早い操作

## インストール

```bash
# このプラグインディレクトリをClaude Codeで使用
cc --plugin-dir /path/to/simple-commit
```

または、`.claude-plugin/` ディレクトリにコピー：

```bash
cp -r simple-commit ~/.claude/plugins/
```

## 使い方

1. 変更をステージング：
```bash
git add .
```

2. コミットコマンドを実行：
```
/commit
```

コマンドが以下を自動実行：
- `git status` でステージング状態を確認
- `git diff --staged` で変更内容を分析
- `git log --oneline -5` で最近のコミットスタイルを学習
- Conventional Commits形式のメッセージを生成
- コミットを実行

## コミットメッセージ形式

- **Conventional Commits準拠**（`fix:`, `feat:`, `docs:`, `refactor:`など）
- **50文字以内推奨**
- **最近のコミット履歴のスタイルに従う**
- **絵文字不要**
- **"Generated with Claude Code"などの装飾なし**

## 例

```bash
# 変更をステージング
git add src/auth.ts

# コミット実行
/commit
# → "fix: resolve authentication timeout issue"
```

## Prerequisites

- [Claude Code CLI](https://claude.com/claude-code) installed and configured
- Git 2.0 or higher
- Must be run within a Git repository

## Project Structure

```
simple-commit/
├── .claude-plugin/
│   └── plugin.json         # Plugin metadata
├── commands/
│   └── commit.md          # Commit command definition
├── README.md              # This file
├── LICENSE                # MIT License
└── .gitignore            # Version control settings
```

## Detailed Usage Examples

### Basic Workflow

```bash
# 1. Edit files
vim src/auth.ts

# 2. Review changes
git diff

# 3. Stage changes
git add src/auth.ts

# 4. Auto-commit with Claude Code
/commit
# → Command analyzes changes, generates appropriate message, and commits
```

### Example Generated Commit Messages

**For new features:**
```
feat: add user authentication
```

**For bug fixes:**
```
fix: resolve authentication timeout issue
```

**For documentation updates:**
```
docs: update API documentation
```

**For refactoring:**
```
refactor: simplify error handling logic
```

**For tests:**
```
test: add unit tests for auth module
```

### Multiple File Changes

```bash
# Stage multiple files
git add src/auth.ts src/utils.ts tests/auth.test.ts

# Execute commit
/commit
# → Analyzes all changes and generates the most appropriate message
```

## Troubleshooting

### Command not found

**Symptom:** `/commit` command is not available

**Solution:**
1. Restart Claude Code
2. Verify plugin is installed: `/plugin list`
3. Check marketplace is properly added: `/plugin marketplace list`

### No staged changes

**Symptom:** "Error: No staged changes found" is displayed

**Solution:**
```bash
# Check status
git status

# Stage files
git add <file>

# Try commit again
/commit
```

### Commit message doesn't match expectations

**Symptom:** Generated message is not appropriate

**Solution:**
- The command learns style from recent commit history
- For better messages, maintain consistent style in past commits
- You can manually edit with `git commit --amend` if needed

### Commit fails to execute

**Symptom:** Commit fails with error

**Solution:**
1. Check Git configuration:
   ```bash
   git config user.name
   git config user.email
   ```
2. If not configured:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

## FAQ

**Q: What is Conventional Commits?**
A: Conventional Commits is a specification for commit messages with clear rules. It uses prefixes like `feat:`, `fix:` to clarify the type of change. See https://www.conventionalcommits.org/ for details.

**Q: Can I manually edit commit messages?**
A: Yes. You can use `git commit --amend` after committing. However, this plugin is designed for simple and fast operations, so using auto-generated messages as-is is recommended.

**Q: Can I include emojis in messages?**
A: This plugin is designed to generate simple messages without emojis. If you need emojis, commit manually or edit the command definition.

**Q: What happens with multiple change types?**
A: The plugin automatically determines the primary change type. When multiple types exist, it prioritizes the most significant change (e.g., new features). For granular control, commit changes separately.

**Q: What's the message length limit?**
A: Recommended is under 50 characters, but it may exceed if necessary. The plugin prioritizes brevity while ensuring the change is clearly communicated.

**Q: How does it learn commit history style?**
A: The command references the last 5 commits using `git log --oneline -5`, analyzes their language (Japanese/English) and expression style, and generates messages accordingly.

**Q: Does it automatically push?**
A: No. This plugin only performs local commits. Push manually with `git push`.

## Design Philosophy

This plugin is designed based on the following principles:

1. **Simplicity**: Complete commits with minimal operations
2. **Consistency**: Adherence to Conventional Commits standard
3. **Speed**: Uses fast Haiku model
4. **Non-intrusive**: No decorations like "Generated with Claude Code"
5. **Adaptive**: Learns from repository's existing style

## Customization

To customize command behavior, edit `commands/commit.md`.

Examples:
- Change commit message format
- Use different model (`model: sonnet`, etc.)
- Implement additional validation

## Contributing

This is a personal project, but feedback and suggestions are welcome.

## License

MIT License - See LICENSE file for details

## Author

yostos

## Version

0.1.0

## Update History

- 2024-12-12: Initial release - Auto-commit with Conventional Commits format

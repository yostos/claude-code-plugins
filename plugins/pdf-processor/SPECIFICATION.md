# PDF処理Plugin - 開発者向け仕様書

> **言語について**: このドキュメントは日本語で記述されています。
>
> **Document Language**: This specification is written in Japanese.
>
> **対象読者**: 開発者とコントリビューター向けの技術仕様書です。
> エンドユーザー向けの使用方法は [README.md](README.md) を参照してください（英語）。

## 1. 概要

スキャンで作成した複数のPDFファイルを処理するClaude Code Pluginです。
人による目次作成作業を挟むため、**2つのCommand**に分かれています。

### 設計思想

- **Bash Shell Scriptによる実装**: Python依存を排除し、標準的なUnixツール（pdftk、ocrmypdf）を直接使用
- **2段階処理**: OCR処理と目次作成を分離し、人間によるレビューと編集を可能に
- **エラーハンドリング**: set -eによる早期終了と詳細なエラーメッセージ
- **クロスプラットフォーム**: macOSとLinux両方で動作

## 2. Plugin構成

### プラグイン名
`pdf-processor`

### ディレクトリ構造
```
pdf-processor/
├── .claude-plugin/
│   └── plugin.json           # プラグインメタデータ
├── commands/
│   ├── preprocess.md         # /pdf-processor:preprocess
│   └── apply-toc.md          # /pdf-processor:apply-toc
├── scripts/
│   ├── pdf_preprocess.sh     # 前処理スクリプト
│   └── pdf_apply_toc.sh      # 目次適用スクリプト
├── README.md                 # 使用方法
├── LICENSE                   # ライセンス情報
└── sample_toc.txt            # 目次情報サンプル
```

## 3. Plugin メタデータ

### .claude-plugin/plugin.json
```json
{
  "name": "pdf-processor",
  "description": "スキャンPDFのマージ、OCR処理、目次作成を行うツール",
  "version": "1.0.0",
  "author": {
    "name": "yostos"
  },
  "homepage": "https://github.com/yostos/claude-code-plugins",
  "repository": {
    "type": "git",
    "url": "https://github.com/yostos/claude-code-plugins.git"
  }
}
```

## 4. 前提条件

### 必要なツール
- `pdftk-java`: PDFの結合と目次作成に使用
- `ocrmypdf`: OCR処理と最適化に使用
- `tesseract-lang`: OCRエンジン（日本語対応）

### インストール方法（macOS）
```bash
brew install pdftk-java
brew install ocrmypdf
brew install tesseract-lang
```

### インストール方法（Linux）
```bash
sudo apt-get update
sudo apt-get install pdftk
sudo apt-get install ocrmypdf
sudo apt-get install tesseract-ocr tesseract-ocr-jpn
```

## 5. Claude Codeコマンド定義

### Command 1: 前処理コマンド

コマンド定義の詳細は [commands/preprocess.md](commands/preprocess.md) を参照してください。

**役割**: 複数のPDFをマージしてOCR処理を実行し、メタデータテンプレートを生成

**使用モデル**: Haiku（処理がシンプルなため、高速・低コストなHaikuモデルを使用）

### Command 2: 目次適用コマンド

コマンド定義の詳細は [commands/apply-toc.md](commands/apply-toc.md) を参照してください。

**役割**: OCR済みPDFに編集済みメタデータ（目次情報）を適用して最終版PDFを生成

**使用モデル**: Haiku（処理がシンプルなため、高速・低コストなHaikuモデルを使用）

## 6. Bashスクリプト仕様

### 6.1 scripts/pdf_preprocess.sh

#### 機能
1. PDFのマージ
2. OCR処理と最適化
3. メタデータのダンプ
4. 中間ファイルの自動削除
5. 進捗表示（ocrmypdfの標準出力を利用）

#### コマンドライン引数
```bash
bash pdf_preprocess.sh [OPTIONS] INPUT_FILES...

必須引数:
  INPUT_FILES           処理するPDFファイル（複数指定可能）

オプション引数:
  -o, --output-name     出力ファイル名のベース（デフォルト: output）
  -d, --directory       入力ディレクトリ（全PDFを処理）
  --skip-ocr-if-present 既にOCR済みのページをスキップ
  --optimize-level      最適化レベル 0-3（デフォルト: 3）
  -h, --help            ヘルプメッセージを表示
```

#### 処理フロー
```
1. 環境チェック
   - pdftk --version
   - ocrmypdf --version
   - tesseract --version

2. PDFマージ
   - pdftk input1.pdf input2.pdf ... cat output {name}_merged.pdf

3. OCR処理（進捗表示付き）
   - ocrmypdf -l jpn --optimize 3 {name}_merged.pdf {name}_ocr.pdf
   - ocrmypdfの標準出力で進捗が表示される

4. メタデータダンプ
   - pdftk {name}_ocr.pdf dump_data_utf8 output {name}_metadata_template.txt

5. クリーンアップ
   - rm -f {name}_merged.pdf
```

#### 実装の特徴
- シェルスクリプト（Bash）で実装
- エラー発生時は即座に終了（set -e）
- 引数解析はwhileループとcase文で実装
- ファイルの存在確認と検証を実行前に実施

### 6.2 scripts/pdf_apply_toc.sh

#### 機能
1. 目次情報の適用
2. 最終版PDF生成

#### コマンドライン引数
```bash
bash pdf_apply_toc.sh [OPTIONS] OCR_PDF METADATA_FILE

必須引数:
  OCR_PDF              OCR処理済みPDFファイル
  METADATA_FILE        編集済みメタデータファイル

オプション引数:
  -o, --output         出力ファイル名（デフォルト: {元}_final.pdf）
  --cleanup            一時ファイルを削除
  -h, --help           ヘルプメッセージを表示
```

#### 処理フロー
```
1. ファイル存在確認
   - OCR PDFファイルが存在するか
   - メタデータファイルが存在するか
   - メタデータに"BookmarkBegin"が含まれているか（grepで確認）

2. 目次適用
   - pdftk {ocr_pdf} update_info_utf8 {metadata} output {name}_final.pdf

3. 完了報告
   - 最終PDFのパスを表示
```

#### 実装の特徴
- シェルスクリプト（Bash）で実装
- エラー発生時は即座に終了（set -e）
- 出力ファイル名の自動生成（_ocr.pdfを_final.pdfに変換）
- オプションでクリーンアップ機能を提供

## 7. エラーハンドリング

### チェック項目
1. 必要なツールのインストール確認
2. 入力ファイルの存在確認
3. 入力ファイルの有効性確認（PDFとして開けるか）
4. ディスク容量の確認
5. 各処理ステップの成功/失敗

### エラーメッセージ例
```
# ツール未インストール
"エラー: pdftk-javaがインストールされていません。
インストール方法: brew install pdftk-java"

# ファイルが存在しない
"エラー: 指定されたファイルが見つかりません: page1.pdf"

# 無効なPDF
"エラー: page1.pdfは有効なPDFファイルではありません"

# メタデータに目次情報がない
"警告: メタデータファイルに目次情報（BookmarkBegin）が見つかりません。
目次を追加してから再実行してください。"
```

## 8. 目次情報の編集方法

### メタデータファイルの構造

`{名前}_metadata_template.txt`には既存のPDF情報が含まれています。
ユーザーは**ファイル末尾**に以下の形式で目次情報を追加します。

### 目次の記述形式

```
BookmarkBegin
BookmarkTitle: 第1章 イントロダクション
BookmarkLevel: 1
BookmarkPageNumber: 1

BookmarkBegin
BookmarkTitle: 1.1 背景
BookmarkLevel: 2
BookmarkPageNumber: 3

BookmarkBegin
BookmarkTitle: 1.2 目的
BookmarkLevel: 2
BookmarkPageNumber: 5

BookmarkBegin
BookmarkTitle: 第2章 方法論
BookmarkLevel: 1
BookmarkPageNumber: 10
```

フィールド説明:
- **BookmarkTitle**: 目次に表示されるタイトル
- **BookmarkLevel**: 階層レベル（1が最上位、2が第2階層、3が第3階層...）
- **BookmarkPageNumber**: そのセクションが始まるページ番号（1始まり）

## 9. 実装言語

### Bash Shell Script

#### 使用する組み込みコマンド
- `set`: エラーハンドリング（set -e）
- `while`/`case`: 引数解析
- `if`/`[[ ]]`: 条件分岐
- `find`: ファイル検索
- `grep`: テキスト検索
- `rm`: ファイル削除
- `command -v`: コマンド存在確認

#### 外部コマンド
- `pdftk`: PDFの結合、メタデータダンプ、目次適用
- `ocrmypdf`: OCR処理と最適化
- `tesseract`: OCRエンジン（ocrmypdfから利用）

## 10. 成果物

プラグインとして以下のファイルを作成してください:

```
pdf-processor/
├── .claude-plugin/
│   └── plugin.json              # プラグインメタデータ
├── commands/
│   ├── preprocess.md            # 前処理コマンド定義
│   └── apply-toc.md             # 目次適用コマンド定義
├── scripts/
│   ├── pdf_preprocess.sh        # 前処理スクリプト（実行権限付与）
│   └── pdf_apply_toc.sh         # 目次適用スクリプト（実行権限付与）
├── README.md                    # プラグイン使用方法
├── LICENSE                      # ライセンス情報
└── sample_toc.txt               # 目次情報サンプル
```

## 11. ワークフロー全体像

```
[複数のPDFファイル]
        ↓
[Command 1: /pdf-processor:preprocess]
  ├─ PDFマージ（一時ファイル作成）
  ├─ OCR処理と最適化（進捗表示）
  ├─ メタデータダンプ
  └─ 一時ファイル自動削除
        ↓
[出力: OCR済みPDF + メタデータテンプレート]
        ↓
[ユーザー作業: 目次情報の編集]
        ↓
[Command 2: /pdf-processor:apply-toc]
  └─ 目次情報の適用
        ↓
[完成版PDF（目次付き）]
```

## 12. 実装時の注意事項

1. **自然言語解析**: ユーザーの指示から適切にファイルパスと出力名を抽出
2. **進捗表示**: ocrmypdfの標準出力を利用（リアルタイム表示）
3. **エラーハンドリング**: 各ステップで適切なエラーチェックと処理（set -eで即座に終了）
4. **一時ファイル管理**: 処理成功時も失敗時も確実にクリーンアップ
5. **エンコーディング**: 日本語ファイル名・目次に対応（UTF-8）
6. **クロスプラットフォーム**: macOS/Linux両方で動作するBashスクリプト
7. **実行権限**: スクリプトファイルに実行権限（chmod +x）を付与

## 13. テスト方法

1. サンプルPDFファイルを3つ用意
2. `/pdf-processor:preprocess` で基本処理が正常完了することを確認
3. 進捗表示が正しく動作することを確認
4. 中間ファイルが自動削除されることを確認
5. メタデータテンプレートに目次情報を追加
6. `/pdf-processor:apply-toc` で目次が正しく適用されることを確認
7. 出力PDFがOCR済みで検索可能か確認
8. 出力PDFの目次（しおり）が正しく設定されているか確認

## 14. 配布方法

### ローカル開発時
```bash
# プラグインディレクトリを指定して起動
claude --plugin-dir ./pdf-processor

# または Claude Code内から
/plugin install ./pdf-processor
```

### GitHubで公開する場合
1. GitHubリポジトリを作成
2. プラグインをpush
3. ユーザーは以下でインストール:
```bash
/plugin install yostos/claude-code-plugins/plugins/pdf-processor
```

### Marketplace経由で配布する場合
1. Marketplaceリポジトリを作成
2. `.claude-plugin/marketplace.json` を追加
3. 詳細は公式ドキュメント参照

## 15. 開発者向けセットアップ

### 開発環境の準備

1. **リポジトリのクローン**
   ```bash
   git clone https://github.com/yostos/claude-code-plugins.git
   cd claude-code-plugins/plugins/pdf-processor
   ```

2. **必要なツールのインストール**
   - macOS: `brew install pdftk-java ocrmypdf tesseract-lang`
   - Linux: README.mdのインストール手順を参照

3. **スクリプトのテスト**
   ```bash
   # 前処理スクリプトのヘルプ表示
   bash scripts/pdf_preprocess.sh -h

   # 目次適用スクリプトのヘルプ表示
   bash scripts/pdf_apply_toc.sh -h
   ```

### スクリプトの拡張方法

#### 新しいオプションの追加

`scripts/pdf_preprocess.sh`に新しいオプションを追加する場合:

1. 引数解析部分のcase文に新しいオプションを追加
2. オプションの説明をusage関数に追加
3. 処理ロジックに新しいオプションの動作を実装

例:
```bash
# 引数解析部分
case $1 in
    --new-option)
        NEW_OPTION="$2"
        shift 2
        ;;
    # ...
esac
```

#### エラーメッセージのカスタマイズ

エラーメッセージは明確で実行可能な解決策を含めることを推奨:
```bash
echo "エラー: 説明"
echo "解決方法: 具体的な手順"
exit 1
```

## 16. コントリビューションガイドライン

### プルリクエストの作成

1. フォークしてブランチを作成
2. 変更を実装（スクリプト、ドキュメント）
3. テストを実行して動作確認
4. プルリクエストを作成

### コーディング規約

- Bashスクリプト: ShellCheck推奨ルールに従う
- エラーハンドリング: `set -e`を使用
- コメント: 複雑なロジックには説明を追加
- 変数名: わかりやすい名前を使用（UPPER_CASE for constants, lower_case for variables）

### ドキュメント更新

- README.md: ユーザー向けの変更
- SPECIFICATION.md: 技術仕様の変更
- 両方のドキュメントが一貫性を保つように注意

---

**ユーザー向けの使用方法については [README.md](README.md) を参照してください。**

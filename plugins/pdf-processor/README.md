# PDF Processor Plugin

A Claude Code Plugin for processing multiple scanned PDF files.

> **For Developers**: For implementation details, architecture, and extension methods, see [SPECIFICATION.md](SPECIFICATION.md) (written in Japanese).

## Overview

This plugin merges multiple scanned PDF files, performs OCR processing, and adds table of contents (TOC/bookmarks). The workflow is split into two commands to allow for manual TOC creation.

### Key Features

- Merge multiple PDF files into one
- OCR processing with Japanese language support
- PDF optimization to reduce file size
- Add table of contents (bookmarks)
- Metadata editing

## Installation

### Prerequisites

This plugin requires the following tools:

#### macOS

```bash
brew install pdftk-java
brew install ocrmypdf
brew install tesseract-lang
```

#### Linux (Ubuntu/Debian)

```bash
sudo apt-get update
sudo apt-get install pdftk
sudo apt-get install ocrmypdf
sudo apt-get install tesseract-ocr tesseract-ocr-jpn
```

### Plugin Installation

```bash
# From GitHub
/plugin install yostos/claude-code-plugins/plugins/pdf-processor

# From local directory
/plugin install ./pdf-processor
```

## Usage

### Workflow Overview

```
[Multiple PDF Files]
        ↓
[Command 1: /pdf-processor:preprocess]
  - Merge PDFs
  - OCR processing and optimization
  - Dump metadata
        ↓
[Output: OCR-processed PDF + Metadata Template]
        ↓
[User Task: Edit TOC Information]
        ↓
[Command 2: /pdf-processor:apply-toc]
  - Apply TOC information
        ↓
[Final PDF with TOC]
```

### Step 1: Preprocessing Command

Merge multiple PDF files and perform OCR processing.

#### Command

```
/pdf-processor:preprocess
```

#### Usage Examples

User instruction examples:
```
Process page1.pdf, page2.pdf, page3.pdf with output name mybook
```

or:
```
Process all PDFs in scanned_pages directory and output as book2024
```

#### Output Files

- `{output_name}_ocr.pdf`: OCR-processed PDF
- `{output_name}_metadata_template.txt`: Template for TOC editing

### Step 2: Edit TOC Information

Open the generated `{output_name}_metadata_template.txt` in an editor and add TOC information at the end of the file.

#### TOC Format

```
BookmarkBegin
BookmarkTitle: Chapter 1 Introduction
BookmarkLevel: 1
BookmarkPageNumber: 1

BookmarkBegin
BookmarkTitle: 1.1 Background
BookmarkLevel: 2
BookmarkPageNumber: 3

BookmarkBegin
BookmarkTitle: 1.2 Purpose
BookmarkLevel: 2
BookmarkPageNumber: 5

BookmarkBegin
BookmarkTitle: Chapter 2 Methodology
BookmarkLevel: 1
BookmarkPageNumber: 10
```

#### Field Descriptions

- `BookmarkTitle`: Title displayed in the TOC
- `BookmarkLevel`: Hierarchy level (1 is top level, 2 is second level, 3 is third level, etc.)
- `BookmarkPageNumber`: Page number where the section starts (1-indexed)

See `sample_toc.txt` for reference.

### Step 3: Apply TOC Command

Apply the edited metadata file to the OCR-processed PDF to generate the final PDF.

#### Command

```
/pdf-processor:apply-toc
```

#### Usage Examples

User instruction examples:
```
Create final version from mybook_ocr.pdf and mybook_metadata_edited.txt
```

or:
```
Apply edited metadata.txt to book_ocr.pdf
```

#### Output File

- `{output_name}_final.pdf`: Final PDF with TOC

## Advanced Options

### Preprocessing Command Options

To run the bash script directly, use these options:

```bash
bash scripts/pdf_preprocess.sh [OPTIONS] INPUT_FILES...

Required arguments:
  INPUT_FILES           PDF files to process (multiple files allowed)

Optional arguments:
  -o, --output-name NAME     Base name for output files (default: output)
  -d, --directory DIR        Input directory (process all PDFs)
  --skip-ocr-if-present      Skip already OCR'd pages
  --optimize-level LEVEL     Optimization level 0-3 (default: 3)
  -h, --help                 Display help message
```

### Apply TOC Command Options

To run the bash script directly, use these options:

```bash
bash scripts/pdf_apply_toc.sh [OPTIONS] OCR_PDF METADATA_FILE

Required arguments:
  OCR_PDF              OCR-processed PDF file
  METADATA_FILE        Edited metadata file

Optional arguments:
  -o, --output FILE    Output filename (default: {base}_final.pdf)
  --cleanup            Delete temporary files
  -h, --help           Display help message
```

## Troubleshooting

### Tool Not Installed Error

```
Error: pdftk is not installed.
```

Solution: Install the required tools following the Prerequisites section.

### File Not Found Error

```
Error: File not found: page1.pdf
```

Solution: Verify the file path is correct. You can use relative or absolute paths.

### TOC Information Not Found Warning

```
Warning: TOC information (BookmarkBegin) not found in metadata file.
```

Solution: Add TOC information starting with `BookmarkBegin` to the metadata file.

### Slow OCR Processing

OCR processing can take time depending on the number of pages. Progress messages from ocrmypdf are displayed during processing.

You can improve processing speed by lowering the optimization level:

```bash
bash scripts/pdf_preprocess.sh --optimize-level 1 -o mybook page1.pdf page2.pdf
```

## License

MIT License

## Author

yostos

## Repository

https://github.com/yostos/claude-code-plugins

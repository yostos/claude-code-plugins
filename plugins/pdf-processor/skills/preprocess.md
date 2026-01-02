---
description: Merge multiple PDFs and run OCR processing
argument-hint: Specify PDF files or directory to process
model: haiku
---

# PDF Preprocessing Skill

Execute the following steps according to user instructions.

## Processing Steps

1. **Environment Check**
   - CRITICAL: Run this EXACT command: `which pdftk ocrmypdf tesseract`
   - You MUST check for `pdftk` command (the brew package is called pdftk-java, but the command itself is `pdftk`)
   - If `pdftk` is not found, tell user to run: `brew install pdftk-java`
   - If `ocrmypdf` is not found, tell user to run: `brew install ocrmypdf`
   - If `tesseract` is not found, tell user to run: `brew install tesseract-lang`

2. **File Collection**
   - If user didn't specify files or directory, use AskUserQuestion to ask:
     - Question: "Which PDF files do you want to process?"
     - Options: "Specify files", "Specify directory", "All PDFs in current directory"
   - Collect PDFs from user-specified files or directory
   - Sort by filename in ascending order

3. **Execute Processing**
   - Run `${CLAUDE_PLUGIN_ROOT}/scripts/pdf_preprocess.sh`
   - Pass file list (no output name needed - script uses 'temp' as default)

4. **Report Results**
   - Verify output files after processing completes
   - Guide user to next step (TOC editing)

## Execution Examples

User input examples:
- "Process page1.pdf, page2.pdf, page3.pdf"
- "Process all PDFs in scanned_pages directory"
- "Process all PDFs in current directory"

Commands to execute:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/pdf_preprocess.sh page1.pdf page2.pdf page3.pdf
# or
bash ${CLAUDE_PLUGIN_ROOT}/scripts/pdf_preprocess.sh -d scanned_pages
# or
bash ${CLAUDE_PLUGIN_ROOT}/scripts/pdf_preprocess.sh -d .
```

## Output

- `temp_ocr.pdf`: OCR-processed PDF
- `temp_metadata_template.txt`: Template for TOC editing

## Next Steps Guidance

After processing completes, inform the user:

```
Preprocessing completed.

Output files:
  - temp_ocr.pdf (OCR-processed PDF)
  - temp_metadata_template.txt (TOC editing template)

Next steps:
1. Open temp_metadata_template.txt in an editor
2. Add TOC information at the end of the file in the following format:

BookmarkBegin
BookmarkTitle: Chapter 1 Title
BookmarkLevel: 1
BookmarkPageNumber: 1

BookmarkBegin
BookmarkTitle: 1.1 Subtitle
BookmarkLevel: 2
BookmarkPageNumber: 5

3. After editing, run:
   /pdf-processor:apply-toc temp_ocr.pdf {edited_metadata_file} {output_filename}
```

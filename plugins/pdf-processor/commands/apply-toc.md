---
description: Apply TOC information to OCR-processed PDF
argument-hint: Specify OCR-processed PDF, edited metadata file, and output filename
model: haiku
---

# Apply TOC Command

Execute the following steps according to user instructions.

## Processing Steps

1. **Argument Collection**
   - If OCR PDF is not specified, use AskUserQuestion to ask for it (suggest: temp_ocr.pdf)
   - If metadata file is not specified, use AskUserQuestion to ask for it (suggest: temp_metadata_template.txt)
   - If output filename is not specified, use AskUserQuestion to ask for it (suggest current directory name or relevant filename)

2. **File Verification**
   - Verify OCR-processed PDF file exists
   - Verify edited metadata file exists
   - Check that metadata contains TOC information (BookmarkBegin)

3. **Execute Processing**
   - Run `${CLAUDE_PLUGIN_ROOT}/scripts/pdf_apply_toc.sh`
   - Pass PDF file, metadata file, and output filename as arguments

4. **Report Results**
   - Report final PDF file path
   - Confirm processing completion

## Execution Examples

User input examples:
- "Apply TOC to create 実践Claude Code入門.pdf"
- "Create mybook.pdf from temp_ocr.pdf and edited_metadata.txt"

Commands to execute:
```bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/pdf_apply_toc.sh temp_ocr.pdf edited_metadata.txt -o "実践Claude Code入門.pdf"
# or
bash ${CLAUDE_PLUGIN_ROOT}/scripts/pdf_apply_toc.sh temp_ocr.pdf temp_metadata_template.txt -o mybook.pdf
```

## Output

- `{output_filename}`: Final PDF with TOC

## Completion Message

```
TOC application completed.

Output file:
  - {output_filename}

Processing complete. Please check the TOC (bookmarks) in your PDF viewer.
```

#!/bin/bash
set -e

# Default values
OUTPUT_PDF=""
CLEANUP=false

# Display usage
usage() {
    cat <<EOF
Usage: $0 OCR_PDF METADATA_FILE -o OUTPUT_FILE [OPTIONS]

Apply TOC Script - Apply TOC information to OCR-processed PDF

Required arguments:
  OCR_PDF              OCR-processed PDF file
  METADATA_FILE        Edited metadata file
  -o, --output FILE    Output filename (required)

Optional arguments:
  --cleanup            Delete temporary files
  -h, --help           Display this help message

Examples:
  $0 temp_ocr.pdf edited_metadata.txt -o "実践Claude Code入門.pdf"
  $0 temp_ocr.pdf temp_metadata_template.txt -o mybook.pdf
EOF
    exit 1
}

# Parse arguments
OCR_PDF=""
METADATA_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            OUTPUT_PDF="$2"
            shift 2
            ;;
        --cleanup)
            CLEANUP=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        -*)
            echo "Error: Unknown option: $1"
            usage
            ;;
        *)
            if [[ -z "$OCR_PDF" ]]; then
                OCR_PDF="$1"
            elif [[ -z "$METADATA_FILE" ]]; then
                METADATA_FILE="$1"
            else
                echo "Error: Extra argument: $1"
                usage
            fi
            shift
            ;;
    esac
done

# Check required arguments
if [[ -z "$OCR_PDF" ]] || [[ -z "$METADATA_FILE" ]]; then
    echo "Error: Please specify both OCR PDF file and metadata file."
    usage
fi

if [[ -z "$OUTPUT_PDF" ]]; then
    echo "Error: Output filename is required. Use -o option to specify."
    usage
fi

# 1. File verification
echo "=== File Verification ==="

if [[ ! -f "$OCR_PDF" ]]; then
    echo "Error: OCR PDF file not found: $OCR_PDF"
    exit 1
fi
echo "✓ OCR PDF file: $OCR_PDF"

if [[ ! -f "$METADATA_FILE" ]]; then
    echo "Error: Metadata file not found: $METADATA_FILE"
    exit 1
fi
echo "✓ Metadata file: $METADATA_FILE"

# Check if metadata contains TOC information
if ! grep -q "BookmarkBegin" "$METADATA_FILE"; then
    echo "Warning: TOC information (BookmarkBegin) not found in metadata file."
    echo "Please add TOC and retry."
    exit 1
fi
echo "✓ TOC information found"

# 2. Apply TOC
echo ""
echo "=== Apply TOC ==="
echo "Output file: $OUTPUT_PDF"

pdftk "$OCR_PDF" update_info_utf8 "$METADATA_FILE" output "$OUTPUT_PDF"
echo "✓ TOC application completed"

# 3. Cleanup (optional)
if [[ "$CLEANUP" == true ]]; then
    echo ""
    echo "=== Cleanup ==="
    rm -f "$OCR_PDF" "$METADATA_FILE"
    echo "✓ Temporary files deleted"
fi

# Completion message
echo ""
echo "================================================"
echo "TOC application completed."
echo ""
echo "Output file:"
echo "  - $OUTPUT_PDF"
echo ""
echo "Processing complete. Please check the TOC (bookmarks) in your PDF viewer."
echo "================================================"

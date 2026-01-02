#!/bin/bash
set -e

# Default values
OUTPUT_NAME="temp"
DIRECTORY=""
INPUT_FILES=()
SKIP_OCR_IF_PRESENT=""
OPTIMIZE_LEVEL=3

# Display usage
usage() {
    cat <<EOF
Usage: $0 [OPTIONS] INPUT_FILES...

PDF Preprocessing Script - Merge multiple PDFs and run OCR processing

Required arguments:
  INPUT_FILES           PDF files to process (multiple files allowed)

Optional arguments:
  -d, --directory DIR        Input directory (process all PDFs)
  --skip-ocr-if-present      Skip already OCR'd pages
  --optimize-level LEVEL     Optimization level 0-3 (default: 3)
  -h, --help                 Display this help message

Note: Output files are created with 'temp' prefix for intermediate processing.

Examples:
  $0 page1.pdf page2.pdf page3.pdf
  $0 -d scanned_pages
  $0 -d .
EOF
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--directory)
            DIRECTORY="$2"
            shift 2
            ;;
        --skip-ocr-if-present)
            SKIP_OCR_IF_PRESENT="--skip-text"
            shift
            ;;
        --optimize-level)
            OPTIMIZE_LEVEL="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        -*)
            echo "Error: Unknown option: $1"
            usage
            ;;
        *)
            INPUT_FILES+=("$1")
            shift
            ;;
    esac
done

# 1. Environment check
echo "=== Environment Check ==="
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 is not installed."
        echo "Installation: brew install $2"
        exit 1
    fi
    echo "✓ Found $1: $($1 --version 2>&1 | head -n1)"
}

check_command "pdftk" "pdftk-java"
check_command "ocrmypdf" "ocrmypdf"
check_command "tesseract" "tesseract-lang"

# 2. Collect files
echo ""
echo "=== File Collection ==="
if [[ -n "$DIRECTORY" ]]; then
    echo "Collecting PDFs from directory: $DIRECTORY"
    if [[ ! -d "$DIRECTORY" ]]; then
        echo "Error: Directory not found: $DIRECTORY"
        exit 1
    fi
    mapfile -d $'\0' INPUT_FILES < <(find "$DIRECTORY" -maxdepth 1 -name "*.pdf" -print0 | sort -z)
    if [[ ${#INPUT_FILES[@]} -eq 0 ]]; then
        echo "Error: No PDF files found in directory: $DIRECTORY"
        exit 1
    fi
fi

if [[ ${#INPUT_FILES[@]} -eq 0 ]]; then
    echo "Error: No input files specified."
    usage
fi

echo "PDF files to process:"
for file in "${INPUT_FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "Error: File not found: $file"
        exit 1
    fi
    echo "  - $file"
done

# 3. Merge PDFs
MERGED_PDF="${OUTPUT_NAME}_merged.pdf"
echo ""
echo "=== PDF Merge ==="
echo "Output file: $MERGED_PDF"
pdftk "${INPUT_FILES[@]}" cat output "$MERGED_PDF"
echo "✓ PDF merge completed"

# 4. OCR processing and optimization
OCR_PDF="${OUTPUT_NAME}_ocr.pdf"
echo ""
echo "=== OCR Processing and Optimization ==="
echo "Output file: $OCR_PDF"
echo "Optimization level: $OPTIMIZE_LEVEL"

OCR_OPTS="-l jpn --optimize $OPTIMIZE_LEVEL"
if [[ -n "$SKIP_OCR_IF_PRESENT" ]]; then
    OCR_OPTS="$OCR_OPTS $SKIP_OCR_IF_PRESENT"
fi

# Run OCR processing (progress displayed to stdout)
ocrmypdf $OCR_OPTS "$MERGED_PDF" "$OCR_PDF"
echo "✓ OCR processing completed"

# 5. Dump metadata
METADATA_TEMPLATE="${OUTPUT_NAME}_metadata_template.txt"
echo ""
echo "=== Metadata Dump ==="
echo "Output file: $METADATA_TEMPLATE"
pdftk "$OCR_PDF" dump_data_utf8 output "$METADATA_TEMPLATE"
echo "✓ Metadata dump completed"

# 6. Cleanup
echo ""
echo "=== Cleanup ==="
rm -f "$MERGED_PDF"
echo "✓ Deleted intermediate file: $MERGED_PDF"

# Completion message
echo ""
echo "================================================"
echo "Preprocessing completed."
echo ""
echo "Output files:"
echo "  - $OCR_PDF (OCR-processed PDF)"
echo "  - $METADATA_TEMPLATE (TOC editing template)"
echo ""
echo "Next steps:"
echo "1. Open $METADATA_TEMPLATE in an editor"
echo "2. Add TOC information at the end of the file in this format:"
echo ""
echo "BookmarkBegin"
echo "BookmarkTitle: Chapter 1 Title"
echo "BookmarkLevel: 1"
echo "BookmarkPageNumber: 1"
echo ""
echo "BookmarkBegin"
echo "BookmarkTitle: 1.1 Subtitle"
echo "BookmarkLevel: 2"
echo "BookmarkPageNumber: 5"
echo ""
echo "3. After editing, run:"
echo "   /pdf-processor:apply-toc $OCR_PDF {edited_metadata_file}"
echo "================================================"

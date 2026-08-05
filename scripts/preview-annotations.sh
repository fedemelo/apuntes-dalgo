#!/usr/bin/env bash
#
# Fast standalone preview for a single \begin{pseudocode}...\end{annotations}
# block, without compiling the full book. Crops tightly to the content.
#
# Usage:
#   scripts/preview-annotations.sh <file.tex>            # list blocks in the file
#   scripts/preview-annotations.sh <file.tex> <index>     # render block <index>
#
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <file.tex> [block-index]" >&2
    exit 1
fi

SRC=$1
INDEX=${2:-}

if [[ ! -f "$SRC" ]]; then
    echo "File not found: $SRC" >&2
    exit 1
fi

REPO_ROOT=$(git -C "$(dirname "$SRC")" rev-parse --show-toplevel)

# Find all \begin{pseudocode}...\end{pseudocode}, optionally immediately
# followed (modulo blank lines) by \begin{annotations}...\end{annotations}.
# Prints one "start end" pair per block (1-based, inclusive, original file).
BLOCKS=$(awk '
    /\\begin\{pseudocode\}/ { start=NR; state="code"; next }
    state=="code" && /\\end\{pseudocode\}/ { end=NR; state="after"; next }
    state=="after" && /^[[:space:]]*$/ { next }
    state=="after" && /\\begin\{annotations\}/ { state="ann"; next }
    state=="after" { print start, end; state="none"; next }
    state=="ann" && /\\end\{annotations\}/ { print start, NR; state="none"; next }
    END { if (state=="after") print start, end }
' "$SRC")

if [[ -z "$BLOCKS" ]]; then
    echo "No \\begin{pseudocode} blocks found in $SRC" >&2
    exit 1
fi

COUNT=$(wc -l <<<"$BLOCKS" | tr -d ' ')

if [[ -z "$INDEX" ]]; then
    echo "Blocks in $SRC:"
    i=0
    while IFS=' ' read -r s e; do
        i=$((i+1))
        snippet=$(sed -n "$((s+1))p" "$SRC" | sed -E 's/^[[:space:]]*//' | cut -c1-60)
        echo "  [$i] lines $s-$e: $snippet"
    done <<<"$BLOCKS"
    echo "Rerun with a block index: $0 $SRC <index>" >&2
    exit 1
fi

if ! [[ "$INDEX" =~ ^[0-9]+$ ]] || (( INDEX < 1 || INDEX > COUNT )); then
    echo "Invalid block index '$INDEX' (file has $COUNT block(s))." >&2
    exit 1
fi

RANGE=$(sed -n "${INDEX}p" <<<"$BLOCKS")
START=${RANGE% *}
END=${RANGE#* }

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

# Book-level shared annotation macros (e.g. algoritmos/shared_annotations.tex),
# if the book this file belongs to has one.
ABS_SRC_DIR=$(cd "$(dirname "$SRC")" && pwd)
REL_SRC_DIR=${ABS_SRC_DIR#"$REPO_ROOT"/}
BOOK_DIR=${REL_SRC_DIR%%/*}
SHARED_ANNOTATIONS="$REPO_ROOT/$BOOK_DIR/shared_annotations.tex"

{
    echo '\documentclass{article}'
    echo '\usepackage[margin=1in]{geometry}'
    echo '\usepackage{fmbdalgo}'
    if [[ -f "$SHARED_ANNOTATIONS" ]]; then
        echo "\\input{$SHARED_ANNOTATIONS}"
    fi
    echo '\pagestyle{empty}'
    echo '\begin{document}'
    sed -n "${START},${END}p" "$SRC"
    echo '\end{document}'
} > "$WORKDIR/preview.tex"

(
    cd "$WORKDIR"
    TEXINPUTS="$REPO_ROOT/packages//:" \
        latexmk -pdf -interaction=nonstopmode \
        -pdflatex="pdflatex -shell-escape %O %S" preview.tex \
        > preview.compile.log 2>&1
) || {
    echo "Compilation failed. Log:" >&2
    tail -40 "$WORKDIR/preview.compile.log" >&2
    exit 1
}

pdfcrop --margins 5 "$WORKDIR/preview.pdf" "$WORKDIR/preview-crop.pdf" >/dev/null

OUT_DIR="$REPO_ROOT/.preview"
mkdir -p "$OUT_DIR"
BASENAME=$(basename "$SRC" .tex)
OUT_PREFIX="$OUT_DIR/${BASENAME}-block${INDEX}"
pdftoppm -png -r 300 "$WORKDIR/preview-crop.pdf" "$OUT_PREFIX" >/dev/null

OUT_FILE="${OUT_PREFIX}-1.png"
if [[ ! -f "$OUT_FILE" ]]; then
    # pdftoppm omits the "-1" suffix when there is only one page in some versions
    OUT_FILE="${OUT_PREFIX}.png"
fi

echo "$OUT_FILE"

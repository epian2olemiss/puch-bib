#!/bin/bash
#
# bib2docx.sh — Convert a .bib file to a Word document (.docx) with
# references formatted in Public Choice journal style.
#
# Usage: bib2docx.sh input.bib [output.docx]
#
# If output is omitted, produces input_publicchoice.docx in the same directory.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
BST="$SKILL_DIR/latex-package/publicchoice.bst"
STY="$SKILL_DIR/latex-package/publicchoice.sty"

# Check dependencies
for cmd in pdflatex bibtex pandoc; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: $cmd is not installed." >&2
    exit 1
  fi
done

if [ -z "$1" ]; then
  echo "Usage: bib2docx.sh input.bib [output.docx]" >&2
  exit 1
fi

INPUT_BIB="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
BIB_NAME="$(basename "$1" .bib)"

if [ -n "$2" ]; then
  OUTPUT_DOCX="$(cd "$(dirname "$2")" 2>/dev/null && pwd)/$(basename "$2")" || OUTPUT_DOCX="$2"
else
  OUTPUT_DOCX="$(dirname "$INPUT_BIB")/${BIB_NAME}_publicchoice.docx"
fi

# Create temp directory
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

# Copy files to temp
cp "$BST" "$TMPDIR/"
cp "$STY" "$TMPDIR/"
cp "$INPUT_BIB" "$TMPDIR/refs.bib"

# Extract all citation keys from the .bib file
KEYS=$(grep -E '^\s*@\w+\{' "$INPUT_BIB" | sed 's/.*{\s*//' | sed 's/\s*,\s*//' | tr '\n' ',' | sed 's/,$//')

# Generate a minimal .tex that cites everything
cat > "$TMPDIR/doc.tex" <<LATEX
\documentclass{article}
\usepackage{publicchoice}
\begin{document}
\nocite{*}
\bibliographystyle{publicchoice}
\bibliography{refs}
\end{document}
LATEX

# Build
cd "$TMPDIR"
pdflatex -interaction=nonstopmode doc.tex > /dev/null 2>&1
bibtex doc > /dev/null 2>&1
pdflatex -interaction=nonstopmode doc.tex > /dev/null 2>&1
pdflatex -interaction=nonstopmode doc.tex > /dev/null 2>&1

# Extract formatted references from .bbl, clean up LaTeX commands
# Convert .bbl to a clean markdown file
python3 - <<'PYTHON'
import re, sys

with open("doc.bbl", "r") as f:
    bbl = f.read()

# Remove thebibliography environment
bbl = re.sub(r'\\begin\{thebibliography\}\{[^}]*\}', '', bbl)
bbl = re.sub(r'\\end\{thebibliography\}', '', bbl)

# Split into entries
entries = re.split(r'\\bibitem\[[^\]]*\]\{[^}]*\}\s*', bbl)
entries = [e.strip() for e in entries if e.strip()]

lines = []
for entry in entries:
    # Clean LaTeX commands
    text = entry
    text = text.replace('\\newblock ', '')
    text = text.replace('\\newblock', '')
    text = re.sub(r'\\textit\{([^}]*)\}', r'*\1*', text)  # \textit -> markdown italic
    text = re.sub(r'\\emph\{([^}]*)\}', r'*\1*', text)
    text = re.sub(r'\\url\{([^}]*)\}', r'\1', text)        # \url -> plain text
    text = re.sub(r'\\href\{[^}]*\}\{([^}]*)\}', r'\1', text)
    text = text.replace('~', ' ')
    text = text.replace('\\&', '&')
    text = text.replace('\\', '')
    text = re.sub(r'\{([^}]*)\}', r'\1', text)              # remove remaining braces
    # Collapse whitespace
    text = re.sub(r'\s+', ' ', text).strip()
    if text:
        lines.append(text)

with open("refs.md", "w") as f:
    f.write("# References\n\n")
    for line in lines:
        f.write(line + "\n\n")

print(f"Formatted {len(lines)} references.")
PYTHON

# Convert to docx
pandoc refs.md -o "$OUTPUT_DOCX" --from=markdown --to=docx

echo "Output written to: $OUTPUT_DOCX"

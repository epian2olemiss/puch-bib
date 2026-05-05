---
name: puch-bib
description: Convert article information (titles, authors, journals, DOIs, etc.) into BibTeX entries and Word-ready reference text formatted for the Public Choice journal citation style. Use when the user provides publication details and needs them formatted for Public Choice, or mentions "puch-bib", "Public Choice bibliography", "Public Choice format", or "format for Public Choice".
user_invocable: true
---

# /puch-bib — Public Choice Bibliography Formatter

You format publication information into two outputs:

1. **BibTeX** (`.bib`) — for LaTeX/Overleaf workflows
2. **Word text** — a plain-text reference list entry ready to paste into a Word document

Both outputs follow the **Public Choice** journal citation style.

## Input

The user provides article information in any form: a title, author list, DOI, URL, pasted citation, or a mix. Extract whatever fields are available. If a DOI or URL is provided, use the WebFetch tool to retrieve missing metadata (title, authors, year, journal, volume, issue, pages).

If critical information is missing and cannot be inferred, ask the user before proceeding.

## Public Choice Citation Style Reference

Public Choice (Springer) uses a Chicago author-date / Springer Basic style. Key rules below — these match what the bundled `publicchoice.bst` produces.

### In-Text Citations

- One author: (Author Year) — e.g., (Fan 2003)
- Two authors: (Author and Author Year) — e.g., (Stoeckle and Coffran 2013)
- Three or more authors: (Author et al. Year) — e.g., (Cui et al. 2014)
- Multiple references separated by semicolons: (Fan 2003; Stoeckle and Coffran 2013)
- No comma between author and year.

### Reference List — Formatting Rules

- **Author names**:
  - First author: `Last, First Middle` (full first names, not initials)
  - Subsequent authors: `First Middle Last` (natural order)
  - Use `and` (not `&`) before the final author
  - Multiple authors separated by commas
- **Year**: After the author block, **not in parentheses**, followed by a period — e.g., `... and Markus Reischmann. 2016.`
- **Article titles**: Sentence case, not italicized, ended with a period
- **Journal names**: Italicized, title case, no comma between journal and volume
- **Volume**: Plain text (not italicized), directly after the journal name
- **Issue number**: In parentheses with a leading space — e.g., `45 (1)`
- **Pages**: Colon (no space before) between issue and pages; full range with en-dash — e.g., `45 (1): 39–56`
- **DOI**: Include when available, as a URL: `https://doi.org/...`
- **Punctuation**: Periods separate major elements (authors / year / title / journal info / DOI)

### Entry Types and Templates

#### Journal Article

**Word format:**
```
Last, First Middle, First Middle Last, and First Middle Last. Year. Article title in sentence case. Journal Name Volume (Issue): StartPage–EndPage. https://doi.org/DOI
```

**Example:**
```
Kauder, Björn, Niklas Potrafke, and Markus Reischmann. 2016. Do politicians reward core supporters? Evidence from a discretionary grant program. European Journal of Political Economy 45 (1): 39–56. https://doi.org/10.1016/j.ejpoleco.2016.09.003
```

For articles cited by article number rather than page range:
```
Rudolph, Lukas, and Arndt Leininger. 2021. Coattails and spillover-effects: Quasi-experimental evidence from concurrent executive and legislative elections. Electoral Studies 70: 102264. https://doi.org/10.1016/j.electstud.2020.102264
```

#### Book

**Word format:**
```
Last, First Middle. Year. Book title in sentence case. Place: Publisher.
```

**Example:**
```
Bauldry, William C. 2009. Introduction to real analysis. Hoboken, NJ: John Wiley & Sons.
```

#### Edited Book

**Word format:**
```
Last, First Middle, and First Middle Last, eds. Year. Book title in sentence case. Place: Publisher.
```

#### Book Chapter

**Word format:**
```
Last, First Middle. Year. Chapter title in sentence case. In Book title in sentence case, ed. First Middle Last, StartPage–EndPage. Place: Publisher.
```

#### Working Paper / Report

**Word format:**
```
Last, First Middle. Year. Title in sentence case. Working Paper No. XXXX. Institution/Series.
```

#### Thesis / Dissertation

**Word format:**
```
Last, First Middle. Year. Title in sentence case. Doctoral dissertation/Master's thesis, Institution, Place.
```

## Output Format

For each item the user provides, output **both** formats clearly labeled.

### BibTeX

Use the appropriate entry type (`@article`, `@book`, `@incollection`, `@inproceedings`, `@techreport`, `@phdthesis`, `@mastersthesis`, `@misc`).

Rules for BibTeX keys:
- Format: `AuthorYear` using the first author's last name and 4-digit year
- If ambiguous (e.g., two Smith2024 entries in the same batch), append a lowercase letter: `Smith2024a`, `Smith2024b`
- Protect capitalization in titles with braces where needed (proper nouns, acronyms): e.g., `{COVID}-19`, `{United States}`
- Always include the `doi` field when available (raw DOI, no URL prefix)
- Use `--` for page ranges in BibTeX

Example:
```bibtex
@article{Stoeckle2013,
  author    = {Stoeckle, Mark Y. and Coffran, Claud},
  title     = {TreeParser-aided {Klee} diagrams display taxonomic clusters in {DNA} barcode and nuclear gene datasets},
  journal   = {Scientific Reports},
  year      = {2013},
  volume    = {3},
  pages     = {2635},
  doi       = {10.1038/srep02635}
}
```

### Word Text

Output the formatted reference as plain text (no markup), ready to paste into a Word document. Use an en-dash (–) for page ranges. Italicize **only** the journal name or book title; use underscores for clarity: `_Journal Name_`. Volume number is plain.

Example:
```
Stoeckle, Mark Y., and Claud Coffran. 2013. TreeParser-aided Klee diagrams display taxonomic clusters in DNA barcode and nuclear gene datasets. _Scientific Reports_ 3 (1): 2635. https://doi.org/10.1038/srep02635
```

## Batch Mode

If the user provides multiple items at once, format all of them and output:
1. All BibTeX entries together (ready to paste into a `.bib` file)
2. All Word text entries together (ready to paste into a reference list), sorted alphabetically by first author last name

## DOI Lookup

If the user provides only a DOI or a URL containing a DOI, use WebFetch on `https://doi.org/DOI` to retrieve metadata, then format accordingly. If the user provides a paper title but no DOI, attempt to look it up via WebSearch.

## Edge Cases

- **Missing fields**: Include only the fields that are available. Do not fabricate metadata.
- **Non-English titles**: Keep the original title. If a translation is provided, include it in brackets after the original.
- **Forthcoming articles**: Use `(Forthcoming)` in place of the year if no year is available.
- **Online-first / no volume/pages yet**: Omit volume/pages; include the DOI.
- **Multiple works by same author in same year**: Append lowercase letters to the year: 2024a, 2024b — in both BibTeX keys and in-text citations.

## Bibliography-to-Word Conversion

This skill can also convert an entire bibliography into a Word document (`.docx`) formatted in Public Choice style.

### How it works

1. **If the input is a `.bib` file**: Run the bundled script directly:
   ```bash
   ~/.claude/skills/puch-bib/scripts/bib2docx.sh input.bib output.docx
   ```
   The script uses the `publicchoice.bst` to format the references via LaTeX, then converts to `.docx` via pandoc. The output file argument is optional — if omitted, it produces `input_publicchoice.docx` in the same directory.

2. **If the input is NOT a `.bib` file** (e.g., plain text references, a Word document, a PDF bibliography, or pasted text):
   - First, parse each reference and convert it to a BibTeX entry. Use WebSearch/WebFetch to look up missing metadata (DOIs, page numbers, etc.) when needed.
   - Write all entries to a temporary `.bib` file.
   - Then run the `bib2docx.sh` script on that `.bib` file.

3. **Open the output** `.docx` file for the user when done.

### Requirements

The script requires `pdflatex`, `bibtex`, and `pandoc` to be installed.

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

The style is based on the Paperpile Public Choice format (https://paperpile.com/s/public-choice-citation-style/). Key rules:

### In-Text Citations

- One author: (Author Year) — e.g., (Fan 2003)
- Two authors: (Author and Author Year) — e.g., (Stoeckle and Coffran 2013)
- Three or more authors: (Author et al. Year) — e.g., (Cui et al. 2014)
- Multiple references separated by semicolons: (Fan 2003; Stoeckle and Coffran 2013)

### Reference List — Formatting Rules

- **Author names**: Last, F. I. — use `&` before the final author
- **Year**: In parentheses after the author block
- **Article titles**: Sentence case, not italicized
- **Journal names**: Italicized, title case
- **Volume**: Italicized
- **Issue number**: In parentheses, not italicized
- **Pages**: Full range with en-dash (e.g., 752–753)
- **DOI**: Include when available, as a URL: `https://doi.org/...`
- **Punctuation**: Periods separate major elements

### Entry Types and Templates

#### Journal Article

**Word format:**
```
Last, F. I., & Last, F. I. (Year). Article title in sentence case. Journal Name, Volume(Issue), StartPage–EndPage. https://doi.org/DOI
```

**Example:**
```
Stoeckle, M. Y., & Coffran, C. (2013). TreeParser-aided Klee diagrams display taxonomic clusters in DNA barcode and nuclear gene datasets. Scientific Reports, 3, 2635.
```

#### Book

**Word format:**
```
Last, F. I. (Year). Book title in sentence case. Place: Publisher.
```

**Example:**
```
Bauldry, W. C. (2009). Introduction to real analysis. Hoboken, NJ: John Wiley & Sons, Inc.
```

#### Edited Book

**Word format:**
```
Last, F. I., & Last, F. I. (Eds.). (Year). Book title in sentence case (Edition). Place: Publisher.
```

#### Book Chapter

**Word format:**
```
Last, F. I. (Year). Chapter title in sentence case. In F. I. Last & F. I. Last (Eds.), Book title in sentence case (pp. StartPage–EndPage). Place: Publisher.
```

#### Working Paper / Report

**Word format:**
```
Last, F. I. (Year). Title in sentence case (Working Paper No. XXXX). Institution/Series.
```

#### Thesis / Dissertation

**Word format:**
```
Last, F. I. (Year). Title in sentence case (Doctoral dissertation/Master's thesis). Institution, Place.
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

Output the formatted reference as plain text (no markup), ready to paste into a Word document. Use an en-dash (–) for page ranges. Italics should be indicated with underscores for clarity: `_Journal Name_`, `_Volume_`.

Example:
```
Stoeckle, M. Y., & Coffran, C. (2013). TreeParser-aided Klee diagrams display taxonomic clusters in DNA barcode and nuclear gene datasets. _Scientific Reports_, _3_, 2635.
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

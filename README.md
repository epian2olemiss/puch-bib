# puch-bib — Public Choice Bibliography Formatter

A [Claude Code](https://claude.com/claude-code) skill that converts article information into **BibTeX** and **Word-ready** reference text formatted for the *Public Choice* journal citation style.

## Install

Clone this repo into your Claude Code skills directory:

```bash
git clone https://github.com/louisrouanet-econ/puch-bib.git ~/.claude/skills/puch-bib
```

Then restart Claude Code. The `/puch-bib` slash command will be available.

## Usage

In Claude Code, type `/puch-bib` and provide article information in any form:

- A DOI: `10.1007/s11127-025-01267-4`
- A title and authors: `Magness, Carden, and Murtazashvili, "Consumers' sovereignty and W. H. Hutt's critique of the color bar", Public Choice, 2025`
- A pasted citation or URL
- Multiple articles at once

The skill outputs both:
1. **BibTeX** entry (for `.bib` files / Overleaf)
2. **Word text** (formatted reference for Word documents)

## Citation Style

Public Choice (Springer) uses a Chicago author-date / Springer Basic style. The skill follows what the journal actually publishes:

- Full first names (not initials)
- `and` before final author (not `&`)
- Year follows the author block, **not in parentheses** — e.g., `... and Markus Reischmann. 2016.`
- Article titles in sentence case
- Journal name italicized, title case
- Volume in plain text (not italicized), with issue in parentheses: `45 (1)`
- Colon between issue and pages, en-dashed range: `45 (1): 39–56`
- DOI as URL: `https://doi.org/...`

**Example:**

```
Kauder, Björn, Niklas Potrafke, and Markus Reischmann. 2016. Do politicians reward core supporters? Evidence from a discretionary grant program. European Journal of Political Economy 45 (1): 39–56. https://doi.org/10.1016/j.ejpoleco.2016.09.003
```

For online-only articles cited by article number rather than page range:

```
Rudolph, Lukas, and Arndt Leininger. 2021. Coattails and spillover-effects: Quasi-experimental evidence from concurrent executive and legislative elections. Electoral Studies 70: 102264. https://doi.org/10.1016/j.electstud.2020.102264
```

## Bulk Bibliography → Word

To reformat an entire `.bib` file into a Public Choice–styled Word document:

```bash
~/.claude/skills/puch-bib/scripts/bib2docx.sh input.bib output.docx
```

The script uses the bundled `publicchoice.bst` BibTeX style to format the references via LaTeX, then converts to `.docx` via pandoc. Requires `pdflatex`, `bibtex`, and `pandoc`.

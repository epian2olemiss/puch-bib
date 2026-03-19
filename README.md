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

Based on the [Public Choice citation style](https://paperpile.com/s/public-choice-citation-style/) from Paperpile.

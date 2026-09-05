# AGENTS

## Project Purpose

This public repository contains Stata 18 analysis code and supporting tabular data for "Hickam's Dictum: An Analysis of Multiple Diagnoses" (Journal of General Internal Medicine, published online October 28, 2024; DOI: 10.1007/s11606-024-09120-y; PMID: 39467949).

## Public and Data-Safety Rules

- Treat the repository as public research code.
- Do not add PHI, credentials, private drafts, reviewer correspondence, or publisher-formatted article PDFs.
- The committed workbooks are intended public/anonymized source data for the article. Do not merge in respondent identifiers or non-public clinical data.
- Do not copy long passages from the published article into Markdown. Use DOI/PubMed links and short paraphrased summaries instead.
- Generated outputs belong under `Results and Figures/` and are ignored unless intentionally archived in a release.

## How to Orient Quickly
Consult only the entries relevant to the requested edit or run.

1. Read `README.md` for the article context, dependencies, run command, and file inventory.
2. Read `llms.txt` for the compact machine-readable index.
3. Use `CITATION.cff` for structured citation metadata.
4. Use `data_dictionary.md` or `data_dictionary.csv` before interpreting workbook columns.
5. Inspect `Hickam Analysis.do` before running it; the do-file should be launched from the repository root.

## Workflow

Install the required Stata packages listed in `README.md`, then run:

```bash
make run
```

or directly:

```bash
stata-mp -b do "Hickam Analysis.do"
```

Set `STATA=stata-se` or another executable name when using `make` on systems without `stata-mp`.

## Verification Before Publishing Changes

- Run `git diff --check`.
- Validate `CITATION.cff` as YAML after citation edits.
- Confirm `llms.txt`, `README.md`, `AGENTS.md`, and the data dictionary agree on DOI, PMID, file names, and run command.
- When run commands or the Makefile change, inspect `make -n run`; a dry run checks wiring and is not Stata execution evidence.
- For analysis/runner changes, perform applicable Stata verification within the authorized workflow. It requires a licensed runtime and the approved inputs; executable availability alone does not authorize a restricted-data run. Inspect generated logs and report unavailable data/package/runtime gates separately from static checks.
- Do not commit `.DS_Store`, Stata swap/recovery files, logs, generated figures/tables, or local manuscript drafts.

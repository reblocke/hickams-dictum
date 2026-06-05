# Hickam's Dictum: Analysis Code and Supporting Data

[![DOI](https://img.shields.io/badge/DOI-10.1007%2Fs11606--024--09120--y-blue)](https://doi.org/10.1007/s11606-024-09120-y)
[![PMID](https://img.shields.io/badge/PMID-39467949-blue)](https://pubmed.ncbi.nlm.nih.gov/39467949/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Code and supporting tabular data for **"Hickam's Dictum: An Analysis of Multiple Diagnoses"**, published in the *Journal of General Internal Medicine* on October 28, 2024.

## Description

This repository reproduces the Stata analyses and exported displays for a study of multiple diagnoses, Hickam's dictum, and Ockham's razor. The paper combines three sources: a literature review of published case reports, a review of New England Journal of Medicine diagnostic teaching cases, and an anonymous online provider survey using four diagnostic vignettes.

Canonical links:

- Article DOI: <https://doi.org/10.1007/s11606-024-09120-y>
- PubMed: <https://pubmed.ncbi.nlm.nih.gov/39467949/>
- Repository: <https://github.com/reblocke/hickams-dictum>
- Machine-readable citation metadata: [CITATION.cff](CITATION.cff)
- Machine-readable repository index: [llms.txt](llms.txt)

## Quick Start

Run commands from the repository root. The do-file expects the three Excel workbooks to remain in the root directory.

### Requirements

| Component | Required version or source | Purpose |
| --- | --- | --- |
| Stata | 18 IC, SE, or MP | Main analysis workflow |
| `table1_mc` | SSC | Descriptive tables |
| `catplot` | SSC | Categorical plots |
| `coefplot` | SSC | Regression coefficient plots |
| `pmcalplot` | SSC | Calibration plot and bootstrap C statistic |
| `cleanplots` | `net install cleanplots, from("https://tdmize.github.io/data")` | Plot scheme |
| Excel workbooks | Repository root | Survey, NEJM case, and case-report source data |

Install the Stata packages once:

```stata
ssc install table1_mc
ssc install catplot
ssc install coefplot
ssc install pmcalplot
net install cleanplots, from("https://tdmize.github.io/data")
```

Run in batch mode with the Stata executable available on your system:

```bash
make run
# or
stata-mp -b do "Hickam Analysis.do"
```

Alternative executable names such as `stata-se` or `stata` also work if installed locally. The do-file now fails early with a clear message if the input workbooks are missing or if it is not launched from the repository root.

## Workflow and Outputs

The analysis is controlled by [Hickam Analysis.do](Hickam%20Analysis.do). It imports `Survey_Responses.xlsx`, cleans the survey variables used in the paper, runs descriptive summaries, trend tests, logistic and multinomial models, and exports figures/tables to a dated directory:

```text
Results and Figures/<Stata date>/
Results and Figures/<Stata date>/Logs/
```

Expected exported outputs include:

| Output | Role |
| --- | --- |
| `Fig 1 - Overall Pie.png` | Paper Figure 1, overall vignette response distribution |
| `Fig 2 - PGY Count all answers.png` | Paper Figure 2, vignette responses by training level |
| `Table 2 - training and specialty by correct.xlsx` | Paper Table 2 summary export |
| `Answers by Training.xlsx` | Supporting survey response table |
| `training and specialty by answer.xlsx` | Supporting response table by answer |
| `Regression Coeffs by PGY and Spec.png` | Supporting adjusted regression plot |
| `Logs/(HH_MM_SS)Hickam Analysis.log` | Batch run log |

The do-file also creates `Cases Pie.png` from a small manually simulated count block used for illustration. That figure is not required for the main survey analyses.

## Data and Codebook

No protected health information is included. The survey was anonymous and the University of Utah IRB granted an exemption, as described in the article. Survey platform administrative fields are present in the raw export but are dropped by the analysis script before modeling.

| File | Sheets | Description | Public reuse note |
| --- | --- | --- | --- |
| `Survey_Responses.xlsx` | `Sheet` | Anonymous provider responses to the multiple-diagnoses vignette survey | Use with the codebook; do not add identifiable respondent data |
| `NEJM Cases.xlsx` | `2015-2018`, `2021-2023` | Tabulated NEJM Case Records and Clinical Problem-Solving cases | Links and diagnoses come from published teaching cases |
| `Published Case Reviews.xlsx` | `All-reviewed`, `included-only`, `Sheet3` | Tabulated case reports and coding summaries for Hickam/Ockham cases | Article links and notes should be interpreted with the paper |

Variable-level documentation is provided in:

- Human-readable codebook: [data_dictionary.md](data_dictionary.md)
- Machine-usable CSV codebook: [data_dictionary.csv](data_dictionary.csv)

## File Inventory

| Path | Type | Description |
| --- | --- | --- |
| `Hickam Analysis.do` | Stata script | Main analysis and figure/table export workflow |
| `Makefile` | Command wrapper | Runs the do-file with `$(STATA) -b do` |
| `Survey_Responses.xlsx` | Data | Anonymous survey export used for paper analyses |
| `NEJM Cases.xlsx` | Data | NEJM didactic case review tabulation |
| `Published Case Reviews.xlsx` | Data | Published case-report review tabulation |
| `data_dictionary.md` | Documentation | Human-readable workbook and derived-variable dictionary |
| `data_dictionary.csv` | Documentation | Machine-usable data dictionary |
| `CITATION.cff` | Citation metadata | GitHub citation metadata for the paper and repository |
| `llms.txt` | Machine-readable index | Agent/LLM orientation and canonical links |
| `AGENTS.md` | Agent instructions | Repository-specific instructions for coding agents |
| `LICENSE` | License | MIT license for repository code |

Generated files under `Results and Figures/` are intentionally ignored and should not be committed unless a release explicitly archives them.

## Authors, Funding, and Conflicts

Article authors:

- Scott K. Aberegg, MD, MPH
- Brian R. Poole, MD
- Brian W. Locke, MD, MSc

Funding: no funding was reported for the study.

Conflict of interest: B.W.L. advises and owns equity in Mountain Biometrics; the authors reported no other conflicts of interest in the article.

## Citation

Please cite the article when using this repository:

> Aberegg SK, Poole BR, Locke BW. Hickam's Dictum: An Analysis of Multiple Diagnoses. *Journal of General Internal Medicine*. Published online October 28, 2024. doi:10.1007/s11606-024-09120-y.

For software/repository citation metadata, use [CITATION.cff](CITATION.cff) and include the GitHub URL plus the commit or release used.

## License and Reuse

- Code: MIT License, see [LICENSE](LICENSE).
- Author-created text, figures, tables, and data notes: CC BY 4.0 unless otherwise noted.
- Third-party source material, publisher pages, linked articles, and quoted article metadata remain under their original terms.
- Do not copy publisher-formatted PDFs or restricted third-party content into this repository.

## Maintenance and Contact

Open a GitHub issue or pull request for repository-specific questions. For article correspondence, use the corresponding author listed on the journal page.

## Machine Readability

This repository follows a public research-code orientation pattern for human and machine readers:

- `README.md` gives the project overview, run path, data inventory, and citation.
- `llms.txt` gives a compact machine-readable index.
- `AGENTS.md` gives instructions for coding agents.
- `CITATION.cff` gives structured citation metadata with the verified DOI.
- `data_dictionary.md` and `data_dictionary.csv` document the workbook variables and Stata-derived variables.

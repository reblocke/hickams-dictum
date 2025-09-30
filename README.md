# Hickam’s Dictum — Reproduction Package

> Code and data to reproduce the main analyses and figures in **“Hickam’s Dictum: An Analysis of Multiple Diagnoses”** (Journal of General Internal Medicine, published October 28, 2024; DOI: 10.1007/s11606-024-09120-y).

**Links & IDs**
- Article (open access): https://doi.org/10.1007/s11606-024-09120-y  
- Repository: https://github.com/reblocke/hickams-dictum  
- This README prepared against commit `3c8505c` (2025-04-28).  
- Corresponding analysis environment: Stata 18.

## Cite this work
If you use this repository, please cite the article and (optionally) this software release. See `CITATION.cff` for machine‑readable metadata.

- Aberegg SK, Poole BR, Locke BW. *Hickam’s Dictum: An Analysis of Multiple Diagnoses*. **J Gen Intern Med**. 2024. doi:10.1007/s11606-024-09120-y.

## Quick start (reproduce the main results)

**Requirements**
- Stata 18 (IC/SE/MP) on Windows, macOS, or Linux.
- The three Excel files in the repo root:
  - `Survey_Responses.xlsx`
  - `NEJM Cases.xlsx`
  - `Published Case Reviews.xlsx`

**Install user-written Stata packages (first run only)**
In Stata's Command window:

```
ssc install table1_mc
ssc install catplot
ssc install coefplot
ssc install pmcalplot
net install cleanplots, from("https://tdmize.github.io/data")
```

**Run the analysis**
- Option A (GUI): Open `Hickam Analysis.do` and `Do` the file.  
- Option B (batch): From a shell in the repository directory, run one of the following depending on your Stata executable name:

```
stata-mp -b do "Hickam Analysis.do"
# or
stata-se -b do "Hickam Analysis.do"
# or
stata -b do "Hickam Analysis.do"
```

The script creates a dated folder `Results and Figures/<today>/` and writes figures, tables, and a log file. Some figures use the `cleanplots` graphics scheme.

### Expected outputs
The do-file writes (at minimum) the following, which correspond to the paper’s displays:

**Figures**
- `Results and Figures/<date>/Fig 1 - Overall Pie.png` — pie chart of vignette responses (paper Figure 1).
- `Results and Figures/<date>/Fig 2 - PGY Count all answers.png` — responses by training level (paper Figure 2).
- Additional exports (useful/supplementary):  
  `PGY Count.png`, `Correct - PGY Proportion.png`, `Answers - PGY Proportion.png`,  
  `Correct Specialty Count.png`, `Answer Specialty Count.png`,  
  `Correct Specialty Proportion.png`, `Answer Specialty Proportion.png`,  
  `Regression Coeffs by PGY and Spec.png`.

**Tables**
- `Results and Figures/<date>/Table 2 - training and specialty by correct.xlsx` — Table 2 in the manuscript (training and specialty by correct response).
- `Results and Figures/<date>/Answers by Training.xlsx`
- `Results and Figures/<date>/training and specialty by answer.xlsx`

> Note: The do-file also contains a small “manually simulate observed answers” block used for an illustrative pie chart (`Cases Pie.png`). This is not needed for the main survey analyses.

## Data access and ethics

- **Survey:** Anonymous provider survey conducted in August 2023 via social media. Institutional review board (University of Utah) granted an exemption. The raw responses used in the paper are in `Survey_Responses.xlsx` at the repo root.
- **NEJM case series:** Tabulation of *Case Records of the Massachusetts General Hospital* and *Clinical Problem‑Solving* articles, primarily from 2021–2023 with an earlier set from 2015–2018, summarized in `NEJM Cases.xlsx`.
- **Case reports:** Tabulation of 83 published case reports concerning Hickam’s dictum or Ockham’s razor, summarized in `Published Case Reviews.xlsx`.

No protected health information is included in this repository. See the paper for details and the appendices referenced there.

## Computational environment

- **Language:** Stata 18
- **User-written packages:** `table1_mc`, `catplot`, `coefplot`, `pmcalplot`, `cleanplots` (see install commands above).
- **OS/architecture tested:** Author‑provided code has been used on Windows and macOS; Stata 18 is cross‑platform.
- **Randomness:** The analysis is deterministic; when bootstrap is used (for calibration plots), seeds are set in the do‑file.

## Repository layout

```
├── Hickam Analysis.do                # main analysis script (Stata)
├── Survey_Responses.xlsx             # survey data (anonymous)
├── NEJM Cases.xlsx                   # tabulated NEJM cases
├── Published Case Reviews.xlsx       # tabulated case reports
├── Results and Figures/              # (created by the do-file on run)
└── README.md, CITATION.cff, CONTRIBUTING.md, CODE_OF_CONDUCT.md, SECURITY.md, LICENSE
```

## Releasing and archiving
For a citable snapshot, create a GitHub Release and enable Zenodo archiving, which will mint a DOI for the exact code state that matches the paper. Add the release DOI to this README and to `CITATION.cff`.

## Funding, conflicts, and contact

- **Funding:** The authors report **no funding** for the study.
- **Conflicts of interest:** One author (B.W.L.) advises and owns equity in Mountain Biometrics; the authors report no other conflicts.
- **Maintainer / questions:** Please open a GitHub issue in this repository. (If you prefer email, use the corresponding author listed in the paper.)

## Licenses

- **Code:** MIT License (see `LICENSE`).  
- **Text/figures/tables produced here:** CC BY 4.0, unless noted.  
- **Data files:** Content created by the authors is CC BY 4.0; any third‑party copyrighted content remains under its original terms.

---
**Provenance.** The paper is open access under CC BY 4.0; it states that raw data and Stata 18 code are available in this repository and that the IRB exempted the anonymous survey. The do-file documents which tables/figures are exported and where.

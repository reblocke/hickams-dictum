# Contributing

Thanks for your interest in improving this research compendium! We welcome bug reports, documentation improvements, and small, targeted code changes.

## Ways to contribute
- **Bug reports:** Open a GitHub issue with a minimal description of the problem and steps to reproduce (include Stata version and OS).
- **Documentation:** Fix typos, clarify instructions, or add missing details.
- **Code:** Keep changes small and focused; prefer clear, well‑commented Stata code over clever one‑liners. If you add user‑written dependencies, document their installation in the README.
- **Reproducibility:** If a figure/table cannot be regenerated, open an issue and attach the log from `Results and Figures/<date>/Logs/`.

## Development setup
1. Install Stata 18 and the user‑written packages listed in the README.
2. Clone the repo and ensure the three Excel files are in the repo root.
3. Run the analysis in batch (`stata-mp -b do "Hickam Analysis.do"`) or via the GUI.
4. Verify that `Results and Figures/<date>/` contains the expected outputs.

## Code style & logs
- Keep file paths **relative** to the repository directory.
- Use informative graph/table filenames (the existing do‑file already exports with descriptive names).
- Do **not** commit generated outputs under `Results and Figures/`; share them via releases if needed.
- Leave helpful comments around blocks that correspond to specific manuscript figures/tables.

## Pull requests
- Create a feature branch and make your changes there.
- Include a short summary in the PR description of what and why.
- Link to the relevant issue(s), if any.
- Expect review focused on clarity, correctness, and reproducibility.

## Large files
Avoid adding raw data files > 50 MB to Git history. If needed, use Git LFS or link to an external archival repository.

## Licensing & attribution
- Code changes are contributed under the MIT License.
- Documentation contributions are under CC BY 4.0.
- Please keep `CITATION.cff` current so users know how to cite the work.

## Conduct
By participating, you agree to abide by the project Code of Conduct (`CODE_OF_CONDUCT.md`).


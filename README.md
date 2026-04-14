# England & Wales 2021 microcensus analysis of nurses' commuting patterns

[![Zenodo DOI](https://zenodo.org/badge/1018535453.svg)](https://zenodo.org/badge/latestdoi/1018535453)
[![OSF DOI](https://img.shields.io/badge/OSF-10.17605%2FOSF.IO%2FQS4WV-blue)](https://doi.org/10.17605/OSF.IO/QS4WV)

## Overview
This repository contains the public analysis code and supporting documentation for the completed England & Wales 2021 microcensus analysis of nurses' commuting patterns.

The study examines commuting distance and transport mode among nurses and midwives compared with a comparator occupational group using England & Wales microcensus data. The associated manuscript has been submitted to *International Nursing Review* and is currently under peer review.

This repository is being shared to improve transparency and reproducibility. The underlying microdata are restricted-access and cannot be made publicly available here.

## Citation

If you use this code, please cite the archived Zenodo release:

Jamieson, M., & Atherton, I. (2026). *England & Wales microcensus 2021 nurse commute project analysis code* (Version 1.0.0) [Software]. Zenodo. https://doi.org/10.5281/zenodo.19209218

Concept DOI for the repository as a whole: https://doi.org/10.5281/zenodo.19209219

## Study status
- **Analysis status:** completed
- **Manuscript status:** submitted to *International Nursing Review*; under peer review
- **Preregistration status:** none for this England & Wales analysis, because the study was completed before the current prospective open-science workflow was established
- **Related OSF project:** https://osf.io/8pexy/overview
- **Related future work:** a separate Scotland analysis is planned under a prospective open-science workflow

## Repository contents
- `inr_nurse_eng_wal_analysis.R` — main R analysis script
- `docs/manuscript_status.md` — short note on manuscript status and versioning
- `LICENSE` — licence for the code in this repository
- `CITATION.cff` — citation metadata for GitHub and downstream archives
- `.gitignore` — standard exclusions for local and generated files

## Data access and restrictions
The analysis uses restricted-access microcensus data. These data are **not** included in this repository and cannot be shared publicly.

Anyone wishing to rerun the analysis would need:
1. legitimate access to the underlying data through the relevant governance route;
2. local adaptation of file paths and, where necessary, environment-specific settings; and
3. the required R packages installed locally.

## Software and package dependencies
The main script currently loads the following R packages:
- `haven`
- `dplyr`
- `tidyr`
- `forcats`
- `MASS`
- `broom`
- `tibble`
- `tidyselect`
- `gtsummary`

Users may also need additional packages depending on later sections of the script and local execution environment.

## Reproducibility note
This repository is intended as a transparency archive for the code used in the England & Wales analysis. Because the underlying data are restricted and the script currently contains environment-specific file paths, some local modification will be required before the code can be rerun in another secure environment.

## Citation
Please cite the archived release of this repository.

- **GitHub repository:** `https://github.com/YOUR-USERNAME/nurse-travel-england-wales-analysis`
- **Zenodo DOI:** `TO BE ADDED AFTER FIRST RELEASE`

Once a Zenodo release DOI has been minted, that DOI should be used as the primary citation target for the code.

## Suggested citation
**Before Zenodo DOI is minted**

Jamieson, M. *England & Wales microcensus 2021 nurse commute project analysis code* [code repository]. GitHub. Available at: `https://github.com/YOUR-USERNAME/nurse-travel-england-wales-analysis`

**After Zenodo DOI is minted**

Jamieson, M. (2026). *England & Wales microcensus 2021 nurse commute project analysis code* (Version 1.0.0) [Computer software]. Zenodo. `https://doi.org/10.5281/zenodo.xxxxxxx`

## Author and affiliation
**Michelle Jamieson**  
Edinburgh Napier University  
Scottish Centre for Administrative Data Research

**Iain Atherton**  
Edinburgh Napier University  
Scottish Centre for Administrative Data Research

## Recommended related links
- OSF project hub: https://osf.io/8pexy/overview
- Add Zenodo DOI here after release
- Add published article citation here once available

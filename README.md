# England & Wales 2021 microcensus analysis of nurses' commuting patterns

[![OSF](https://img.shields.io/badge/OSF-10.17605%2FOSF.IO%2FQS4WV-blue)](https://doi.org/10.17605/OSF.IO/QS4WV)
[![DOI](https://zenodo.org/badge/1018535453.svg)](https://zenodo.org/badge/latestdoi/1018535453)
[![Environment](https://img.shields.io/badge/Environment-Safegaurded%20Data-orange)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

This repository provides the analysis code for a completed study of nurses’ commuting patterns using England & Wales Census 2021 microdata. The project is documented on OSF and archived on Zenodo for reproducibility.

---

## Overview

This repository contains the analysis code and minimal supporting documentation for the England & Wales 2021 microcensus analysis of nurses’ commuting patterns.

The study compares commuting distance and transport mode among nurses and midwives with a comparator occupational group using Census 2021 microdata (England & Wales).

The associated manuscript is currently under peer review at *International Nursing Review*.

---

## Open science and transparency

This project follows a hybrid open science model:

- **OSF (project hub: protocol, materials, documentation)**  
  https://doi.org/10.17605/OSF.IO/QS4WV

- **Zenodo (versioned, citable archive of analysis code)**  
  https://doi.org/10.5281/zenodo.19209219

The analysis uses restricted-access Census microdata, which cannot be shared publicly. This repository provides the full analytical workflow required to reproduce the results within an approved secure research environment.

---

## Study status

- Analysis: complete  
- Manuscript: under review (*International Nursing Review*)  
- Preregistration: not applicable (retrospective analysis)

---

## Repository structure

- `inr_nurse_eng_wal_analysis.R` — main analysis script  
- `manuscript_status.md` — manuscript tracking notes  
- `CITATION.cff` — citation metadata  
- `LICENSE` — MIT license

---

## Data access

The analysis uses restricted-access Census 2021 microdata (England & Wales).

These data are not publicly available. Access is subject to approval via the relevant secure research service.

To reproduce the analysis, users must:
- obtain authorised access to the data;
- adapt file paths and environment-specific settings; and
- install required R packages.

---

## Software and dependencies

The main script uses the following R packages:

- haven  
- dplyr  
- tidyr  
- forcats  
- MASS  
- broom  
- tibble  
- tidyselect  
- gtsummary  

Additional packages may be required depending on execution environment and extensions to the analysis.

---

## Reproducibility

This repository provides the complete analytical logic used in the study. Full reproducibility requires execution within an approved secure data environment.

The code may require minor modification to run in different environments due to:
- secure data access constraints;
- environment-specific file paths; and
- dependency management.

---

## Citation

Please cite the archived Zenodo release:

Jamieson M, Atherton I. England & Wales microcensus 2021 nurse commute analysis code (Version 1.0.1) [software]. Zenodo. https://doi.org/10.5281/zenodo.19209219

Concept DOI (all versions):  
https://doi.org/10.5281/zenodo.19209219

---

## Authors and affiliation

Michelle Jamieson  
Edinburgh Napier University  
Scottish Centre for Administrative Data Research  

Iain Atherton  
Edinburgh Napier University  
Scottish Centre for Administrative Data Research  

---

## Related resources

- OSF project hub: https://doi.org/10.17605/OSF.IO/QS4WV  
- Zenodo archive: https://doi.org/10.5281/zenodo.19209219  
- Manuscript: under review (*International Nursing Review*)

---

## License

This repository is licensed under the MIT License.

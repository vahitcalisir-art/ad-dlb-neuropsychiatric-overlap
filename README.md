# Genetic overlap between neuropsychiatric traits and Alzheimer's disease and dementia with Lewy bodies

Analysis code, summary results and manuscript build tools for the study "Genetic overlap between neuropsychiatric traits and AD and DLB: local genetic correlation and bidirectional MR study" (Original Research, submitted to Frontiers in Dementia).

The study tests genome-wide genetic correlation (LDSC), local genetic correlation (LAVA) and bidirectional two-sample Mendelian randomization between four psychiatric traits (major depressive disorder, post-traumatic stress disorder, insomnia, schizophrenia) and Alzheimer's disease (AD) and dementia with Lewy bodies (DLB), using public GWAS summary statistics only.

## Repository layout

| Path | Content |
|---|---|
| `analysis/analysis_plan.md`, `analysis_plan.sha256` | Analysis plan frozen before the cross-trait analyses (SHA-256 recorded at freezing) |
| `analysis/deviations.md` | Every departure from the frozen plan, with reason and timing (Supplementary Table S1) |
| `analysis/R/` | Analysis scripts, run in numeric order (see below); shared settings in `utils.R` |
| `analysis/run_pipeline_gate3.sh`, `analysis/run_gate3_extra.sh` | End-to-end rerun used for the reproducibility check |
| `analysis/logs/` | Run logs, harmonisation QC, clumping logs, `session_info.txt` (R and package versions) |
| `data/` | Download scripts and data manifest only; no GWAS data are included |
| `results/results.json`, `results/tables/`, `results/figures/` | All reported values, tables and figure data |
| `manuscript/` | Manuscript sections in Markdown; every number is inserted from `results/results.json` |
| `tools/` | Manuscript build and checks (DOCX build, audit, reference verification, Gate 3 comparison, supplement build) |
| `sources/` | Reference registry, bibliographic metadata and reading notes with the verbatim passages behind each citation (publisher full texts are not included) |
| `docs/` | Journal requirements and archived copies of the journal and data-provider pages that were consulted |
| `build/` | Progress log, audit report, Gate 3 comparison reports, figure previews, submission checklist |

## Data

No data are redistributed here. All inputs are public summary statistics that can be downloaded without application, data use agreement or fee:

- AD (Bellenguez et al., 2022): GWAS Catalog GCST90027158
- DLB (Chia et al., 2021): GWAS Catalog GCST90001390
- MDD (without 23andMe), PTSD and SCZ: Psychiatric Genomics Consortium, https://pgc.unc.edu/for-researchers/download-results/ (doi: 10.6084/m9.figshare.27061255, 10.6084/m9.figshare.26349322, 10.6084/m9.figshare.19426775)
- Insomnia (UK Biobank only): Complex Trait Genetics lab, https://cncr.nl/research/summary_statistics/ (doi: 10.5281/zenodo.24366723)
- FinnGen release 13, endpoint G6_ALZHEIMER: https://www.finngen.fi/en/access_results
- LAVA UK Biobank and 1000 Genomes LD reference: distributed with LAVA (https://github.com/josefin-werme/LAVA); clumping reference: http://fileserve.mrcieu.ac.uk/ld/1kg.v3.tgz

`data/download_open.sh`, `data/download_open_parallel.sh` and `data/download_terms.sh` download the files into `data/raw/` and record size and SHA-256. `data/DATA_MANIFEST.md`, `data/source_verification.md` and `data/finngen_verification.md` document the files, publisher checksums, terms of use and the FinnGen endpoint.

## Software

R 4.3.3 with GenomicSEM 0.0.5, LAVA 0.1.5, TwoSampleMR 0.7.14, MRPRESSO 1.0, MRlap 0.0.3.3, simex 1.8 and coloc 5.2.3 (`analysis/setup_packages.R`; full versions in `analysis/logs/session_info.txt`); PLINK 1.9 for clumping against the local 1000 Genomes EUR reference. Python 3.12 for the manuscript tools (`requirements.txt`).

## Running the analysis

Scripts resolve paths relative to the repository root. After downloading the data:

```
Rscript analysis/R/01_munge.R
Rscript analysis/R/02_ldsc.R
Rscript analysis/R/03_lava.R ukb
Rscript analysis/R/03_lava.R ukb strandcheck
Rscript analysis/R/03_lava.R g1000
Rscript analysis/R/03c_lava_integrity.R
Rscript analysis/R/04_mr.R
Rscript analysis/R/04b_mr_output_integrity.R
Rscript analysis/R/05_mr_sensitivity.R
Rscript analysis/R/05b_ptsd_ad_finngen.R
Rscript analysis/R/05c_steiger_prevalence.R
Rscript analysis/R/05d_steiger_insomnia_prev030.R
Rscript analysis/R/06_coloc.R
Rscript analysis/R/06b_power_summary.R
Rscript analysis/R/06c_lava_reference_diagnostic.R
Rscript analysis/R/06d_lava_g1000_fdr_pairs.R
Rscript analysis/R/07_figures.R
Rscript analysis/R/07b_tables.R
Rscript analysis/R/07c_instrument_table.R
```

Worker counts are set with the environment variables `LAVA_CORES`, `MR_CORES` and `MRLAP_CORES`. LAVA uses a fixed base seed with per-pair seeds, so the local analysis is reproduced exactly. The full run took about 17 hours with 4 workers on a 32 GB machine.

The manuscript is built with `python tools/text_keys.py`, `python tools/audit_manuscript.py`, `python tools/verify_refs.py`, `python tools/build_docx.py` and `python tools/build_supplement.py`.

## Reproducibility check (Gate 3)

The complete pipeline was re-run from the raw summary statistics in a separate directory (`analysis/run_pipeline_gate3.sh`, `analysis/run_gate3_extra.sh`) and compared with the reported results by `tools/compare_gate3.py`. All 3,795 values in `results.json`, 35 tables (419,585 cells) and the 4 figures were identical; only file paths, run times and file timestamps differed (explicit whitelist in the script). The report is `build/gate3_comparison.md`.

## Licence

Code (`analysis/`, `tools/`, `sources/*.py`, `sources/*.sh`, `data/*.sh`): MIT licence (`LICENSE`). Results, figures and documentation written for this project: Creative Commons Attribution 4.0 International (CC BY 4.0, https://creativecommons.org/licenses/by/4.0/). Third-party material is not covered by these licences: the archived web pages in `docs/evidence/` and the verbatim passages quoted in `sources/notes/` remain under the terms of their publishers and are included only to document the sources used; GWAS summary statistics remain under their providers' terms.

## Citation

A versioned archive with a DOI will be created on acceptance. Until then, please cite the manuscript.

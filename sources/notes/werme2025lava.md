> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Werme J, de Leeuw CA; LAVA (Local Analysis of [co]Variant Association) software documentation, GitHub README, repository josefin-werme/LAVA, note dated 2025-06-27 for LAVA v0.1.5; README at commit e729a245f7b6 (last change 2026-07-28), retrieved 2026-11-21 from https://raw.githubusercontent.com/josefin-werme/LAVA/main/README.md; official software documentation (not peer reviewed); access route: public GitHub repository (local copy sources/fulltext/werme2025lava_README_e729a245f7b6.md)

## Section-by-section reading log
- Abstract: (not applicable: software README; no abstract)
- Introduction: (not applicable: software README) The opening NOTE states that, as of v0.1.5, custom LAVA LD reference files based on a large UK Biobank cohort are available, and the developers strongly recommend the UK Biobank reference instead of 1,000 Genomes for European-ancestry analyses because the 1,000 Genomes data were found to lead to possible inflation of type 1 error rates and bias in local heritability estimates due to its small sample size; the evidence is linked to a preprint (preprints.org 202507.0966, de Leeuw, Werme, Posthuma, "Re-Evaluating Local Genetic Correlation Analysis in the HDL Framework"; not peer reviewed; a reply preprint by other authors exists, preprints.org 202508.1096).
- Methods: (not applicable) Installation, input format (info file, sample-overlap file, locus file, LD reference in LAVA format; preprocessed reference data linked from REFERENCE.md), univariate test, bivariate local rg, multiple regression and partial correlation, eQTL input.
- Results: (not applicable)
- Discussion: (not applicable)
- Limitations stated by authors: the recommendation rests on a non-peer-reviewed preprint.
- Supplementary material: not applicable

## Quality appraisal
Official documentation of the software used (LAVA v0.1.5), written by its developers; authoritative for what the developers recommend, not for the empirical claim itself, whose evidence is an unpublished preprint in an open exchange with other authors. Used only to state the developers' recommendation that motivated the pre-registered reference choice.

## Relevance to this manuscript
- M2/M4: reason for the pre-registered choice of the UK Biobank LAVA reference (analysis plan §0.3 item 5), written as the developers' recommendation, not as established fact.
- D3: 1000 Genomes sensitivity analysis (reference-panel difference) — the README states the developers' concern; any causal interpretation of the 1000 Genomes results stays cautious.

## Decision
KEEP — only verbatim source for the pre-registered rationale (investigator decision 2026-11-21, item 2c/2e).

## Claims
- c1 | Introduction | "We **strongly** recommend that users switch to using the UK Biobank reference …" | Developers recommend the UK Biobank LD reference for European-ancestry LAVA analyses (M2)
- c2 | Introduction | "possible inflation of type 1 error rates and bias in the local …" | Developers' stated reason: possible type I error inflation and local h2 bias with the small 1000 Genomes panel (M2, D3)
- c3 | Introduction | "custom LAVA LD reference files based on a large UK Biobank cohort …" | UK Biobank LAVA reference available from v0.1.5 (M2)

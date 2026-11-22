> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Burgess S, Davies NM, Thompson SG; 2016; Bias due to participant overlap in two-sample Mendelian randomization; Genetic Epidemiology 40(7):597–608; DOI 10.1002/gepi.21998; methodological simulation study with worked examples; access route PMC-XML (PMC5082560)

## Section-by-section reading log
- Abstract: One-sample weak-instrument bias is toward the observational association; two-sample bias is toward the null. With partial overlap, bias (continuous outcome) is linear in the proportion of overlap: relative bias 10% at F=10 in one-sample becomes 5% at 50% overlap and 3% at 30%. In case-control settings, risk-factor associations estimated in controls only give unbiased estimates; using cases too gives bias similar to continuous outcomes. Consortia should release risk-factor associations excluding cases.
- Introduction: IV assumptions (all variants assumed valid but possibly weak). Weak-instrument bias and type 1 error inflation in one-sample; two-sample bias conservative toward null. Overlapping consortia make direction unclear.
- Methods: Theory of weak-instrument bias (2SLS overfitting; relative bias ≈ 1/E(F); IVW equivalent to 2SLS). Simulation 1: 20 SNPs (MAF 0.3), continuous outcome, overlap 0–100% in 10% steps, n=10,000 per sample, 10,000 replicates, causal effect 0.2 or 0, confounder effect 0.6/1/2, α 0.04/0.06/0.08. Analytic formulae: bias under null = OLS × overlap% × 1/F; type 1 error formula; variance formula; F–R² relation. Simulation 2 validates formulae; Simulation 3 binary case-control outcome (5,000 cases/5,000 controls) with risk factor measured in controls only vs all.
- Results: Table 1: bias linear in overlap; with positive effect, bias shifts from toward null (0% overlap) to toward confounded association; with null effect no bias at 0% overlap. Table 2: relative bias ≈ 1/mean F; empirical type 1 error up to 84.8% at mean F 1.2, 5.9% at F 85. Table 3: controls-only risk-factor associations show no bias or type 1 inflation; all-participant associations biased. F statistic highly variable (3.4–22.6 across substudies); suggests external R² and lower confidence limit for F. Examples: GIANT–GLGC overlap ~71% but F≈97 so little bias; GIANT–CARDIoGRAMplusC4D 27/38 studies overlap; EduYears follow-up F=5.1 risky.
- Discussion: Linear overlap bias; percentage overlap relative to larger dataset; winner's curse from discovery data accentuates bias; MR-Egger bias more pronounced, I² better indicator than F; practical recommendations: non-overlapping exposure data, equal weights, fewer stronger variants; web app sb452.shinyapps.io/overlap.
- Limitations stated by authors: assumes valid IVs; no clear way to evaluate bias from discovery-sample overlap; formula for MR-Egger one-sample bias not derived; approximations less accurate for weakest instruments and binary outcomes; non-collapsibility of odds ratios.
- Supplementary material: not available (Web Appendix A1–A4 with R code referenced)

## Quality appraisal
Peer-reviewed, well-cited methods paper; analytic formulae validated by simulation. Assumes valid instruments and linear models. No conflicts of interest. Consistent with hemani2018mr and bowden2016consistent on overlap bias; underpins MRlap-type corrections (mounier2023bias).

## Relevance to this manuscript
M2: primary citation for bias due to participant overlap (direction, linear dependence on overlap fraction, dependence on F), weak-instrument bias directions, and recommendations. D6: limitation discussion of sample overlap between exposure and outcome GWAS (e.g. shared cohorts/UK Biobank), winner's curse, MR-Egger sensitivity.

## Decision
KEEP — key method reference for sample-overlap bias motivating the study's MRlap sensitivity analysis.

## Claims
- c1 | Abstract | "For a continuous outcome, bias due to sample overlap is a linear …" | Overlap bias linear in overlap fraction (M2, D6)
- c2 | Abstract | "if the relative bias of the one‐sample instrumental variable estimate is 10% …" | Quantitative magnitude of overlap bias (M2, D6)
- c3 | Introduction | "This bias (known as weak instrument bias) acts in the direction of …" | Direction of weak-instrument bias in one-sample/overlap (M2, D6)
- c4 | Introduction | "In a two‐sample Mendelian randomization analysis, any bias due to weak instruments …" | Direction of weak-instrument bias in non-overlapping two-sample MR (M2, D6)
- c5 | Results | "This suggests that a conventional Mendelian randomization analysis with a binary outcome …" | Case-control outcome nuance for overlap bias (M2, D6)
- c6 | Discussion | "If the datasets are of different size, then the percentage overlap in …" | How to compute overlap proportion (M2)
- c7 | Discussion | "Weak instrument bias will be accentuated if the genetic variants were initially …" | Winner's curse compounds overlap bias (D6)
- c8 | Discussion | "This means that bias due to sample overlap may be more serious …" | MR-Egger more sensitive to overlap bias (M2, D6)

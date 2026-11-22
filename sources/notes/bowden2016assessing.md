> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Bowden J, Del Greco M F, Minelli C, et al.; 2016; Assessing the suitability of summary data for two-sample Mendelian randomization analyses using MR-Egger regression: the role of the I2 statistic; International Journal of Epidemiology 45(6):1961–1974; DOI 10.1093/ije/dyw220; methodological paper (new diagnostic, bias correction, simulation, applied example); access route PMC-XML (PMC5446088)

## Section-by-section reading log
- Abstract: IVW and MR-Egger treat SNP-exposure associations as known (NOME assumption). IVW weak-instrument bias indexed by F-statistic; for MR-Egger an adapted I² statistic (I²GX, 0–1) indicates expected relative bias (dilution) of the MR-Egger slope in two-sample MR. SIMEX explored to correct dilution. Simulations: NOME violation biases MR-Egger toward null; with all variants valid, MR-Egger pleiotropy test type I error inflated; SIMEX mitigates. LDL-c→CAD example: I²GX close to 1. Recommends caution if I²GX < 90%.
- Introduction: IVW assumes all valid IVs; horizontal pleiotropy common with many GWAS variants; F-statistic not sufficient for MR-Egger; instrument strength for MR-Egger is a collective property, weak set induces regression dilution.
- Methods: Two-sample model with independent non-overlapping samples, uncorrelated variants, oriented positive SNP-exposure associations. NOME defined. IVW with first-order weights; F_j ≈ γ̂²/σ²X; two-sample weak instrument bias toward null. MR-Egger under InSIDE; intercept detects only directional pleiotropy. Expected MR-Egger slope ≈ β × var(γ)/var(γ̂). I²GX = (Q_GX − (L−1))/Q_GX computed from Cochran's Q of SNP-exposure estimates; weighted version uses γ̂/σY and σX/σY. I²GX 0.9 ≈ 10% bias, analogous to F=10. SIMEX: simulate increasing measurement error (1+λ)σ²X, fit extrapolation model, extrapolate to λ = −1; crude β̂/I²GX unstable.
- Results: Simulation (25 SNPs, 5000 replicates; Table 1 F̄=125, I²GX 0.95–0.75; Table 2 F̄=20, I²GX 0.60–0.40): unadjusted MR-Egger slope ≈ β × estimated I²GX; with balanced pleiotropy and I²GX=75%, MR-Egger intercept type I error >10%; SIMEX corrects bias when F̄ high but less effective when F̄ low, and under causal null with low F̄ and I²GX SIMEX can be worse than no adjustment. I²GX estimate variability decreases with more instruments. LDL-c→CAD (57 variants, mean F 132): IVW 0.45 (SE 0.053); MR-Egger intercept −0.0102 (P=0.0298), slope 0.632; I²GX 0.971 weighted, 0.974 unweighted; SIMEX slope 0.650 (Table 3), multiplicative random effects.
- Discussion: IVW unbiased under balanced pleiotropy and more powerful; MR-Egger more robust to directional pleiotropy but less robust to NOME violation; I²GX more relevant than F for MR-Egger; MR-Egger remains reliable for testing causal null even when NOME violated.
- Limitations stated by authors: one-sample setting not addressed; InSIDE assumed in simulations (InSIDE violation biases MR-Egger regardless of I²GX); idealised summary data ignore non-collapsibility and ascertainment for case-control binary outcomes; SIMEX is only one possible correction; naive division unreliable in general.
- Supplementary material: not available (Appendix with technical details referenced)

## Quality appraisal
Peer-reviewed, foundational diagnostic paper; no conflicts declared. Simulations idealised (normal summary data, InSIDE on average). Threshold of 0.9 is a heuristic analogy to F=10. Consistent with bowden2015mendelian; partially revises its examples.

## Relevance to this manuscript
M2: primary citation for NOME assumption, I²GX definition and 0.9 (90%) threshold, and SIMEX correction of MR-Egger; also IVW weak-instrument bias toward null in two-sample. D6: weak-instrument/regression dilution as limitation of MR-Egger; binary case-control outcomes not handled in the framework.

## Decision
KEEP — the I²GX/SIMEX method used directly in the study's MR-Egger analyses.

## Claims
- c1 | Abstract | "Both methods use weights that consider the single nucleotide polymorphism (SNP)-exposure associations …" | Definition of NOME assumption (M2)
- c2 | Abstract | "An adaptation of the I 2 statistic from the field of meta-analysis …" | I²GX purpose (M2)
- c3 | Abstract | "the MR-Egger estimate of causal effect is biased towards the null when …" | MR-Egger regression dilution indexed by I²GX (M2, D6)
- c4 | Key Messages | "An I G X 2 value of 0.9 indicates a relative bias …" | Interpretation of the 0.9 threshold (M2)
- c5 | Discussion | "If it is sufficiently low (less than 90%), point estimates of causal …" | I²GX < 0.9 rule and SIMEX recommendation (M2)
- c6 | Methods | "Under SIMEX, new data sets are created by simulating SNP-exposure association estimates …" | SIMEX procedure (M2)
- c7 | Discussion (Limitations) | "If InSIDE is violated, for example due to pleiotropic effects acting via …" | I²GX does not protect against InSIDE violation (M2, D6)
- c8 | Discussion | "It is comforting to note that standard MR-Egger regression remains a reliable …" | MR-Egger causal null test robust to NOME violation (M2)

> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Bowden J, Davey Smith G, Burgess S; 2015; Mendelian randomization with invalid instruments: effect estimation and bias detection through Egger regression; International Journal of Epidemiology 44(2):512–525; DOI 10.1093/ije/dyv080; methodological paper (statistical method + applied examples + simulation); access route PMC-XML (PMC4469799)

## Section-by-section reading log
- Abstract: Frames multi-instrument MR as a meta-analysis; pleiotropy bias is analogous to small-study bias; Egger regression adapted (MR-Egger) gives a test for directional pleiotropy (intercept) and a slope estimate of the causal effect that is consistent under InSIDE even if all variants are invalid.
- Introduction: Large numbers of GWAS variants increase precision but also the chance of invalid IVs via horizontal pleiotropy; pleiotropic variants bias IVW/TSLS and inflate type I error.
- Methods: Linear structural model with gamma_j (variant–exposure) and alpha_j (direct pleiotropic effect). IV1–IV3 defined (IV3 = exclusion restriction). Ratio (Wald) estimate; IVW estimate = fixed-effect meta-analysis weighted by inverse outcome-SE squared, equivalent to weighted regression through origin. Bias of IVW = weighted function of alpha/gamma. InSIDE (Instrument Strength Independent of Direct Effect) defined as independence of gamma and alpha distributions; weaker version of exclusion restriction. MR-Egger = weighted regression with unconstrained intercept; intercept = average pleiotropic effect; slope consistent under InSIDE as N and J go to infinity. Funnel and scatter plots for visual asymmetry. Variants must be oriented so all exposure associations are positive.
- Results: Height→FVC (ALSPAC, 180 variants, n=3631): IVW 0.59 (0.50, 0.67); MR-Egger intercept -0.0009, P=0.75; MR-Egger slope 0.60 (0.46, 0.75); Cochran's Q P=0.99. BP→CAD (29 variants, CARDIoGRAM): SBP IVW 0.054 (P=4×10−6) vs MR-Egger 0.015 (P=0.64), intercept P=0.21; DBP IVW 0.083 vs MR-Egger −0.024, intercept P=0.054; strong Q heterogeneity. Simulation (Table 1, 10,000 datasets, 25 variants, two-sample): IVW biased under directional pleiotropy; MR-Egger approximately unbiased with SEs about twice as large and low power; under InSIDE violation (scenario d) MR-Egger less biased than IVW. Table 2: with many weak variants (J>100) MR-Egger type I error inflates.
- Discussion: Box 1 summarizes assumptions and procedure. Relation to median-based and lasso methods requiring at least half valid instruments. Cochran's Q heterogeneity as over-identification test. Weak-instrument bias: towards confounded observational association in one-sample, towards null in two-sample. Winner's curse and sample overlap noted as alternative explanation of funnel asymmetry.
- Limitations stated by authors: InSIDE fails if pleiotropy acts via confounders (e.g. population stratification, upstream exposure); low power; no reliable SE method for non-zero effect; assumes uncorrelated variants; assumes homogeneous causal effect across IVs.
- Supplementary material: not available (Web Appendix with R/Stata code referenced only)

## Quality appraisal
Foundational, peer-reviewed methods paper with formal derivation and simulation; widely adopted. Limitations openly stated (InSIDE untestable, low power, weak-instrument sensitivity). Not an empirical study, so sample size not relevant beyond examples. No conflicts with other sources; later refined by bowden2016assessing (I²GX/SIMEX) regarding NOME violation.

## Relevance to this manuscript
M2: primary citation for MR-Egger (intercept test of directional pleiotropy, slope under InSIDE), IVW definition, Cochran's Q heterogeneity, IV assumptions. D6: weak-instrument bias direction in two-sample MR, sample overlap/winner's curse, low power of MR-Egger.

## Decision
KEEP — original MR-Egger method paper, used directly in the study's sensitivity analyses.

## Claims
- c1 | Abstract | "Under the assumption that the association of each genetic variant with the …" | MR-Egger validity under InSIDE (M2)
- c2 | Methods | "We refer to the condition that the distributions of these parameters are …" | Definition of InSIDE assumption (M2)
- c3 | Discussion (Box 1) | "If the intercept differs from zero (the MR-Egger test), then there is …" | MR-Egger intercept as test of directional pleiotropy (M2)
- c4 | Discussion (Box 1) | "In this regression model, the intercept is constrained to equal zero. This …" | IVW assumption that all instruments are valid (M2)
- c5 | Discussion | "When there are pleiotropic instruments but the InSIDE assumption is not satisfied, …" | MR-Egger as sensitivity analysis and its limits (M2, D6)
- c6 | Discussion (Box 1) | "The InSIDE assumption would be violated if the pleiotropic effects act via …" | InSIDE violation mechanism (M2, D6)
- c7 | Discussion | "Considerable heterogeneity would be evidence that the genetic variants are estimating different …" | Cochran's Q heterogeneity interpretation (M2)
- c8 | Discussion | "In a two-sample setting, weak instrument bias is in the direction of …" | Weak instrument bias direction in two-sample MR (D6)

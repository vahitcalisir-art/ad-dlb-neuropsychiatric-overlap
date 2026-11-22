> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Bowden J, Davey Smith G, Haycock PC, et al.; 2016; Consistent Estimation in Mendelian Randomization with Some Invalid Instruments Using a Weighted Median Estimator; Genetic Epidemiology 40(4):304–314; DOI 10.1002/gepi.21965; methodological paper (new estimator, simulation, applied example); access route PMC-XML (PMC4849733)

## Section-by-section reading log
- Abstract: Proposes the weighted median estimator, consistent when up to 50% of the information comes from invalid IVs; better finite-sample type 1 error than IVW; complementary to MR-Egger. Lipids→CAD example: IVW suggests HDL-c effect, weighted median and MR-Egger suggest null, matching trials.
- Introduction: Reverse causation and confounding motivate MR; IV1–IV3 defined (IV1 only testable). Two challenges with multiple variants: sample overlap with weak instruments causes bias and inflated type 1 error; invalid instruments.
- Methods: Linear model, uncorrelated variants, two-sample summary data. IVW = inverse-variance-weighted mean of ratio estimates, 0% breakdown. Simple median: 50% breakdown. Weighted median: median of weighted empirical distribution of ratio estimates using first-order inverse-variance weights; consistent if at least 50% of weight from valid IVs; assumes no single IV contributes >50% of weight; CIs by parametric bootstrap. Penalized weighted median downweights variants by Cochran's Q contribution (weight × min(1, 20q)). MR-Egger and InSIDE summarized (intercept = average pleiotropy; InSIDE likely if pleiotropy direct, violated if via a shared confounder).
- Results: Simulation (25 variants, n=10,000/20,000, 10,000 datasets, invalid proportion 0.1–0.3; Tables 2–3): balanced pleiotropy all methods unbiased; directional pleiotropy with InSIDE: IVW biased, weighted median less biased, MR-Egger unbiased but SE ~3× IVW; InSIDE violated: all biased, MR-Egger worst, penalized weighted median lowest type 1 error. Applied (185 variants, GLGC/CARDIoGRAM, Table 4): LDL-c IVW 0.482 (0.060), weighted median 0.458 (0.065), MR-Egger 0.617 (0.103); HDL-c IVW −0.254 (0.070) vs weighted median −0.069 (0.071), MR-Egger −0.013 (0.115), intercept −0.014 (0.005) P<0.05; triglycerides robust. Median methods SE 30–50% smaller than MR-Egger.
- Discussion: Table 5 summary of breakdown levels (IVW 0%, median 50%, MR-Egger 100% under InSIDE). Median methods agnostic to mechanism of invalidity (LD, stratification, differential survival). Selection bias not resolved. Assumes no causal effect heterogeneity. Warns against data-driven cherry-picking of variants. Recommends reporting a range of robust sensitivity analyses.
- Limitations stated by authors: 50% valid-weight assumption still required and untestable; selection bias unaddressed; no causal effect heterogeneity assumed; not guidance on variant selection; inflated type 1 error when ≥20% variants invalid with directional pleiotropy.
- Supplementary material: not available (Supporting Information described: one-sample simulations Tables A1–A3, Figures A1–A2, R code)

## Quality appraisal
Peer-reviewed, foundational methods paper with simulation and positive-control applied example; widely used. Not an empirical study, sample size not applicable. Authors declare no conflict of interest. Consistent with bowden2015mendelian; complements hartwig2017robust (mode-based).

## Relevance to this manuscript
M2: primary citation for weighted median estimator and its 50%-valid-weight assumption, IVW 0% breakdown, rationale for using multiple robust estimators with differing assumptions. D6: sample overlap with weak instruments causes bias/inflated type 1 error; selection bias not resolved by robust estimators.

## Decision
KEEP — original weighted median method paper, used directly in the study's sensitivity analyses.

## Claims
- c1 | Abstract | "This estimator is consistent even when up to 50% of the information …" | Weighted median robustness property (M2)
- c2 | Methods | "Although the simple median provides a consistent estimate of causal effect if …" | Weighted median assumption: at least half the weight from valid instruments (M2)
- c3 | Methods | "The IVW estimate is an efficient analysis method when all genetic variants …" | IVW efficiency and sensitivity to any invalid instrument (M2)
- c4 | Discussion | "MR‐Egger regression can give consistent estimates when 100% of genetic variants are …" | Contrast of MR-Egger and weighted median assumptions (M2)
- c5 | Introduction | "if there is substantial overlap in the datasets from which the association …" | Bias from sample overlap with weak instruments (M2, D6)
- c6 | Discussion | "Consistent estimates would be guaranteed if some genetic variants were invalid IVs …" | Median methods agnostic to mechanism of invalidity (M2)
- c7 | Discussion | "Selection bias may affect all genetic variants in a particular analysis, and …" | Selection/survival bias not resolved by robust estimators (D6)
- c8 | Discussion | "perform and report results from a range of sensitivity analyses using robust …" | Rationale for multiple sensitivity estimators (M2)

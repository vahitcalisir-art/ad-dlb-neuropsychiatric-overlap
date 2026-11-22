> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Hartwig FP, Davey Smith G, Bowden J; 2017; Robust inference in summary data Mendelian randomization via the zero modal pleiotropy assumption; International Journal of Epidemiology 46(6):1985–1998; DOI 10.1093/ije/dyx102; methodological paper (new estimator, simulation, applied examples); access route PMC-XML (PMC5837715)

## Section-by-section reading log
- Abstract: Proposes the mode-based estimate (MBE): consistent when the largest group of similar ratio estimates comes from valid instruments, even if most instruments are invalid. Less bias and lower type I error than other methods under the null in many settings; power lower than IVW and weighted median but higher than MR-Egger.
- Introduction: IV assumptions (relevance, independence, exclusion restriction); IVW requires all valid or balanced pleiotropy plus InSIDE; MR-Egger and weighted median relax assumptions.
- Methods: Two-sample summary-data model; ratio estimate and delta-method SE; NOME (no measurement error) assumption defined. ZEMPA: the mode of the bias terms is zero. Breakdown of simple MBE between ~50% and 100(L−2)/L %; weighted MBE 50%–100% (exclusive). Implementation: mode of a normal-kernel smoothed empirical density of ratio estimates (simple and inverse-variance weighted), bandwidth via modified Silverman rule with tuning parameter phi; SE by parametric bootstrap (MAD). Four simulation scenarios (L=30 variants; InSIDE-respecting and InSIDE-violating pleiotropy; power in two-sample; 50%/100% sample overlap). F-statistic and I²GX used to quantify NOME violation in IVW and MR-Egger. Cochran's Q for heterogeneity. Applied: lipids (185 variants) and urate (31 variants) on CHD.
- Results: Sim 1 (InSIDE holds): MR-Egger least biased; MBEs less biased than IVW and weighted median. Sim 2 (InSIDE violated): MBEs less biased than IVW, weighted median and MR-Egger except ≥80% invalid. Sim 3: power order IVW > weighted median > weighted MBE > simple MBE > MR-Egger. Overlap sim: MR-Egger most biased; MBE very imprecise in small samples. Applied (Table 4): HDL-C IVW −0.254 (95% CI 0.115; 0.393 decrease) not confirmed by weighted MBE −0.003; urate IVW 0.163 (0.027; 0.298) not confirmed by others; smallest I²GX 0.993; Q P-values 0.0003 to 1.7×10−21.
- Discussion: Table 5 gives breakdown and pleiotropy assumptions for IVW, MR-Egger, simple/weighted median, simple/weighted MBE. Finite-sample contamination even under ZEMPA; phi is bias–variance trade-off; NOME weights unnecessary for MBE; simple vs weighted MBE comparison useful; CIs over-cover; regression dilution in MBE needs research. Related to Guo et al. and Kang et al. MBE recommended in combination with other methods.
- Limitations stated by authors: finite-sample bias even when ZEMPA holds; true breakdown level unknown in practice; low precision in small samples; choice of bandwidth; over-coverage of CIs; regression dilution not characterized.
- Supplementary material: not available (Supplementary Tables S1–S7, Methods with R code referenced)

## Quality appraisal
Peer-reviewed methods paper with extensive simulation; no conflicts declared. Assumption (ZEMPA) untestable; performance sensitive to bandwidth. Consistent with bowden2016consistent (complementary robust estimator). Not an empirical study, sample size not applicable.

## Relevance to this manuscript
M2: primary citation for weighted mode (MBE) estimator and ZEMPA assumption; also states IVW assumption (all valid or balanced pleiotropy + InSIDE), Table 5 summary of breakdown levels, rationale for triangulating estimators. D6: MBE low power and sample-overlap behaviour.

## Decision
KEEP — original weighted mode method paper, used directly in the study's sensitivity analyses.

## Claims
- c1 | Abstract | "The MBE is consistent when the largest number of similar (identical in …" | Weighted mode consistency property (M2)
- c2 | Key Messages | "The MBE requires that the most common causal effect estimate is a …" | Definition of ZEMPA (M2)
- c3 | Discussion (Table 5) | "Consistent if the largest weights among the k subsets are contributed by …" | Weighted MBE assumption (M2)
- c4 | Introduction | "the inverse variance weighting (IVW) method requires that either all variants are …" | IVW assumption (M2)
- c5 | Abstract | "Its power to detect a causal effect was smaller compared with the …" | Relative power of mode estimator (M2, D6)
- c6 | Results | "Importantly, the precision of the MBE was very low, suggesting that the …" | MBE imprecision; suited to two-sample summary-data setting (M2, D6)
- c7 | Methods | "Cochran’s Q test was used to test for the presence of horizontal …" | Use of Cochran's Q for heterogeneity/pleiotropy (M2)
- c8 | Discussion | "Using several methods that make different assumptions, rather than a single method, …" | Rationale for multiple MR estimators (M2)

> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Hemani G, Tilling K, Davey Smith G; 2017; Orienting the causal relationship between imprecisely measured traits using GWAS summary data; PLoS Genetics 13(11):e1007081 (correction e1007149); DOI 10.1371/journal.pgen.1007081; methodological paper (theory, simulation, applied example); access route PMC-XML (PMC5711033)

## Section-by-section reading log
- Abstract: Measurement error can make the mediation-based causal inference test (CIT) infer the wrong direction, worsening with sample size. Introduces an MR extension (MR Steiger) to infer causal direction using summary data, less susceptible to measurement error and unmeasured confounding. Applied to DNA methylation vs gene expression; results sensitive to measurement error and horizontal pleiotropy; recommends triangulation.
- Introduction: Mediation-based approaches vs MR; MR robust to exposure measurement error when assumptions hold; bidirectional MR requires valid instruments for each trait; difficulty knowing which trait a SNP primarily affects; two-sample MR advantages.
- Methods: Model with scale and imprecision measurement error. CIT four tests. MR causal test via 2SLS. Steiger's Z-test for correlated correlations (one-sample) and for independent correlations (two-sample) comparing variance explained by SNP in exposure vs outcome; direction inferred from sign(Z) with p_Steiger. Reliability metric R (ratio of measurement-error parameter space supporting vs opposing the inferred direction). Simulations: 432 parameter combinations × 100 replicates; n = 100, 1000, 10000. Applied: 458 methylation–expression associations (Shakhbazov et al.), Wald ratio; implemented in MR-Base.
- Results: CIT infers wrong direction as exposure imprecision rises; sample size increases confidence in wrong answer. MR Steiger FDR ~0.05; liable to wrong direction when d<0 (d = ρx,xo − ρx,y ρy,yo); unlikely to err from confounding when observational variance explained <0.2. Applied: methylation predominantly causal (p=1.3×10−5), median R 3.92 (1.08–37.11); conclusion very sensitive to platform measurement error.
- Discussion: MR preferable to mediation-based methods; MR Steiger extends to multiple instruments (total variance explained, assuming independence); possible extension to binary traits using liability-scale variance explained with population prevalence; assumes no horizontal pleiotropy; winner's curse not accounted for.
- Limitations stated by authors: Steiger assumes a causal relationship and a valid instrument for one trait; wrong direction possible with horizontal pleiotropy, differential measurement error, or unmeasured confounding; winner's curse inflates variance explained; simulations limited to single instrument, one-sample, quantitative traits; non-differential uncorrelated measurement error only.
- Supplementary material: not available (S1–S3 Text, S1–S2 Fig described)

## Quality appraisal
Peer-reviewed methods paper (PLoS Genetics), no competing interests. Simulations limited to quantitative traits and single instruments; application to binary disease outcomes requires liability-scale conversion with assumed prevalence (relevant to our prevalence assumptions). Consistent with other MR methods literature.
Correction checked 2026-11-21 (Correction 10.1371/journal.pgen.1007149): reference 36 was incorrect; no effect on any claim used here.

## Relevance to this manuscript
M2: primary citation for Steiger directionality test/Steiger filtering, its assumptions and failure modes; bidirectional MR concept. M3: supports need for population prevalence when computing variance explained on liability scale for binary traits. D6: winner's curse, measurement error and pleiotropy as threats to directional inference.

## Decision
KEEP — original MR Steiger method paper; Steiger filtering is used directly in the study.

## Claims
- c1 | Methods | "The Steiger test assumes that there is a causal relationship between the …" | Steiger test assumptions (M2)
- c2 | Methods | "First, some levels of horizontal pleiotropy, where the SNP influences the outcome …" | Steiger failure mode: pleiotropy (M2, D6)
- c3 | Methods | "Third, some levels of unmeasured confounding between the exposure and the outcome …" | Steiger failure mode: confounding (M2, D6)
- c4 | Introduction | "if valid genetic instruments are known for both traits of interest then …" | Bidirectional MR rationale (M2)
- c5 | Discussion | "We also note that it is straightforward to extend the MR Steiger …" | Steiger with multiple instruments (M2)
- c6 | Discussion | "it is possible that the analysis could be extended to binary traits …" | Liability-scale variance for binary traits requires prevalence (M2, M3)
- c7 | Discussion | "We also haven’t accounted for the influence of winner’s curse, which can …" | Winner's curse limitation of Steiger (D6)
- c8 | Methods | "Note that the same correlation test approach can be applied to a …" | Steiger applicable in two-sample summary-data MR (M2)

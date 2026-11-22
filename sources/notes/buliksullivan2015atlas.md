> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Bulik-Sullivan B, Finucane HK, Anttila V, et al.; 2015; An atlas of genetic correlations across human diseases and traits; Nature Genetics 47(11):1236-1241; DOI 10.1038/ng.3406; methods paper (cross-trait LD score regression) with application to 24 GWAS; access route: PMC-XML (NIHMS author manuscript, PMC4797329)

## Section-by-section reading log
- Abstract: Introduces cross-trait LD score regression (LDSC) to estimate genetic correlation from GWAS summary statistics only, not biased by sample overlap; 276 rg among 24 traits (e.g. anorexia-schizophrenia, anorexia-obesity, education with diseases).
- Introduction: Observational epidemiology suffers confounding and reverse causation; genetics can help. MR uses significant SNPs only; rg uses all SNPs and suits highly polygenic traits. REML and polygenic scores need individual genotypes.
- Methods: Expected product of z-scores E[z1j z2j] depends on LD score (slope = genetic covariance) plus intercept term rho*Ns/sqrt(N1N2) capturing sample overlap and phenotypic correlation; shared population stratification also affects mainly the intercept. Constrained-intercept option lowers SE (up to 30%) but biased if intercept misspecified. rg = genetic covariance normalised by SNP heritabilities; no observed vs liability scale distinction for rg. Two-step estimator (intercept estimated excluding chi2>30 SNPs). Block jackknife SE with 200 blocks. LD scores from N=378 1000 Genomes Europeans; HapMap3 SNPs; munging filters (INFO>0.9, MAF>1%, remove strand-ambiguous, indels, allele mismatches with 1000 Genomes). GC correction biases h2 and covariance but cancels in rg. Discussion of reverse causation (primarily concern for high-prevalence diseases) and non-random ascertainment (case/control/covariate sampling attenuates rg). rg is asymptotically proportional to MR estimates; rg differs from pleiotropy (requires consistent direction).
- Results: Simulations with complete sample overlap (2,062 individuals, chr2): accurate rg (truth 0.50, estimate 0.49; Table 1), SEs match SD; not biased by case oversampling; rg robust to misspecified architecture as biases cancel in the ratio. Replicates REML psychiatric cross-disorder rg (Fig. 1). 276 pairwise rg (Fig. 2; 1176 among 49 traits in Suppl. Table 4). Alzheimer's-years of education rg -0.29 (0.1); schizophrenia-Alzheimer's rg 0.04 (0.06), p>0.1; AD rg with other psychiatric traits near zero with large SEs. RA vs CD/UC near-zero rg despite shared loci because effect directions are mixed.
- Discussion: Advantages: no individual genotypes, no genome-wide significant SNPs, no LD pruning, unbiased by sample overlap. rg is immune to environmental confounding but subject to genetic confounding (analogous to pleiotropy in MR); affected by misclassification and covariate-based sampling.
- Limitations stated by authors: needs larger samples than individual-level methods; not applicable to recently admixed populations; assortative mating not investigated; most effective for polygenic traits (traits with large-effect SNPs better analysed via those SNPs).
- Supplementary material: not available (referenced only)

## Quality appraisal
Highly cited, peer-reviewed foundational method with simulation validation. AD data were IGAP stage 1 (17,008 cases/37,154 controls), much smaller than Bellenguez 2022, so its AD-psychiatric null rg are low-powered. No MR. No conflicts declared. Consistent with buliksullivan2015ld on intercept and reference-panel robustness.

## Relevance to this manuscript
- M2: cross-trait LDSC method (slope = genetic covariance, intercept absorbs sample overlap and stratification), robustness of rg to sample overlap; use of intercepts as overlap estimates for LAVA.
- D3: robustness to moderate ancestry mismatch between LD reference and GWAS sample; 1000 Genomes EUR LD scores suitable for European meta-analyses; not applicable to admixed samples.
- D1: prior near-zero rg between AD and schizophrenia/psychiatric traits.
- I3: example (RA vs CD/UC) of shared loci with mixed directions giving near-zero genome-wide rg (masking argument; pleiotropy vs rg distinction).
- D6: reverse causation and ascertainment effects on rg; low power with small samples.

## Decision
KEEP — core method paper for genome-wide rg (LDSC via GenomicSEM) used by the study, plus prior AD-psychiatric rg results.

## Claims
- c1 | Abstract | "for estimating genetic correlation that requires only GWAS summary statistics and is …" | Cross-trait LDSC needs only summary statistics and is robust to sample overlap (M2)
- c2 | Results | "The expected magnitude of this inflation is uniform across all markers, and …" | Sample overlap inflation is absorbed by the intercept, not the slope (M2, D6)
- c3 | Results | "so the estimates of genetic correlation will not be biased by sample …" | rg robust to sample overlap (M2)
- c4 | Results | "Similarly, shared population stratification will alter the intercept but have minimal impact …" | Cross-trait intercept also captures shared stratification (M2, D3)
- c5 | Methods | "single-trait LD Score regression is only minimally biased by uncorrected population stratification …" | LDSC robustness to moderate LD-reference/population mismatch (D3)
- c6 | Methods | "LD Scores estimated from the 1000 Genomes reference panel are suitable for …" | Justification for 1000 Genomes EUR LD scores (M2, D3)
- c7 | Discussion | "Second, cross-trait LD Score regression is not currently applicable to samples from …" | Ancestry restriction of LDSC (D3, D6)
- c8 | Results | "This suggests that the genetic basis of Alzheimer’s disease is distinct from …" | Prior genome-wide rg found AD near-uncorrelated with psychiatric traits (D1, I3)
- c9 | Methods | "Genetic correlation estimates for traits with heritability z -score below 4 are …" | Heritability Z < 4 threshold for flagging rg as low power (M2, D4)

> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Bulik-Sullivan BK, Loh P-R, Finucane H, et al. (with the Schizophrenia Working Group of the PGC); 2015; LD Score Regression Distinguishes Confounding from Polygenicity in Genome-Wide Association Studies; Nature Genetics 47(3):291–295; DOI 10.1038/ng.3211 (PMID 25642630; PMC4495769; NIH author manuscript); statistical methods paper (method + simulations + application to >20 GWAS phenotypes); access route PMC-XML (published version, author manuscript)

## Section-by-section reading log
- Abstract: Polygenicity and confounding (cryptic relatedness, population stratification) both inflate GWAS test statistics; LD Score regression separates them via the relationship between test statistics and LD; the intercept gives a more powerful and accurate correction factor than genomic control; polygenicity accounts for most inflation in large GWAS.
- Introduction: Variants in LD with causal variants show inflation proportional to LD; cryptic relatedness and drift-driven stratification do not correlate with LD Score. E[χ2|ℓj] = N h2 ℓj / M + N a + 1; holds for meta-analyses and ascertained binary traits (h2 on observed scale); intercept minus one estimates the mean contribution of confounding bias.
- Methods (Results overview + Online Methods): LD Scores from 1000 Genomes EUR (378 phased individuals), unbiased r2 estimator, 1 cM windows, singletons excluded (MAF > 0.13%); jackknife SEs and attenuation-bias correction; EUR MAF < 1% and long-range LD/large-effect loci excluded from regression; HapMap3 SNPs (~1.1 million), long-range LD and pericentromeric regions removed; weights for LD overcounting and heteroskedasticity; block-jackknife SEs (~2,000 SNP blocks). Reference/target mismatch: mean-zero noise biases intercept up and slope down; directional differences bias intercept down or up. Intra-European mean LD Scores (MAF > 1%): EUR 110, CEU 109, GBR 104, FIN 117, TSI 102; FIN 7% larger (recent Finnish bottleneck), TSI 8% smaller; EUR LD Scores on an all-Finnish GWAS may bias the intercept upward; worst-case bias ±10 × slope (~±10% of inflation attributed to confounding), more likely upward. EUR panel adequate for outbred predominantly northern-European populations (European American, UK); other populations need a different panel. Assumes no systematic correlation between FST and LD Score.
- Results: Simulations — polygenic traits give intercept ~1 (few causal variants: unbiased but very large SEs); pure stratification gives intercept ≈ λGC; mixed stratification/relatedness + polygenicity (WTCCC2, Framingham) correctly partitioned; not noticeably biased by case-control ascertainment; frequency-dependent architecture minimal bias (mean intercept 0.994); fails if all causal variants are rare. Real data (>20 phenotypes; Table 1): slope always > 0, intercept below λGC (mean difference 0.11). Schizophrenia (~70,000 Europeans): intercept 1.07 (Table 1: 1.070, SE 0.010), mean χ2 1.613. Major Depression intercept 1.009; Bipolar 1.030; ADHD 1.008. (Published numbers differ from the preprint: >20 phenotypes vs >30; SCZ intercept 1.07 vs 1.066; MDD 1.009 vs 1.005; Bipolar 1.030 vs 1.028.)
- Discussion: Direct genotype-level correction preferred when possible; with summary data only, the intercept is a more robust quantification of confounding than λGC, with power gain growing with sample size; extension to East Asian or West African populations straightforward with appropriate reference panels; admixed populations future research; extensions to heritability components and genetic correlation in progress.
- Limitations stated by authors: variance per SNP correlated with LD Score (MAF-dependent architectures) can bias the intercept downward; ineffective if all causal variants are rare; unstable (large SEs) with few causal variants; linked selection may correlate FST with LD Score; reference–target LD mismatch (including Finland/Italy) biases the intercept; model misspecification may moderately inflate intercepts in large well-calibrated GWAS; not yet for admixed populations.
- Supplementary material: not available (referenced only)

## Quality appraisal
Foundational, peer-reviewed method (Nat Genet 2015), extensive simulation validation; no competing interests. Text is the NIH author manuscript of the published article. Concordant with the cross-trait LDSC extension (buliksullivan2015atlas) regarding 1000 Genomes EUR LD Scores. Not MR.

## Relevance to this manuscript
- M2: what the LDSC intercept and slope estimate (confounding vs polygenicity), 1000 Genomes EUR LD Scores, HapMap3 restriction; intercept as conservative correction.
- D3: explicit LD-reference mismatch statements — EUR panel adequate for northern-European/UK populations; FIN mean LD Score 7% higher; EUR LD Scores on an all-Finnish GWAS may bias the intercept upward (FinnGen R13 AD sensitivity analysis); worst-case ±10% bias.
- D6: few causal variants / low polygenic signal → very large SEs (relevant to the small DLB GWAS).

## Decision
KEEP — core LDSC method paper underpinning genome-wide rg and the D3 population-mismatch argument; now read in its published version.

## Claims
- c1 | Introduction | "if we regress χ 2 statistics from GWAS against LD Score (LD …" | LDSC intercept estimates confounding; slope reflects polygenic signal (M2)
- c2 | Results | "We note that if there are few causal variants, the LD Score …" | Instability with few causal variants / weak polygenic signal (M2, D6)
- c3 | Results | "If there is mismatch between LD Scores from the reference population and …" | LD-reference vs GWAS-population mismatch biases LDSC (D3)
- c4 | Results | "in comparison to the combined EUR LD Score, the mean LD Score …" | Finnish LD structure differs from pan-European reference (D3)
- c5 | Results | "the EUR reference panel is adequate for studies in outbred populations of …" | Validity of EUR reference for UK/European GWAS; other populations need other panels (D3, M2)
- c6 | Methods | "The observation that the mean LD Score in the Finnish (FIN) population …" | Elevated Finnish LD reflects founder bottleneck (D3)
- c7 | Methods | "if one attempts to perform LD Score regression using the 1000 Genomes …" | EUR LD Scores on a Finnish GWAS may bias the intercept upward (D3; FinnGen sensitivity analysis)
- c8 | Results | "The low intercept of 1.07 and indicates at most a small contribution …" | Schizophrenia GWAS inflation mostly polygenic (M2)

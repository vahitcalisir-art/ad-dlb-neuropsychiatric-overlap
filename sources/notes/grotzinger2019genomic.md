> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Grotzinger AD, Rhemtulla M, de Vlaming R, et al.; 2019; Genomic structural equation modelling provides insights into the multivariate genetic architecture of complex traits; Nature Human Behaviour 3(5):513-525; DOI 10.1038/s41562-019-0566-x; methods paper (multivariate method, simulations, applications); access route: PMC-XML (NIHMS author manuscript, PMC6520146)

## Section-by-section reading log
- Abstract: Genomic SEM synthesises rg and SNP-h2 from GWAS summary statistics of samples with varying and unknown overlap; models multivariate genetic architecture, multivariate GWAS, polygenic scores, heterogeneity (Q_SNP). Five-psychiatric-trait p-factor: 27 new independent SNPs.
- Introduction: Pervasive pleiotropy (including insomnia-schizophrenia rg); existing methods cannot model causes of observed rg; Genomic SEM models genetic covariance structure from summary statistics.
- Methods: Two-stage SEM. Stage 1: multivariable LDSC estimates genetic covariance matrix S (h2 diagonal, genetic covariances off-diagonal) and its sampling covariance matrix V_S via an expanded block jackknife; off-diagonal elements of V_S capture dependence from sample overlap. Stage 2: WLS (default, diagonally weighted) or ML estimation with sandwich-corrected SEs; nearPD smoothing. For categorical outcomes, liability-scale h2 and covariances should populate S. SNP-level models use cross-trait LDSC intercepts for sampling covariances of SNP effects. Fit indices: model chi2 (N-free), CFI, AIC, SRMR. QC defaults: MAF<1%, INFO<0.9, MHC removed, HapMap3 SNPs; LD scores from 1000 Genomes Phase 3 restricted to HapMap3. Multivariate GWAS QC: reference MAF<0.01, INFO<0.6. PLINK clumping r2 0.1, 500 kb (1 Mb for chr 6 and 8) with 1000 Genomes Phase 3 reference. Simulations: factor structure recovery (UKB genotypes, 39,909 individuals), partial sample overlap (bivariate intercept .67 as expected; no upward bias of Z statistics, slope 1.003), MTAG equivalence.
- Results: Psychiatric p-factor (SCZ, BIP, MDD, PTSD, anxiety; European) fit adequate (CFI .848, SRMR .212); 128 loci for p-factor, 27 new; neuroticism 118 loci, 38 new; Q_SNP 1 (p-factor) and 69 (neuroticism) loci. LDSC intercepts of Genomic SEM output ~.99 (no uncontrolled inflation). p-factor PGS outperformed univariate PGS in UKB. DEPICT: nervous-system enrichment.
- Discussion: Accounts for unknown sample overlap; flexible covariance modelling; compares with MTAG, GWIS, GW-SEM.
- Limitations stated by authors: Genomic SEM inherits assumptions and limitations of the covariance estimator (LDSC): no LD pruning, ethnically homogeneous samples of similar ancestry; WLS may be dominated by the best-powered GWAS; SRMR positively biased with low-powered GWAS; power depends on h2, rg, N and overlap; reference vs sample MAF discrepancies.
- Supplementary material: not available (referenced only)

## Quality appraisal
Peer-reviewed, widely used methods paper with simulation validation, including explicit validation under sample overlap. Our study uses only its LDSC (multivariable ldsc function) for genome-wide rg, not SEM modelling. No conflicts declared. Consistent with Bulik-Sullivan 2015 (inherits LDSC assumptions).

## Relevance to this manuscript
- M2: GenomicSEM ldsc() as the implementation of genome-wide rg; handles unknown sample overlap via sampling covariance matrix; liability-scale conversion for binary traits (requires population prevalence, links to M3); QC defaults (HapMap3, MAF, INFO, MHC); 1000 Genomes Phase 3 LD scores; PLINK clumping parameters as an example.
- D3: requirement for ancestrally homogeneous samples; inherits LDSC assumptions.
- D6: sample overlap handled; low-powered GWAS issues.

## Decision
KEEP — software/method paper for the LDSC implementation (GenomicSEM) actually used by the study.

## Claims
- c1 | Abstract | "Genomic SEM synthesizes genetic correlations and SNP-heritabilities inferred from GWAS summary statistics …" | GenomicSEM estimates rg/h2 from summary statistics with unknown sample overlap (M2)
- c2 | Results | "we demonstrate that the inclusion of data from overlapping samples does not …" | Robustness to sample overlap (M2, D6)
- c3 | Methods | "Here we use a novel version of LDSC that accounts for potentially …" | How multivariable LDSC in GenomicSEM handles overlap (M2)
- c4 | Methods | "The same strengths, as well as assumptions and limitations, that are known …" | GenomicSEM-based rg inherits LDSC assumptions (M2, D3)
- c5 | Results | "summary statistics for different phenotypes should be obtained from ethnically homogeneous samples …" | Ancestry homogeneity requirement for LDSC/GenomicSEM (D3)
- c6 | Methods | "when the outcomes are categorical, the liability scale heritabilities and genetic covariances …" | Liability-scale estimates used for binary traits, requiring population prevalence inputs (M2, M3)
- c7 | Methods | "including removing SNPs with an MAF < 1%, information scores < .9, …" | Default LDSC QC in GenomicSEM (M2)
- c8 | Methods | "The LD scores used for the analyses presented were estimated from 1000 …" | 1000 Genomes-based LD scores (M2)

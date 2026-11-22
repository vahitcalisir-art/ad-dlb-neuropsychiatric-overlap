> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Shi H, Mancuso N, Spendlove S, et al.; 2017 (published version: Am J Hum Genet 101(5):737-751, DOI 10.1016/j.ajhg.2017.09.022); "Local genetic correlation gives insights into the shared genetic architecture of complex traits"; text file is the bioRxiv preprint (doi 10.1101/092668, version posted 8 December 2016), NOT the published AJHG version; methods paper (rho-HESS) with simulations and application to 35 traits; access route: OA-PDF (bioRxiv preprint)

## Section-by-section reading log
- Abstract: rho-HESS quantifies trait-pair correlation due to genetic variation in a small region, from GWAS summary data, no distributional assumption on effect sizes, accounting for LD and sample overlap. 35 traits: 27 regions with significant local rg; 7 regions for 12 trait pairs with negligible genome-wide rg; putative causal direction for 15 pairs.
- Introduction: Colocalisation posterior probabilities do not convey direction/magnitude; genome-wide rg aggregates all variants. Local rg in ~1.5 Mb approximately independent LD blocks (Berisa-Pickrell). Unbiased with in-sample LD; approximately unbiased with 1000 Genomes reference LD.
- Methods: Fixed-effect model; local genetic covariance from marginal betas and pseudo-inverse of LD matrix, bias-corrected for sample overlap (needs n_s and phenotypic correlation, the latter from cross-trait LDSC); truncated-SVD regularisation of reference LD; local rg = covariance standardised by local SNP-h2; recommend local rg only at loci with significant local h2; parametric bootstrap SE. Simulations: 1000 Genomes EUR halves (202/203 individuals), HAPGEN2 50,000 individuals. Empirical: 35 European GWAS (N>20,000), 1,703 LD blocks, HapMap3 SNPs MAF>5%, strand-ambiguous removed, HLA excluded. Bi-directional causal inference via local rg at trait-specific GWAS loci.
- Results: Unbiased in simulations; cross-trait LDSC adapted locally is biased. Aggregated estimates concordant with LDSC (R = 0.74); 234 vs 99 significant genome-wide pairs (Fig. 3). HDL-LDL: genome-wide rg -0.05 but 9 loci with significant local rg (APOB, APOA, APOE regions; Fig. 7). MCV-PLT chr6:134-136M local rg 1.0 vs genome-wide 0.01. Putative SCZ -> UC causal direction.
- Discussion: Approximately unbiased irrespective of architecture; identifies local signals regardless of genome-wide significance.
- Limitations stated by authors: requires phenotypic correlation and number of shared individuals (assumed full overlap within consortium, none across) — misspecification biases; bi-directional analysis only putative causality; covariate-adjusted GWAS may cause false inference; loci assumed independent (long-range LD); truncated-SVD introduces bias with fixed eigenvector number.
- Supplementary material: not available

## Quality appraisal
Peer-reviewed in published form (AJHG 2017); text is the preprint. A competing local rg method (rho-HESS), not used by the study. No dementia or relevant psychiatric pairs except schizophrenia with blood/immune traits. No conflicts declared. Its masking argument is concordant with, and cited by, Werme et al. (LAVA).

## Relevance to this manuscript
- I3: genome-wide rg can be null because positive and negative local covariances cancel; local rg detected in pairs with negligible genome-wide rg. However, werme2022integrated (the method actually used) states the same argument explicitly ("local rg’s in opposing directions could result in a low or completely non-significant global rg") and shows it empirically, including psychiatric traits.
- M2 (indirect): recommends local rg only at loci with significant local h2 — same rationale as LAVA's univariate filter, but LAVA's own paper suffices.

## Decision
DROP — competing local rg method not used by the study; its masking argument (I3) is fully covered by werme2022integrated, so it adds no distinct claim (optional second citation for the cancellation mechanism only; if kept, cite the AJHG 2017 version, not the preprint).

## Claims
- c1 | Results | "can be attributed to either symmetric distribution of local genetic covariance (positive …" | Optional only: null genome-wide rg may reflect cancelling local covariances (I3)
- c2 | Results | "genetic covariance cancels out negative local genetic covariance, see Figure 1) and/or …" | Optional only: cancellation mechanism of opposite-sign local signals (I3)
- c3 | Abstract | "of 12 pairs of traits that show negligible genome-wide correlation, further showcasing" | Optional only: local rg found where genome-wide rg is negligible (I3)

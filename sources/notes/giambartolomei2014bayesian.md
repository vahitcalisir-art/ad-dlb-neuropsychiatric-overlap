> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Giambartolomei C, Vukcevic D, Schadt EE, et al.; 2014; Bayesian test for colocalisation between pairs of genetic association studies using summary statistics; PLoS Genetics 10(5):e1004383; DOI 10.1371/journal.pgen.1004383; methods paper (Bayesian colocalisation, coloc) with simulations and application (lipids x liver eQTL); access route: PMC-XML (PMC4022491)

## Section-by-section reading log
- Abstract: Method to assess whether two association signals are consistent with a shared causal variant, from single-SNP summary statistics; applicable to any pair of GWAS datasets. Re-analysis of 966 liver eQTL samples with lipid meta-analysis (>100,000 Europeans): supported 26/38 reported colocalisations, 14 new; coloc R package and web server.
- Introduction: Visual overlap insufficient because eQTLs are abundant; previous ranking and proportionality tests require SNP selection (winner's curse bias) and individual-level data; Sherlock addresses a different question.
- Methods: Two traits in distinct samples of unrelated individuals from the same ethnic group (identical allele frequencies and LD). Assumptions: causal variant included (typed or well imputed) and at most one association per trait in the region. Each configuration assigned to one of five hypotheses: no association; trait 1 only; trait 2 only; both traits with two independent SNPs; both traits with one shared SNP (H0-H4; symbols lost in text extraction). Posterior probabilities PP0-PP4 via Wakefield approximate Bayes factors summed over configurations weighted by SNP-level priors; prior SD of effect 0.20 binary, 0.15 quantitative. SNP-level priors for association with each trait and with both traits (numeric prior values are missing from the plain text — only the interpretation "1 in 100 SNPs associated with trait 1 also associated with the other" and sensitivity "1 in 50", "1 in 10" survive). Conditional (stepwise) analysis to handle multiple signals.
- Results: Simulations: with biomarker N=2,000 the causal variant must explain ~2% of variance for reliable PP4>80% (Fig. 3); missing causal variant reduces PP4 but PP3 stays low (loss of power, not misleading inference; Figs 4-5); outperforms proportional testing in distinguishing colocalisation from lack of power; PP4 only affected by secondary signal of similar strength (Fig. S8). Application: 26/38 reported loci PP4 supported, 14 novel colocalised loci (Table 2), several reported eQTL-lipid pairs not supported (PP3>75%, Table 1); MHC results to be interpreted with caution. Prior choice determinant in strong-LD loci (ANGPTL3 PP4 91% to 49%).
- Discussion: Aim is not fine-mapping but whether a shared causal variant is plausible; dense genotyping/imputation key; equal prior for all variants; low PP4 with low PP3 indicates limited power; high PP4 is correlation not causality; multiple genes in a region can all show high PP4.
- Limitations stated by authors: single causal variant per trait assumption; requires causal variant typed/imputed; imputation uncertainty; equal SNP priors; independence of effect sizes under shared variant; prior choice influential in high-LD regions; conditional approach may be biased by top-SNP selection.
- Supplementary material: not available (Text S1/S2 and tables referenced only)

## Quality appraisal
Peer-reviewed, foundational and widely used colocalisation method. Simulation-based power assessment indicates DLB-scale GWAS may lack power (PP0-PP2 dominating). Problem: plain-text extraction from PMC-XML dropped inline mathematical symbols, so hypothesis labels (H0-H4) and the numeric default priors (p1, p2, p12) cannot be quoted verbatim from this file; default priors should be cited from the coloc package documentation / Wallace 2020 or verified in the PDF. No conflicts declared.

## Relevance to this manuscript
- M2: coloc method — five hypotheses, PP4 as evidence of a shared causal variant, PP3 distinct variants; single-causal-variant and same-population assumptions; ABF from summary statistics.
- D6: low PP4 with high PP0-PP2 reflects low power (relevant to DLB); high PP4 is not causality; single-variant assumption at multi-signal loci (e.g. APOE region); MHC caution.
- D3: assumes both samples share the same LD/allele frequencies (population mismatch).

## Decision
KEEP — the colocalisation method used by the study (always KEEP); flag that priors and hypothesis labels need verification from the PDF or coloc documentation.

## Claims
- c1 | Abstract | "We have developed a novel statistical methodology to assess whether two association …" | What coloc tests (M2)
- c2 | Results | "A large posterior probability for hypothesis 3, PP3, indicates support for two …" | Interpretation of PP3 / H3 (M2)
- c3 | Results | "In contrast, if PP4 is large, the data support a single variant …" | Interpretation of PP4 / H4 (M2)
- c4 | Results | "Secondly, that at most one association is present for each trait in …" | Single-causal-variant assumption (M2, D6)
- c5 | Results | "We assume that samples are drawn from the same ethnic group, i.e. …" | Same-ancestry/LD assumption (M2, D3)
- c6 | Results | "A key advantage in our Bayesian approach is the ability to distinguish …" | Distinguishing absence of colocalisation from low power (M2, D6)
- c7 | Discussion | "a low PP4 may not indicate evidence against colocalisation in situations where …" | Low PP4 can reflect limited power (D6; DLB)
- c8 | Discussion | "Moreover, a high PP4 is a measure of correlation, not causality." | Interpretive caution for colocalised loci (D5, D6)

> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Hemani G, Zheng J, Elsworth B, et al.; 2018; The MR-Base platform supports systematic causal inference across the human phenome; eLife 7:e34408; DOI 10.7554/eLife.34408; software/resource paper with applied example; access route PMC-XML (PMC5976434)

## Section-by-section reading log
- Abstract: MR-Base integrates a curated database of complete GWAS summary results with an API, web app and R packages (TwoSampleMR, MRInstruments) automating two-sample MR (2SMR), including sensitivity analyses for horizontal pleiotropy. 11 billion SNP-trait associations from 1673 GWAS.
- Introduction: GWAS summary data uses; MR principles and IV assumptions (IV1 relevance, IV2 no alternative pathway, IV3 no confounder association); vertical vs horizontal pleiotropy; Figure 1 describes IVW (fixed/random), MR-Egger (InSIDE), median (majority valid), mode (largest cluster valid).
- Methods (Model and Materials and methods): workflow: instrument selection (p<5×10−8, replication), clumping against similar-ancestry reference, outcome extraction, LD proxies from 1000 Genomes (503 Europeans, r²≥0.6, within 250 kb), harmonisation (wrong effect allele, strand, palindromic SNPs resolved by allele frequency, incompatible alleles excluded). Methods: Wald ratio, IVW (random effects by default, fixed if underdispersion), maximum likelihood, MR-Egger, weighted median, weighted mode; diagnostics: heterogeneity (Q), leave-one-out, funnel plots; access to MR-PRESSO, RadialMR, MendelianRandomization, mr.raps. Database QC pipeline (Elasticsearch) described.
- Results: Database 1673 GWAS, ~11 billion associations, 4 million samples, median n 21,315; 605 UK Biobank traits. LDL→CHD example: GLGC/CARDIoGRAMplusC4D with 28–31% overlap, F=85; random-effects IVW OR 1.45 (1.30–1.62); Q=122.5, p=4.72e-07; MR-Egger intercept −0.013 (p=0.020), OR 1.85 (1.48–2.32); weighted median 1.56 (1.43–1.70); weighted mode 1.68 (1.56–1.80); leave-one-out stable. PheWAS of outliers (rs11065987 near BRAP; hematocrit pathway). Hypothesis-free MR-PheWAS of LDL lowering.
- Discussion: strengths (efficiency, QC reliability, reproducibility, central repository, Steiger test for reverse-causal instruments). Limitations inherent to 2SMR: sample overlap biases toward confounded observational association (weak-instrument bias), worse with winner's curse; strong instruments (F≫10) minimise it; exposure and outcome samples should be from same population; differing populations bias magnitude but direction still informative. Limitations compounded by MR-Base: multiple testing, interpretation, winner's curse from automated instrument selection (discovery GWAS). Directional and null inferences more reliable than magnitudes.
- Limitations stated by authors: as above (sample overlap, population mismatch, multiple testing/data dredging, winner's curse, GWAS catalog unit ambiguity); Steiger test subject to assumptions.
- Supplementary material: not available (Supplementary file 1A–G listed)

## Quality appraisal
Peer-reviewed (eLife, with published decision letters). Resource paper rather than causal study; applied example confirmatory. No competing interests declared (funding includes GSK, Biogen for individual authors). Consistent with method papers it implements.

## Relevance to this manuscript
M2: citation for MR-Base/TwoSampleMR software, harmonisation and clumping procedures, random-effects IVW default, leave-one-out, heterogeneity, Steiger use. D3/D6: sample overlap bias toward confounded estimate, need for strong instruments, population/LD mismatch affecting magnitude but not direction, winner's curse.

## Decision
KEEP — the TwoSampleMR/MR-Base software paper used directly in the study.

## Claims
- c1 | Abstract | "We therefore developed MR-Base ( http://www.mrbase.org ): a platform that integrates a …" | MR-Base/TwoSampleMR description (M2)
- c2 | Model | "MR-Base implements a random effects IVW model by default, unless there is …" | Random-effects IVW default (M2)
- c3 | Model | "An efficient way to ensure that instruments are independent is to use …" | LD clumping with ancestry-matched reference (M2)
- c4 | Model | "To evaluate if the MR estimate is driven or biased by a …" | Leave-one-out analysis rationale (M2)
- c5 | Discussion | "One way to mitigate the impact of such invalid instruments is to …" | Steiger filtering of reverse-causal instruments (M2)
- c6 | Discussion | "which could bias effect estimates from 2SMR towards the confounded observational association …" | Bias from participant overlap (M2, D6)
- c7 | Discussion | "Bias from sample overlap can be minimized by using strong instruments (e.g. …" | Strong instruments mitigate overlap bias (M2, D6)
- c8 | Discussion | "Thus, results may still be informative for directions of causality, but not …" | Population mismatch affects magnitude not direction (D3, D6)

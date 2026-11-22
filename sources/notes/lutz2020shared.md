> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Lutz MW, Sprague D, Barrera J, et al.; 2020; Shared genetic etiology underlying Alzheimer's disease and major depressive disorder; Translational Psychiatry 10:88; DOI 10.1038/s41398-020-0769-y; conditional/conjunctional FDR pleiotropy analysis with one-direction MR (summary statistics); access route PMC-XML (PMC7062839)

## Section-by-section reading log
- Abstract: Pleiotropy (cFDR) analysis of IGAP LOAD and PGC MDD GWAS. Moderate enrichment LOAD|MDD (max ~4-fold with APOE, ~8-fold without); MDD|LOAD ~7-fold but no SNP significant. Excluding APOE, SNPs mapping to 40 genes (9 known LOAD loci incl. SPI1, MS4A cluster on chr 11), eQTL overlap in blood/monocytes; immune response and endocytosis pathways.
- Introduction: Depression/anxiety most frequent NPS in LOAD; MDD associated with increased LOAD incidence; a previous study (Gibson 2017) found no shared polygenic structure.
- Methods: LOAD: IGAP stage 1 (21,982 AD cases, 41,944 controls; 11,480,632 SNPs; ADGC, EADI, CHARGE, GERAD/PERADES; European; Kunkle 2019 data link) — clinical AD, no proxy cases. MDD: PGC-MDD2 (Wray et al.) restricted to deCODE, Generation Scotland, GERA, iPSYCH and UK Biobank, excluding 23andMe: 59,851 cases, 113,154 controls (includes UK Biobank). 9,154,389 shared SNPs (INFO 0.6–1.06). cFDR/conjunctional FDR with fold-enrichment and conditional Q–Q plots, LD pruning r2 > 0.2 (1000 Genomes EUR); analyses with and without APOE region (±300 kb, chr19:45,111,942–45,711,941). MR: LOAD SNPs as instruments, MDD as outcome, two-sample MR in MR-Base, MR-Egger used for all calculations; instrument p < 1 × 10^-8, LD r2 0.001, clumping distance 10 kb. Functional annotation (UCSC, SNPnexus, i-Gsea4Gwas, FUMA/GTEx, Cardiogenics monocyte eQTL). No LDSC rg, no local rg, no MDD -> AD MR.
- Results: Fold-enrichment LOAD|MDD 2.0–4.2 (with APOE), 2.4–7.8 (without); MDD|LOAD 1.8–7.0 / 2.0–7.2. MR LOAD -> MDD OR = 1.4 (95% CI 1.2–1.7); Egger intercept P = 0.09. cFDR LOAD|MDD (APOE excluded) Q ≤ 0.05: SNPs in 40 genes (Table 1; e.g. MS4A4E rs1582763 Q 1.40E-10, SPI1 rs67472071 Q 1.05E-06; known loci BIN1, CELF1, CR1, FERMT2, MS4A6A, PICALM, PTK2B, SORL1, SPI1); MDD|LOAD none at Q ≤ 0.05 excluding APOE (Table 2 lists relaxed results incl. TMEM106B rs7785189); conjunctional FDR only marginal (rs4929858 Q = 0.06, rs3103780 Q = 0.07). MS4A SNPs eQTL for MS4A6A (blood) and MS4A4A (monocytes).
- Discussion: Shared genetic etiology LOAD–MDD via immune/endocytosis pathways; discrepancy with Gibson 2017 (LDSC/PRS null) attributed to method (cFDR vs LDSC/PRS) and heterogeneous MDD diagnostic criteria. Claims MR relationship not due to horizontal pleiotropy.
- Limitations stated by authors: need for replication cohorts; causality of pathways requires experimental validation; proximity-based gene mapping; limitations of 1000 Genomes LD reference panel for summary-statistic methods.
- Supplementary material: not available (Tables S1–S6 referenced, not in text file)

## Quality appraisal
Peer-reviewed (Translational Psychiatry, reputable). cFDR pleiotropy enrichment is not a genetic correlation (direction-agnostic, sensitive to shared LD/polygenicity). Weak MR practice: single-direction (AD -> MDD) MR using MR-Egger as the sole estimator, no IVW/weighted median, clumping window of only 10 kb (risk of correlated instruments), APOE apparently retained in the MR (not stated as excluded) despite its dominance, no Steiger or overlap assessment, no CI for Egger intercept beyond P = 0.09; "OR 1.4" for AD liability -> MDD is large given null rg elsewhere. Small/old MDD GWAS (PGC-MDD2 subset). Conflicts with Gibson 2017 (no rg/PRS overlap) and Huang 2020 (non-significant MDD <-> AD MR).

## Relevance to this manuscript
D1: prior study reporting polygenic overlap and AD -> MDD MR (OR 1.4) using IGAP clinical AD (no proxy) and PGC-MDD2 without 23andMe (with UK Biobank). Overlap with our data: none identical — our AD is Bellenguez 2022 (contains IGAP cohorts plus UK Biobank proxy), our MDD is PGC MDD2025 without 23andMe and without UK Biobank. Our bidirectional MR with multiple estimators, APOE exclusion and Steiger can test whether the AD -> MDD effect holds. I3: APOE dominance masks other pleiotropic signals (fold enrichment doubles without APOE). D5: immune/endocytosis, SPI1, MS4A. D3: 1000 Genomes LD reference limitations.

## Decision
KEEP — peer-reviewed prior genetic-overlap/MR study of AD and MDD; needed for D1 contrast (positive AD -> MDD MR vs null rg) and I3 APOE masking, cited with caveats on MR practice.

## Claims
- c1 | Methods | "These results included genotyped and imputed data on 13,554,550 variants from 59,851 …" | Prior study's MDD dataset (PGC-MDD2 without 23andMe) (D1, M1)
- c2 | Methods | "Stage 1 IGAP results were used, which included genotyped and imputed data …" | Prior study's clinical AD dataset (IGAP) (D1, D2)
- c3 | Results | "The MR analysis estimated a moderate influence of the LOAD-associated SNPs on …" | Prior AD -> MDD MR estimate (D1)
- c4 | Methods | "The MR Egger methodology 45 was used for all calculations. For the …" | Weak MR practice in prior study (single estimator, 10 kb clumping) (D1)
- c5 | Results | "Excluding the SNPs in the APOE region clearly identified a stronger polygenic …" | APOE dominance masks pleiotropic signal (I3)
- c6 | Discussion | "In contrast, Gibson et al. previously assessed overlapping polygenic architecture for LOAD …" | Discordant prior genetic-overlap findings and method dependence (D1, I3)
- c7 | Discussion | "These genes are involved in two major biological pathways and functional classes, …" | Shared biological pathways (D5)
- c8 | Discussion | "Several studies have pointed to the limitations of using LD measures based …" | LD reference panel limitation (D3)

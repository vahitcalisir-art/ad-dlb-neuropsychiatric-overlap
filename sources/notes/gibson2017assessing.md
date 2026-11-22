> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Gibson J, Russ TC, Adams MJ, et al.; 2017; Assessing the presence of shared genetic architecture between Alzheimer's disease and major depressive disorder using genome-wide association data; Translational Psychiatry 7(4):e1094; DOI 10.1038/tp.2017.49; cross-trait LDSC genetic correlation and polygenic risk score study (individual-level cohorts + summary statistics); access route PMC-XML (PMC5416691)

## Section-by-section reading log
- Abstract: Tested overlapping polygenic architecture of MDD and AD in Generation Scotland (GS:SFHS, N = 19,889) and UK Biobank (N = 25,118). LDSC with IGAP AD: rG = -0.103, P = 0.59. MDD PRS nominally associated with recalled AD family history in GS:SFHS only (not surviving correction); AD PRS not associated with depression, late-onset depression or age at onset. Conclusion: comorbidity not explained by common variants.
- Introduction: Depressed patients ~1.5 times as likely to develop AD; depression as risk factor or prodrome; prior candidate-gene APOE/CR1–MDD findings inconsistent; earlier rg atlas found no MDD–AD overlap.
- Methods: GS:SFHS (SCID-based MDD; 2,654 cases) and UK Biobank (Smith et al. putative MDD from touchscreen/self-report/EHR; 9,130 cases, 15,988 controls); European/UK. AD GWAS: IGAP (17,008 AD cases, 37,154 controls; Lambert 2013 stage 1; clinical AD, no proxy); MDD GWAS: PGC MDD (9,240 cases, 9,519 controls). PRSice PRS at 5 thresholds (clumping r2 0.2, 300 kb); Bonferroni over thresholds; APOE-excluded (1000 kb) MDD PRS sensitivity. LDSC between IGAP AD and UKB MDD GWAS (GS:SFHS MDD excluded: mean χ2 1.015); liability-scale with population prevalences 1.3% AD and 19% depression. Proxy AD = self-reported family history of AD (GS:SFHS N = 3,116; UKB N = 4,149). Cox models for depression age at onset; early/late-onset subsets (quartiles, <40/>40 years). AVENGEME power. No MR, no local rg.
- Results: LDSC rG = -0.103 (SE 0.190), Z = -0.540, P = 0.589. MDD PRS predicted MDD (r2 < 1%). AD PRS predicted AD family history in both cohorts (UKB P = 7.03 × 10^-12). MDD PRS -> AD family history: GS:SFHS strongest P ≤ 0.05 threshold β 0.048 (0.009, 0.086), P = 1.55 × 10^-2 (not surviving correction); UKB null. AD PRS -> MDD null in both (Table 2). AD PRS not associated with age at depression onset (Table 3; e.g. HR 0.969 (0.910, 1.031)) or early/late onset (Table 4). Power >80–90% for full samples, 16–73% for AOO analyses.
- Discussion: Genetic bases of lifetime MDD and AD largely distinct; MDD GWAS underpowered and heterogeneous (227 symptom combinations); late-life depression may be prodromal and a genetic correlation with late-onset depression could be diluted when lifetime depression is used; family history of AD as acceptable substitute in non-clinical samples, though potentially recall-biased and confounded by mood state.
- Limitations stated by authors: very small effects (true null vs underpowered); AOO analysis underpowered; different MDD ascertainment across samples; binary depression measure; lifetime depression GWAS mixes subtypes; participants too young for AD (no AD GWAS; proxy family history used); few true late-onset depression cases; poor UKB AOO data; possible IGAP–sample overlap.
- Supplementary material: not available

## Quality appraisal
Peer-reviewed (Translational Psychiatry). Early, small GWAS inputs (IGAP 2013; PGC MDD 18,759; UKB MDD GWAS N ~24,000), so LDSC rG SE is large (0.190) — the null is imprecise and does not exclude modest rg. No MR. Self-reported family-history proxy used in PRS analyses (recall bias acknowledged). Superseded by larger later rg analyses, but historically the key null rg reference for MDD–AD. Liability-scale prevalences (AD 1.3%, depression 19%) differ from ours (AD 0.05, MDD 0.15).

## Relevance to this manuscript
D1: first LDSC rg between AD and MDD; null (rG -0.103, SE 0.190). Datasets: IGAP 2013 clinical AD (no UK Biobank proxy) with a UK Biobank MDD GWAS; no overlap with our exact datasets (we use Bellenguez 2022 and PGC MDD2025 without UKB/23andMe). Supports that genome-wide rg between MDD and AD is near zero (I3) and that lifetime vs late-life depression phenotype matters (D6). D2: uses parental/sibling family history of AD as proxy and argues it is acceptable, but notes recall bias and mood-state confounding. M3: illustrates prevalence assumptions for liability scale (not a primary prevalence source).

## Decision
KEEP — classic null AD–MDD LDSC rg reference; needed for D1/I3 and for the lifetime-depression (D6) argument.

## Claims
- c1 | Abstract | "Using linkage disequilibrium score regression with genome-wide association study (GWAS) summary statistics …" | Prior null rg AD–MDD (D1, I3)
- c2 | Results | "The estimate of genetic correlation between the IGAP AD data and UKB …" | Precise prior rg estimate with SE (D1)
- c3 | Methods | "PRS for AD were estimated using summary statistics from an independent GWAS …" | Prior study's AD dataset (clinical IGAP) (D1)
- c4 | Methods | "PRS for MDD were created using summary statistics from an independent GWAS …" | Prior study's MDD dataset (small PGC MDD) (D1)
- c5 | Discussion | "the AD family history variable may also reflect non-genetic familial factors and …" | Biases of family-history proxy AD phenotype (D2)
- c6 | Discussion | "it remains possible that a genetic correlation exists between these two phenotypes, …" | Lifetime vs late-life depression phenotype limitation (D6)
- c7 | Limitations | "our effect sizes are very small, indicating that either we are correct …" | Power limitation of prior null rg (D1, D6)

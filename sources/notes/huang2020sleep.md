> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Huang J, Zuber V, Matthews PM, et al.; 2020; Sleep, major depressive disorder, and Alzheimer disease: A Mendelian randomization study; Neurology 95(14):e1963–e1970; DOI 10.1212/WNL.0000000000010463; bidirectional two-sample MR (summary statistics); access route PMC-XML (PMC7682841)

## Section-by-section reading log
- Abstract: Bidirectional two-sample MR among sleep traits (UK Biobank, n = 446,118), MDD (PGC, n = 18,759) and AD (IGAP, n = 63,926). IVW, weighted median, MR-Egger. Genetic AD liability associated with morning chronotype (OR 1.01, p = 0.001), shorter sleep (self-report β = -0.006, p = 1.9 × 10^-4; accelerometer β = -0.015, p = 6.9 × 10^-5), less long sleep, earlier L5 timing, fewer sleep episodes, and lower insomnia risk (OR 0.99, p = 7 × 10^-13). No evidence of sleep -> AD and no significant MDD <-> AD.
- Introduction: Comorbidity of depression and AD; an earlier GWAS found no shared genetic architecture between depression and AD; hypothesis that sleep affects MDD and AD but no MDD–AD causal link.
- Methods: STROBE reporting. Sleep GWAS all UK Biobank: chronotype 403,195; insomnia 237,627 (129,270 frequent-insomnia cases, self-report "usually" trouble falling asleep/waking); self-reported sleep duration 446,118 (short/long sleep binary); accelerometer traits 85,670. MDD: PGC (9,240 cases, 9,519 controls; DSM-IV clinical MDD; i.e. the early PGC MDD GWAS). AD primary: IGAP (Kunkle 2019 meta-analysis; 21,982 cases, 41,944 controls; clinical or autopsy; ~19% autopsy confirmed). AD sensitivity: AD/AD-by-proxy meta-analysis (71,880 cases, 383,378 controls; UK Biobank parental-history proxy cases, 47,793 with ≥1 affected parent; rg 0.81 between AD and AD-by-proxy). European ancestry. Instruments p < 5 × 10^-8 (sleep, AD) but arbitrary p < 1 × 10^-4 for MDD; clumping r2 > 0.1 removed; F > 10; Wald ratio, IVW, weighted median, MR-Egger, MR-PRESSO; Bonferroni 0.05/26 = 0.002; APOE (rs7412, rs429358) exclusion sensitivity; TwoSampleMR, R 3.5.0. No genetic correlation.
- Results: No sleep <-> MDD effects. MDD <-> AD IVW estimates positive in both directions but non-significant (numeric estimates only in supplementary figures e-19/e-20). AD -> sleep phenotypes significant after Bonferroni (Table 1 / Figure 1; numeric table content not in text file beyond abstract). AD/AD-by-proxy sensitivity: only accelerometer sleep duration remained significant. No sleep -> AD effect. Without APOE SNPs, AD -> sleep duration effects lost; other AD -> sleep effects (incl. insomnia) sustained.
- Discussion: AD-related sleep findings in genetically high-risk individuals (lower insomnia) inconsistent with clinical AD sleep disturbance; hypothesis that preclinical vs clinical AD affect sleep differently. Depression may be prodromal; late-onset depression instruments needed. APOE use as instrument violates exclusion restriction due to pleiotropy.
- Limitations stated by authors: variable power across instruments; MR assumes lifetime exposure; critical exposure period not identifiable (middle-aged/older GWAS samples); only ~19% autopsy-confirmed AD, subtypes not considered; APOE direct/indirect effects; self-report/accelerometer rather than polysomnography sleep; European ancestry; null findings may reflect low power.
- Supplementary material: not available (Dryad tables/figures referenced, not in text file)

## Quality appraisal
Peer-reviewed, high-quality venue (Neurology). Strengths: bidirectional design, Bonferroni, APOE sensitivity, STROBE. Weak MR practice for MDD: tiny PGC MDD GWAS (18,759) with arbitrary p < 1 × 10^-4 threshold and lenient clumping r2 0.1 (correlated, weak instruments, likely biased toward null/inflated precision); MDD–AD null therefore underpowered. Sample overlap between UK Biobank sleep GWAS and UK Biobank-containing AD-by-proxy sensitivity outcome not addressed. Tiny absolute effects (OR 0.99) for AD -> insomnia, driven by highly significant AD instruments. Insomnia N inconsistently reported (237,627 total vs 237,627 controls). Superseded data: MDD and AD GWAS are now much larger, but findings remain widely cited.

## Relevance to this manuscript
D1: prior bidirectional MR of insomnia and MDD with clinical AD (IGAP Kunkle 2019) plus proxy-AD sensitivity. Overlap with our data: insomnia from UK Biobank (earlier Lane 2019-type GWAS, not Watanabe 2022); MDD PGC early GWAS (not PGC MDD2025); AD IGAP 2019 (subset of the cohorts later in Bellenguez 2022) and Jansen 2019 proxy AD. No DLB, PTSD, SCZ, no rg/LAVA. Key agreement point for us: AD -> lower insomnia (reverse direction) and null insomnia -> AD; null MDD <-> AD. I3: APOE pleiotropy argument and APOE-excluded re-analysis. D2: AD-by-proxy described (rg 0.81). D6: lifetime exposure, timing, ancestry.

## Decision
KEEP — peer-reviewed bidirectional MR of insomnia/MDD and AD with APOE sensitivity; core D1 comparator despite dated MDD instruments.

## Claims
- c1 | Abstract | "We also found that higher risk of AD was associated with lower …" | Reverse-direction AD -> insomnia MR finding (D1)
- c2 | Abstract | "However, we did not find evidence that these abnormal sleep patterns were …" | Null sleep -> AD and MDD <-> AD in prior MR (D1)
- c3 | Methods | "Genetic associations with AD were obtained from the meta-analysis of GWAS on …" | Prior study's clinical AD dataset (D1, M1)
- c4 | Methods | "For sleep-related phenotypes and AD, we chose the genetic instruments using genome-wide …" | Weak MDD instrument selection in prior MR (D1 weakness, D6)
- c5 | Methods | "AD-by-proxy status was based on self-reported parents' diagnoses of AD. A total …" | Proxy AD phenotype definition (D2)
- c6 | Discussion | "because APOE is associated with multiple disorders besides AD, 26 the use …" | Rationale for APOE-excluded MR re-analysis (I3, M2)
- c7 | Results | "Without APOE ε4, the causal associations of AD with self-reported and accelerometer-based …" | APOE-dependence of reverse-direction findings (I3, D1)
- c8 | Limitations | "MR analysis assumes a lifetime exposure to the risk factor and is …" | Lifetime-exposure limitation of MR (D6)
- c9 | Methods | "The phenotypes either were self-reported (chronotype, insomnia, sleep duration) or were estimated …" | Insomnia among the sleep phenotypes tested against AD (D1)

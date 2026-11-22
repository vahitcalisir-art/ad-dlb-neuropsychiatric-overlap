> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Monereo-Sánchez J, Schram MT, Frei O, et al.; 2021; Genetic Overlap Between Alzheimer's Disease and Depression Mapped Onto the Brain; Frontiers in Neuroscience 15:653130; DOI 10.3389/fnins.2021.653130; LDSC rg, MiXeR and conjunctional FDR (summary statistics) with UK Biobank individual-level follow-up and neuroimaging; access route PMC-XML (PMC8288283)

## Section-by-section reading log
- Abstract: MiXeR and cFDR (pleioFDR) on AD GWAS (n = 79,145) and depression GWAS (n = 450,619); follow-up in 403,029 UK Biobank participants and 30,699 with brain MRI. 98 shared causal variants, 0.44 concordant; TMEM106B SNP associated with AD (B = -0.002, p = 9.1 × 10^-4) and depression (B = 0.007, p = 3.2 × 10^-9) in UKB and with corpus callosum, third ventricle and inferior temporal gyrus measures. Substantial overlap with mixed directions.
- Introduction: MDD comorbid in 22–59% of AD; debate risk factor vs prodrome; more evidence that midlife depression is a risk factor for AD than vice versa; AD oligogenic, MDD highly polygenic; prior negligible rg (Gibson 2017; Lutz 2020 cited) may hide mixed-direction overlap.
- Methods: AD GWAS: Jansen et al. 2019 phase 1 only (PGC-ALZ, IGAP, ADSP; 24,087 LOAD cases, 55,058 controls; European; explicitly chosen because it contains no UK Biobank participants, i.e. clinical AD without proxy cases). Depression GWAS: PGC MDD (Wray et al. 2018/2019) including 23andMe but with UK Biobank left out (121,198 cases, 329,421 controls). MHC excluded from both; APOE (chr19: 45–45.8 Mb) excluded from AD. Cross-trait LDSC rg; MiXeR (1000 Genomes Phase 3); pleioFDR conjunctional FDR < 0.05. UKB follow-up: proxy AD score (ICD-10 AD = 2, else +1 per affected parent, unaffected parents weighted (100-age)/100; n = 390,284; rg 0.81 with AD per Jansen); broad depression (ICD-10 F32–34/F38–39 or help-seeking for nerves; n = 403,029; rg 0.85 with strict MDD per Howard 2018). Neuroimaging 96 FreeSurfer measures, alpha 0.001. No MR, no local rg.
- Results: AD h2 0.05 (SE 0.01), 18 loci; depression h2 0.05 (SE 0.002), 33 loci. LDSC rg = -0.03 (SE = 0.06, p = 0.60). MiXeR: AD 261 causal variants, depression 15,228; 98 shared (38% of AD, 1% of depression; ~4 expected by chance); concordance 0.44. cFDR: rs5011436 (TMEM106B intron) shared; in UKB C allele protective for proxy AD, risk for depression; associated with larger corpus callosum segments (posterior B = 0.035, p = 3.4 × 10^-6), smaller third ventricle (B = -0.025, p = 5.0 × 10^-6), larger inferior temporal gyrus area.
- Discussion: Overlap hidden from rg by mixed directions of effects (analogous to SCZ–educational attainment); depression heterogeneity contributes; narrower depression subtypes may show more concordance with AD; TMEM106B lysosomal/TDP-43 biology; GWAS sample sizes of millions needed.
- Limitations stated by authors: MiXeR assumes common variants and Gaussian effect distribution, which may be violated for oligogenic AD enriched for rare variants; need larger samples, cleaner phenotype definitions; gene–gene and gene–environment interactions unaddressed.
- Supplementary material: not available

## Quality appraisal
Peer-reviewed (Frontiers in Neuroscience; same publisher family as our target journal; the handling editor was organising a Research Topic with two of the authors — minor editorial COI noted in text). Good practice: avoided sample overlap by using UKB-free AD and depression GWAS; APOE and MHC excluded. Limitations: AD GWAS modest (24,087 cases); depression GWAS includes 23andMe self-report; UKB replication uses proxy AD (family history), with tiny effect (B = -0.002); no MR, no local rg (LAVA). rg estimate still precise enough (SE 0.06) to suggest near-zero global correlation.

## Relevance to this manuscript
D1: prior genome-wide rg AD–depression -0.03 (SE 0.06) with clinical-only AD (Jansen phase 1, no UKB) and PGC MDD without UKB but with 23andMe. Overlap with our data: neither identical (ours: Bellenguez 2022 AD incl. UKB proxy; PGC MDD2025 without 23andMe and UKB), but conceptually closest to our UKB-free MDD choice. I3: key source that near-zero genome-wide rg hides mixed-direction shared variants — direct rationale for LAVA local rg. D2: describes the proxy AD construction and deliberately avoids proxy AD in discovery. D5: TMEM106B shared locus (consistent with kumar2026genetic).

## Decision
KEEP — peer-reviewed prior AD–depression rg/MiXeR study with explicit mixed-direction argument; supports I3 and D1, and TMEM106B (D5).

## Claims
- c1 | Results | "Using LDSC, the two disorders showed a negligible genetic correlation of −0.03 …" | Prior genome-wide rg AD–depression (D1, I3)
- c2 | Methods | "The phase 1 sample of this GWAS was chosen as it did …" | Prior study's AD dataset choice: clinical-only, UKB-free (D1, D2)
- c3 | Methods | "We used a version of the meta-analysed summary statistics where the UKB …" | Prior study's depression dataset (PGC MDD without UKB) (D1, M1)
- c4 | Results | "Bivariate mixture modelling indicated that there were 98 causal variants overlapping between …" | Polygenic overlap despite null rg (I3)
- c5 | Results | "The net result of this is a negligible negative correlation, despite a …" | Genome-wide rg hides mixed-direction effects (I3)
- c6 | Methods | "All other participants received a 1-U increase for each biological parent reported …" | Construction of proxy AD phenotype in UK Biobank (D2)
- c7 | Discussion | "We postulate that studies using more narrow depressive disorder subtypes would find …" | Depression heterogeneity as explanation of null rg (D1, D6)
- c8 | Discussion | "The SNP rs5011436 is located in an intron of the gene TMEM106B …" | Shared TMEM106B locus (D5)

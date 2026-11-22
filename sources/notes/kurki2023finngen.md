> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Kurki MI, Karjalainen J, Palta P, et al.; 2023; FinnGen provides genetic insights from a well-phenotyped isolated population; Nature 613(7944):508–518 (corrected publication, Nature 2023;615:E19); DOI 10.1038/s41586-022-05473-8; study type: biobank resource description + GWAS/PheWAS of register-based end points; access route: PMC-XML (PMC9849126)

## Section-by-section reading log
- Abstract: FinnGen aims to genotype 500,000 Finns linked to national health registers; median participant age 63 years and substantial hospital-based recruitment make it enriched for disease end points. Release 5 analysis of 224,737 participants; 15 benchmark diseases, 30 new associations (mostly Finnish-enriched low-frequency variants); PheWAS of 1,932 end points with 2,733 genome-wide significant associations.
- Introduction: Finnish founding bottleneck ~120 generations ago followed by rapid expansion; enrichment of deleterious low-frequency alleles (Finnish Disease Heritage), fewer rare variants overall. Public–private partnership of 9 biobanks and 13 pharma partners; register data collected since 1969.
- Methods: Samples from legacy (often disease-specific) cohorts and prospective hospital/private/blood-service biobanks. Phenotypes (end points) built from nationwide registers (HILMO in/outpatient, AvoHILMO primary care, Cause of Death, drug reimbursement/purchase, Cancer Registry) using Finnish ICD-10 harmonised with ICD-8/ICD-9; end points with >50% case overlap clustered → 1,932 end points. Genotyping on Illumina/Affymetrix arrays (154,714 on custom Axiom FinnGen1; 70,023 legacy); data lifted over to GRCh38/hg38; imputation with population-specific SISu v3 panel (3,775 Finnish high-coverage WGS; 16,962,023 variants), INFO <0.6 or MAF <0.0001 excluded. Association by SAIGE mixed-model logistic regression with sex, age, genotyping batch and 10 PCs; fine-mapping with SuSiE (MHC excluded); colocalization (eCAVIAR-style CLPP). Replication in Estonian Biobank (136,724) and Pan-UKBB European subset (build 37 lifted to build 38); IVW meta-analysis.
- Results: 3,676/224,737 (1.63%) non-Finnish ancestry outliers removed (PCA with 1000 Genomes); 73.6% have third-degree or closer relatives (vs 30.3% in UKBB); 218,792 individuals with phenotype data (56.5% female). Register-based phenotypes comparable to disease-specific GWAS: no rg significantly <1 (lowest 0.89, SE 0.07, AMD). 15 diseases: 275 independent non-HLA associations, 298 after meta-analysis, 30 new. Alzheimer's disease was one of the 15 benchmark diseases but excluded from the power-extrapolation analysis. PheWAS: 2,733 associations in 2,496 loci across 807 end points; coding-variant examples (PLTP, LAG3, TM6SF2, etc.). No psychiatric genetic correlation analyses reported.
- Discussion: Founder effect enables discovery with fewer cases; hospital-based recruitment gives higher case prevalence than UKBB — most extreme for Alzheimer's disease (2.7% vs 0.2%); high prevalence of schizophrenia (2.5%, n = 5,562) and bipolar disorder (2.1%). FinnGen not epidemiologically representative; recruitment not expected to bias GWAS results but relevant for progression/prediction work.
- Limitations stated by authors: not epidemiologically representative; prevalence estimates may be over/under-represented vs population (e.g., asthma, T2D vs FinRegistry); low eQTL colocalization because Finnish-enriched variants rare in non-Finnish eQTL datasets; rare variants underpowered for subtle effects.
- Supplementary material: not available (only captions/descriptions in text)

## Quality appraisal
Very large, register-linked biobank (Nature, peer-reviewed). Phenotypes are register (ICD)-based clinical diagnoses, validated by rg ≈1 with published GWAS for 15 diseases. Bias risks: non-representative hospital/legacy-cohort recruitment, high relatedness (handled with mixed models), Finnish founder population (LD/allele-frequency differences vs non-Finnish Europeans — relevant to LD-reference choice). Note: paper describes release 5 (2020); the manuscript uses R13, whose sample size and AD end point counts must be cited from FinnGen R13 documentation, not this paper. No psychiatric rg reported.
Correction checked 2026-11-21 (Author Correction 10.1038/s41586-023-05837-8): one author affiliation corrected; no effect on any claim used here.

## Relevance to this manuscript
M1: canonical citation for FinnGen design, register-based clinical (ICD) phenotyping, GRCh38 build, SISu imputation, SAIGE covariates — justifies FinnGen AD as clinically defined (non-proxy) sensitivity outcome. D2: register/clinical diagnosis contrasts with proxy AD phenotypes; AD sample prevalence 2.7% vs 0.2% in UKBB. D3: Finnish founding bottleneck and allele-frequency enrichment → caveat when using European (UKBB) LD reference / 1000G for Finnish data. D6: non-representative recruitment.

## Decision
KEEP — primary description of the FinnGen resource used for the clinical AD sensitivity outcome (data-source paper actually used).

## Claims
- c1 | Abstract | "FinnGen aims to study the genome and national health register data of …" | FinnGen design, register-linked biobank (M1)
- c2 | Abstract | "Given the relatively high median age of participants (63 years) and the …" | cohort composition of FinnGen sensitivity outcome (M1, D6)
- c3 | Introduction | "In Finland, a strong founding bottleneck occurred about 120 generations ago followed …" | Finnish founder population; LD-reference mismatch caveat (D3)
- c4 | Methods | "Clinical end points were constructed from the register codes using the Finnish …" | FinnGen AD is a register-based clinical diagnosis, not proxy (M1, D2)
- c5 | Methods | "Chip genotyping data produced with previous chip platforms and reference genome builds …" | genome build GRCh38 for FinnGen summary statistics; liftover needed for harmonisation (M1)
- c6 | Results | "Most participants have broadly Finnish ancestry; 3,676 out of 224,737 (1.63%) outliers …" | ancestry of FinnGen sample (M1, D3)
- c7 | Discussion | "The difference was the most extreme for Alzheimer’s disease (2.7% in FinnGen …" | AD case enrichment in FinnGen vs UK Biobank (M1, D2)
- c8 | Discussion | "However, owing to the recruitment strategy, FinnGen is not epidemiologically representative, and …" | sample prevalence ≠ population prevalence; limitation (D6, M3)

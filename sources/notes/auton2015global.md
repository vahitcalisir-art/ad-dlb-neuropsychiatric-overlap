> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
The 1000 Genomes Project Consortium (Auton A, Abecasis GR, Altshuler DM, et al.); 2015; A global reference for human genetic variation; Nature 526(7571):68-74; DOI 10.1038/nature15393; population genomics resource paper (phase 3 reference panel); access route: PMC-XML (PMC4750478)

## Section-by-section reading log
- Abstract: Phase 3 completion: 2,504 individuals from 26 populations; low-coverage WGS, deep exome, dense arrays; >88 million variants (84.7 M SNPs, 3.6 M indels, 60,000 SVs) phased onto haplotypes; >99% of SNPs with frequency >1% captured across ancestries.
- Introduction: Resource enables array design, imputation, variant cataloguing, filtering; 26 populations in five continental groups (AFR, EAS, EUR, SAS, AMR); WGS mean depth 7.4x, exome 65.7x.
- Methods: Ensemble of 24 variant callers with machine-learning filtering (FDR <5% for SNPs/indels); haplotype scaffold from arrays and relatives (Box 1); validation with deep Complete Genomics data for 427 individuals; heterozygous genotype accuracy 99.4% SNPs.
- Results: Table 1: EUR sample size 503 (AFR 661, AMR 347, EAS 504, SAS 489). Typical genome differs from reference at 4.1-5.0 million sites; most variants rare; 86% of variants restricted to one continental group. Population structure: north-south cline within Europe. PSMC: non-African bottlenecks 15,000-20,000 years ago, followed by rapid growth except PEL, MXL and FIN. FIN among populations with many locally drifted variants (rare globally, common locally). Imputation r2 >95% for common variants; LD decays fastest in African and slowest in East Asian populations; common variants have 15-20 tagging variants (r2 >0.8) in non-African populations vs ~8 in African populations. AMD re-analysis: permutation genome-wide threshold ~1.5x10-8.
- Discussion: Broad representation of global variation versus Eurocentric disease studies; benchmark for methods; ~96% of genome accessible; SV capture still limited.
- Limitations stated by authors: structural variation capture limited; ~2.3 million previously described variants absent; rare variant imputation remains challenging.
- Supplementary material: not consulted (Supplementary Information PDF not available as text)

## Quality appraisal
Authoritative, peer-reviewed reference resource. Competing interests: several authors affiliated with Illumina, Affymetrix and other companies (declared; not relevant to our use). The EUR super-population (N=503) is small and includes FIN, TSI, IBS, GBR and CEU, so LD in specific populations (e.g. Finnish) may differ from the pooled panel.

## Relevance to this manuscript
- M2: description of the 1000 Genomes phase 3 reference panel (EUR subset) used for LD clumping, LD scores and LAVA locus definitions.
- D3: within-Europe structure (north-south cline), Finnish bottleneck/drifted variants, and population-specific LD decay support the argument that LD reference panels may mismatch specific target populations (e.g. FinnGen).
- D6: Eurocentric bias of disease GWAS limits generalisability.

## Decision
KEEP — the reference panel actually used by the study (always KEEP).

## Claims
- c1 | Abstract | "Here we report completion of the project, having reconstructed the genomes of …" | Size and design of 1000 Genomes phase 3 (M2)
- c2 | Introduction | "In this final phase, individuals were sampled from 26 populations in Africa …" | Existence of the EUR super-population used as LD reference (M2)
- c3 | Abstract | "This resource includes >99% of SNP variants with a frequency of >1% …" | Coverage of common variants (M2)
- c4 | Results | "For example, east–west clines are visible in Africa and East Asia, a …" | Substructure within Europe (D3)
- c5 | Results | "These bottlenecks were followed by extremely rapid inferred population growth in non-African …" | Distinct Finnish demographic history (D3)
- c6 | Results | "Several populations have relatively large numbers of these variants, and these are …" | Finnish population carries many locally drifted variants (D3)
- c7 | Results | "Controlling for sample size, the decay of LD as a function of …" | LD structure differs across populations, requiring ancestry-matched references (D3)
- c8 | Discussion | "the bulk of complex disease studies in humans, which primarily study European …" | Eurocentric GWAS limit generalisability (D6)

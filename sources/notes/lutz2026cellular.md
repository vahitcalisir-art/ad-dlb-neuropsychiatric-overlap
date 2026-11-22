> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Lutz MW, Man Z, Chiba-Falek O; 2026; Cellular transcriptomic signatures underpinning the heterogeneity of depression in Alzheimer's disease; Alzheimer's & Dementia 22(9):e71823; DOI 10.1002/alz.71823; postmortem brain single-nucleus RNA-seq differential expression study (not GWAS/MR); access route PMC-XML (PMC13569991)

## Section-by-section reading log
- Abstract: snRNA-seq of dorsolateral prefrontal cortex from older cognitively normal and LOAD individuals (ROSMAP) and young individuals (Maitra dataset), stratified by MDD; cell-type DEGs, pathways, cell–cell communication. Shared MDD-associated DEGs (JUNB, DUSP1 in glutamatergic neurons; PRAM1, SNX9 in microglia); MDD–LOAD shared DEGs HSPA1A, NDUFB7; ~5–10 times more DEGs in females; microglial PPAR and interferon alpha/beta signaling.
- Introduction: Depression common in LOAD and associated with increased LOAD risk; GWAS-based evidence of shared genetic architecture LOAD–MDD (refs 31–37) and shared immune/synaptic/inflammatory pathways; transcriptomic basis understudied.
- Methods: ROSMAP snRNA-seq (424 subjects; analytic groups AD+MDD 50, AD 107, CN+MDD 33, CN 110; mean age 85–88, ~70% female); Maitra young cohort (GSE213982; MDD 34, controls 37; mean age 43). MDD by DSM-III-R clinical diagnosis. NEBULA negative binomial mixed models (covariates sex, age, PMI); |log2FC| > 0.2, FDR < 0.1; Metascape pathways; CellChat; sex-stratified analyses; validation against 4 external transcriptomic/proteomic studies. No GWAS summary statistics, no rg, no MR performed in this paper.
- Results: Older CN: GABAergic 230, glutamatergic 191, microglia 100 MDD-DEGs; young cohort ~10-fold more DEGs; LOAD vs controls 1914 DEGs, 321 shared with MDD comparisons; DUSP1 and JUNB common to all three cohorts (opposite direction in older CN). Microglial pathways PPAR, interferon alpha/beta, VEGFA. Sex-specific DEGs dominate. Validation: DUSP1, JUNB, JUN, NCKIPSD, NTNG1 supported.
- Discussion: Summarises authors' prior work: MR showed moderate influence of LOAD SNPs on MDD risk (ref 34); LDSC correlation LOAD–MDD reported by another >400,000-individual study (ref 68); PRS predicting depression onset in LOAD. Notes possible age confound for overlap.
- Limitations stated by authors: clinical MDD with comorbid NPS (anxiety, apathy) as confounders; age confounding between young and LOAD cohorts; chance overlap; lenient FDR 0.1; postmortem tissue, medication, substance use, comorbid cerebrovascular pathology, RNA degradation, cross-cohort technical differences; female predominance in older cohorts.
- Supplementary material: not available (tables/figures referenced, not in text file)

## Quality appraisal
Peer-reviewed, good venue (Alzheimer's & Dementia), but small case groups (33–50 MDD cases per older cohort), lenient FDR 0.1, many DEGs nominal; cross-cohort and age confounding. Not a genetic epidemiology study: no GWAS datasets, no rg/LAVA, no MR — cannot be compared to our design. Its statements about prior rg/MR are secondary citations.

## Relevance to this manuscript
Not a prior GWAS/MR study, so contributes nothing direct to D1 (does not answer our question; no data overlap with our GWAS sources). Marginal D5 (microglial PPAR/interferon and stress-response pathways shared between MDD and LOAD) and I1 (depression common in LOAD), both better supported by other sources. Secondary mention of LOAD SNPs -> MDD MR could be cited only via the original paper (Lutz 2020, in this batch).

## Decision
DROP — transcriptomic study off-design for our GWAS/MR comparison; small samples; any needed D5 pathway point is optional and the genetic-overlap claims are better cited from lutz2020shared.

## Claims
- c1 | Discussion | "Previously we elucidated the shared genetic architecture between MDD and LOAD, 34 …" | Secondary pointer to prior AD -> MDD MR (D1; cite original lutz2020shared instead)
- c2 | Discussion | "Our results for the microglia also highlighted several pathways and genes involved …" | Optional shared biological pathways (D5)

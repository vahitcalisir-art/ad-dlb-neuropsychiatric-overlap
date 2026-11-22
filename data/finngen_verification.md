# FinnGen Alzheimer's disease GWAS: verification for sensitivity analysis

Checked on 2026-11-20. Only official sources were used: FinnGen web pages, FinnGen GitBook documentation, the FinnGen PheWeb API, Risteys, the FinnGen public Google Cloud Storage bucket, and the publishers' or PMC full texts and supplements for the cohort papers.

- Nothing was registered or submitted, and no terms were accepted.
- No summary-statistics file was downloaded. File sizes come from HTTP `HEAD` requests. The column header comes from a 4 KB range request.
- Small files that were downloaded: the FinnGen R13 manifest (820 KB), the PheWeb phenotype lists (about 1 MB each), the MDD figshare cohort table (8 KB), and the supplementary tables and notes of the cohort papers (each 5 MB or less).

---

## 1. Latest public data freeze

| Item | Value | Source |
|---|---|---|
| Latest freeze with public summary statistics | **R13 (DF13)** | https://finngen.gitbook.io/documentation/data-download.md ("Release 13 contains GWAS summary association statistics ...") |
| Public release date: FinnGen results page | **"DF13, public release June 2, 2026"** | https://www.finngen.fi/en/access_results |
| Public release date: GitBook release table | **"Q3 2026"**. Release to partners was Q2 2025. Total PheWAS sample size 500,186 | https://finngen.gitbook.io/documentation/releases.md |
| Date of the bucket files | `Last-Modified: Tue, 05 May 2026` on the R13 `.gz` files (from HEAD) | https://storage.googleapis.com/finngen-public-data-r13/summary_stats/finngen_R13_G6_ALZHEIMER.gz |
| Public browser | https://r13.finngen.fi/ | access_results page |

The two official pages give different dates: 2 June 2026, which falls in Q2, against "Q3 2026". The actual date is **UNVERIFIED** beyond these two statements. I recommend citing "FinnGen R13, publicly released 2026" and the access date.

Other notes:
- The Association-tests page has an internal inconsistency. It says 2,755 endpoints and 500,348 samples, and 500,348 is the R12 sample size in the release table (https://finngen.gitbook.io/documentation/methods/phewas/logistic-regression.md).
- R14 is not public. Risteys already shows an "R14" label (https://risteys.finngen.fi/endpoints/G6_ALZHEIMER), but there is no `finngen-public-data-r14` bucket (HEAD returned 404).

## 2. How the summary statistics are obtained (access model)

**Mechanism: an online form that asks for identifying details, with a mandatory agreement checkbox. Download instructions then arrive by email.**

- From https://finngen.gitbook.io/documentation/data-download.md: *"To download FinnGen summary statistics you will need to fill the online form at [this link](https://elomake.helsinki.fi/lomakkeet/124935/lomake.html). You will then receive …"*
- From https://www.finngen.fi/en/access_results: the data can be downloaded "from Google cloud storage free of charge" after completing the form.
- Form fields at https://elomake.helsinki.fi/lomakkeet/124935/lomake.html. I read the form but did not submit it:
  - First name
  - Last name
  - Organization
  - Email ("Please fill the email address carefully")
  - Country
  - A required checkbox: *"I agree that I will never attempt to identify any individual participant"*, followed by *"I certify to be in compliance with all applicable local, state, and federal laws or regulations and institutional policies regarding human subjects and genetics research"*
  - A "Proceed" button
- No application is reviewed by anyone. There is no signed data-use agreement and no fee: the files are said to be "free of charge".
- **The files are also publicly reachable without the form.**
  - The documentation publishes the manifest URL: `https://storage.googleapis.com/finngen-public-data-r13/summary_stats/finngen_R13_manifest.tsv`.
  - Every summary-statistics file answers an anonymous `HEAD` request with `HTTP 200`.
  - Even so, FinnGen's stated route is the form. Using the files therefore means accepting the form's terms.

**Judgement against the project rule** (allowed: download without an application, a signed agreement or a fee; click-through terms are fine):
- **This is borderline and has to be your call.** It is not an application, a signed DUA or a fee.
- It is more than a pure click-through, because it asks for your name, organization, email and country, and then sends instructions by email.
- If the rule counts "registration-type forms with an agreement checkbox, no review" as click-through, FinnGen is **usable**. If it requires zero personal data, it is **not compliant**, even though the bucket is technically open.
- I did not fill in the form.

**Terms and citation, verbatim**

- Restrictions, from https://www.finngen.fi/en/access_results:
  - *"The results are not intended to serve as a basis for product development, marketing activities, or health-related claims."*
  - *"Any use of FinnGen results for commercial purposes is the sole responsibility of the user."*
  - The results "may be freely used by the scientific community and other interested parties."
- Acknowledgement, from data-download.md and access_results: *"We want to acknowledge the participants and investigators of the FinnGen study"*
- Citation, from data-download.md: *"Kurki M.I., et al. FinnGen provides genetic insights from a well-phenotyped isolated population. Nature 2023 Jan;613(7944):508-518. doi: 10.1038/s41586-022-05473-8. Epub 2023 Jan 18."* The page adds: *"Furthermore, if possible, include "FinnGen" as a keyword for your publication."*
- Form text: *"Please remember to acknowledge the FinnGen study when using these results in publications."*
- One observation: the website BibTeX on data-download.md still reads "Documentation of R12 release", year 2024.

## 3. Alzheimer's disease endpoints in R13

Counts for each endpoint come from the official R13 manifest (https://storage.googleapis.com/finngen-public-data-r13/summary_stats/finngen_R13_manifest.tsv). The R13 PheWeb API (https://r13.finngen.fi/api/phenos) gives the same numbers. Definitions come from R13 Risteys at https://r13.risteys.finngen.fi/endpoints/<CODE>.

| Endpoint (R13) | Name | Cases | Controls | GW-sig loci (PheWeb) | Definition (R13 Risteys) |
|---|---|---|---|---|---|
| **G6_ALZHEIMER** | Alzheimer disease | **16,652** | **483,534** | 42 | ICD-10 **G30** and ICD-9 **3310** in **hospital discharge and cause of death** only. There is no ICD-8 code ("$!$"). 2 of 7 registries are used, with no KELA, primary care or outpatient sources. No exclusion codes, conditions or age limit. Controls: "individuals that are not cases". https://r13.risteys.finngen.fi/endpoints/G6_ALZHEIMER |
| **G6_AD_STRICT** | Alzheimer's disease, strict definition | 12,545 | 483,210 | 37 | Rule `G30[01]\|F00[01]` (ICD-10 G30.0, G30.1, F00.0, F00.1) plus ICD-9 3310 and ICD-8 29010, in hospital discharge and cause of death. Also **KELA reimbursement code 307** with the same ICD-10 codes. 3 of 7 registries. Control exclusion: G6_ALZHEIMER. "First used in FinnGen datafreeze DF12". https://r13.risteys.finngen.fi/endpoints/G6_AD_STRICT |
| **AD_LO_EXMORE** | AD, late onset (more control exclusions) | 11,359 | 191,784 | 33 | ICD-10 F00.1 and G30.1 (with combined codes) in hospital discharge and cause of death. No ICD-9 or ICD-8 codes. Control exclusion: `G6_AD_STRICT\|F5_DEMENTIA\|F5_DEMENTIA_U\|F5_PSYCH\|NEURODIS\|MEMLOSS\|TRAUMBRAIN_NONCONCUS`. Median age at first event 80.92. https://r13.risteys.finngen.fi/endpoints/AD_LO_EXMORE |
| AD_EO_EXMORE | AD, early onset (more control exclusions) | 1,965 | 191,784 | 9 | Definition not fetched; the parallel structure to AD_LO_EXMORE is **UNVERIFIED** |
| AD_AM_EXMORE | AD, atypical or mixed (more control exclusions) | 4,292 | 191,784 | 8 | Not fetched (UNVERIFIED) |
| AD_U_EXMORE | AD, undefined (more control exclusions) | 500 | 191,784 | 2 | Not fetched (UNVERIFIED) |
| F5_ALZHDEMENT | Dementia in Alzheimer disease | 8,916 | 465,023 | 24 | ICD-10 F00 and ICD-8 29010 in hospital discharge and cause of death. No ICD-9 code. Control exclusion: F5_ORGANIC. https://r13.risteys.finngen.fi/endpoints/F5_ALZHDEMENT |

**G6_AD_WIDE is not in R13.** It is absent from the R13 manifest and PheWeb list, and `finngen_R13_G6_AD_WIDE.gz` returns 404. In R12 it was present:
- G6_AD_WIDE: 10,821 cases and 485,932 controls
- G6_ALZHEIMER: 13,964 cases and 486,384 controls

Source: https://r12.finngen.fi/api/phenos.

**Proxy or family-history cases.** None of these definitions uses family-history or proxy (parental dementia) information. They rely only on clinical register diagnoses: hospital discharge (HILMO), cause of death (Statistics Finland) and, for G6_AD_STRICT, the KELA special reimbursement register, as listed in the Risteys rules above. FinnGen endpoints are register-based (https://finngen.gitbook.io/documentation/methods/endpoints.md).

**Recommendation: use `G6_ALZHEIMER` (R13), with 16,652 cases and 483,534 controls.**
- It has the largest N of the clinically diagnosed AD endpoints.
- The diagnosis is clinical, by ICD G30 in hospital or death records, and no proxy cases are used.
- Caveat: its controls are simply "not cases", so they include people with other dementias. Diagnostic specificity also depends on register coding.
- Suggested secondary checks: `G6_AD_STRICT` (12,545 / 483,210; G30.0, G30.1, F00.0 and F00.1 plus KELA reimbursement) or `AD_LO_EXMORE` (11,359 / 191,784; late-onset cases with controls that exclude dementia, psychiatric and neurological conditions and memory loss).
- Note that Risteys shows somewhat different counts under its "R14" label (18,829 for G6_ALZHEIMER), but **R14 is not public**.

## 4. File format and download URL

From https://finngen.gitbook.io/documentation/data-description.md:
- *"GWAS summary statistics (tab-delimited, bgzipped, genome build 38, tabix index files included)"*
- Columns are described as "chromosome on build GRCh38 (`1-23`)", with `alt` as the effect allele and `beta` on the log(OR) scale.

Header and first line, read with a 4 KB byte-range request on the R13 G6_ALZHEIMER file:

```
#chrom  pos  ref  alt  rsids  nearest_genes  pval  mlogp  beta  sebeta  af_alt  af_alt_cases  af_alt_controls
1       13668  G  A  rs2691328  DDX11L1  0.261299  0.582862  -0.164077  0.146063  0.00598678  0.00572598  0.00599576
```

- **Build: GRCh38.**
- **rsIDs: present** in the `rsids` column. Some rows have `NA`, and a row can hold several comma-separated IDs.
- The file has no N column. Use the manifest's case and control counts.
- No INFO column is present in the file.

GWAS method, from https://finngen.gitbook.io/documentation/methods/phewas/logistic-regression.md:
- REGENIE, with covariates for age, sex, 10 PCs and genotyping batch.
- Firth approximation for p < 0.01 (`--firth --approx --pThresh 0.01 --firth-se`).
- Minimum allele count 5.
- Imputation used the SISu v4.2 panel (https://finngen.gitbook.io/documentation/methods/genotype-imputation/genotype-imputation.md).

**URL pattern for R13** (from the manifest; R12 used an extra `/release/` sub-folder):

```
https://storage.googleapis.com/finngen-public-data-r13/summary_stats/finngen_R13_{ENDPOINT}.gz   (+ .gz.tbi)
```

| File | HEAD status | Size (Content-Length) | Last-Modified |
|---|---|---|---|
| https://storage.googleapis.com/finngen-public-data-r13/summary_stats/finngen_R13_G6_ALZHEIMER.gz | 200 | 805,395,928 bytes (~768 MiB) | 2026-05-05 |
| https://storage.googleapis.com/finngen-public-data-r13/summary_stats/finngen_R13_G6_ALZHEIMER.gz.tbi | 200 | not recorded | not recorded |
| https://storage.googleapis.com/finngen-public-data-r13/summary_stats/finngen_R13_G6_AD_STRICT.gz | 200 | 805,122,458 | 2026-05-05 |
| https://storage.googleapis.com/finngen-public-data-r13/summary_stats/finngen_R13_AD_LO_EXMORE.gz | 200 | 804,141,477 | 2026-05-05 |
| https://storage.googleapis.com/finngen-public-data-r13/summary_stats/finngen_R13_F5_ALZHDEMENT.gz | 200 | 804,335,413 | 2026-05-05 |
| (R12) https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_G6_ALZHEIMER.gz | 200 | 814,787,266 | 2024-10-22 |
| (R12) https://storage.googleapis.com/finngen-public-data-r12/summary_stats/release/finngen_R12_G6_AD_WIDE.gz | 200 | 814,551,017 | 2024-10-22 |

Google Cloud path: `gs://finngen-public-data-r13/summary_stats/finngen_R13_G6_ALZHEIMER.gz` (from the manifest).

## 5. Ancestry and UK Biobank

- **Participants are Finnish only.**
  - Samples come from Finnish biobanks: Arctic, Auria, Borealis, Eastern Finland, Central Finland, the Finnish Red Cross Blood Service, Tampere, Helsinki, Terveystalo and THL (https://finngen.gitbook.io/documentation/methods/cohort-description.md).
  - Disease endpoints are built from Finnish national registers (https://finngen.gitbook.io/documentation/methods/endpoints.md).
- **Ancestry QC.** PCA with 1000 Genomes was used to remove non-Finnish samples. The final set has 281,515 unrelated inliers of Finnish ancestry and 218,975 related samples of Finnish ancestry, with 19,482 rejected (https://finngen.gitbook.io/documentation/methods/phewas/quality-checks.md). The GWAS keeps related individuals, and REGENIE accounts for relatedness.
- **UK Biobank: none.** The list of contributing biobanks contains no UK Biobank and no non-Finnish biobank, so FinnGen has no UK Biobank participants.
  - I found no single sentence that states "no UKB" verbatim. The conclusion follows from the cohort composition.
  - UKB appears on FinnGen pages only in the separate FinnGen + UKBB meta-analysis browsers (https://www.finngen.fi/en/access_results), which are distinct from the FinnGen-only summary statistics.

## 6. Cohort overlap with the other GWAS

| GWAS | Is FinnGen included? | Release | FinnGen N | Source |
|---|---|---|---|---|
| **(a) PGC MDD2025 (Adams et al., Cell 2025), EUR no23andMe-noUKBB** | **YES** | **R5** (`R5_18032020`) | **23,424 cases / 192,220 controls**, summary statistics, EUR, phenotype "EHR" | figshare cohort table `pgc-mdd2025_no23andMe-noUKBB_eur_v3.49.24.11.txt`, https://ndownloader.figshare.com/files/51486998 , row: `FinnGen  R5_18032020  FinnGen  FinnGen  sumstats  EUR  EHR  23424  192220`. No other Finnish cohort appears in this table. I did not check the Cell paper's own supplementary cohort table (PMC11829167) beyond this file. |
| **(b) PGC-PTSD Freeze 3 (Nievergelt et al., Nat Genet 2024)** | **YES**, as cohort "FING" (Supplementary Table 1, #90; summary results; Case/Control; ICD-9/10) | **Most likely DF6, but UNVERIFIED.** The Supplementary Note cites "Biobank Access Decisions for FinnGen samples and data utilized in FinnGen Data Freeze 6" and says the EHR data covered "269,078 patients from FinnGen". No R-number is stated explicitly for the PTSD GWAS. | **9,801 cases / 249,993 controls** (broad PTSD, EUR). Narrow: 863 / 249,993. Analysed with SAIGE and 5 PCs. | Supplementary Tables 1 and 2: https://static-content.springer.com/esm/art%3A10.1038%2Fs41588-024-01707-9/MediaObjects/41588_2024_1707_MOESM4_ESM.xlsx ; Supplementary Note: https://static-content.springer.com/esm/art%3A10.1038%2Fs41588-024-01707-9/MediaObjects/41588_2024_1707_MOESM1_ESM.pdf (pp. 16 and 33); methods: https://pmc.ncbi.nlm.nih.gov/articles/PMC11396662/ |
| **(c) PGC3 SCZ (Trubetskoy et al., Nature 2022)** | **FinnGen: NO.** "FinnGen" does not appear in the main text (https://pmc.ncbi.nlm.nih.gov/articles/PMC9392466/). **However, Finnish cohorts are included:** `scz_xfi3m_eur_sr-qc` and `scz_xfii6_eur_sr-qc` (PI Palotie, THL Psychiatric Family Collections). Their controls come from Health 2000, FINRISK, NFBC and HBCS. | not applicable | not applicable | Supplementary Information, p. 47: https://static-content.springer.com/esm/art%3A10.1038%2Fs41586-022-04434-5/MediaObjects/41586_2022_4434_MOESM1_ESM.pdf . These legacy THL cohorts may be part of FinnGen through the THL Biobank (FinnGen uses "legacy" genotyping batches, and the PTSD note says older cohorts were "transferred to the THL Biobank"). **Whether these individuals overlap with FinnGen R13, and by how many, is UNVERIFIED** but plausible. Expect it to be small. |
| **(d) Watanabe et al. 2022 insomnia, UKB-only file** | **NO** (the file contains only UK Biobank by construction) | not applicable | 0 | Paper: https://doi.org/10.1038/s41588-022-01124-w (PMID 35835914). The full meta-analysis had 593,724 cases and 1,771,286 controls. FinnGen has no UKB participants (Section 5), so the UKB-only file cannot overlap. I did not open the UKB-only file's own README. |
| **(e) Bellenguez et al. 2022 AD (EADB)** | **Stage II only. Not in stage I.** Main text: "Stage II samples are from the ADGC, CHARGE and FinnGen consortia". Stage I consortia: "EADB, GR@ACE, EADI, GERAD/PERADES, DemGene, Bonn, the Rotterdam study, the CCHS study, NxC and the UKBB". | **UNVERIFIED** (no R-number found) | **7,329 cases / 252,879 controls** (Supplementary Table 1, "FinnGen" row) | https://pmc.ncbi.nlm.nih.gov/articles/PMC9005347/ ; Supplementary Tables: https://static-content.springer.com/esm/art%3A10.1038%2Fs41588-022-01024-z/MediaObjects/41588_2022_1024_MOESM4_ESM.xlsx . If you use the **stage I** summary statistics (EADB stage I: 39,106 clinically diagnosed AD cases, 46,828 proxy-ADD cases, 401,577 controls), FinnGen is not included. Stage I **does include UK Biobank** (2,447 diagnosed cases, 46,828 proxy cases and 338,440 controls). No Finnish country row appears among the EADB stage I cohorts in Supplementary Table 1 (searched for "Finn"). I did not verify which Bellenguez file your project uses. |
| **(f) Chia et al. 2021 DLB (Nat Genet 53:294)** | **NO.** FinnGen is not mentioned. This was a whole-genome sequencing study of 2,591 LBD cases and 4,027 controls from 44 institutions or consortia, with replication in 970 cases and 8,928 controls. | not applicable | 0 | https://pmc.ncbi.nlm.nih.gov/articles/PMC7946812/ . Authors with Helsinki affiliations (University of Helsinki and HUS pathology) suggest that some Finnish brain-bank samples may have contributed. Whether those individuals are in FinnGen is **UNVERIFIED**, and the possible overlap is negligible in size. |

**What this means for MR and genetic correlation**
- FinnGen R13 G6_ALZHEIMER shares participants with the **MDD2025 no23andMe-noUKBB** file (FinnGen R5 is a subset of R13) and with **PTSD Freeze 3** (FinnGen DF6 or similar).
- FinnGen is therefore **not** an independent outcome sample for those exposures. Handle it with LDSC or LDSC-based overlap correction, or use MR methods that are robust to sample overlap.
- Alternatively, use the PGC MDD and PTSD releases that exclude FinnGen, if they exist. Their existence is **UNVERIFIED**.
- The overlap is zero or negligible with Watanabe UKB-only, with Chia DLB, and with Bellenguez **stage I**. It is small but unquantified with PGC3 SCZ, through the legacy Finnish cohorts.

## Summary of UNVERIFIED items
- The exact R13 public release date: 2 June 2026 on the FinnGen results page against "Q3 2026" in the GitBook.
- Whether the form-based access counts as "click-through" under the project rule. This is a policy judgement for you. The facts are listed in Section 2.
- The definitions of AD_EO_EXMORE, AD_AM_EXMORE and AD_U_EXMORE (not fetched).
- The FinnGen release used in PTSD Freeze 3 (DF6 is implied by the acknowledgement text) and in Bellenguez 2022 stage II (not found).
- The amount of overlap between the PGC3 SCZ Finnish cohorts and FinnGen R13, and between the Helsinki contributors to Chia 2021 and FinnGen.
- The Cell paper's own supplementary cohort table for MDD2025. Only the figshare cohort file was checked.

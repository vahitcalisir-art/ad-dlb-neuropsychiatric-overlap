# Phase 1: Verification of GWAS summary-statistics sources

Verification date: 2026-11-19 (UTC). Every value below comes from a page, API response, README or file header I fetched on that date.

How I checked:
- GWAS Catalog REST API v2 (`https://www.ebi.ac.uk/gwas/rest/api/v2/studies/<GCST>`). The legacy API now returns HTTP 410.
- EBI FTP directory listings, `README.txt` files and `-meta.yaml` files.
- Figshare API (`https://api.figshare.com/v2/articles/<id>`) and Zenodo API (`https://zenodo.org/api/records/<id>`).
- The PGC download page, the CTG (cncr.nl) summary-statistics page, and NIAGADS DSS.
- Paper full text from Europe PMC and PMC.
- File sizes come from HTTP HEAD, or from a 1-byte range GET (`Content-Range`) where a server rejected HEAD (fileserve.mrcieu) or redirects (figshare).
- Column headers come from range requests of the first ≤128 KB of each file. No full data files were downloaded. The only whole files downloaded were small README or metadata files (≤110 KB).
- No terms were accepted and no registration was made.

---

## Summary table

| # | Role | Recommended file | Ancestry | N | Build | UKB | 23andMe | Usable |
|---|---|---|---|---|---|---|---|---|
| 1 | AD (clinical + proxy) | GCST90027158 (EBI FTP, harmonised `.h.tsv.gz`) | EUR | 39,106 clinical cases + 46,828 proxy cases / 401,577 controls | GRCh38 | **Yes** (UKB proxy-ADD) | No | **Yes** (CC0) |
| 2 | AD (clinical, no UKB) | GCST007511 `Kunkle_etal_Stage1_results.txt` (EBI FTP) | EUR | 21,982 / 41,944 | GRCh37 | No | No | **Yes, with use restriction** (see terms). NIAGADS full set needs an application. |
| 3 | DLB | GCST90001390 (EBI FTP, harmonised) | EUR | 2,591 / 4,027 | GRCh38 | No | No | **Yes** |
| 4 | MDD | PGC MDD2025 `pgc-mdd2025_no23andMe_eur` (or `…no23andMe-noUKBB_eur`) on figshare | EUR | 412,305 / 1,588,397; Neff 1,152,656 (no-UKBB file: 357,636 / 1,281,936; Neff 967,084) | GRCh37 | Yes (a no-UKBB file exists) | **Excluded** | **Yes** (PGC click-through terms) |
| 5 | PTSD | PGC-PTSD Freeze 3 `eur_ptsd_pcs_v4_aug3_2021.vcf.gz` (+ case/control file) on figshare | EUR | 137,136 / 1,085,746; Neff 641,533 | GRCh37 | **Yes** | Not a listed cohort | **Yes** (PGC click-through terms). Z-score file only; beta/SE only in the case/control file. |
| 6 | Insomnia | Watanabe 2022 Zenodo 10.5281/zenodo.24366723 `insomnia_ukb2b_EUR_sumstats_20190311_with_chrX_mac_100.txt.gz` | EUR | 109,548 / 277,440 (**UKB only**) | GRCh37 (see note) | **Yes, UKB only** | **Excluded** (only top-10k 23andMe SNPs) | **Yes** (CC BY-NC-SA 4.0 + CTG conditions) |
| 7 | SCZ | PGC3 `PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv.gz` (figshare) | EUR | 52,017 cases / 75,889 controls + 1,369 trios | GRCh37 | No UKB cohort code in cohort list | Not listed | **Yes** (PGC terms + SCZ Fort Lauderdale clause) |
| 8a | LDSC LD scores / HM3 list | GenomicSEM Box folder (`eur_w_ld_chr`, `w_hm3.snplist`). The Broad originals are now requester-pays. | EUR (1000G) | – | hg19 (UNVERIFIED in docs) | – | – | Yes (Box). Broad path is not free. |
| 8b | LAVA reference + loci | `g1000_eur.zip` (SURFsara) + `blocks_s2500_m25_f1_w200.GRCh37_hg19.locfile`. The authors now recommend the UKB LD reference instead. | EUR | – | GRCh37 | UKB ref = UKB-derived | – | Yes |
| 8c | Clumping reference | `http://fileserve.mrcieu.ac.uk/ld/1kg.v3.tgz` | 5 1000G super-pops (EUR subset) | – | UNVERIFIED | – | – | Yes |

---

## 1. Alzheimer's disease, clinical + proxy (Bellenguez et al. 2022, EADB)

- **Role:** Main AD exposure/outcome. It includes UK Biobank proxy cases, so it overlaps with UKB-containing traits.
- **Citation:** Bellenguez C, Küçükali F, Jansen IE, Kleineidam L, Moreno-Grau S, et al. *New insights into the genetic etiology of Alzheimer's disease and related dementias.* Nat Genet 2022;54:412–436. DOI: 10.1038/s41588-022-01024-z. PMID 35379992, PMC9005347.
- **Data availability (paper, verbatim):** "Genome-wide summary statistics have been deposited to the European Bioinformatics Institute GWAS Catalog (https://www.ebi.ac.uk/gwas/) under accession no. GCST90027158."
- **Landing page:** https://www.ebi.ac.uk/gwas/studies/GCST90027158. API: https://www.ebi.ac.uk/gwas/rest/api/v2/studies/GCST90027158
- **Accession:** GCST90027158. **Confirmed.** The API returns `full_summary_stats_available: true` and `pubmed_id 35379992`.
- **Files** (directory `https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90027001-GCST90028000/GCST90027158/`):

| File | Type | Size (bytes, from HEAD) | Last-Modified |
|---|---|---|---|
| `GCST90027158_buildGRCh38.tsv.gz` | Author-submitted file in GWAS-SSF format; meta.yaml says `is_harmonised: false` | 755,201,909 | 2025-02-09 |
| `harmonised/35379992-GCST90027158-MONDO_0004975.h.tsv.gz` | Harmonised (`is_harmonised: true`; reference: Ensembl release 95) | 1,140,755,970 | 2022-07-11 |
| `harmonised/35379992-GCST90027158-MONDO_0004975-Build38.f.tsv.gz` | Formatted (pre-harmonisation) | 575,146,963 | 2022-07-11 |
| `README.txt`, `*-meta.yaml`, `md5sum.txt` | metadata | small | |

- **Ancestry:** European, 487,511 individuals. The API lists countries Belgium, Bulgaria, Czech Republic, Denmark, Finland, France, Germany, Greece, Italy, Netherlands, Norway, Portugal, Spain, Sweden, Switzerland, U.K. and U.S.
- **N** (API `initial_sample_size`, matching the paper verbatim): "39,106 European ancestry clinically diagnosed cases, 46,828 European ancestry proxy cases, 401,577 European ancestry controls". Stage I has 21,101,114 variants.
  - The paper gives the UKB component verbatim: "In the UKBB … the analysis included 2,447 diagnosed cases, 46,828 proxy cases of dementia and 338,440 controls."
  - Proxy definition (paper): "The UKBB's proxy-AD designation is based on questionnaire data in which individuals are asked whether their parents had dementia."
  - **Effective N: not stated** in the catalog, README or the passages I read. Per-SNP `n_cases`/`n_controls` columns exist.
  - Replication (stage II, not in the file): 25,392 cases / 276,086 controls.
- **Build:** GRCh38 (meta.yaml `genome_assembly: GRCh38`; README: "variant_alternate_id … (according to GRCh38)"). Positions use dbSNP build 153 rsIDs according to the paper's tables.
- **Columns** (raw file header): `variant_id p_value chromosome base_pair_location effect_allele other_allele effect_allele_frequency odds_ratio ci_lower ci_upper beta standard_error n_cases n_controls het_isq het_pvalue variant_alternate_id`.
  - The harmonised file adds the `hm_*` columns (`hm_rsid`, `hm_effect_allele`, `hm_beta`, `hm_code` and others).
  - README: "n_cases : Total number of cases included in the meta-analysis; n_controls : Total number of controls…"
- **Cohorts (API):** EADB, GR@CE, EADI, GERAD, PERADES, DemGene, Bonn, RS, CCHS, **UKB**, Other.
- **UK Biobank: YES.** The UKB proxy-ADD GWAS is meta-analysed into stage I. No EADB-without-UKB file was found in the catalog deposit.
- **23andMe: NO.** It is not in the cohort list and the paper text never mentions 23andMe.
- **Access terms:** The API gives `terms_of_license: https://creativecommons.org/publicdomain/zero/1.0/` (**CC0**). EBI general terms also apply: "EMBL-EBI expects attribution (e.g. in publications, services or products)". It is an open FTP download with no click-through.
- **Usable: YES.**

## 2. Alzheimer's disease, clinical diagnosis without UKB (Kunkle et al. 2019, IGAP stage 1)

- **Role:** AD source without UK Biobank, for sensitivity analysis or to avoid UKB overlap.
- **Citation:** Kunkle BW, Grenier-Boley B, Sims R, Bis JC, Damotte V, Naj AC, et al. *Genetic meta-analysis of diagnosed Alzheimer's disease identifies new risk loci and implicates Aβ, tau, immunity and lipid processing.* Nat Genet 2019;51:414–430. DOI: 10.1038/s41588-019-0358-2. PMID 30820047, PMC6463297.
- **Paper data availability (verbatim excerpt):** "…Stage 1 discovery have been deposited in The National Institute on Aging Genetics of Alzheimer's Disease Data Storage Site (NIAGADS)—a …"

### 2a. NIAGADS NG00075 (https://dss.niagads.org/datasets/ng00075/)

- Page title: "NG00075 – IGAP Rare Variant Summary Statistics – Kunkle et al. (2019)".
- Filesets:
  - **fsa000139** "IGAP Rare Variant - Kunkle et al. (2019) P-values only (open access)": public.
  - **fsa000140** "…Full Summary Statistics (application needed)": controlled.
- Terms (verbatim):
  - "To access this data, please log into DSS and submit an application." … "Once approved, you will be able to log in and access the data within the DARM portal." "The p-value only files are available in the 'Open Access Dataset' tab." "P-value data is generally available to all users…" "However, gaining access to allele frequencies requires a formal data request."
  - Citation: "Please cite/reference the use of NIAGADS data by including the accession NG00075".
- **Verdict:** The full NIAGADS set **requires an application, so it is not usable** under the rules. The NIAGADS open file is P-values only, which is not enough for MR. I did not open the DSS file manifest, so the open file's columns are UNVERIFIED.

### 2b. GWAS Catalog GCST007511 (open deposit of the same stage 1)

- Landing: https://www.ebi.ac.uk/gwas/studies/GCST007511. API: `pubmed_id 30820047`, `full_summary_stats_available: true`, `snp_count 11480632`.
- API N: "21,982 European ancestry cases, 41,944 European ancestry controls". Replication (not in the file): "up to 13,292 … cases, up to 17,219 … controls".
- Directory: `https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST007001-GCST008000/GCST007511/`
  - `Kunkle_etal_Stage1_results.txt`: **569,380,789 bytes** (HEAD; Last-Modified 2019-08-13). Uncompressed.
  - `Kunkle_etal_2019_IGAP_summary_statistics_README_0.docx`: 15,961 bytes.
  - `harmonised/`: **empty**, so there is no harmonised file.
- **Columns** (file header): `Chromosome Position MarkerName Effect_allele Non_Effect_allele Beta SE Pvalue`. The file has beta and SE but **no allele frequency and no per-SNP N**.
- **Build:** README states "Chromosome: Chromosome of the SNP (Build 37, Assembly Hg19)" and "Position: … (Build 37, Assembly Hg19)", so **GRCh37**. Imputation reference: 1000G "phase 1 integrated release 3, March 2012".
- **Ancestry:** European. Countries: Canada, France, Germany, Greece, Iceland, Netherlands, U.K., U.S.
- **Cohorts** (README): ADGC, EADI, CHARGE, GERAD/PERADES. **UK Biobank: NO. 23andMe: NO.** Neither is in the README cohort list or the paper's stage-1 description.
- **Access terms:**
  - The API gives `terms_of_license: https://www.ebi.ac.uk/about/terms-of-use/`. Those terms say: "EMBL-EBI imposes no additional restriction on the use of the contributed data than those provided by the data owner"; "The original data may be subject to rights claimed by third parties".
  - The data owner's README, deposited alongside the file, says verbatim: "We welcome your request with the proviso that these summary data should not be used for research into the genetics …" and "Due to the possibility of identification of individuals from these summary results, allele frequency data are accessible through the NIAGADS application process."
  - Citation requirement: "IGAP should be cited in acknowledgments, Materials and Methods, and References sections". The README gives fixed acknowledgment text and the Kunkle 2019 reference.
- **Usable: YES, the GWAS Catalog file is openly downloadable** with no application. **Caution:** the IGAP restriction on "potentially sensitive behavioral traits" is not defined further. Psychiatric traits (MDD, PTSD, insomnia, SCZ) are not named, but the PI should judge whether the project complies.

## 3. Dementia with Lewy bodies (Chia et al. 2021)

- **Role:** DLB outcome/exposure.
- **Citation:** Chia R, Sabir MS, Bandres-Ciga S, Saez-Atienzar S, Reynolds RH, et al. *Genome sequencing analysis identifies new loci associated with Lewy body dementia and provides insights into its genetic architecture.* Nat Genet 2021;53:294–303. DOI: 10.1038/s41588-021-00785-3. PMID 33589841, PMC7946812.
- **Paper data availability (verbatim):** "The GWAS summary statistics have been deposited in the GWAS catalog". Individual-level data: "dbGaP (accession number: phs001963.v1.p1 NIA DementiaSeq)".
- **Accession:** **GCST90001390, confirmed.** API: `pubmed_id 33589841`, disease_trait "Dementia with Lewy bodies", genotyping "Genome-wide sequencing", `snp_count 20137051`.
- **Landing:** https://www.ebi.ac.uk/gwas/studies/GCST90001390
- **Files** (directory `https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90001001-GCST90002000/GCST90001390/`):

| File | Size (bytes) | Notes |
|---|---|---|
| `GCST90001390_buildGRCh38.tsv.gz` | 237,286,354 | author file; `variant_id` = **NA** (no rsIDs) in first rows |
| `harmonised/33589841-GCST90001390-EFO_0006792.h.tsv.gz` | 391,918,252 | harmonised, has `hm_rsid` |
| `harmonised/33589841-GCST90001390-EFO_0006792-Build38.f.tsv.gz` | 241,742,926 | formatted |

- **N:** API gives "2,591 European ancestry cases, 4,027 European ancestry controls". The paper and README agree ("2,591 Lewy body dementia cases and 4,027 neurologically healthy aged controls"). Replication (not in the file): 970 cases / 8,928 controls. Effective N is not stated.
- **Build:** GRCh38 (meta.yaml; the paper says "chromosomal position is shown according to hg38").
- **Columns (raw):** `variant_id p_value chromosome base_pair_location effect_allele other_allele effect_allele_frequency odds_ratio beta standard_error`.
- **Ancestry:** European. Countries: Canada, France, Greece, Italy, Luxembourg, Republic of Ireland, Spain, U.K., U.S.
- **UK Biobank: NO. 23andMe: NO.** Neither appears in the paper text.
- **Terms:** EBI terms of use (`https://www.ebi.ac.uk/about/terms-of-use/`). Open download with no click-through. Cite the paper.
- **Usable: YES.**

## 4. Major depression (PGC MDD)

The PGC download page (https://pgc.unc.edu/for-researchers/download-results/) lists, among others:
- mdd2025 (Cell, PMID 39814019) → https://doi.org/10.6084/m9.figshare.27061255
- mdd2019edinburgh (Nat Neurosci, PMID 30718901) → https://datashare.ed.ac.uk/handle/10283/3203
- mdd2018_noUKBB (Nat Genet, PMID 29700475) → https://doi.org/10.6084/m9.figshare.21655784
- mdd2018 → https://doi.org/10.6084/m9.figshare.14672085
- mdd2026adolescent (figshare 33973996): an adolescent-specific release, not relevant here.

### 4a. Recommended: PGC MDD2025 (Adams et al. 2025), excluding 23andMe

- **Citation:** Adams MJ, Streit F, Meng X, Awasthi S, et al. (Major Depressive Disorder Working Group of the PGC). *Trans-ancestry genome-wide study of depression identifies 697 associations implicating cell types and pharmacotherapies.* Cell 2025;188(3):640–652.e9. DOI: 10.1016/j.cell.2024.12.002. PMID 39814019, PMC11829167.
- **Landing:** https://doi.org/10.6084/m9.figshare.27061255. Figshare v5, published 2026-05-27. Figshare-level licence **CC BY 4.0**.
- **README** (`README.pgc-mdd2025.txt`, verbatim): "These are the summary statistics for the PGC MDD3 meta-analysis. (no23andMe version)". Contents include:
  - "pgc-mdd2025_no23andMe_eur: Summary statistics QC'd for Neff excluding 23andMe (European ancestries)"
  - "pgc-mdd2025_no23andMe-noUKBB: … excluding 23andMe and UK Biobank (European ancestries)"
- **Files** (sizes from the figshare API, confirmed with range GET):

| File | URL | Bytes |
|---|---|---|
| `pgc-mdd2025_no23andMe_eur_v3-49-24-11.tsv.gz` | https://ndownloader.figshare.com/files/51487019 | 232,895,012 |
| `pgc-mdd2025_no23andMe-noUKBB_eur_v3-49-24-11.tsv.gz` | https://ndownloader.figshare.com/files/51487022 | 225,357,893 |
| `daner_pgc_mdd_no23andMe_eur_hg19_v3.49.24.11.neff.gz` | https://ndownloader.figshare.com/files/52371878 | 267,142,134 |
| `daner_pgc_mdd_no23andMe-noUKBB_eur_hg19_v3.49.24.11.neff.gz` | https://ndownloader.figshare.com/files/52371881 | 255,879,352 |
| `pgc-mdd2025_no23andMe_eur_v3-49-24-11_formatted.tsv.gz` (GWAS-SSF) | https://ndownloader.figshare.com/files/52419704 | 233,816,353 |
| `pgc-mdd2025_no23andMe-noUKBB_eur_v3-49-24-11_formatted.tsv.gz` (GWAS-SSF) | https://ndownloader.figshare.com/files/52419710 | 226,328,069 |
| cohort tables `pgc-mdd2025_no23andMe_eur_v3.49.24.11.txt` / `…-noUKBB…txt` | /files/51486995, /files/51486998 | 8,060 / 7,981 |
| multi-ancestry `pgc-mdd2025_no23andMe_div_v3-49-46-01.tsv.gz` | /files/51487010 | 195,963,903 |

- **N** (file pre-header, verbatim values):
  - no23andMe_eur: `nCase=412305`, `nControl=1588397`, `nEffective=1152656`, `nCohort=75`, `nVariants=7363302`.
  - no23andMe-noUKBB_eur: `nCase=357636`, `nControl=1281936`, `nEffective=967084`, `nCohort=74`, `nVariants=7139872`.
  - **Neff convention:** the paper text says "European ancestry meta-analysis, excluding 23andMe (N effective = … 576,327)". That is exactly half of the file's 1,152,656. The file's `nEffective` is the total Neff (= 4/(1/Ncase+1/Ncontrol) summed). The daner file gives both `Neff_half` and `Neff` per SNP.
- **Build:** `##genomeReference="GRCh37"`. Imputation reference: HRC v1.1.
- **Columns:** `#CHROM POS ID EA NEA BETA SE PVAL FCAS FCON IMPINFO NEFF NCAS NCON HETI HETDF HETPVAL` (BETA = ln(OR)).
- **Cohorts in no23andMe_eur** (from the cohort table, sumstats cohorts):
  - AGDS, Airwave, ALSPAC, BASIC, BioVU, CHB/DBDS, deCODE, Estonian Biobank, EXCEED, FinnGen, GenScot, GERA, HUNT, iPSYCH2012, iPSYCH2015i, iCBT, MoBa (×3), **MVP [EUR] (151,974 cases / 226,640 controls)**, Partners Biobank, PREFECT, SHARE, STAGE, Takeda, **UK Biobank [EUR] (54,669 cases / 306,461 controls, "Quest" phenotype)**.
  - Plus about 49 PGC genotype cohorts.
- **UK Biobank:** included in `no23andMe_eur`, **excluded** in `no23andMe-noUKBB_eur`. A diff of the two cohort tables shows that UKBB is the only difference.
- **23andMe: EXCLUDED** in both files.
- **Terms:** PGC Data Access Terms (click-through "I agree to the PGC Terms and Conditions" on the download page). Verbatim key conditions:
  - "Use of these data is NOT unrestricted."
  - "Investigators will not cross-post these data or make them available elsewhere – this website is the definitive source for these data;"
  - "Investigators will never attempt to identify any participant who contributed to these data;"
  - "Investigators will only use these data for scientific research – any commercial or for-profit use of these data requires permission …"
  - "Investigators may not use these data to develop any type of risk or predictive test for an unborn individual;"
  - "Investigators will cite the appropriate PGC publications in any presentations, publications, or communications or publications arising from use of these data;"
  - "…respect and not to compete with the scientific priorities of the PGC team according to the Fort Lauderdale principles."
  - The file header `termsOfUse` adds: "…used only for non-commercial research purposes; … secondary distribution of the data without registration by secondary parties is prohibited; … will cite the appropriate publications…"
  - Note: the figshare item is labelled CC BY 4.0, but the PGC terms (no redistribution) are stricter. Follow the PGC terms and do not re-host the files.
- **Usable: YES.**

### 4b. Older alternatives (not recommended)

- **Wray et al. 2018 without 23andMe and UKB:** figshare 21655784, `daner_pgc_mdd_meta_w2_no23andMe_rmUKBB.gz` (297,769,060 bytes, https://ndownloader.figshare.com/files/39504667), **CC0**. Description (verbatim): "excluding 23andMe and UK Biobank. Cite Wray et al 2018 … and Howard et al 2019". Header: `FRQ_A_45396 FRQ_U_97250`, so 45,396 cases / 97,250 controls. Columns include `Nca Nco Neff_half`.
- **Howard et al. 2019 (Edinburgh DataShare 10283/3203):** `PGC_UKB_depression_genome-wide.txt` (347.43 MB). The file name implies PGC + UKB without 23andMe, but the page does not state 23andMe exclusion explicitly, and only `PGC_UKB_23andMe_depression_10000.txt` (top 10k) carries 23andMe. I could not read the End-user Licence text on that page, so its **terms are UNVERIFIED**. It is not needed because MDD2025 supersedes it.

## 5. PTSD (PGC-PTSD Freeze 3, Nievergelt et al. 2024)

- **Citation:** Nievergelt CM, Maihofer AX, Atkinson EG, Chen CY, Choi KW, et al. *Genome-wide association analyses identify 95 risk loci and provide insights into the neurobiology of post-traumatic stress disorder.* Nat Genet 2024;56:792–808. DOI: 10.1038/s41588-024-01707-9. PMID 38637617, PMC11396662.
- **Paper data availability (verbatim):** "Summary statistics for PGC PTSD Freeze 3 will be made available upon publication under the accession ID ptsd2024 via the PGC website".
- **Landing:** PGC page entry "ptsd2024" → https://doi.org/10.6084/m9.figshare.26349322 (v3, published 2025-01-31, figshare licence CC BY 4.0).
- **Files:**

| File | URL | Bytes | Content (README) |
|---|---|---|---|
| `eur_ptsd_pcs_v4_aug3_2021.vcf.gz` | https://ndownloader.figshare.com/files/47850151 | 254,036,468 | "European Ancestry GWAS" (primary, sample-size-weighted Z) |
| `eur_ptsdcasecontrol_pcs_v4_aug3_2021.vcf.gz` | https://ndownloader.figshare.com/files/52065146 | 152,377,987 | EUR case/control, IVW (log-OR) |
| `trans_ptsd_pcs_v4_aug3_2021.vcf.gz` | /files/47850169 | 128,487,948 | multi-ancestry |
| `aam_…`, `hna_…` | /files/47850136, /files/47850163 | | AFR / Hispanic-Native American |
| `ptsd2024_sumstats_readme.pdf` | /files/52065149 | 106,614 | README |

- **European-only file: YES.**
- **N** (EUR file header): `nCase="137136"`, `nControl="1085746"`, `nCohort="63"`, `nVariants=7193585`. The methods paragraph in the header says verbatim: "EA (n=1,222,882; effective sample size (neff)=641,533)". The per-SNP `NEFF` column reaches 641,533.
- **Build:** `##genomeReference="GRCh37"`. Imputation reference: HRC v1.0.
- **Columns:**
  - Primary EUR file: `CHROM ID POS A1 A2 FREQ NEFF Z P DIRE`. There is **no BETA/SE**.
  - Case/control file: `CHROM ID POS A1 A2 FREQ BETA SE P NCASE NCON NEFF NTOT`.
  - The README says the primary GWAS is "a sample-size weighted, z-score based meta-analysis … does not produce beta values". For MR it says the transformed betas give "no direct quantification of causal effect magnitude", and "Option 2: Consider using the effect sizes from the less powered case/control GWAS". It also warns that the case/control GWAS loci "will not line up with the loci described in the manuscript".
- **UK Biobank: YES.** The cohort list contains `ukbb` (10,913 cases / 124,888 controls) and `ukb2` (9,882 / 120,862). The paper lists "UK Biobank" among the EHR biobanks and says "UKBB was analyzed using BOLT-LMM". **No UKB-free PTSD file is published.**
- **Million Veteran Program: YES.** Cohort `mvp` has 32,372 / 154,317. Header: "MVP release 3 GWAS using the Post-traumatic Stress Disorder Checklist".
- **Other overlapping biobanks in the cohort list:** `fing` (FinnGen), `hunt`, `esbb` (Estonia), `biov` (BioVU), `mgbb` (Mass General Brigham), `biom` (BioMe), `mayo`, `dai2`/iPSYCH (paper: "iPSYCH from Denmark"), `agds`, `qimr`/`qim2`, `swed` (STR-STAGE).
- **23andMe:** not a cohort. The paper mentions 23andMe only in competing-interest statements.
- **Terms:** the same PGC Data Access Terms as §4 (click-through). File `termsOfUse` (verbatim): "These data are provided *as is*, and without warranty, for scientific and educational use only. If you download these data, …"
- **Usable: YES.** Note the Z-only primary file.

## 6. Insomnia (Watanabe et al. 2022, CTG)

- **Citation:** Watanabe K, Jansen PR, Savage JE, Nandakumar P, Wang X, 23andMe Research Team, Hinds DA, Gelernter J, Levey DF, Polimanti R, Stein MB, Van Someren EJW, Smit AB, Posthuma D. *Genome-wide meta-analysis of insomnia prioritizes genes associated with metabolic and psychiatric pathways.* Nat Genet 2022;54(8):1125–1132. DOI: 10.1038/s41588-022-01124-w. PMID 35835914.
- **Landing:** The old URL https://ctg.cncr.nl/software/summary_statistics now redirects (301) to https://cncr.nl/ctg/. The current page is https://cncr.nl/research/summary_statistics/, which links "Use this link" → https://doi.org/10.5281/zenodo.24366723 (Zenodo record "Insomnia (Watanabe et al., Nat Gen 2022) summary statistics", open access, licence `cc-by-nc-sa-4.0`).
- **CTG page note (verbatim):** "The summary statistics exclude the 23andMe data used in the manuscript meta-analysis. Access to the full set, including 23andMe results, …"
- **Files** (Zenodo API; HEAD confirmed for the main file):

| File | URL | Bytes | N (README) |
|---|---|---|---|
| `insomnia_ukb2b_EUR_sumstats_20190311_with_chrX_mac_100.txt.gz` | https://zenodo.org/api/records/24366723/files/insomnia_ukb2b_EUR_sumstats_20190311_with_chrX_mac_100.txt.gz/content | 618,512,627 | "UK Biobank unrelated EUR samples … 109,548 cases and 277,440 controls" |
| `insomnia_female_ukb2b_EUR_…txt.gz` | …/content | 579,028,859 | 66,976 / 141,982 |
| `insomnia_male_ukb2b_EUR_…txt.gz` | …/content | 569,475,019 | 42,572 / 135,458 |
| `insomnia_23andme_sumstats_20190205_mac_100_top_10000.txt.gz` | …/content | 368,807 | top 10,000 variants only, 23andMe 593,724 / 1,771,286 |
| `insomnia_20190311_README.txt`, `README_atlas_ukb2_sumstats.txt` | | 2,246 / 1,935 | |

- **Important:** the open genome-wide file is **UK Biobank only** (PLINK 2.0 logistic regression). It is **not the full Watanabe 2022 meta-analysis**, which requires the 23andMe DTA.
  - The GWAS Catalog has Watanabe 2022 studies (GCST90131901/2/3) but `full_summary_stats_available: false`.
  - No other insomnia GWAS with full sumstats in the catalog is larger. Only GCST90018869 (Sakaue 2021, 1,402 EUR cases) and GCST90018649 matched `disease_trait=Insomnia`.
  - **A more recent open insomnia release was not found** in my searches of the CTG page and the GWAS Catalog. Treat that as unverified rather than proven absent.
- **Effective N:** not stated.
- **Build:** the insomnia README does not state the build. The companion `README_atlas_ukb2_sumstats.txt` in the same record, which describes the same "ukb2" pipeline and columns, says "BP: base pair position on GRCh37". So the build is GRCh37, confirmed indirectly. The `SNP` column is formatted chr:pos:alleles.
- **Columns:** `SNP CHR BP A1 TEST NMISS OR SE L95 U95 STAT P A2 SNPID_UKB RSID_UKB A1_UKB A2_UKB INFO_UKB MAF_UKB MAF NCHROBS`. A1 is the tested allele and SE is on the log(OR) scale.
- **UK Biobank: YES (exclusively). 23andMe: EXCLUDED** (only the top-10k file).
- **Terms** (CTG page, verbatim):
  - "This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License."
  - "In addition, when downloading the sumstats you agree not to attempt to identify individual participants and not to use the …"
  - "Commercial use: If you want to use the sumstats commercially, you must first get our permission…"
  - "Please cite this reference when using the summary statistics."
  - There is no click-through form; downloading means agreeing.
- **Usable: YES.** It is UKB-only, so the overlap implications are significant (see the matrix).

## 7. Schizophrenia (PGC3, Trubetskoy et al. 2022)

- **Citation:** Trubetskoy V, Pardiñas AF, Qi T, Panagiotaropoulou G, Awasthi S, et al. *Mapping genomic loci implicates genes and synaptic biology in schizophrenia.* Nature 2022;604:502–508. DOI: 10.1038/s41586-022-04434-5. PMID 35396580, PMC9392466.
- **Landing:** PGC entry "scz2022" → https://doi.org/10.6084/m9.figshare.19426775 (v7, published 2025-03-06, figshare CC BY 4.0).
- **README** (`PGC3_SCZ_sumstats_release_v3.2_README.pdf`, verbatim): "PGC3_SCZ_wave3.european.autosome.public.v3.tsv.gz: These are summary statistics from the meta-analysis of european ancestry cohorts for autosomal SNPs." The README also defines "primary" (core EUR+EAS plus AA and Latino) and "core" (EUR + EAS).
- **Files:**

| File | URL | Bytes |
|---|---|---|
| `PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv.gz` (**EUR only**) | https://ndownloader.figshare.com/files/34517828 | 239,710,564 |
| `PGC3_SCZ_wave3.primary.autosome.public.v3.vcf.tsv.gz` (multi-ancestry primary) | https://ndownloader.figshare.com/files/34517861 | 236,122,083 |
| `PGC3_SCZ_wave3.core.autosome.public.v3.vcf.tsv.gz` | /files/34517807 | 442,947,443 |
| `PGC3_SCZ_sumstats_release_v3.2_README.pdf` | /files/34865091 | 67,691 |

- **N** (EUR file header): `nCase="52017"`, `nControl="75889"`, `nTrio="1369"`, `nCohort="76"`, `nVariants=7659767`. Rows show `NCAS 53386`, `NCON 77258`, `NEFF 58749.13`. The header defines NCAS/NCON as "effective sample size cases/controls", which counts trios, and NEFF as "effective sample size total".
  - For comparison, the primary file header gives 71,554 cases / 97,863 controls / 3,068 trios (99 cohorts) and has a `NEFFDIV2` column.
- **Build:** `##genomeReference="GRCh37"`. Imputation: HRC1.1.
- **Columns (EUR):** `CHROM ID POS A1 A2 FCAS FCON IMPINFO BETA SE PVAL NCAS NCON NEFF`. Header text: "A1 = SNP reference allele for freq, beta, or ln(OR)".
- **UK Biobank:** the EUR cohort list (76 codes, starting `ipsych,bep1b,…`) contains no UK Biobank cohort code. In the paper text, UK Biobank appears only as a citation (Bycroft et al.). **Not included, as far as I can verify.**
  - There is a separate figshare file `daner_PGC_SCZ_w3_90_0418b_ukbbdedupe.gz`. Its meaning (presumably deduplicated against UKB) is UNVERIFIED.
- **23andMe:** not mentioned in the paper or the cohort list. **Not included.** The cohort list does include **iPSYCH** (`ipsych`).
- **Terms:**
  - The PGC Data Access Terms (§4, click-through) apply.
  - The SCZ-specific `termsOfUse` (verbatim): "All data here are released under a Fort Lauderdale Agreement … these data and results may not be used in …" The manuscript was published in 2022, so the embargo clause no longer applies.
- **Usable: YES.**

## 8. LD references

### 8a. LDSC European LD scores (`eur_w_ld_chr`) and HapMap3 SNP list (`w_hm3.snplist`)

- **Official URLs are dead.** Both the LDSC README and the wiki still point to `https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2` and `…/w_hm3.snplist.bz2`. Both now redirect to alkesgroup.broadinstitute.org and return **HTTP 404**. `storage.googleapis.com/broad-alkesgroup-public/LDSCORE/eur_w_ld_chr.tar.bz2` also returns 404.
- **Official relocation notice** (`https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/README_new_data_location.txt`, verbatim): "Due to excessive data transfer costs, this directory is now available on a requester-pays basis at https://console.cloud.google.com/storage/browser/broad-alkesgroup-public-requester-pays. The downloader will …"
  - Requester-pays means a Google Cloud billing account and a fee, so it **is not usable** under the rules. The API confirms: "Bucket is a requester pays bucket but no user project provided."
  - Zenodo 7768714 ("S-LDSC reference files", Steven Gazal, CC BY 4.0, open) does **not** contain `eur_w_ld_chr` or `w_hm3.snplist`. It contains 1000G **Phase 3** alternatives:
    - `1000G_Phase3_ldscores.tgz`: 13,362,450 bytes
    - `1000G_Phase3_weights_hm3_no_MHC.tgz`: 12,757,654 bytes
    - `1000G_Phase3_plinkfiles.tgz`: 288,277,344 bytes
    - URLs follow `https://zenodo.org/api/records/7768714/files/<name>/content`.
- **Working source for the original files:** the GenomicSEM wiki (https://github.com/GenomicSEM/GenomicSEM/wiki/3.-Genome‐wide-Models) says verbatim: "Weights for the european population used here can be obtained by downloading the eur_w_ld_chr folder in the link below (Note …". It also says the HapMap3 file "can be obtained from" the same link.
  - The Box shared folder "GenomicSEMFiles" returns HTTP 200 anonymously. Its listing includes:
    - `eur_w_ld_chr` (folder, 48 files, 45,385,812 bytes)
    - `w_hm3.snplist` (17,264,312 bytes)
    - `reference.1000G.maf.0.005.txt.gz`
  - Box shared links do not support HEAD on individual files, so sizes come from the Box page metadata.
- **Ancestry:** 1000 Genomes European. The LDSC wiki says verbatim: "These LD Scores were computed using 1000 Genomes European data". **Build: not stated in the pages I fetched (UNVERIFIED).** LDSC matches on rsID.
- **Terms:** no licence text on the Box folder or the GenomicSEM wiki (UNVERIFIED). Cite LDSC (Bulik-Sullivan et al. 2015) and Genomic SEM.
- **Usable: YES** via the GenomicSEM Box link. The Zenodo Phase 3 set is the CC BY 4.0 alternative.

### 8b. LAVA 1000G Phase 3 EUR reference and locus file

- **Source:** LAVA GitHub (https://github.com/josefin-werme/LAVA, v0.1.5, README dated 2025-06-27) and `REFERENCE.md`. The CTG LAVA page (https://cncr.nl/research/lava/) points to GitHub.
- **Primary citation:** Werme J, van der Sluis S, Posthuma D, de Leeuw CA. *An integrated framework for local genetic correlation analysis.* Nat Genet 2022;54:274–282. DOI: 10.1038/s41588-022-01017-y.
- **1000G EUR PLINK:** https://vu.data.surfsara.nl/index.php/s/VZNByNwpD8qqINe/download → `g1000_eur.zip`, **511,626,945 bytes** (HEAD; Last-Modified 2024-02-07).
- **Locus file:** https://raw.githubusercontent.com/josefin-werme/LAVA/main/support_data/blocks_s2500_m25_f1_w200.GRCh37_hg19.locfile (63,426 bytes). Header `LOC CHR START STOP`, 2,495 loci. README: "obtained via https://github.com/cadeleeuw/lava-partitioning using the g1000 data phase 3, build GRCh37/hg19". **Build: GRCh37.**
- **Authors' warning (README, verbatim):** "as of LAVA version 0.1.5, custom LAVA LD reference files based on a large UK Biobank cohort is now available …"
- **UKB LAVA reference v1.1** (requires LAVA ≥0.1.5): "LD is computed from 100,000 unrelated individuals of European ancestry from the UK Biobank … Total filesize is 15 Gb (unzipped)". It comes as 7 zips, sizes from HEAD:

| Chromosomes | Download ID | Bytes |
|---|---|---|
| chr1-2 | 7NBVIvtPRdu7Qhz | 2,125,499,261 |
| chr3-4 | fy6ITboMojHrQXr | 1,922,789,237 |
| chr5-6 | mRz31q0lq7KMcuI | 1,913,638,071 |
| chr7-9 | 89RXxPN2BlOqxLs | 2,367,297,971 |
| chr10-12 | 3dU1L2Hap43xuCs | 2,026,421,707 |
| chr13-16 | DQqJ2Sqr49RP4xe | 1,841,138,868 |
| chr17-23 | U8eg5XfTr8qPzPp | 1,913,810,980 |

  Each is downloaded from `https://vu.data.surfsara.nl/index.php/s/<ID>/download`.
- **Terms:** none stated for the reference files. The LAVA `DESCRIPTION` file says "License: All rights reserved". The CTG page says: "When using LAVA, please refer to this paper."
- **Usable: YES.** Open download, no form.

### 8c. 1000G EUR PLINK reference for clumping (MRC IEU)

- **Documented in** the ieugwasr vignette `local_ld.Rmd` (github.com/MRCIEU/ieugwasr). Verbatim: "To get the same LD reference dataset that is used by the API, you can download it directly from here: …", including `EUR.bed/.bim/.fam`. Also: "The reference panel has INDELs removed and only retains SNPs with MAF > 0.01 in the selected population."
- **File:** http://fileserve.mrcieu.ac.uk/ld/1kg.v3.tgz.
  - HEAD returned **HTTP 502 Proxy Error**.
  - A 1-byte range GET returned **206 Partial Content, total 1,567,805,147 bytes**, Last-Modified 2020-05-07. The file exists.
  - HTTPS did not respond.
- **Build:** not stated in the vignette (**UNVERIFIED**). Clumping is by rsID.
- **Terms:** none stated (UNVERIFIED).
- **Usable: YES.**

---

## Sample-overlap matrix

Key: **UKB** = UK Biobank. **Heavy** = the same large cohort makes up a big share of both samples. "–" = no shared cohort that I could verify.

| | AD-Bellenguez | AD-Kunkle | DLB-Chia | MDD2025 no23 EUR | MDD2025 no23-noUKBB | PTSD EUR | Insomnia (UKB) | SCZ EUR |
|---|---|---|---|---|---|---|---|---|
| **AD-Bellenguez** | – | **Heavy**: EADI, GERAD/PERADES, Rotterdam (RS) in both (Kunkle is largely nested in EADB stage I) | Possible clinical/neuropath cohort overlap (UNVERIFIED) | **UKB** (338,440 UKB controls in AD) | – (no verifiable cohort) | **UKB** | **UKB, heavy** (insomnia is 100% UKB) | – |
| **AD-Kunkle** | | – | Possible (UNVERIFIED) | – | – | – | – | – |
| **DLB-Chia** | | | – | – | – | – | – | – |
| **MDD no23 EUR** | | | | – | nested (superset) | **Heavy**: UKB, MVP, iPSYCH, FinnGen, HUNT, Estonian Biobank, BioVU, Partners/MGB, AGDS, STAGE, … | **UKB** | iPSYCH (and possibly other PGC cohorts) |
| **MDD no23-noUKBB** | | | | | – | MVP, iPSYCH, FinnGen, HUNT, ESTBB, BioVU, MGB, AGDS, STAGE (no UKB) | – (no UKB) | iPSYCH |
| **PTSD EUR** | | | | | | – | **UKB** (ukbb + ukb2 ≈ 20.8k cases / 245.8k controls) | iPSYCH (PTSD lists iPSYCH among EHR biobanks) |
| **Insomnia (UKB)** | | | | | | | – | – |
| **SCZ EUR** | | | | | | | | – |

Notes:
1. **UK Biobank** is in AD-Bellenguez, MDD2025 no23andMe EUR, PTSD EUR and insomnia (UKB-only). It is absent from Kunkle, Chia, SCZ PGC3 and MDD2025 no23andMe-noUKBB.
   - The cleanest combinations for two-sample MR involving insomnia use Kunkle (AD), Chia (DLB) and the MDD noUKBB file.
   - PTSD has no public UKB-free file, so PTSD × insomnia and PTSD × Bellenguez overlap is unavoidable. Use MR methods robust to overlap, or report LDSC cross-trait intercepts.
2. **MVP** is shared between MDD2025 and PTSD (MDD: 151,974 / 226,640; PTSD: 32,372 / 154,317).
3. **iPSYCH** is in MDD2025 (iPSYCH2012 + iPSYCH2015i), PTSD (paper: "iPSYCH from Denmark") and SCZ PGC3 (`ipsych`).
4. **Kunkle vs Bellenguez:** EADB stage I includes the EADI, GERAD/PERADES and RS cohorts that make up much of IGAP stage 1. Use them as alternatives, not as two independent samples.
5. The LDSC bivariate intercept will quantify the overlap empirically. The matrix above only lists cohorts named in official documentation.

---

## UNVERIFIED items (and what I tried)

1. **Bellenguez effective N:** not stated in the GWAS Catalog API, README, meta.yaml or the paper passages I read. Compute it from the per-SNP `n_cases`/`n_controls` if needed.
2. **Kunkle NIAGADS open-access (P-value-only) file name and columns:** NIAGADS states the fileset exists. I did not log into DSS or open the file manifest.
3. **Whether the IGAP restriction on "potentially sensitive behavioral traits" covers MDD, PTSD, insomnia or SCZ:** not defined in the README. Needs PI judgement or an email to IGAP/NIAGADS.
4. **Chia DLB cohort overlap with the AD consortia:** the paper says cases came from "44 institutions/consortia". I did not cross-check the supplementary cohort list.
5. **Howard 2019 Edinburgh DataShare End-user Licence text:** the page lists the licence but its text was not in the fetched page. 23andMe exclusion is implied only by the file name.
6. **A more recent open insomnia GWAS than Watanabe 2022:** none found on the CTG page or among GWAS Catalog `disease_trait=Insomnia` studies with full sumstats. A broader literature search was not done.
7. **Insomnia file build:** stated as GRCh37 only in the companion atlas README in the same Zenodo record, not in the insomnia README itself.
8. **SCZ `daner_PGC_SCZ_w3_90_0418b_ukbbdedupe.gz`:** its meaning is not documented in the README.
9. **Genome build of `eur_w_ld_chr` / `w_hm3.snplist` and of MRC IEU `1kg.v3.tgz`:** not stated on the official pages I fetched. Both are used via rsID.
10. **Licence terms for the GenomicSEM Box folder and the MRC IEU LD reference:** none published on the pages I fetched.
11. **MRC IEU fileserve:** HEAD returned 502, but a range GET succeeded. The server may be unreliable.
12. Journal volume, issue and page numbers in the citations were checked against Europe PMC metadata. For Watanabe 2022 they come from the CTG page.
13. **Nature article pages:** they redirect to an auth cookie wall. All paper quotes come from Europe PMC/PMC full text instead.

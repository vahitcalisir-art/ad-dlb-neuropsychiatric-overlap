# DATA_MANIFEST

Prepared: 2026-11-20. All files are in `data/raw/`. Source verification (official pages, APIs, READMEs; accessed 2026-11-19): `data/source_verification.md`. Download logs: `data/raw_download_*.log`. Full checksum log including README and metadata files: `data/raw/CHECKSUMS.tsv`.

Verification of integrity:
- Publisher MD5 checked and matched: MDD, PTSD, SCZ (figshare `computed_md5`); insomnia, LDSC (Zenodo checksum); Bellenguez, Chia (EBI `harmonised/md5sum.txt`).
- No publisher checksum: LAVA references (all 8 zips pass `unzip -t`); MRC IEU 1kg.v3 (passes full `tar tzf`); LAVA locus file.

Terms acceptance: the PGC Data Access Terms (MDD, PTSD, SCZ) and the CNCR insomnia conditions were accepted by the investigator on 2026-11-19 before download. No file is redistributed; `data/raw/` is not to be shared or uploaded.

---

## 1. GWAS summary statistics

### 1.1 Alzheimer's disease (cases + UK Biobank proxy cases) — Bellenguez et al. 2022
- Role: main AD exposure/outcome.
- Publication: Bellenguez C, et al. New insights into the genetic etiology of Alzheimer's disease and related dementias. Nat Genet 2022;54:412–436. doi:10.1038/s41588-022-01024-z.
- Access: GWAS Catalog GCST90027158, https://www.ebi.ac.uk/gwas/studies/GCST90027158 ; file from `https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics/GCST90027001-GCST90028000/GCST90027158/harmonised/`.
- File: `bellenguez2022/35379992-GCST90027158-MONDO_0004975.h.tsv.gz` (GWAS Catalog harmonised; Ensembl release 95), 1,140,755,970 bytes, SHA-256 `cf83ca485c9499d505604893fa6ca98d7e9d9ab7536a68248b008000a3dc3a6a`, MD5 `e2c8be73b5aa7698c5e8878ae607fe85` (matches EBI).
- Sample: 39,106 clinically diagnosed cases + 46,828 UK Biobank proxy cases / 401,577 controls (European; 487,511 total). UKB component: 2,447 diagnosed, 46,828 proxy, 338,440 controls. Per-SNP `n_cas`, `n_con` columns. Effective N not stated by the authors; to be computed from per-SNP counts.
- Ancestry: European. Build: **GRCh38** (meta.yaml). Columns: `hm_variant_id hm_rsid hm_chrom hm_pos hm_other_allele hm_effect_allele hm_beta hm_odds_ratio hm_ci_lower hm_ci_upper hm_effect_allele_frequency hm_code variant_id p_value chromosome base_pair_location effect_allele other_allele effect_allele_frequency odds_ratio ci_lower ci_upper beta standard_error n_cas n_con`.
- UK Biobank: **yes**. 23andMe: no.
- Terms: CC0 (GWAS Catalog `terms_of_license`); EMBL-EBI expects attribution. Open download.

### 1.2 Dementia with Lewy bodies — Chia et al. 2021
- Role: DLB exposure/outcome.
- Publication: Chia R, et al. Genome sequencing analysis identifies new loci associated with Lewy body dementia and provides insights into its genetic architecture. Nat Genet 2021;53:294–303. doi:10.1038/s41588-021-00785-3.
- Access: GWAS Catalog GCST90001390, https://www.ebi.ac.uk/gwas/studies/GCST90001390 (harmonised directory).
- File: `chia2021/33589841-GCST90001390-EFO_0006792.h.tsv.gz`, 391,918,252 bytes, SHA-256 `adcf6a6423e405e20fcd46a391d79d7ad12fc5fae23dd394deff6ebc1cb623a7`, MD5 `e04988c46ee51f7a32c7e50e9978f782` (matches EBI). The author-submitted file has no rsIDs; the harmonised file (`hm_rsid`) is used.
- Sample: 2,591 cases / 4,027 controls (European; whole-genome sequencing). No per-SNP N column.
- Build: **GRCh38**. Columns: as 1.1 without `n_cas`/`n_con`.
- UK Biobank: no. 23andMe: no.
- Terms: EMBL-EBI terms of use; open download; cite the paper.

### 1.3 Major depression — PGC MDD2025 (Adams et al. 2025), 23andMe excluded
- Role: MDD exposure/outcome. Two versions downloaded; which one is primary is decided in the Faz 2 plan.
- Publication: Adams MJ, et al. Trans-ancestry genome-wide study of depression identifies 697 associations implicating cell types and pharmacotherapies. Cell 2025;188(3):640–652.e9. doi:10.1016/j.cell.2024.12.002.
- Access: PGC download page https://pgc.unc.edu/for-researchers/download-results/ → figshare doi:10.6084/m9.figshare.27061255 (v5).
- Files (GRCh37; columns `#CHROM POS ID EA NEA BETA SE PVAL FCAS FCON IMPINFO NEFF NCAS NCON HETI HETDF HETPVAL`, BETA = ln(OR)):
  - `mdd2025/pgc-mdd2025_no23andMe_eur_v3-49-24-11.tsv.gz`, 232,895,012 bytes, SHA-256 `5d6fc5aee638e73457da703b75e0b4d4dacfb1b87578fd464b771209c0dfb22a`. Header: nCase 412,305; nControl 1,588,397; nEffective 1,152,656 (sum of per-cohort 4/(1/Nca+1/Nco); the paper reports half, 576,327). **Includes UK Biobank** (54,669 / 306,461), MVP, iPSYCH, FinnGen and others.
  - `mdd2025/pgc-mdd2025_no23andMe-noUKBB_eur_v3-49-24-11.tsv.gz`, 225,357,893 bytes, SHA-256 `c6b999307d15fa5916b99ff67455c403a20de9688593bb58adda76a2a296c1f3`. Header: nCase 357,636; nControl 1,281,936; nEffective 967,084. **UK Biobank excluded.**
  - Cohort tables: `pgc-mdd2025_no23andMe_eur_v3.49.24.11.txt`, `pgc-mdd2025_no23andMe-noUKBB_eur_v3.49.24.11.txt`.
- 23andMe: excluded in both.
- Terms: PGC Data Access Terms (accepted). Key conditions: no cross-posting or redistribution; never attempt to identify participants; scientific, non-commercial use only; no risk/predictive test for an unborn individual; cite the appropriate PGC publications; Fort Lauderdale principles.

### 1.4 PTSD — PGC-PTSD Freeze 3 (Nievergelt et al. 2024)
- Role: PTSD exposure/outcome.
- Publication: Nievergelt CM, et al. Genome-wide association analyses identify 95 risk loci and provide insights into the neurobiology of post-traumatic stress disorder. Nat Genet 2024;56:792–808. doi:10.1038/s41588-024-01707-9.
- Access: PGC "ptsd2024" → figshare doi:10.6084/m9.figshare.26349322 (v3). README `ptsd2024_sumstats_readme.pdf`.
- Files (GRCh37):
  - `ptsd2024/eur_ptsd_pcs_v4_aug3_2021.vcf.gz` (primary, sample-size-weighted Z meta-analysis), 254,036,468 bytes, SHA-256 `e204896e066e175f955cfbc6b300b887ed68746d08432ecc57732ba0ca803825`. Columns `CHROM ID POS A1 A2 FREQ NEFF Z P DIRE` (no BETA/SE). Header: nCase 137,136; nControl 1,085,746; 63 cohorts; Neff 641,533 (methods text in header).
  - `ptsd2024/eur_ptsdcasecontrol_pcs_v4_aug3_2021.vcf.gz` (case/control IVW, log-OR), 152,377,987 bytes, SHA-256 `5073c3a8722ac654b586c048654cb06687e18cb89a87ac3e7364dad9b09a301f`. Columns `CHROM ID POS A1 A2 FREQ BETA SE P NCASE NCON NEFF NTOT`. The header repeats the primary file's nCase/nControl, but the per-SNP columns give max NCASE 140,767, max NCON 1,109,073 and **max NEFF 460,805** (6,545,577 variants); per-SNP values are used. README recommends this file when effect sizes are needed (e.g. MR).
- UK Biobank: **yes** (cohorts `ukbb` 10,913/124,888 and `ukb2` 9,882/120,862); no UKB-free file is published. MVP: yes (32,372/154,317). iPSYCH: yes. 23andMe: not a cohort.
- Terms: PGC Data Access Terms (accepted) plus file `termsOfUse` (non-commercial research only; no secondary distribution; cite publications).

### 1.5 Insomnia — Watanabe et al. 2022, open UK Biobank file
- Role: insomnia exposure/outcome.
- Publication: Watanabe K, et al. Genome-wide meta-analysis of insomnia prioritizes genes associated with metabolic and psychiatric pathways. Nat Genet 2022;54:1125–1132. doi:10.1038/s41588-022-01124-w.
- Access: https://cncr.nl/research/summary_statistics/ → Zenodo doi:10.5281/zenodo.24366723.
- File: `insomnia/insomnia_ukb2b_EUR_sumstats_20190311_with_chrX_mac_100.txt.gz`, 618,512,627 bytes, SHA-256 `17db877b90f1fb940a2cd2405c35ca0e8873964c0f33dd91a8bb1b8adf6f0ebe`. README: "UK Biobank unrelated EUR samples … 109,548 cases and 277,440 controls", PLINK 2.0 logistic regression.
- Columns: `SNP CHR BP A1 TEST NMISS OR SE L95 U95 STAT P A2 SNPID_UKB RSID_UKB A1_UKB A2_UKB INFO_UKB MAF_UKB MAF NCHROBS` (A1 = tested allele; SE of log(OR)).
- Build: GRCh37 (stated in the companion `README_atlas_ukb2_sumstats.txt` of the same record; the insomnia README does not state it).
- **This is not the full Watanabe 2022 meta-analysis**: the full set includes 23andMe and requires a 23andMe Data Transfer Agreement, so it is not used (§1.1-5). STRICT_RULES Faz 1 allows "the most recent open release".
- UK Biobank: **yes, exclusively**. 23andMe: excluded.
- Terms: CC BY-NC-SA 4.0; "you agree not to attempt to identify individual participants and not to use the sumstats for projects that may lead …"; commercial use needs permission; cite the paper (accepted).

### 1.6 Schizophrenia — PGC3 (Trubetskoy et al. 2022)
- Role: SCZ exposure/outcome.
- Publication: Trubetskoy V, et al. Mapping genomic loci implicates genes and synaptic biology in schizophrenia. Nature 2022;604:502–508. doi:10.1038/s41586-022-04434-5.
- Access: PGC "scz2022" → figshare doi:10.6084/m9.figshare.19426775 (v7). README `PGC3_SCZ_sumstats_release_v3.2_README.pdf`.
- File: `scz2022/PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv.gz` (European ancestry, autosomes), 239,710,564 bytes, SHA-256 `dbba3a85575c99fd1c2e3497d0c7a44539ccfdbf2e69742f8bdbda879230bcd7`. Header: nCase 52,017; nControl 75,889; nTrio 1,369; 76 cohorts; 7,659,767 variants. Columns `CHROM ID POS A1 A2 FCAS FCON IMPINFO BETA SE PVAL NCAS NCON NEFF` (A1 = reference allele for freq/beta; BETA = ln(OR)). Cohort list: `scz2022-Extended-Data-Table1.xlsx`. **`NEFF` is half the effective N** despite its header description ("effective sample size total"): Σ 4/(1/Nca+1/Nco) over the header's per-cohort counts = 114,792 (half 57,396; + 1,369 trios ≈ 58,765 vs file 58,749). Harmonisation uses 2 × `NEFF` (analysis/deviations.md C1).
- Build: GRCh37.
- UK Biobank: no UKB cohort code in the cohort list. 23andMe: not listed. iPSYCH: yes.
- Terms: PGC Data Access Terms (accepted) plus Fort Lauderdale clause (the publication embargo ended with the 2022 paper).

### 1.6b Alzheimer's disease, clinical diagnosis, no UK Biobank, no proxy cases — FinnGen R13 (sensitivity)
- Role: pre-registered sensitivity analysis for AD (analysis plan §4b). Verification report: `data/finngen_verification.md` (accessed 2026-11-20).
- Publication: Kurki MI, et al. FinnGen provides genetic insights from a well-phenotyped isolated population. Nature 2023;613:508–518. doi:10.1038/s41586-022-05473-8. Release: FinnGen R13 (DF13); public release date given as "June 2, 2026" on https://www.finngen.fi/en/access_results and "Q3 2026" in the GitBook release table (cite as R13, 2026, with access date).
- Endpoint: `G6_ALZHEIMER`, 16,652 cases / 483,534 controls (R13 manifest). Definition (R13 Risteys): ICD-10 G30, ICD-9 3310, hospital discharge and cause-of-death registers; controls are non-cases; no proxy or family-history cases.
- File: `https://storage.googleapis.com/finngen-public-data-r13/summary_stats/finngen_R13_G6_ALZHEIMER.gz` (805,395,928 bytes, HEAD 2026-11-20) + `.tbi`. GRCh38; columns `#chrom pos ref alt rsids nearest_genes pval mlogp beta sebeta af_alt af_alt_cases af_alt_controls` (alt = effect allele, beta = log OR); no N column (N from manifest); no INFO column. REGENIE with Firth correction for P < 0.01.
- Ancestry: Finnish. UK Biobank: none.
- Overlap: MDD noUKBB (FinnGen R5, 23,424 / 192,220); PTSD Freeze 3 (FING, 9,801 / 249,993); possible small overlap with Finnish THL cohorts in PGC3 SCZ (unquantified); none with insomnia UKB-only file; Bellenguez stage I file: none (FinnGen only in stage II, which is not in the file).
- Access: online form https://elomake.helsinki.fi/lomakkeet/124935/lomake.html (first name, last name, organisation, email, country; required checkbox "I agree that I will never attempt to identify any individual participant" / "I certify to be in compliance with all applicable local, state, and federal laws or regulations and institutional policies regarding human subjects and genetics research"); download instructions by email; no review, agreement or fee ("free of charge").
- Terms (verbatim): "The results are not intended to serve as a basis for product development, marketing activities, or health-related claims." "Any use of FinnGen results for commercial purposes is the sole responsibility of the user." Acknowledgement: "We want to acknowledge the participants and investigators of the FinnGen study". Cite Kurki et al. 2023; include "FinnGen" as a keyword if possible.
- Access completed by the investigator via the form (2026-11-20).
- Manifest: `finngen/finngen_R13_manifest.tsv`, downloaded by the investigator to Windows and copied (`finngen_R13_manifest.user_copy.tsv`), and independently downloaded from the official address https://storage.googleapis.com/finngen-public-data-r13/summary_stats/finngen_R13_manifest.tsv ; both copies are byte-identical, SHA-256 `c9caafa9b98ee5ef050a705766bd1c451fc2154fb8e81b069022012a2f75ae20`. **Status: downloaded by the user, verified against the official address.**
- Endpoint choice recorded before download: `analysis/deviations.md` D2.
- Downloaded (2026-11-20, curl from the official address; the `summary_stats/release/` path given in the access e-mail returns HTTP 404 for R13, the manifest's `path_https` without `release/` was used):
  - `finngen/finngen_R13_G6_ALZHEIMER.gz`, 805,395,928 bytes, SHA-256 `9cfdf75f996ca688eb9de4638fa0dc5249b102c8e65da0423769b5ce4324e8eb`, MD5 `3649575a280ce3e51e771cc25f716741` (matches the server's `x-goog-hash`).
  - `finngen/finngen_R13_G6_ALZHEIMER.gz.tbi`, 1,769,741 bytes, SHA-256 `d3a9cce8850cf838e24c62be0548c6bba6ad0debfdd14aaf3996661e27b7aebc`, MD5 `de06d18e44d9def5e1f61a9c09010c10` (matches).
- Overlap re-checked against the project's own copies: MDD cohort tables (with and without UKB) list `FinnGen R5_18032020, 23,424 cases / 192,220 controls`; the PTSD Freeze 3 file header lists cohort `fing` with 9,801 cases.
- Publication requirements: Acknowledgments sentence verbatim "We want to acknowledge the participants and investigators of the FinnGen study."; cite Kurki et al. 2023 (registered as `kurki2023finngen`); FinnGen introduced in the Methods in the authors' own words (the template paragraph from the access e-mail is not reused); "FinnGen" as a keyword if possible.

### 1.7 Excluded: Alzheimer's disease clinical diagnosis without UK Biobank — Kunkle et al. 2019
- NIAGADS NG00075 full summary statistics require an application; the open NIAGADS file has P-values only.
- GWAS Catalog GCST007511 is openly downloadable, but the IGAP README deposited with it states that the data "should not be used for research into … potentially sensitive behavioral traits such as alcohol or drug addictions". Whether psychiatric traits are covered is undefined, so the dataset was **excluded** by investigator decision (2026-11-19) under §1.1-5. Not downloaded. Consequence: no AD analysis free of UK Biobank; to be stated in Methods and Limitations.

---

## 2. Reference panels

| Use | File | Source | Bytes | SHA-256 | Build | Terms |
|---|---|---|---|---|---|---|
| LDSC weights (HapMap3, MHC removed) | `ldsc_ref/1000G_Phase3_weights_hm3_no_MHC.tgz` | Zenodo doi:10.5281/zenodo.7768714 | 12,757,654 | `d3e29112c64766dcee0ad9ec69ebda3d24cbe29ddb559d75443b10bcf8756c91` | GRCh37 (1000G Phase 3) | CC BY 4.0 |
| LDSC LD scores | `ldsc_ref/1000G_Phase3_ldscores.tgz` | same | 13,362,450 | `470fe954080ba164f6b18ca2be8f8a6e2585d983b4a248556b5ffff2c3d0145f` | GRCh37 | CC BY 4.0 |
| LDSC allele frequencies | `ldsc_ref/1000G_Phase3_frq.tgz` | same | 85,939,688 | `ce0539686811151b820b8105dbe00e6371a79cf433c6545423ca26a9e7416b7f` | GRCh37 | CC BY 4.0 |
| 1000G Phase 3 EUR PLINK (LDSC set) | `ldsc_ref/1000G_Phase3_plinkfiles.tgz` | same | 288,277,344 | `18383e998035521270d158b0aa4e546d269fc938f6e8490ff6916b644330f5df` | GRCh37 | CC BY 4.0 |
| LAVA locus definitions (2,495 loci) | `lava_ref/blocks_s2500_m25_f1_w200.GRCh37_hg19.locfile` | LAVA GitHub `support_data/` | 63,426 | `462e81bce9ca85c9f11c0feb4d1bda24dd2c0fe095bfcc83fd32f77dff9a0882` | GRCh37 | LAVA repo |
| LAVA LD reference, UK Biobank v1.1 (**primary**) | `lava_ref/ukb_ref_chr{1-2,3-4,5-6,7-9,10-12,13-16,17-23}.zip` | vu.data.surfsara.nl (links in LAVA REFERENCE.md) | 14,110,596,095 total | see CHECKSUMS.tsv | GRCh37 | no licence stated; cite LAVA |
| LAVA LD reference, 1000G Phase 3 EUR (sensitivity) | `lava_ref/g1000_eur.zip` | vu.data.surfsara.nl | 511,626,945 | `83a48fd9dcaa0b9a874b18c63143a4ede93f05505b215b0bd8790130a0d7a954` | GRCh37 | no licence stated; cite LAVA |
| LD clumping reference (1000G, 5 super-populations; EUR used) | `clump_ref/1kg.v3.tgz` | MRC IEU, http://fileserve.mrcieu.ac.uk/ld/1kg.v3.tgz (ieugwasr vignette) | 1,567,805,147 | `06125160770fc65adf0296fe9a461011a910338bd106b4e319add13e81ab3670` | not stated (clumping by rsID) | none stated |

Notes:
- The original LDSC `eur_w_ld_chr` / `w_hm3.snplist` at the Broad Institute are no longer freely available (404, or requester-pays, which is a fee and excluded under §1.1-5). The Zenodo 1000G Phase 3 set matches STRICT_RULES ("1000 Genomes Faz 3 EUR"). A HapMap3 SNP list with alleles for munging will be derived from the Phase 3 weights SNPs and the Phase 3 PLINK `.bim` alleles; the derivation is scripted in `analysis/R/01_munge.R`.
- **LAVA UK Biobank reference, provenance** (checked 2026-11-20):
  - Distributor: the LAVA authors (J. Werme, C. A. de Leeuw, Vrije Universiteit Amsterdam). Documented in `REFERENCE.md` of https://github.com/josefin-werme/LAVA ("UK Biobank reference in LAVA binary LD format, version 1.1 (requires LAVA v0.1.5 or up). Recommended for European ancestry analyses. …").
  - Download: public links on the SURF Research Drive of Vrije Universiteit (`https://vu.data.surfsara.nl/index.php/s/<ID>/download`), no registration, form or password.
  - `VERSION_INFO` inside each zip: "LAVA reference LD - release 1.1; Source: UK Biobank (N = 100,000); Range: up to 10 Mb; Storage format: eigen …" (files dated 2025-06-20).
  - Publication: **no peer-reviewed publication describes the panel.** The LAVA README cites a preprint (https://www.preprints.org/manuscript/202507.0966) for the finding that 1000 Genomes inflates type I error. Citation in the manuscript: the LAVA method paper (Werme et al., Nat Genet 2022) plus the repository and release (v1.1).
  - Terms: none stated on the download pages, in the archives or in the repository (GitHub repository licence: none; LAVA package DESCRIPTION: "All rights reserved"). No application, agreement or fee.
  - Decision: meets the "publicly available and unconditional" criterion; kept as the primary LAVA reference.
- LAVA primary reference = UK Biobank (investigator decision 2026-11-19, following the LAVA authors' recommendation); 1000G EUR = pre-registered sensitivity analysis. This departs from the STRICT_RULES Faz 1 table and is recorded in `build/PROGRESS.md` and the Faz 2 plan.

---

## 3. Sample overlap (Kapı 1)

Only cohorts named in official documentation are listed. The LDSC cross-trait intercept will quantify overlap empirically, and MRlap will correct MR estimates for it.

| Pair | Shared cohorts | Severity |
|---|---|---|
| AD × DLB | Clinical/neuropathology cohort overlap possible (not documented) | Unknown, likely small |
| AD × MDD (with UKB) | UK Biobank (AD: 338,440 UKB controls + 46,828 proxy cases; MDD: 54,669 / 306,461) | Large |
| AD × MDD (noUKBB) | none documented | – |
| AD × PTSD | UK Biobank | Large |
| AD × insomnia | UK Biobank (insomnia is 100% UKB) | Large |
| AD × SCZ | none documented | – |
| DLB × any psychiatric trait | none documented | – |
| MDD (with UKB) × PTSD | UK Biobank, MVP, iPSYCH, FinnGen, HUNT, Estonian Biobank, BioVU, MGB, AGDS, STAGE | Large |
| MDD (noUKBB) × PTSD | MVP, iPSYCH, FinnGen, HUNT, Estonian Biobank, BioVU, MGB, AGDS, STAGE | Large |
| MDD (with UKB) × insomnia | UK Biobank | Large |
| MDD (noUKBB) × insomnia | none | – |
| MDD × SCZ | iPSYCH (and possibly other PGC cohorts) | Moderate |
| PTSD × insomnia | UK Biobank (ukbb + ukb2 ≈ 20.8k cases / 245.8k controls) | Large |
| PTSD × SCZ | iPSYCH | Moderate |
| insomnia × SCZ | none documented | – |
| FinnGen AD × MDD (noUKBB and with UKB) | FinnGen R5 (23,424 / 192,220) is a cohort of both MDD files | Moderate (MRlap) |
| FinnGen AD × PTSD | FinnGen cohort `fing` (9,801 cases / 249,993 controls) | Moderate (MRlap) |
| FinnGen AD × SCZ | possible: Finnish THL family cohorts in PGC3 (unquantified) | Small |
| FinnGen AD × insomnia | none (insomnia file is UK Biobank only) | – |
| FinnGen AD × Bellenguez AD | none in the stage I file used (FinnGen only in Bellenguez stage II) | – |

The MR design is two-sample between psychiatric traits and AD/DLB, so the pairs that matter for MR are AD/DLB × each psychiatric trait. DLB has no documented overlap with any psychiatric trait. AD (Bellenguez) overlaps through UK Biobank with MDD (with-UKB version), PTSD and insomnia.

---

## 4. Harmonisation (Faz 1 step 3) — to be applied in `analysis/R/01_munge.R`

Target build GRCh37. Bellenguez and Chia (GRCh38) are mapped to GRCh37 positions by rsID using the 1000G Phase 3 PLINK `.bim` (GRCh37). Filters: MAF ≥ 0.01; INFO ≥ 0.9 where available (MDD `IMPINFO`, SCZ `IMPINFO`, insomnia `INFO_UKB`); multi-allelic and strand-ambiguous palindromic SNPs removed; MHC (chr6:25–34 Mb, GRCh37) excluded for LDSC; APOE region (chr19:44.4–46.5 Mb, GRCh37) flagged for the sensitivity analysis.


## GENCODE v19 gene annotation (GRCh37) — added 2026-11-20
- Purpose: gene names for LAVA loci in the descriptive (exploratory) listing of nominal local correlations (`analysis/R/06b_power_summary.R`); not used in any test.
- File: `data/raw/gencode19/gencode.v19.annotation.gtf.gz`, 37,991,892 bytes, SHA-256 9909e8123a40eca090c3f8e501633f7cc65cd6c4adb83b95009745eca3564d70.
- Source: https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.annotation.gtf.gz (GENCODE release 19, Ensembl 74, GRCh37; file header date 2013-12-05). Downloaded 2026-11-20 with curl, no login.
- Terms: GENCODE data are freely available without restriction (no application, agreement or fee).
- Use: `gene` records with gene_type "protein_coding"; a gene is listed for a locus if its span overlaps the locus boundaries.

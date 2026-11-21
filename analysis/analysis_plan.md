# Pre-registered analysis plan

Title: Genetic overlap between neuropsychiatric traits and Alzheimer's disease and dementia with Lewy bodies: a local genetic correlation and bidirectional Mendelian randomization study

Status: written 2026-11-20 before any cross-trait analysis was run. At the time of writing, only single-file harmonisation and single-file quality control (`analysis/R/01_munge.R`: allele-frequency concordance with the reference, λGC, sample-size checks) had been performed. No genetic correlation, heritability, local genetic correlation, instrument selection, MR or colocalisation result had been computed or viewed. The FinnGen R13 AD file (§4b) had not been downloaded. The plan is frozen by recording its SHA-256 in `analysis/analysis_plan.sha256`. Any later change is recorded in `analysis/deviations.md` with its reason and reported in the Methods.

Reporting standard: STROBE-MR (completed item by item in Supplementary File S1).

---

## 0. Data and design decisions fixed before analysis

### 0.1 Traits and files (details in `data/DATA_MANIFEST.md`)

| Trait | Primary file | Use | UK Biobank |
|---|---|---|---|
| Alzheimer's disease (AD) | Bellenguez 2022, GCST90027158 (clinical + UKB proxy cases) | all analyses | yes |
| Dementia with Lewy bodies (DLB) | Chia 2021, GCST90001390 | all analyses | no |
| Major depressive disorder (MDD), **primary** | PGC MDD2025, no23andMe, **noUKBB**, EUR | all analyses | **no** |
| MDD, sensitivity | PGC MDD2025, no23andMe, with UKB, EUR | sensitivity analyses only (§4.7, §2.4) | yes |
| PTSD | PGC-PTSD Freeze 3, EUR: Z-score file for LDSC and LAVA (Neff 641,533); case/control file (BETA, SE) for MR and colocalisation | see column 1 | yes |
| Insomnia | Watanabe 2022, open UKB-only file (109,548 / 277,440) | all analyses | yes (100%) |
| Schizophrenia (SCZ) | PGC3 2022, EUR autosomes | all analyses | no |
| AD, clinical, sensitivity | FinnGen R13 endpoint `G6_ALZHEIMER` (16,652 cases / 483,534 controls; ICD-10 G30 / ICD-9 3310 in hospital discharge and cause-of-death registers; no proxy cases) | sensitivity analysis only (§4b) | no |

Decisions and reasons:
1. **MDD primary = UK Biobank-free version.** AD (Bellenguez) contains UK Biobank (338,440 controls and 46,828 proxy cases). Using the UKB-free MDD file removes AD × MDD sample overlap by design, which is preferred over relying on statistical correction. The UKB-containing MDD file (larger, Neff 1,152,656 vs 967,084) is analysed as a sensitivity analysis with MRlap correction for overlap.
2. **Kunkle et al. 2019 (AD clinical diagnosis, no UK Biobank) is not used.** Its full summary statistics at NIAGADS (NG00075) require an application; the open GWAS Catalog deposit (GCST007511) carries the IGAP condition that the data "should not be used for research into … potentially sensitive behavioral traits such as alcohol or drug addictions". Whether psychiatric traits fall under this condition is undefined, so the dataset was excluded under the project's data-use rule. **Consequence:** Kunkle cannot serve as the UK Biobank-free AD sensitivity analysis. For PTSD and insomnia, which have no public UK Biobank-free files, the overlap with the primary AD GWAS cannot be removed by design; in the primary analysis it is handled only by MRlap (§4.7) and quantified by the LDSC cross-trait intercept (§2.3). FinnGen R13 clinical AD (§4b) is added as the UK Biobank-free and proxy-free AD sensitivity analysis; it removes the UK Biobank overlap with PTSD and insomnia but introduces FinnGen overlap with MDD and PTSD (§4b.3). This is stated in the Methods and the Limitations.
3. **Insomnia** uses the only openly available genome-wide file, which is UK Biobank only. The full Watanabe 2022 meta-analysis (with 23andMe) requires a data transfer agreement and is not used.
4. **PTSD**: the primary Freeze 3 file is a sample-size-weighted Z-score meta-analysis without effect sizes. LDSC and LAVA need only Z and N and use this file (greater power). MR and coloc need BETA and SE and use the case/control file from the same release, as recommended by its README. As a sensitivity analysis, genome-wide rg is also computed with the case/control file.
5. **LAVA reference panel = UK Biobank (LAVA v1.1 reference, 100,000 unrelated Europeans)**, following the LAVA authors' recommendation that the 1000 Genomes panel can inflate type I error and bias local heritability; the 1000 Genomes Phase 3 EUR panel is used as a sensitivity analysis. This departs from the reference named in STRICT_RULES (1000 Genomes) and is reported.
6. **LDSC reference = 1000 Genomes Phase 3 EUR** (Zenodo 10.5281/zenodo.7768714: HapMap3 weights without MHC, LD scores). The original Broad `eur_w_ld_chr` files are no longer freely available.

### 0.2 Harmonisation (already applied, `analysis/R/01_munge.R`)
GRCh37; GRCh38 files mapped by rsID to the 1000G Phase 3 EUR reference; MAF ≥ 0.01; INFO ≥ 0.9 where available; strand-ambiguous palindromic SNPs (MAF > 0.42) removed; multi-allelic and duplicate positions removed; MHC (chr6:25–34 Mb) flagged and excluded from LDSC and LAVA; APOE region (chr19:44.4–46.5 Mb) flagged. Counts per step: `analysis/logs/munge_counts.csv`.

### 0.3 Population prevalences (assumptions)
Needed only for liability-scale h² (descriptive) and for Steiger filtering (§4.5). They are fixed here as **working assumptions** before any analysis: AD 0.05, DLB 0.005, MDD 0.15, PTSD 0.07, insomnia 0.10, SCZ 0.01. For each of the six values a primary source (a population-based prevalence study or systematic review) will be identified in Faz 4 and cited in the Methods. If no primary source supports a value, it is replaced with the value from the best available cited source, the affected analyses are re-run, and the change is recorded in `analysis/deviations.md`. No uncited prevalence value appears in the manuscript. Robustness: Steiger filtering is repeated with each prevalence halved and doubled, and any change in the retained instrument set is reported.

### 0.4 Trait pairs
- **Primary pairs (8):** {MDD, PTSD, insomnia, SCZ} × {AD, DLB}.
- **Secondary pairs (7):** AD × DLB and the six pairs among the four psychiatric traits. Reported descriptively in the supplement; not part of the primary hypotheses or the primary multiple-testing family.

---

## 1. Hypotheses (non-directional, two-sided)
- H1 (genome-wide): for each primary pair, the genome-wide genetic correlation differs from zero.
- H2 (local): for each primary pair, at least one genomic locus shows a local genetic correlation different from zero.
- H3 (APOE): for each primary pair involving AD, the genome-wide genetic correlation and the MR estimate differ when the APOE region is excluded.
- H4 (MR, both directions): genetic liability to each psychiatric trait is associated with AD and DLB risk, and genetic liability to AD and DLB is associated with each psychiatric trait.
- H5 (colocalisation): loci with significant local genetic correlation share a causal variant.
No direction of effect is predicted.

---

## 2. Genome-wide genetic correlation (`02_ldsc.R`)
2.1 Method: LD score regression as implemented in GenomicSEM `ldsc()`, all 15 pairs (primary + secondary), on HapMap3 SNPs present in the 1000G Phase 3 weights, MHC excluded.
2.2 Input: Z and effective N per SNP (case/control traits entered with sample prevalence 0.5 and Neff). SNP heritability is reported on the observed scale with Neff; liability-scale heritability is reported descriptively using the population prevalences of §0.3 (the conversion does not affect rg or any test in this plan).
2.3 Reported: rg, SE, 95% CI, P; univariate h² and intercepts; cross-trait intercepts (an empirical index of sample overlap).
2.4 Sensitivity: (a) MDD with UK Biobank instead of noUKBB; (b) PTSD case/control file instead of the Z-score file; (c) AD pairs with the APOE region removed (H3).
2.5 Univariate h² Z < 4 is flagged as low-power for rg interpretation, but estimates are still reported.

## 3. Local genetic correlation (`03_lava.R`)
3.1 Method: LAVA v0.1.5; 2,495 loci from `blocks_s2500_m25_f1_w200.GRCh37_hg19.locfile`; UK Biobank LD reference (primary), 1000G EUR (sensitivity); MHC loci excluded.
3.2 Sample overlap is modelled with the LAVA overlap matrix estimated from the LDSC cross-trait intercepts (§2.3), as recommended by the LAVA authors.
3.3 Binary traits entered with case and control counts.
3.4 Step 1, univariate test of local heritability for each trait at each locus; a locus is carried forward for a pair only if both traits have univariate P < 1 × 10⁻⁴.
3.5 Step 2, bivariate local rg for each carried-forward locus–pair, reported with 95% CI and P.
3.6 Multiple testing: Benjamini–Hochberg FDR 5% across all bivariate tests of the primary pairs; Bonferroni (0.05 / number of bivariate tests) also reported. Secondary pairs are corrected separately.
3.7 Loci within the APOE region are reported separately and identified as such.

## 4. Bidirectional two-sample Mendelian randomization (`04_mr.R`, `05_mr_sensitivity.R`)
4.1 Directions: 16 primary analyses (8 primary pairs × 2 directions). Secondary pairs are not analysed by MR.
4.2 Instruments: SNPs associated with the exposure at P < 5 × 10⁻⁸. If fewer than 3 independent instruments remain after clumping and filtering, the pre-registered fallback threshold P < 5 × 10⁻⁶ is used for that exposure and reported as such.
4.3 Clumping: PLINK 1.9, r² < 0.001 within 10,000 kb, using the 1000 Genomes EUR reference distributed by MRC IEU (`1kg.v3`).
4.4 Instrument strength: per-SNP F = β² / SE²; SNPs with F ≤ 10 are removed; mean F and total R² are reported.
4.5 Harmonisation: TwoSampleMR `harmonise_data()` (action 2). Instruments absent from the outcome GWAS are dropped (no LD proxies) and the number dropped is reported. Steiger filtering (TwoSampleMR `steiger_filtering`, binary traits on the liability scale using case/control counts and the population prevalences of §0.3) removes SNPs explaining more variance in the outcome than in the exposure.
4.6 Primary estimator: inverse-variance weighted with multiplicative random effects. Sensitivity estimators: MR-Egger (slope and intercept), weighted median, weighted mode, MR-PRESSO (global test, outlier-corrected estimate, distortion test; 10,000 simulations; fixed seed), leave-one-out. Heterogeneity: Cochran's Q (IVW) and Rücker's Q′ (Egger), reported for every MR analysis. MR-Egger validity: the I²GX statistic (Bowden et al. 2016; TwoSampleMR `Isq()` on exposure effects and standard errors) is reported for every analysis. When I²GX < 0.9, the MR-Egger slope and intercept are re-estimated with the SIMEX correction for regression dilution (R package `simex`; 1,000 simulations; fixed seed), and the SIMEX-corrected intercept is the one used in the interpretation rule (§8).
4.7 Sample overlap: MRlap for every primary direction, and for the sensitivity analyses that use MDD with UK Biobank. MRlap-corrected estimates are reported alongside IVW. For the AD × PTSD and AD × insomnia directions, where overlap with the primary AD GWAS cannot be removed by design (§0.1.2), MRlap is the only overlap adjustment within the primary analysis and this is stated; the FinnGen sensitivity analysis (§4b) provides an AD outcome/exposure without UK Biobank for these traits.
4.8 APOE: every direction with AD as exposure or outcome is repeated with all instruments in chr19:44.4–46.5 Mb removed (H3).
4.9 Effect scale: odds ratio of the outcome per unit increase in the log-odds of genetic liability to the exposure, with 95% CI.
4.10 Power: the minimum detectable OR at 80% power (α = 0.05) is reported for each direction, from instrument R² and outcome case/control counts, as context for null results.

## 4b. Sensitivity analysis with clinically diagnosed AD without UK Biobank or proxy cases (FinnGen R13)
4b.1 Rationale. The primary AD GWAS (Bellenguez 2022) includes 46,828 UK Biobank proxy cases defined by self-reported parental dementia, and UK Biobank is also part of the PTSD, insomnia and (sensitivity) MDD GWAS. Proxy-based AD phenotypes can show genetic correlations with education and psychiatric traits that differ from those of clinically diagnosed AD, which bears directly on the question of this study. Because Kunkle 2019 is excluded (§0.1.2), FinnGen R13 is used as the only available clinically diagnosed AD GWAS without UK Biobank and without proxy cases.
4b.2 Data. FinnGen R13, endpoint `G6_ALZHEIMER` (largest clinically diagnosed AD endpoint; register diagnoses only; controls are all non-cases; GRCh38, harmonised with the same pipeline as §0.2, mapped by rsID; N from the R13 manifest). Finnish ancestry: a population isolate within the European ancestry group; the European LD references are used and the ancestry difference is stated as a limitation.
4b.3 Overlap. FinnGen contributes to the MDD noUKBB file (FinnGen R5: 23,424 cases / 192,220 controls) and to PTSD Freeze 3 (cohort FING: 9,801 / 249,993). Possible small overlap with the Finnish THL family cohorts in PGC3 SCZ (unquantified). No overlap with the insomnia (UKB-only) file. MRlap is therefore applied to every FinnGen MR direction, and LDSC cross-trait intercepts are reported.
4b.4 Analyses: the 4 psychiatric traits × FinnGen AD; genome-wide rg (§2) and bidirectional MR (8 directions) with the same instrument rules, estimators, sensitivity set, I²GX/SIMEX, MRlap and APOE-excluded re-analysis as §4. LAVA and coloc are not run for FinnGen.
4b.5 Status: these tests are **not used to declare significance** and are not part of any multiple-testing family. They are reported as consistency checks: agreement or disagreement in direction and magnitude with the corresponding Bellenguez results is described.
4b.6 Access condition. FinnGen summary statistics are obtained through an online form (name, organisation, email, country; agreement not to attempt to identify participants and to comply with applicable regulations); there is no review, agreement or fee. The form is completed by the investigator. If the investigator does not complete it, §4b is not performed and this is recorded in `analysis/deviations.md`.

## 5. Colocalisation (`06_coloc.R`)
5.1 Applied to each locus–pair significant at FDR 5% in §3.6.
5.2 coloc `coloc.abf()`, region = LAVA locus boundaries, case/control datasets (type "cc", s = case fraction), default priors p1 = p2 = 1 × 10⁻⁴, p12 = 1 × 10⁻⁵.
5.3 PP.H4 > 0.8 is interpreted as evidence for a shared causal variant; PP.H3 > 0.8 as evidence for distinct causal variants; otherwise inconclusive.
5.4 Prior sensitivity: p12 = 5 × 10⁻⁶ also reported.

## 6. Multiple testing
6.1 MR: Benjamini–Hochberg FDR over the 16 primary IVW tests; Bonferroni threshold 0.05 / 16 = 0.003125 also reported.
6.2 Genome-wide rg: BH FDR over the 8 primary pairs; the 7 secondary pairs are corrected separately.
6.3 LAVA: §3.6. Sensitivity analyses are not used to declare significance; they are reported as consistency checks.

## 7. Reporting standard
STROBE-MR, completed item by item in Supplementary File S1. All pre-registered analyses are reported regardless of significance; null findings are stated as absence of evidence.

## 8. Pre-specified interpretation rule
An MR finding is described as **"consistent evidence"** only if all three hold: (i) IVW FDR < 0.05; (ii) at least two of the sensitivity estimators (MR-Egger slope, weighted median, weighted mode, MR-PRESSO outlier-corrected) have the same direction as IVW; (iii) MR-Egger intercept P > 0.05, where the intercept is taken from the conventional MR-Egger model if I²GX ≥ 0.9 and from the SIMEX-corrected MR-Egger model if I²GX < 0.9 (§4.6). If MR-Egger cannot be estimated (fewer than 3 instruments), condition (iii) is reported as not evaluable and the finding cannot be described as "consistent evidence". Findings meeting (i) but not (ii)–(iii) are described as "evidence sensitive to pleiotropy". Findings not meeting (i) are described as "no evidence". For directions with substantial overlap (§4.7), a finding is additionally qualified if the MRlap-corrected estimate changes direction or loses nominal significance. Causal language ("causes") is not used unless all sensitivity analyses agree, and then only cautiously.

---

## 9. Software
R 4.3.3; GenomicSEM 0.0.5; LAVA 0.1.5; TwoSampleMR 0.7.14; MRPRESSO 1.0; MRlap 0.0.3.3; simex 1.8; coloc 5.2.3; ieugwasr 1.2.1; data.table 1.18.6.1; PLINK v1.9.1 (11 Nov 2026). Full session information: `analysis/logs/session_info.txt`. All scripts use a fixed seed (20261120).

# Outline

Status: pre-outline notes recorded during Faz 3. The full outline (headings, one-sentence claim per paragraph, supporting source or result) is written at the start of Faz 6 and extends this file. Notes below are binding on the outline and the Discussion.

## Reference budget (written before KEEP decisions; total allowed 30–40)

### A. Mandatory — data sources (8; + 1 conditional)
| # | key | role | status |
|---|---|---|---|
| 1 | bellenguez2022new | AD GWAS | text OK |
| 2 | chia2021genome | DLB GWAS | published text re-read in progress |
| 3 | adams2025trans | MDD GWAS | text OK |
| 4 | nievergelt2024genome | PTSD GWAS | published text re-read in progress |
| 5 | watanabe2022genome | insomnia GWAS | **NO_ACCESS** (NEEDS_PDF priority 1) |
| 6 | trubetskoy2022mapping | SCZ GWAS | published text re-read in progress |
| 7 | kurki2023finngen | FinnGen (sensitivity AD) | text OK |
| 8 | auton2015global | 1000 Genomes (LD scores, clumping, LAVA sensitivity panel) | text OK |
| (9) | kunkle2019genetic | excluded AD GWAS; cited only to state the exclusion and its reason | decision below |

The LAVA UK Biobank reference has no publication of its own; it is cited through the LAVA paper (werme2022integrated) and the repository release.

### B. Mandatory — methods and software (16)
| # | key | method |
|---|---|---|
| 10 | buliksullivan2015ld | LDSC |
| 11 | buliksullivan2015atlas | cross-trait LDSC (rg) |
| 12 | grotzinger2019genomic | GenomicSEM |
| 13 | werme2022integrated | LAVA (**published text NO_ACCESS**, NEEDS_PDF priority 1) |
| 14 | giambartolomei2014bayesian | coloc |
| 15 | chang2015second | PLINK |
| 16 | hemani2018mr | TwoSampleMR / MR-Base |
| 17 | bowden2015mendelian | MR-Egger |
| 18 | bowden2016consistent | weighted median |
| 19 | hartwig2017robust | weighted mode |
| 20 | verbanck2018detection | MR-PRESSO |
| 21 | hemani2017orienting | Steiger |
| 22 | bowden2016assessing | I²GX and SIMEX |
| 23 | mounier2023bias | MRlap (**published text NO_ACCESS**, NEEDS_PDF priority 1) |
| 24 | burgess2016bias | bias from participant overlap (rationale for MRlap and the UKB-free MDD choice) |
| 25 | skrivankova2021strengthening2 | STROBE-MR |
| 26 | mudge2025gencode | GENCODE (v19 gene annotation for LAVA locus gene lists; GENCODE's current primary reference, doi 10.1093/nar/gkae1078; added 2026-11-20) |

Subtotal A + B = 25 (26 with Kunkle). With C ≤ 3 and D ≈ 12 the total reaches about 40–41; if it exceeds 40 at the final KEEP decision, a second source for an already supported claim is removed first (rule below), never a methods source.

### C. Population prevalences (target ≤ 3 sources)
Sources read: bromet2011cross (MDD: lifetime major depressive episode 14.6% in high-income countries; supports 0.15), koenen2017posttraumatic (PTSD: cross-national lifetime 3.9%, high-income 5.0%, USA 6.9%), saha2005systematic (SCZ: lifetime prevalence 4.0 and lifetime morbid risk 7.2 per 1,000; does not support 0.01), anon2022estimation (all-cause dementia only; no AD-specific value). No source read yet for DLB or insomnia. Decision required (see `build/PROGRESS.md`, open decisions): which values to use and how many sources to spend; plan §0.3 requires replacing unsupported values with cited ones (deviations.md).

### D. Introduction and Discussion (remaining 12–13 slots if C uses 3)
Allocation by outline paragraph (Faz 6 outline; numbers are maximum new references per paragraph):
- Intro P1, NPS burden and MBI (2): zhu2026neuropsychiatric, sassi2026mild.
- Intro P2, epidemiological associations and reverse causation (2): livingston2020dementia, meng2025insomnia. PTSD–dementia and SCZ–dementia epidemiology have no accessible source yet (yaffe2010posttraumatic, qureshi2010greater NO_ACCESS).
- Intro P3, genetic approaches and gaps (3): kumar2026genetic (AD × depression/SCZ local rg), huang2020sleep (MR insomnia/MDD–AD), monereosanchez2021genetic (rg AD–MDD without UKB). DLB features and GWAS power: mckeith2017diagnosis, watkins2026understanding (counted under Discussion D4).
- Discussion D1, comparison with prior studies (2 new): lutz2020shared, guo2026sleep; chen2026shared and hu2024relationship would be added if full texts are obtained.
- Discussion D2, proxy bias (1): wu2024pervasive.
- Discussion D3, LD mismatch: buliksullivan2015ld (already counted).
- Discussion D4, DLB (2): mckeith2017diagnosis, watkins2026understanding.
Candidates outside the budget unless a slot frees: gibson2017assessing (superseded inputs; rg already covered by monereosanchez2021genetic), chen2026genetic (weak venue and MR practice), scheltens2021alzheimer (review), anon2020global, anon2022global, sankhe2026neuropsychiatric, fresnais2026anxiety, berrios2026genetic, lutz2026cellular (agents recommended DROP).

Rule: if the total exceeds 40, second and third sources for the same claim are removed first; mandatory methods sources are never removed.

### E. Saving options (assessed 2026-11-20; decision at the end of Faz 5)
Expected new needs in Faz 5: up to 2 (source for the "opposing local signals" premise; source for 17q21.31 long-range LD if the locus is reference-sensitive).

1. One comprehensive prevalence source for all six values — **not feasible**.
   - GBD sources in the pool (anon2020global, anon2022estimation) report point prevalence of all-cause dementia or "Alzheimer's disease and other dementias" combined, have no DLB-specific value, no separate PTSD cause and no insomnia; they fail D3 criterion (i) (prevalence definition must match the GWAS case definition, lifetime for the psychiatric traits).
   - Already achieved: MDD, SCZ and DLB use the assumption stated in their own GWAS paper (adams2025trans, trubetskoy2022mapping, chia2021genome), at no extra reference cost.
   - Remaining prevalence-only references: koenen2017posttraumatic (PTSD), niu2017prevalence (AD, NEEDS_PDF), ohayon2002epidemiology (insomnia, NEEDS_PDF, only if watanabe2022genome states no assumption of its own).
   - Checked and not usable: nievergelt2024genome uses "15% population and sample prevalence" only to transform PRS R² to the liability scale; inconsistent with lifetime PTSD prevalence and with D3; not adopted. bellenguez2022new, kurki2023finngen, livingston2020dementia and anon2022estimation give no AD-specific population prevalence.
   - **Saving: up to 1** (ohayon2002epidemiology not needed if the Watanabe full text states an insomnia prevalence assumption).
2. Several papers for one software package — **already single for TwoSampleMR/MR-Base** (hemani2018mr only; hemani2017orienting is the Steiger method, a separate method). Other method pairs reviewed:
   - buliksullivan2015ld and buliksullivan2015atlas: different methods (h² and intercept vs cross-trait rg); liability h² and intercepts are reported and the intercepts feed the LAVA overlap matrix. Keep both.
   - grotzinger2019genomic: the software actually run (GenomicSEM `ldsc()`). Keep.
   - burgess2016bias vs mounier2023bias: both support the claim that participant overlap biases MR. **Saving: 1** (drop burgess2016bias) if the published MRlap paper (NEEDS_PDF) states this bias with its own evidence; otherwise keep.
   - Lower-priority options (investigator's call): skrivankova2021strengthening2 (STROBE-MR reporting guideline; not required by the journal; checklist can still be supplied without citation) −1; kunkle2019genetic (cited only to state its exclusion) −1, at the cost of naming the excluded dataset without a reference.
3. Net: guaranteed savings 0; likely savings 1–2 (Ohayon, Burgess); optional 1–2 (STROBE-MR, Kunkle). This covers the 2 expected Faz 5 additions without removing an Introduction or Discussion source.
4. **Decisions (investigator, 2026-11-20):**
   - ohayon2002epidemiology: DROP only if the Watanabe 2022 full text states its own insomnia prevalence assumption, evidenced by a verbatim quote in its reading note; otherwise KEEP.
   - burgess2016bias: DROP only if the published MRlap paper (mounier2023bias) itself states that sample overlap biases MR, evidenced by a verbatim quote in its reading note; otherwise KEEP.
   - skrivankova2021strengthening2 (STROBE-MR): KEEP (checklist supplied as a supplementary file; a reporting standard is not invoked without its reference).
   - kunkle2019genetic: KEEP (named in Methods with the reason for exclusion; every named dataset is cited).
   - If the limit is still exceeded at the end of Faz 5, second sources for the same claim are removed.


## Approved Methods wording (investigator, 2026-11-20)
- Palindromic variants: "Palindromic (A/T or C/G) variants with a minor allele frequency above 0.42 were removed; in MR, harmonisation with TwoSampleMR (action 2) inferred the strand of the remaining palindromic variants from effect-allele frequencies and excluded those with frequencies between 0.42 and 0.58. Because the insomnia summary statistics report no effect-allele frequency, all palindromic variants were removed from the insomnia data before every analysis, and MR analyses including insomnia were harmonised with action 3." (deviations C2)
- Strand check: "Palindromic variants with allele frequencies on the opposite side of 0.5 from the reference panel (possible strand mismatch; ≤0.2% of palindromic variants per file) were excluded from the 1000 Genomes LAVA analysis, and all loci reported as significant in the main analysis were re-estimated after their exclusion." (deviations C3)
- LAVA reproducibility (investigator, 2026-11-21; deviations C4): "LAVA estimates bivariate P values and confidence intervals by Monte Carlo simulation (10⁴ draws, increased adaptively to 10⁵ and 10⁶ draws for P < 10⁻⁴ and P < 10⁻⁶); each locus–pair was analysed with a fixed random seed derived from a single base seed ({{res:lava_seed_check.summary.seed_base}}), so that all estimates are reproducible." Seed rule and LAVA version from `lava_seed_check.summary.*`.
- Strand check, Supplementary line (approved 2026-11-21): "Strand-ambiguous SNP exclusion left the SNP set unchanged at all 84 significant locus–pairs; the single borderline change in significance (locus 848, MDD × SCZ) reflected p-value variation at the FDR threshold." Numbers from `lava_strand_check.summary.*`; replaced by the seeded values after the Gate 3 re-run if they change.

## Reference panel sensitivity (investigator decision, 2026-11-21; deviations C4: presentation of a sensitivity result, plan unchanged)
- The 1000 Genomes LAVA results are not presented as findings, and they are not hidden.
- Supplementary, under the heading "Reference panel sensitivity analysis": full 1000 Genomes LAVA results (`results/tables/lava_bivar_g1000.csv`, `lava_univ_g1000.csv`), the list of locus–pairs significant at FDR 5% with that reference, the two-reference comparison of the nominal primary loci including 17q21.31 (`lava_reference_check.*`), and a small table titled "Systematic difference between the two reference panels" with only the relative column: per trait, the 1000 Genomes / UK Biobank ratio of summed local h² over loci analysed with both references (`results/tables/supp_lava_reference_panel_ratio.csv`; `lava_reference_diagnostic.<trait>.ratio_g1000_to_ukb_common`, range `lava_reference_diagnostic.supplementary.range`). Absolute sum/LDSC columns are not shown (investigator decision 2026-11-21); one-sentence note: "Summed local heritabilities are not comparable with genome-wide LDSC estimates because loci with negative variance estimates are dropped." The full diagnostic (`lava_reference_diagnostic.csv`) stays an internal file.
- Results, one sentence: local genetic correlation results were sensitive to the reference panel; the main analysis (UK Biobank reference, pre-registered) gave no dementia × psychiatric locus–pair significant at FDR 5%.
- Results, 1000 Genomes passage (investigator decision 2026-11-21 evening; seeded values): must contain four elements —
  (a) why UK Biobank was pre-specified as the primary reference: the analysis plan (§0.3 item 5) gives "the LAVA authors' recommendation that the 1000 Genomes panel can inflate type I error and bias local heritability". Source (2026-11-21): the official LAVA documentation, werme2025lava c1–c3 ("We **strongly** recommend that users switch to using the UK Biobank reference instead of 1,000 Genomes for any analysis of European ancestry data"; "possible inflation of type 1 error rates and bias in the local heritability estimates due to its small sample size"). werme2022integrated (bioRxiv text) has no such statement (it used 1000 Genomes itself). Wording: "pre-specified in the registered plan, following the LAVA developers' recommendation to use the UK Biobank reference for European-ancestry data because of possible type I error inflation and local heritability bias with the smaller 1000 Genomes panel [werme2025lava]". It is the developers' recommendation, not an established finding: its evidence is a non-peer-reviewed preprint (preprints.org 202507.0966) with a published reply preprint; the Discussion may say the 1000 Genomes pattern "is consistent with the developers' concern" but must not state inflation as fact.
  (b) 1000 Genomes gives systematically higher summed local h² over common loci (`lava_reference_diagnostic.supplementary.range`, Supplementary ratio table).
  (c) the 1000 Genomes results are a sensitivity analysis, not findings.
  (d) `{{res:lava_g1000_fdr_pairs.summary.n_fdr_pairs_g1000}}` primary pairs at FDR 5% with 1000 Genomes; of these, `n_tested_ukb` were testable and `n_nominal_ukb` nominal with UK Biobank (locus 2128, AD × SCZ); the other `n_not_tested_ukb` were not testable with UK Biobank because a trait did not pass the univariate filter. Loci 2206 and 2207 (17q21.31) are nominal with UK Biobank and same-sign with 1000 Genomes but are not among the 1000 Genomes FDR pairs (1000 Genomes FDR 0.06–0.17; `lava_reference_check.*`). The investigator's draft assumed all three were among the 20 — corrected from the data, to be confirmed by the investigator.
- Supplementary table: `results/tables/supp_lava_g1000_fdr_pairs.csv` (each of the 20 pairs: 1000 Genomes and UK Biobank rho (95% CI) and P, UK Biobank status, univariate P of both traits with UK Biobank).
- The 19 → 20 change between unseeded and seeded 1000 Genomes runs goes only in deviations C5 ("1000G result unstable for pairs near the threshold"), not in the text.
- Discussion: the pre-registered choice of the UK Biobank reference (pre-registration; larger panel) and the systematic difference between the two reference panels (with 1000 Genomes, more univariate passes and higher summed local h² over common loci for every trait; written as a difference, not as "inflation", unless the Faz 5 source supports the causal reading). Faz 5: a peer-reviewed source that a small or mismatched LD reference inflates summary-statistic methods (e.g. LD mismatch in fine-mapping or local genetic correlation). Without a source only the observation and the diagnostic table are written, with no causal explanation.
- Positioning note: Kumar 2026 used a 1000 Genomes reference at an uncorrected threshold (see the prior-study note below); compare only descriptively, with the reference-panel sensitivity stated.

- Coloc: one sentence in Methods ("Colocalisation was planned for locus–pairs significant at FDR 5% in the main LAVA analysis") and one in Results stating that no dementia × psychiatric locus–pair met this condition, so colocalisation was not performed (`{{res:coloc.summary.status}}`).

## Null results: power context (investigator instruction, 2026-11-20)
- Main message direction: no reliable evidence of genetic overlap between AD and the psychiatric traits at genome-wide or local level; every null is reported with its power context.
- **Updated main message (investigator, 2026-11-21 evening):** no robust genetic overlap with AD; for DLB, two borderline genome-wide correlations, with MDD and PTSD (FDR-corrected P 0.049 each), resting on a low-power DLB heritability (Z 1.5). The Discussion is written to this message.
- LDSC: 95% CI bounds per primary pair (`power_ldsc.*`), e.g. "genetic correlations larger than X could be excluded".
- LAVA: per primary pair, loci analysed, testable (both traits pass the univariate filter), nominal P < 0.05 and expected (`power_lava_ukb.*`). DLB pairs: few testable loci → "few loci were testable", not "no local overlap".
- MR: minimum detectable OR per direction (`mr.*.min_detectable_or`, plan §4.10).
- Strand check (secondary family, descriptive pairs): one-line Supplementary summary — number of pairs whose sign or significance changed (`lava_strand_check.summary.n_changed`).

## Approved Results wording for null findings (investigator, 2026-11-20)
- LDSC, AD: "Positive genetic correlations with AD larger than approximately 0.06–0.12, depending on the trait, could be excluded (upper 95% confidence limits)." Values from `power_ldsc.ad.*.ci_upper`.
- LDSC, DLB: superseded 2026-11-21. DLB × MDD and DLB × PTSD passed FDR (0.049) and are reported as borderline correlations on a low-power heritability; only DLB × insomnia and DLB × SCZ are nulls with wide intervals (`power_ldsc.dlb.*`).
- LAVA, exploratory and descriptive only: "X of Y testable loci showed nominal local correlation (expected Z), none surviving FDR correction" (`lava_exploratory.<dem>.<psy>.*`). No test of excess (binomial or other) is added. Nominal loci are listed with position, rho (95% CI), P, protein-coding genes (GENCODE v19) and APOE-region flag in a Supplementary table (`results/tables/lava_nominal_primary_ukb.csv`); counts excluding the APOE region are reported alongside.
- If the signs of nominal local correlations are mixed, the Discussion links this cautiously, with a source, to the Introduction premise that genome-wide correlations can mask opposing local signals. Caution required: the chr17q21.31 locus (MAPT/KANSL1 H1/H2 inversion) has long-range LD, so reference-panel sensitivity (UK Biobank vs 1000 Genomes LAVA) is reported before any interpretation.
- MR power: both minimum detectable ORs with units (plan §4.10 per SD; SE-based per unit log odds, deviations D4) in the MR table (main Table 2 in the figure plan, which replaced the draft "Table 3").

- Exploratory LAVA loci, wording rules (investigator, 2026-11-20): gene names identify the locus only ("a locus containing MAPT"); no mechanism-implying wording ("MAPT-mediated" etc.). 17q21.31 (MAPT/KANSL1/CRHR1): UK Biobank and 1000 Genomes rho, CI and P side by side (`lava_reference_check.*`); if the sign changes or the 1000 Genomes estimate lies outside the UK Biobank CI, the locus is described only as "reference-sensitive due to long-range LD at the 17q21.31 inversion", with a source, and not interpreted biologically; if consistent, it may be interpreted within the exploratory frame with peer-reviewed sources. CELF1/SPI1 region (locus 1658): identified as a known AD locus from Bellenguez 2022 Table 1 (note bellenguez2022new c9–c10).
- Faz 5 task: a peer-reviewed source for the premise that genome-wide genetic correlation can mask opposing local signals (local genetic correlation methods literature, e.g. the LAVA paper or comparable methods). If none is found, the premise is removed from the Introduction.

## Figure plan (STRICT_RULES §1.6; investigator draft 2026-11-20, changes justified below)
Common design: grayscale, shape/line-type contrasts, Times New Roman, 16 cm print width; trait order and names identical in every figure — psychiatric: MDD, PTSD, Insomnia, SCZ; dementia: AD (Bellenguez), AD (FinnGen), DLB; zero/reference line always drawn; 95% CI always shown; null results shown. Script: `analysis/R/07_figures.R` (each figure built only from `results/results.json` / `results/tables/*.csv`); previews in `build/figures_preview/`.

Main text (4 figures + 2 tables):
- Figure 1 — Study design (schematic): data sources (cases/controls, ancestry, UK Biobank/FinnGen overlap), analysis layers LDSC → LAVA → (coloc, conditional) → MR → FinnGen sensitivity; primary (solid) vs sensitivity (dashed).
- Figure 2 — Genome-wide rg: 4 psychiatric traits × {AD (Bellenguez), AD (FinnGen), DLB}; rg with 95% CI; APOE-excluded estimates as a second marker; DLB panel labelled "low power, exploratory" (h² Z < 4). The CI bounds carry the "largest rg that can be excluded" information.
- Figure 3 — Local rg: per primary pair, the number of testable loci (denominator) and local rho ± 95% CI by chromosomal position, with nominal and FDR thresholds marked; pairs with 0 testable loci shown as empty panels with "0 testable loci". Caption (seeded run, investigator 2026-11-21): first sentence is the finding; must state "23 testable loci; 8 nominal; no pair reached FDR < 0.05" (values from `power_lava_ukb.*` / `lava_ukb.summary.*` at writing).
- Figure 4 — MR: 16 primary directions, IVW OR (95% CI) with MR-Egger, weighted median and weighted mode as distinct markers; §8 interpretation class labelled; number of instruments and minimum detectable OR printed per row; FinnGen directions (independent AD sample) in a side panel.

Changes from the draft, with reasons:
1. Figure 5 (power) is dropped: the LDSC exclusion bound is the CI shown in Figure 2 and the minimum detectable OR is printed per row in Figure 4 (§1.6-1: no redundant figure).
2. Draft Table 2 (LDSC rg, main + sensitivity) would duplicate Figure 2 (§1.6-1: a finding appears in a figure or a table, not both). Exact rg values for all runs (main, MDD with UKB, PTSD case/control, APOE-excluded, FinnGen) go to Supplementary Table S-LDSC.
3. Draft Table 3 (MR summary) is kept as main Table 2 but without the IVW OR, which Figure 4 shows: it carries the diagnostics needed as exact values — instruments, mean F, I²GX, Cochran Q (P), Egger intercept (P), MR-PRESSO global P, MRlap-corrected estimate, Steiger removals, §8 class.
4. Table 1 — data sources (unchanged).

Supplementary figures (same rules; cited in order): per MR direction scatter, funnel and leave-one-out (directions with ≥ 5 instruments); Steiger prevalence sensitivity (0.5×/2×); sample-overlap matrix (LDSC cross-trait intercepts); harmonisation flow (`munge_counts.csv`); LAVA UK Biobank vs 1000 Genomes comparison; strand-check summary (one line or a small panel).

Status: see `build/PROGRESS.md` (figure list).

## Binding notes for the Discussion

### N1. FinnGen AD × PTSD versus Bellenguez AD × PTSD (genome-wide rg)
- Results: `{{res:sensitivity_finngen.ldsc.finngen.ptsd.rg}}` (FinnGen, clinically diagnosed AD) versus `{{res:ldsc_rg.main.ad.ptsd.rg}}` (Bellenguez, clinical + proxy AD). Report the uncorrected P and the BH and Bonferroni values corrected over the four FinnGen tests (`p_bh_within4`, `p_bonferroni_within4`).
- Framing: **an inconsistency between the two AD GWAS, nothing more.** It is not evidence for or against any hypothesis, and it must not be described as "consistent with" the proxy-phenotype argument.
- Direction check (why it does not support the proxy argument): the proxy argument holds that proxy-based AD may inflate genetic correlations with psychiatric traits; that predicts a higher correlation in the proxy-containing GWAS (Bellenguez) and a lower one in the clinical GWAS (FinnGen). The observed pattern is the reverse. The proxy-phenotype literature may be cited separately, with its correct direction, and the observed result stated as not supporting it.
- Required wording for the result: "nominally associated (uncorrected p = 0.014) but not after correction for four tests (BH-adjusted p = 0.055)", with the numbers taken from `{{res:sensitivity_finngen.ldsc.finngen.ptsd.p_uncorrected}}` and `{{res:sensitivity_finngen.ldsc.finngen.ptsd.p_bh_within4}}`.
- Candidate explanations (a)–(d) have **equal status**. None is presented as the explanation or as established, and each is written with its own peer-reviewed source (Faz 4):
  - (a) Chance cannot be excluded: one of four FinnGen consistency tests; the association is nominal and does not survive correction for four tests (BH and Bonferroni p = 0.055). A corrected p above 0.05 shows only that chance cannot be excluded; it does not show that the result is due to chance.
  - (b) LD mismatch: Finnish founder population versus 1000 Genomes EUR LD scores; effect-allele-frequency correlation with the reference 0.962 for FinnGen versus ≥ 0.993 for the other files that report an effect-allele frequency (insomnia reports MAF only; `analysis/logs/munge_qc.csv`, column `af_check`). Source needed on LDSC sensitivity to LD-reference mismatch.
  - (c) Phenotype definition: register-based diagnosis, possible mixed dementia and misclassification in G6_ALZHEIMER.
  - (d) Sample overlap with the Finnish PTSD cohort (`fing`): affects the LDSC cross-trait intercept rather than rg, but is stated.
  - (e) Documented proxy and survival biases (Wu 2024); these may affect both AD GWAS, through different mechanisms. Wu 2024 (published version) reports that the non-AD component of proxy (parental-history) AD GWAS correlates negatively with MDD and schizophrenia and that combined case-control/proxy meta-analyses such as Bellenguez 2022 fall in between, which would pull psychiatric rg downward in Bellenguez; it also notes that FinnGen ascertains AD from ICD codes with controls not age-matched, which may exacerbate survival bias. Possible explanation only; it accounts for the direction of the difference without establishing it.
- (a)–(e) are written with equal status, each as "possible", none as the explanation (investigator decision, 2026-11-20). The earlier sentence stating that the result does not support the proxy argument is withdrawn: it rested on an assumed direction (inflation) that Wu 2024 does not report.

### N2. Limitations (FinnGen)
- Finnish founder population LD structure versus the 1000 Genomes EUR reference used for LDSC and for MR clumping; applies to all FinnGen LDSC and MR results.
- FinnGen overlaps with the MDD (R5) and PTSD (`fing`) GWAS; MRlap applied (plan §4b.3).
- FinnGen results are consistency checks only (plan §4b.5).

### N4. Positioning against prior SCZ × AD studies (investigator decision, 2026-11-20)
- Not to be called a "replication": replication requires independent data.
- Datasets used by the prior studies:
  - kumar2026genetic (full text read): AD = Bellenguez 2022 (85,934 cases / 401,577 controls) and SCZ = PGC3 Trubetskoy 2022 (53,386 / 77,258), i.e. the same summary statistics as this study; depression from Levey 2021 (different from ours). Methods: MiXeR genome-wide rg and LAVA with a 1000 Genomes reference at an uncorrected threshold; no MR.
  - chen2026shared (abstract only; full text not accessible, NEEDS_PDF): SCZ 53,386 / 77,258 (PGC3 EUR effective counts) and ADRD 111,326 / 677,663 (Bellenguez stage I + II totals); local rg, conjFDR, coloc, bidirectional MR. To be confirmed from the full text.
- Required wording: "concordant (or discordant) with previous genetic correlation and MR studies that used overlapping summary statistics (Chen 2026; Kumar 2026)", with effect sizes side by side. Kumar 2026 has no MR, so "MR" applies to Chen 2026 only.
- Independent evidence: only the FinnGen analysis (independent AD sample), and only if the result is consistent, described as "an independent sample".
- Current results to position: LAVA (UK Biobank reference, FDR 5%) found no significant AD × SCZ or AD × MDD local rg among 9 and 8 tested loci, whereas Kumar 2026 reported 23 and 17 loci at an uncorrected threshold with a 1000 Genomes reference; the 1000 Genomes LAVA sensitivity analysis bears on this.

### N5. PTSD → AD MR (investigator decision, 2026-11-21)
- Main MR message: "no robust evidence of a causal effect of the psychiatric traits on dementia".
- Results (approved wording, investigator 2026-11-21 evening): "The only primary direction below FDR 0.05 (PTSD → AD, OR {{res:mr.ptsd__ad.or_ivw}}; FDR {{res:mr.ptsd__ad.p_ivw_fdr}}) was classified as sensitive to pleiotropy, and the overlap-corrected (MRlap) estimate was not nominally significant ({{res:mr.ptsd__ad.beta_std_mrlap_corrected}}, P {{res:mr.ptsd__ad.p_mrlap_corrected}}). With FinnGen as the outcome source, the IVW estimate was not nominally significant (OR {{res:mr_ptsd_ad_finngen.ptsd__ad_finngen.ivw_or_ci}}; P {{res:mr_ptsd_ad_finngen.ptsd__ad_finngen.ivw_p}})." The "lost significance after correction" wording is withdrawn (MRlap's own uncorrected estimate was already non-significant). MRlap estimates are standardised betas (`beta_std_mrlap_*`), never written as OR. Minimum detectable ORs (1.25 / 1.62) are not in this Results sentence; they go to the Discussion power-limitation sentence (`mr_ptsd_ad_finngen.*.min_detectable_or_plan`).
- FinnGen next to Bellenguez: `results/tables/mr_ptsd_ad_bellenguez_vs_finngen.csv`, `mr_ptsd_ad_finngen.*` (IVW, Egger, WM, WMode, Egger/SIMEX intercept, Q, MR-PRESSO, MRlap, class, minimum detectable OR). FinnGen remains descriptive (plan §4b.5).
- Discussion: the inverse estimate is discussed cautiously together with (i) the direction of the proxy/survival bias documented by Wu 2024 (non-AD component negatively correlated with MDD −0.11 and schizophrenia −0.13; note wu2024pervasive c4; spurious negative correlations with other health outcomes, c5) and (ii) the FinnGen result. Wu 2024 reports no value for PTSD (full text checked 2026-11-21; the 50-trait list is in its unavailable Supplementary Tables): the bias may be extended to PTSD only as an inference, explicitly labelled as such. Wu 2024 also notes FinnGen ICD-based AD with non-age-matched controls may exacerbate survival bias (c8), so FinnGen is not bias-free either.
- Discussion PTSD → AD paragraph, structure (investigator 2026-11-21 evening), in this order:
  1. The inverse Bellenguez estimate is sensitive to pleiotropy (SIMEX Egger intercept `mr.ptsd__ad.simex_intercept_p`) and the overlap-corrected estimate is not significant.
  2. With FinnGen the estimate is not significant, the CI is wide and power is lower (minimum detectable OR `mr_ptsd_ad_finngen.ptsd__ad_finngen.min_detectable_or_plan` vs `mr_ptsd_ad_finngen.ptsd__ad.min_detectable_or_plan`, per SD, plan §4.10).
  3. Wu 2024, verbatim (note wu2024pervasive c4): "We also observed negative genetic correlations with health outcomes including major depressive disorder (cor. = −0.11, P = 0.012), schizophrenia …"; and c5: "Without adjusting for survival bias, we expect to see spurious negative genetic correlations between AD GWAX and other health outcomes." Wu 2024 gives no PTSD value, so the application to PTSD is written explicitly as inference ("may", "would be consistent with").
  4. Same paragraph: Wu 2024's caution on FinnGen (c8): "the AD status in FinnGen was derived from the International Classification of Diseases codes and thus may not be accurate. …"
  5. Closing sentence: these data provide no robust causal evidence for PTSD → AD.
- Forbidden: "protective", "reduces risk", or any causal implication for the PTSD → AD estimate.

### N3. Other binding points recorded so far
- DLB SNP heritability Z = 1.5 (< 4): DLB genetic correlations are flagged as low-power (plan §2.5).
- Kunkle 2019 excluded (IGAP condition); consequence stated in Methods and Limitations (plan §0.1.2).
- SCZ effective N correction (deviations C1) and LAVA binary-trait input (D1) described in Methods.

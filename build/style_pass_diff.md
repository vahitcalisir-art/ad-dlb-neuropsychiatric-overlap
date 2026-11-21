# Style pass: old and new sentences

Old = git tag pre-style-pass; new = working tree. Pairs are matched within paragraphs; merged sentences are grouped.

## 01_abstract.md

- ¶2
  - OLD: Neuropsychiatric symptoms are common in Alzheimer's disease (AD) and dementia with Lewy bodies (DLB), and psychiatric disorders earlier in life are associated with later dementia, but reverse causation limits what observational studies can show <!--from:intro_nps--> <!--from:intro_psych--> <!--from:intro_revcaus-->.
  - NEW: Neuropsychiatric symptoms are common in Alzheimer's disease (AD) and dementia with Lewy bodies (DLB), and psychiatric disorders earlier in life are associated with later dementia, although observational data cannot rule out reverse causation <!--from:intro_nps--> <!--from:intro_psych--> <!--from:intro_revcaus-->.

- ¶2
  - OLD: Genome-wide genetic correlations between AD and psychiatric traits have been close to zero, opposing local signals can cancel in such estimates, and genetic data on DLB are limited <!--from:intro_null--> <!--from:intro_local--> <!--from:intro_dlb-->.
  - NEW: Genome-wide genetic correlations of AD with psychiatric traits have been close to zero, yet local signals of opposite sign can cancel in such estimates <!--from:intro_null--> <!--from:intro_local-->.

- ¶2
  - OLD: (none: new sentence)
  - NEW: Genetic data on DLB remain limited <!--from:intro_dlb-->.

- ¶2
  - OLD: Genome-wide association study (GWAS) summary statistics for major depressive disorder (MDD), post-traumatic stress disorder (PTSD), insomnia and schizophrenia (SCZ) were analyzed against AD and DLB with LD score regression, local genetic correlation and bidirectional two-sample Mendelian randomization (MR) <!--from:intro_aim-->.
  - NEW: Summary statistics from genome-wide association studies (GWAS) of major depressive disorder (MDD), post-traumatic stress disorder (PTSD), insomnia and schizophrenia (SCZ) were analyzed against AD and DLB with LD score regression, local genetic correlation and bidirectional two-sample Mendelian randomization (MR) <!--from:intro_aim-->.

- ¶2
  - OLD: There was no evidence of genome-wide genetic correlation between the psychiatric traits and AD, and the upper confidence limits excluded correlations above {{res:power_ldsc.ad.ptsd.excluded_above}} to {{res:power_ldsc.ad.scz.excluded_above}}.
  - NEW: No psychiatric trait showed evidence of genome-wide genetic correlation with AD, and the upper confidence limits excluded correlations above {{res:power_ldsc.ad.ptsd.excluded_above}} to {{res:power_ldsc.ad.scz.excluded_above}}.

- ¶2
  - OLD: None of the {{res:lava_ukb.summary.bivar_tests_primary}} testable local correlations passed false discovery rate (FDR) correction.
  - NEW: Of the {{res:lava_ukb.summary.bivar_tests_primary}} testable local correlations, none passed false discovery rate (FDR) correction.

- ¶2
  - OLD: Of the sixteen MR directions, only PTSD → AD passed FDR correction (odds ratio {{res:mr.ptsd__ad.or_ivw}}; FDR-corrected P {{res:mr.ptsd__ad.p_ivw_fdr}}).
  - NEW: Among the sixteen MR directions, PTSD → AD alone passed FDR correction (odds ratio {{res:mr.ptsd__ad.or_ivw}}; FDR-corrected P {{res:mr.ptsd__ad.p_ivw_fdr}}), but it was classified as sensitive to pleiotropy and lost nominal significance after correction for sample overlap (P {{res:mr.ptsd__ad.p_mrlap_corrected}}).

- ¶2
  - OLD: That estimate was sensitive to pleiotropy, its overlap-corrected version was not nominally significant (P {{res:mr.ptsd__ad.p_mrlap_corrected}}), and it was not significant with FinnGen AD as outcome (odds ratio {{res:sensitivity_finngen.mr.ptsd__ad_finngen.or_ivw}}).
  - NEW: With FinnGen AD as the outcome, the same direction was not significant (odds ratio {{res:sensitivity_finngen.mr.ptsd__ad_finngen.or_ivw}}).

- ¶2
  - OLD: DLB was genetically correlated with MDD ({{res:ldsc_rg.main.dlb.mdd.rg}}) and PTSD ({{res:ldsc_rg.main.dlb.ptsd.rg}}) at an FDR-corrected P of {{res:ldsc_rg.main.dlb.mdd.p_fdr}}, but the DLB heritability estimate had low power (Z {{res:ldsc_h2.main.dlb.h2_z}}).
  - NEW: For DLB, the genome-wide correlations with MDD ({{res:ldsc_rg.main.dlb.mdd.rg}}) and PTSD ({{res:ldsc_rg.main.dlb.ptsd.rg}}) passed FDR correction (FDR-corrected P {{res:ldsc_rg.main.dlb.mdd.p_fdr}}), but they rest on a DLB heritability estimate with low power (Z {{res:ldsc_h2.main.dlb.h2_z}}).

- ¶2
  - OLD: With a 1000 Genomes LD reference, {{res:lava_g1000_fdr_pairs.summary.n_fdr_pairs_g1000}} local locus–pairs passed FDR correction, of which {{res:lava_g1000_fdr_pairs.summary.n_not_tested_ukb}} were not testable with the UK Biobank reference used in the main analysis.
  - NEW: With a 1000 Genomes LD reference, {{res:lava_g1000_fdr_pairs.summary.n_fdr_pairs_g1000}} local locus–pairs passed FDR correction, and {{res:lava_g1000_fdr_pairs.summary.n_not_tested_ukb}} of them could not be tested with the UK Biobank reference of the main analysis.

- ¶2
  - OLD: These data give no robust evidence of genetic overlap or causal effects between the four psychiatric traits and AD, and the borderline DLB correlations need confirmation in a larger DLB GWAS <!--from:disc_dlb_confirm-->.
  - NEW: The results provide no robust evidence of genetic overlap or causal effects between these psychiatric traits and AD, and the borderline DLB correlations require confirmation in a larger DLB GWAS <!--from:disc_dlb_confirm-->.

## 02_introduction.md

- ¶2
  - OLD: Most patients with dementia develop at least some neuropsychiatric symptoms during the disease, although the prevalence and persistence of individual symptoms vary widely [@zhu2026neuropsychiatric#c1] <!--id:intro_nps-->.
  - NEW: Most people with dementia develop neuropsychiatric symptoms at some stage, although individual symptoms differ widely in prevalence and persistence [@zhu2026neuropsychiatric#c1] <!--id:intro_nps-->.

- ¶2
  - OLD: About 85% of patients with Alzheimer's disease (AD) will develop a neuropsychiatric symptom at some point in the illness [@kumar2026genetic#c7].
  - NEW: In Alzheimer's disease (AD), about 85% of patients develop such a symptom during the illness [@kumar2026genetic#c7].

- ¶2
  - OLD: In a longitudinal clinical cohort, depressed mood was reported by 51% of participants with AD and by 65.2% of those with clinically diagnosed dementia with Lewy bodies (DLB), in whom psychosis was also frequent [@zhu2026neuropsychiatric#c2; @zhu2026neuropsychiatric#c3; @zhu2026neuropsychiatric#c7].
  - NEW: A longitudinal clinical cohort recorded depressed mood in 51% of participants with AD and in 65.2% of those with clinically diagnosed dementia with Lewy bodies (DLB), in whom psychosis was also frequent [@zhu2026neuropsychiatric#c2; @zhu2026neuropsychiatric#c3; @zhu2026neuropsychiatric#c7].

- ¶2
  - OLD: Psychosis in DLB was associated with faster functional decline [@zhu2026neuropsychiatric#c6].
  - OLD: Depressive symptoms are common in DLB, yet trial data on their treatment are scant [@mckeith2017diagnosis#c2].
  - NEW: Psychosis in DLB was associated with faster functional decline in that cohort [@zhu2026neuropsychiatric#c6], and depressive symptoms in DLB are common although trial data on their treatment are scant [@mckeith2017diagnosis#c2].

- ¶2
  - OLD: Symptoms can also precede the diagnosis: mild behavioral impairment, defined by later-life onset and persistence for at least six months, carried a pooled hazard ratio of 2.70 for incident dementia [@sassi2026mild#c4; @sassi2026mild#c1].
  - NEW: Mild behavioral impairment, defined by later-life onset and at least six months of persistence, carried a pooled hazard ratio of 2.70 for incident dementia [@sassi2026mild#c4; @sassi2026mild#c1].

- ¶2
  - OLD: Heterogeneity across studies was substantial, and the association was not specific to AD [@sassi2026mild#c2; @sassi2026mild#c6].
  - NEW: The pooled studies were highly heterogeneous, and the authors suggested that mild behavioral impairment may mark several dementia subtypes besides AD [@sassi2026mild#c2; @sassi2026mild#c6].

- ¶3
  - OLD: Psychiatric disorders that begin earlier in life are also associated with later dementia [@livingston2024dementia#c1; @livingston2024dementia#c8] <!--id:intro_psych-->.
  - NEW: Psychiatric disorders that begin earlier in life are also associated with later dementia, and the 2024 Lancet Commission found a higher risk of dementia 10 to 14 years after a diagnosis of depression [@livingston2024dementia#c8; @livingston2024dementia#c4] <!--id:intro_psych-->.

- ¶3
  - OLD: The 2024 Lancet Commission found a higher risk of dementia 10 to 14 years after a diagnosis of depression and concluded that depression increases risk at all adult ages, although part of the late-life association reflects preclinical dementia [@livingston2024dementia#c4; @livingston2024dementia#c1].
  - NEW: The Commission concluded that depression increases risk at all adult ages, although part of the late-life association reflects preclinical dementia [@livingston2024dementia#c1].

- ¶3
  - OLD: A meta-analysis suggested that post-traumatic stress disorder (PTSD) is a risk factor for dementia, but with considerable heterogeneity between studies [@livingston2024dementia#c6].
  - OLD: The Commission therefore judged the evidence too heterogeneous to classify PTSD as a modifiable risk factor [@livingston2024dementia#c5].
  - NEW: For post-traumatic stress disorder (PTSD), a meta-analysis suggested a higher risk with considerable heterogeneity between studies [@livingston2024dementia#c6], which led the Commission to judge the evidence too heterogeneous to classify PTSD as a modifiable risk factor [@livingston2024dementia#c5].

- ¶3
  - OLD: People with schizophrenia (SCZ) develop more and earlier dementia than others, but it is unclear whether SCZ predisposes to dementia independently of the other risk factors that accompany it [@livingston2024dementia#c8; @livingston2024dementia#c9].
  - NEW: People with schizophrenia (SCZ) develop dementia more often and earlier than others, yet it is unclear whether SCZ predisposes to dementia independently of the risk factors that accompany it [@livingston2024dementia#c8; @livingston2024dementia#c9].

- ¶3
  - OLD: For insomnia, a meta-analysis reported higher risks of all-cause dementia and AD [@meng2025insomnia#c1], whereas a Norwegian cohort found no association with either [@livingston2024dementia#c7].
  - NEW: A meta-analysis reported higher risks of all-cause dementia and AD with insomnia [@meng2025insomnia#c1], whereas a Norwegian cohort found no association with either [@livingston2024dementia#c7].

- ¶3
  - OLD: In that meta-analysis the association was stronger with less than five years of follow-up than with longer follow-up [@meng2025insomnia#c2].
  - OLD: Such a pattern is expected when risks identified in the few years before dementia reflect reverse causation as well as, or instead of, a causal effect [@livingston2024dementia#c2] <!--id:intro_revcaus-->.
  - NEW: The meta-analytic association was stronger when follow-up lasted less than five years [@meng2025insomnia#c2], a pattern expected if risks identified in the few years before dementia reflect reverse causation as well as, or instead of, a causal effect [@livingston2024dementia#c2] <!--id:intro_revcaus-->.

- ¶3
  - OLD: Neuropsychiatric symptoms frequently emerge years before measurable cognitive impairment [@sassi2026mild#c3], and the relationship between insomnia and dementia is considered bidirectional [@meng2025insomnia#c4].
  - NEW: Neuropsychiatric symptoms often appear years before measurable cognitive impairment [@sassi2026mild#c3], and insomnia and dementia are thought to influence each other in both directions [@meng2025insomnia#c4].

- ¶4
  - OLD: Genetic data offer two partly independent approaches: genome-wide genetic correlation (rg) can be estimated by linkage disequilibrium (LD) score regression (LDSC) from genome-wide association study (GWAS) summary statistics alone, and it is not biased by sample overlap [@buliksullivan2015atlas#c1].
  - NEW: Genome-wide genetic correlation (rg), estimated by linkage disequilibrium (LD) score regression (LDSC), requires only genome-wide association study (GWAS) summary statistics and is not biased by sample overlap [@buliksullivan2015atlas#c1].

- ¶4
  - OLD: Mendelian randomization (MR) uses genetic variants as instruments, and its estimates reflect the lifetime effect of genetic liability to the exposure [@skrivankova2021strengthening2#c7; @skrivankova2021strengthening2#c8].
  - OLD: Bidirectional MR additionally assesses the direction of a causal association [@skrivankova2021strengthening2#c4].
  - NEW: Mendelian randomization (MR) uses genetic variants as instruments, so its estimates reflect the lifetime effect of genetic liability to the exposure [@skrivankova2021strengthening2#c7; @skrivankova2021strengthening2#c8], and applying it in both directions addresses the direction of a causal association [@skrivankova2021strengthening2#c4].

- ¶4
  - OLD: An early atlas of genetic correlations concluded that the genetic basis of AD is distinct from psychiatric conditions [@buliksullivan2015atlas#c8].
  - OLD: A recent study again reported genome-wide correlations near zero between AD and both depression and SCZ [@kumar2026genetic#c2].
  - NEW: An early atlas of genetic correlations concluded that the genetic basis of AD is distinct from psychiatric conditions [@buliksullivan2015atlas#c8], and a recent study reported near-zero correlations of AD with depression and SCZ [@kumar2026genetic#c2].

- ¶4
  - OLD: In the reverse direction, genetic liability to AD was associated with a lower risk of insomnia, but reverse-direction associations of this kind depended on the APOE ε4 allele [@huang2020sleep#c1; @huang2020sleep#c7].
  - NEW: Genetic liability to AD was associated with a lower risk of insomnia [@huang2020sleep#c1], and in the same study the reverse-direction associations with sleep duration depended on the APOE ε4 allele [@huang2020sleep#c7].

- ¶5
  - OLD: Null genome-wide results do not exclude shared genetic effects, because local correlations in opposing directions can cancel out in a genome-wide estimate [@werme2022integrated#c1] <!--id:intro_local-->.
  - NEW: A null genome-wide result does not exclude shared genetic effects, since local correlations of opposite sign can cancel out in a genome-wide estimate [@werme2022integrated#c1] <!--id:intro_local-->.

- ¶5
  - OLD: Local genetic correlations also show greater heterogeneity among psychiatric traits than genome-wide estimates suggest [@nievergelt2024genome#c8].
  - NEW: Among psychiatric traits, local correlations reveal more heterogeneity than genome-wide estimates [@nievergelt2024genome#c8].

- ¶5
  - OLD: A local analysis with the Local Analysis of [co]Variant Annotation (LAVA) method reported 17 loci shared between AD and depression and 23 between AD and SCZ [@kumar2026genetic#c3], but at an uncorrected threshold of P < 5 × 10⁻³ [@kumar2026genetic#c5].
  - NEW: Using the Local Analysis of [co]Variant Annotation (LAVA) method, one study reported 17 loci shared between AD and depression and 23 between AD and SCZ [@kumar2026genetic#c3], at an uncorrected threshold of P < 5 × 10⁻³ [@kumar2026genetic#c5].

- ¶5
  - OLD: The APOE region raises a different problem, because its pleiotropy violates the exclusion restriction when APOE variants are used as instruments for AD [@huang2020sleep#c6].
  - NEW: Used as instruments for AD, APOE variants violate the exclusion restriction because of their pleiotropy [@huang2020sleep#c6].

- ¶5
  - OLD: Genetic data on DLB are limited: its largest GWAS included 2,591 cases, against more than 60,000 in recent AD GWAS [@watkins2026understanding#c1], and it had limited power for common variants of small effect [@chia2021genome#c8] <!--id:intro_dlb-->.
  - NEW: The largest DLB GWAS included 2,591 cases, compared with more than 60,000 in recent AD GWAS [@watkins2026understanding#c1], and had limited power for common variants of small effect [@chia2021genome#c8] <!--id:intro_dlb-->.

- ¶5
  - OLD: The largest AD GWAS, for its part, combines clinically diagnosed cases with proxy cases defined by parental history [@bellenguez2022new#c4; @bellenguez2022new#c2].
  - OLD: Proxy-based AD GWAS can give misleading genetic correlations [@wu2024pervasive#c1].
  - NEW: The largest AD GWAS, in turn, combines clinically diagnosed cases with proxy cases defined by parental history [@bellenguez2022new#c4; @bellenguez2022new#c2], and proxy-based AD GWAS can give misleading genetic correlations [@wu2024pervasive#c1].

- ¶5
  - OLD: FinnGen, in contrast, defines AD from register-based diagnosis codes and is enriched for AD cases [@kurki2023finngen#c4; @kurki2023finngen#c7].
  - NEW: FinnGen, by contrast, defines AD from register-based diagnosis codes and is enriched for AD cases [@kurki2023finngen#c4; @kurki2023finngen#c7].

- ¶6
  - OLD: The present study examined MDD, PTSD, insomnia and SCZ against AD and DLB at three levels, namely genome-wide rg [@buliksullivan2015atlas#c1], local rg with LAVA [@werme2022integrated#c1] and bidirectional two-sample MR [@hemani2018mr#c1], with APOE-excluded analyses and a register-based AD GWAS without proxy cases (FinnGen) as sensitivity analyses [@huang2020sleep#c6; @wu2024pervasive#c6] <!--id:intro_aim-->.
  - NEW: The present study examined MDD, PTSD, insomnia and SCZ against AD and DLB with genome-wide rg [@buliksullivan2015atlas#c1], local rg with LAVA [@werme2022integrated#c1] and bidirectional two-sample MR [@hemani2018mr#c1], using APOE-excluded analyses and a register-based AD GWAS without proxy cases (FinnGen) as sensitivity analyses [@huang2020sleep#c6; @wu2024pervasive#c6] <!--id:intro_aim-->.

## 03_methods.md

- ¶3
  - OLD: The study combined genome-wide genetic correlation, local genetic correlation and bidirectional two-sample Mendelian randomization (MR) to examine four psychiatric traits (major depressive disorder, MDD; post-traumatic stress disorder, PTSD; insomnia; schizophrenia, SCZ) against Alzheimer's disease (AD) and dementia with Lewy bodies (DLB).
  - NEW: Four psychiatric traits (major depressive disorder, MDD; post-traumatic stress disorder, PTSD; insomnia; schizophrenia, SCZ) were examined against Alzheimer's disease (AD) and dementia with Lewy bodies (DLB) with genome-wide genetic correlation, local genetic correlation and bidirectional two-sample Mendelian randomization (MR).

- ¶3
  - OLD: AD × DLB and the six pairs among the psychiatric traits were secondary pairs, reported descriptively and corrected separately.
  - NEW: AD × DLB and the six pairs among the psychiatric traits were secondary pairs, reported descriptively and corrected in their own family.

- ¶3
  - OLD: The analysis layers and data sources are summarized in Figure 1.
  - NEW: Figure 1 summarizes the analysis layers and data sources.

- ¶5
  - OLD: Hypotheses, thresholds, multiple-testing families and an interpretation rule for MR were fixed in an analysis plan, frozen with a SHA-256 checksum before cross-trait analyses.
  - OLD: At that point only single-file harmonization and quality control had been run.
  - NEW: Hypotheses, thresholds, multiple-testing families and an interpretation rule for MR were fixed in an analysis plan, frozen with a SHA-256 checksum before cross-trait analyses, when only single-file harmonization and quality control had been run.

- ¶5
  - OLD: Every later change is listed with its reason and timing in Supplementary Table S1.
  - NEW: Supplementary Table S1 lists every later change with its reason and timing.

- ¶5
  - OLD: Reporting follows STROBE-MR [@skrivankova2021strengthening2#c1], completed item by item in Supplementary File S1.
  - NEW: Reporting follows STROBE-MR [@skrivankova2021strengthening2#c1], and the checklist is completed item by item in Supplementary File S1.

- ¶9
  - OLD: Its UK Biobank component also contributed controls, which creates sample overlap with every other GWAS that includes UK Biobank [@bellenguez2022new#c5].
  - NEW: Because its UK Biobank component also contributed controls, it overlaps with every other GWAS that includes UK Biobank [@bellenguez2022new#c5].

- ¶9
  - OLD: For MDD, the primary file was the Psychiatric Genomics Consortium release excluding UK Biobank and 23andMe [@adams2025trans#c1; @adams2025trans#c7], chosen so that AD × MDD overlap was removed by design; the release including UK Biobank served as a sensitivity analysis.
  - NEW: The primary MDD file was the Psychiatric Genomics Consortium release excluding UK Biobank and 23andMe [@adams2025trans#c1; @adams2025trans#c7], chosen to remove AD × MDD overlap by design, and the release including UK Biobank served as a sensitivity analysis.

- ¶9
  - OLD: The sample-size-weighted Z-score file was used for LDSC and LAVA, which need only Z scores and sample sizes [@buliksullivan2015ld#c1; @werme2022integrated#c6], and the case/control file with effect sizes from the same release was used for MR.
  - NEW: LDSC and LAVA need only Z scores and sample sizes, so the sample-size-weighted Z-score file was used for them [@buliksullivan2015atlas#c1; @werme2022integrated#c10], while MR used the case/control file with effect sizes from the same release.

- ¶10
  - OLD: SCZ summary statistics came from the third Psychiatric Genomics Consortium SCZ GWAS, European-ancestry autosomes [@trubetskoy2022mapping#c1].
  - NEW: SCZ summary statistics came from the European-ancestry autosomes of the third Psychiatric Genomics Consortium SCZ GWAS [@trubetskoy2022mapping#c1].

- ¶10
  - OLD: An AD GWAS free of the proxy cases and UK Biobank samples of the primary AD GWAS was required as a sensitivity analysis [@bellenguez2022new#c2].
  - NEW: The sensitivity analysis required an AD GWAS free of the proxy cases and UK Biobank samples of the primary AD GWAS [@bellenguez2022new#c2].

- ¶10
  - OLD: The FinnGen release 13 endpoint for AD met this requirement as a register-based AD GWAS without proxy cases, defined from register-based diagnosis codes in hospital discharge and cause-of-death registers [@kurki2023finngen#c1; @kurki2023finngen#c4].
  - NEW: The FinnGen release 13 AD endpoint met this requirement as a register-based AD GWAS without proxy cases, defined from register-based diagnosis codes in hospital discharge and cause-of-death registers [@kurki2023finngen#c1; @kurki2023finngen#c4].

- ¶10
  - OLD: A larger clinically diagnosed AD GWAS was available only under data-use conditions that could not be reconciled with the analysis of psychiatric traits, and it was therefore not used.
  - NEW: A larger clinically diagnosed AD GWAS was available only under data-use conditions that could not be reconciled with the analysis of psychiatric traits, so it was not used.

- ¶12
  - OLD: Each file was harmonized separately to GRCh37.
  - OLD: Files on GRCh38 were mapped by rsID to the 1000 Genomes Phase 3 European reference [@auton2015global#c1; @auton2015global#c2].
  - NEW: Each file was harmonized separately to GRCh37, and files on GRCh38 were mapped by rsID to the 1000 Genomes Phase 3 European reference [@auton2015global#c1; @auton2015global#c2].

- ¶12
  - OLD: The major histocompatibility complex region (chr6:25–34 Mb) was excluded from genome-wide and local genetic correlation analyses.
  - OLD: The APOE region (chr19:44.4–46.5 Mb) was flagged for the APOE-excluded analyses.
  - NEW: Genome-wide and local genetic correlation analyses excluded the major histocompatibility complex region (chr6:25–34 Mb), and the APOE region (chr19:44.4–46.5 Mb) was flagged for the APOE-excluded analyses.

- ¶12
  - OLD: Allele-frequency concordance with the reference, genomic inflation and declared sample sizes were checked for every file, and the number of SNPs remaining after each step is given in Supplementary Table S2.
  - NEW: For every file, allele-frequency concordance with the reference, genomic inflation and declared sample sizes were checked; Supplementary Table S2 gives the number of SNPs remaining after each step.

- ¶14
  - OLD: SNP heritability and genetic correlation (rg) were estimated by LD score regression [@buliksullivan2015ld#c1; @buliksullivan2015atlas#c1] as implemented in GenomicSEM [@grotzinger2019genomic#c1], using HapMap3 SNPs and LD scores from the 1000 Genomes European panel [@buliksullivan2015atlas#c6].
  - NEW: SNP heritability and genetic correlation (rg) were estimated by LD score regression [@buliksullivan2015ld#c1; @buliksullivan2015atlas#c1] as implemented in GenomicSEM [@grotzinger2019genomic#c1], with HapMap3 SNPs and LD scores from the 1000 Genomes European panel [@buliksullivan2015atlas#c6].

- ¶14
  - OLD: Case/control traits were entered with their effective sample size and a sample prevalence of 0.5, so heritability was estimated on the observed scale.
  - NEW: Case/control traits were entered with their effective sample size and a sample prevalence of 0.5, which places heritability on the observed scale.

- ¶14
  - OLD: Cross-trait LDSC is not biased by sample overlap, which is absorbed by the cross-trait intercept [@buliksullivan2015atlas#c2; @grotzinger2019genomic#c2].
  - NEW: Sample overlap does not bias cross-trait LDSC, because it is absorbed by the cross-trait intercept [@buliksullivan2015atlas#c2; @grotzinger2019genomic#c2].

- ¶14
  - OLD: Genetic correlations of traits with a heritability Z score below 4 are generally too noisy to report [@buliksullivan2015atlas#c9]; under the analysis plan such traits were flagged as low power, but their estimates were reported.
  - NEW: Genetic correlations of traits with a heritability Z score below 4 are generally too noisy to report [@buliksullivan2015atlas#c9], and the analysis plan flagged such traits as low power while still reporting their estimates.

- ¶14
  - OLD: Three sensitivity analyses were specified in the plan: the MDD file including UK Biobank [@adams2025trans#c1], the PTSD case/control file [@nievergelt2024genome#c1] and the exclusion of the APOE region from AD.
  - NEW: The plan specified three sensitivity analyses: the MDD file including UK Biobank [@adams2025trans#c1], the PTSD case/control file [@nievergelt2024genome#c1] and AD with the APOE region removed.

- ¶16
  - OLD: Local genetic correlation was estimated with LAVA version 0.1.5 [@werme2022integrated#c4] across 2,495 approximately independent genomic loci, after excluding loci overlapping the major histocompatibility complex.
  - NEW: Local genetic correlation was estimated with LAVA version 0.1.5 [@werme2022integrated#c4] across 2,495 approximately independent genomic loci, excluding loci that overlap the major histocompatibility complex.

- ¶16
  - OLD: Following the LAVA developers' recommendation for European-ancestry data, the UK Biobank LD reference was specified as primary in the analysis plan [@werme2025lava#c1; @werme2025lava#c3].
  - NEW: The analysis plan specified the UK Biobank LD reference as primary, following the LAVA developers' recommendation for European-ancestry data [@werme2025lava#c1; @werme2025lava#c3].

- ¶16
  - OLD: The developers attribute possible type 1 error inflation and local heritability bias to the smaller 1000 Genomes panel [@werme2025lava#c2], which was therefore analysed as a sensitivity analysis [@auton2015global#c2].
  - NEW: The developers attribute possible type 1 error inflation and local heritability bias to the smaller 1000 Genomes panel [@werme2025lava#c2], which was analysed as a sensitivity analysis [@auton2015global#c2].

- ¶16
  - OLD: Sample overlap was modelled from the LDSC cross-trait intercepts [@werme2022integrated#c5; @werme2022integrated#c6].
  - OLD: Binary traits were entered with case and control counts derived from the effective sample size (Supplementary Table S3).
  - NEW: LDSC cross-trait intercepts supplied the sample overlap model [@werme2022integrated#c5; @werme2022integrated#c6], and binary traits were entered with case and control counts derived from the effective sample size (Supplementary Table S3).

- ¶17
  - OLD: A locus was carried forward for a pair only if both traits had a univariate P below 1 × 10⁻⁴, because local correlations are not interpretable without local genetic signal in both traits [@werme2022integrated#c4].
  - NEW: A locus was carried forward for a pair only if both traits had a univariate P below 1 × 10⁻⁴, since local correlations cannot be interpreted without local genetic signal in both traits [@werme2022integrated#c4].

- ¶17
  - OLD: Bivariate local rho with its 95% CI was then estimated for every carried-forward locus–pair in LAVA [@werme2022integrated#c6].
  - NEW: LAVA then estimated bivariate local rho with its 95% CI for every carried-forward locus–pair [@werme2022integrated#c6].

- ¶17
  - OLD: LAVA obtains bivariate P values and confidence intervals by simulation [@werme2022integrated#c9], so each locus–pair was analysed with its own fixed random seed derived from a single base seed, which makes every estimate reproducible.
  - NEW: Because LAVA obtains bivariate P values and confidence intervals by simulation [@werme2022integrated#c9], each locus–pair was analysed with its own fixed random seed derived from a single base seed, so that every estimate can be reproduced.

- ¶17
  - OLD: For the 1000 Genomes analysis, palindromic SNPs whose allele frequency fell on the opposite side of 0.5 from the reference were removed as possible strand mismatches [@auton2015global#c2].
  - OLD: All locus–pairs that passed FDR correction in the main analysis were then re-estimated after the same exclusion.
  - NEW: In the 1000 Genomes analysis, palindromic SNPs whose allele frequency fell on the opposite side of 0.5 from the reference were removed as possible strand mismatches [@auton2015global#c2], and all locus–pairs that passed FDR correction in the main analysis were re-estimated after the same exclusion.

- ¶17 REMOVED
  - OLD: Analysis proceeded in two steps.

- ¶19
  - OLD: Instruments were SNPs associated with the exposure at P < 5 × 10⁻⁸, with a fallback of P < 5 × 10⁻⁶, specified in the analysis plan, when fewer than three instruments remained.
  - NEW: Instruments were SNPs associated with the exposure at P < 5 × 10⁻⁸, with a plan-specified fallback of P < 5 × 10⁻⁶ when fewer than three instruments remained.

- ¶19
  - OLD: Instruments were clumped in PLINK 1.9 [@chang2015second#c1; @chang2015second#c4] against the 1000 Genomes European reference, so that only approximately independent SNPs were kept [@hemani2018mr#c3]; the clumping window (r² < 0.001 within 10,000 kb) was an analysis-plan choice.
  - NEW: Clumping in PLINK 1.9 [@chang2015second#c1; @chang2015second#c4] against the 1000 Genomes European reference kept only approximately independent SNPs [@hemani2018mr#c3]; the clumping window (r² < 0.001 within 10,000 kb) was an analysis-plan choice.

- ¶19
  - OLD: SNPs with an F statistic of 10 or less were removed, a plan threshold motivated by the reduction of weak-instrument and overlap bias with strong instruments [@hemani2018mr#c7].
  - NEW: SNPs with an F statistic of 10 or less were removed, a plan threshold motivated by the smaller weak-instrument and overlap bias of strong instruments [@hemani2018mr#c7].

- ¶19
  - OLD: Instruments absent from the outcome GWAS were dropped without LD proxies.
  - OLD: Exposure and outcome data were harmonized with TwoSampleMR [@hemani2018mr#c1].
  - NEW: Instruments absent from the outcome GWAS were dropped without LD proxies, and exposure and outcome data were harmonized with TwoSampleMR [@hemani2018mr#c1].

- ¶19
  - OLD: Palindromic SNPs were resolved by allele frequency; for insomnia, which reports no allele frequency, all palindromic SNPs were removed.
  - NEW: Palindromic SNPs were resolved by allele frequency, except for insomnia, whose file reports no allele frequency, so all its palindromic SNPs were removed.

- ¶20
  - OLD: For binary traits the variance explained was computed on the liability scale, which requires population prevalences [@hemani2017orienting#c6].
  - NEW: For binary traits this variance was computed on the liability scale, which requires population prevalences [@hemani2017orienting#c6].

- ¶20
  - OLD: These were 0.15 for MDD [@adams2025trans#c5], 0.01 for SCZ [@trubetskoy2022mapping#c6], 0.001 for DLB [@chia2021genome#c6], 0.05 for PTSD [@koenen2017posttraumatic#c3] and 0.05 for AD (European prevalence among people aged over 50) [@niu2017prevalence#c1; @niu2017prevalence#c2].
  - NEW: The values were 0.15 for MDD [@adams2025trans#c5], 0.01 for SCZ [@trubetskoy2022mapping#c6], 0.001 for DLB [@chia2021genome#c6], 0.05 for PTSD [@koenen2017posttraumatic#c3] and 0.05 for AD (European prevalence among people aged over 50) [@niu2017prevalence#c1; @niu2017prevalence#c2].

- ¶20
  - OLD: Filtering was repeated with every prevalence halved and doubled, and the instruments removed and the IVW estimate on each retained set were recorded.
  - NEW: Filtering was repeated with every prevalence halved and doubled, recording the instruments removed and the IVW estimate on each retained set.

- ¶21
  - OLD: Heterogeneity was assessed with Cochran's Q for the IVW model and Rücker's Q′ for MR-Egger [@bowden2015mendelian#c7].
  - OLD: The I²GX statistic indexed regression dilution of MR-Egger [@bowden2016assessing#c2].
  - NEW: Heterogeneity was assessed with Cochran's Q for the IVW model and Rücker's Q′ for MR-Egger [@bowden2015mendelian#c7], and the I²GX statistic indexed regression dilution of MR-Egger [@bowden2016assessing#c2].

- ¶22
  - OLD: Sample overlap biases two-sample MR estimates toward the observational association [@mounier2023bias#c3].
  - OLD: MRlap was therefore applied to every primary direction and to the sensitivity analyses that used MDD with UK Biobank [@mounier2023bias#c1; @mounier2023bias#c2].
  - NEW: Sample overlap biases two-sample MR estimates toward the observational association [@mounier2023bias#c3], so MRlap was applied to every primary direction and to the sensitivity analyses that used MDD with UK Biobank [@mounier2023bias#c1; @mounier2023bias#c2].

- ¶22
  - OLD: The minimum detectable OR at 80% power and two-sided α of 0.05 was computed from instrument R² and the outcome sample, as context for null results.
  - NEW: As context for null results, the minimum detectable OR at 80% power and two-sided α of 0.05 was computed from instrument R² and the outcome sample.

- ¶23
  - OLD: A finding meeting the first condition only was described as evidence sensitive to pleiotropy, and any other result as no evidence.
  - NEW: A finding that met the first condition only was described as evidence sensitive to pleiotropy, and any other result as no evidence.

- ¶25
  - OLD: The four psychiatric traits were analysed against FinnGen AD for genome-wide rg and for MR in both directions, with the same instrument rules, estimators, MRlap and APOE-excluded analyses [@kurki2023finngen#c4].
  - NEW: FinnGen AD was analysed against the four psychiatric traits for genome-wide rg and for MR in both directions, with the same instrument rules, estimators, MRlap and APOE-excluded analyses [@kurki2023finngen#c4].

- ¶25
  - OLD: FinnGen contributes to the MDD and PTSD GWAS [@nievergelt2024genome#c3], so MRlap was applied to every FinnGen direction.
  - NEW: Because FinnGen contributes to the MDD and PTSD GWAS [@nievergelt2024genome#c3], MRlap was applied to every FinnGen direction.

- ¶25
  - OLD: These analyses were not used to declare significance and are reported as consistency checks, with correction across the four FinnGen tests shown for genome-wide rg [@kurki2023finngen#c1].
  - NEW: These analyses served as consistency checks and were not used to declare significance; for genome-wide rg, correction across the four FinnGen tests is shown [@kurki2023finngen#c1].

- ¶29
  - OLD: The Benjamini–Hochberg procedure [@benjamini1995controlling#c1] controlled the FDR at 5% within each family defined in the analysis plan: the 8 primary genome-wide rg tests, all bivariate LAVA tests of the primary pairs, and the 16 primary IVW tests.
  - NEW: The Benjamini–Hochberg procedure [@benjamini1995controlling#c1] controlled the FDR at 5% within each family defined in the analysis plan, namely the 8 primary genome-wide rg tests, all bivariate LAVA tests of the primary pairs and the 16 primary IVW tests.

- ¶31
  - OLD: Each is described with its timing in Supplementary Table S1.
  - NEW: Supplementary Table S1 describes each with its timing.

## 04_results.md

- ¶3
  - OLD: All six traits had SNP heritability estimates distinguishable from zero except DLB, whose heritability Z score was {{res:ldsc_h2.main.dlb.h2_z}}, below the threshold under which the analysis plan flags rg as low power (Figure 2).
  - NEW: Every trait except DLB had a SNP heritability estimate distinguishable from zero, and the DLB heritability Z score of {{res:ldsc_h2.main.dlb.h2_z}} fell below the threshold under which the analysis plan flags rg as low power (Figure 2).

- ¶3
  - OLD: The heritability Z score was {{res:ldsc_h2.main.ad.h2_z}} for AD and ranged from {{res:ldsc_h2.main.insomnia.h2_z}} to {{res:ldsc_h2.main.mdd.h2_z}} for the psychiatric traits.
  - NEW: Heritability Z scores were {{res:ldsc_h2.main.ad.h2_z}} for AD and ranged from {{res:ldsc_h2.main.insomnia.h2_z}} to {{res:ldsc_h2.main.mdd.h2_z}} across the psychiatric traits.

- ¶4
  - OLD: The estimates were {{res:ldsc_rg.main.ad.mdd.rg}} for MDD, {{res:ldsc_rg.main.ad.ptsd.rg}} for PTSD, {{res:ldsc_rg.main.ad.insomnia.rg}} for insomnia and {{res:ldsc_rg.main.ad.scz.rg}} for SCZ, with FDR-corrected P values of {{res:ldsc_rg.main.ad.mdd.p_fdr}}, {{res:ldsc_rg.main.ad.ptsd.p_fdr}}, {{res:ldsc_rg.main.ad.insomnia.p_fdr}} and {{res:ldsc_rg.main.ad.scz.p_fdr}}.
  - NEW: Point estimates were {{res:ldsc_rg.main.ad.mdd.rg}} for MDD, {{res:ldsc_rg.main.ad.ptsd.rg}} for PTSD, {{res:ldsc_rg.main.ad.insomnia.rg}} for insomnia and {{res:ldsc_rg.main.ad.scz.rg}} for SCZ, with FDR-corrected P values of {{res:ldsc_rg.main.ad.mdd.p_fdr}}, {{res:ldsc_rg.main.ad.ptsd.p_fdr}}, {{res:ldsc_rg.main.ad.insomnia.p_fdr}} and {{res:ldsc_rg.main.ad.scz.p_fdr}}.

- ¶4
  - OLD: The upper confidence limits excluded positive correlations with AD larger than {{res:power_ldsc.ad.ptsd.excluded_above}} to {{res:power_ldsc.ad.scz.excluded_above}}, depending on the trait.
  - NEW: Depending on the trait, the upper confidence limits excluded positive correlations with AD larger than {{res:power_ldsc.ad.ptsd.excluded_above}} to {{res:power_ldsc.ad.scz.excluded_above}}.

- ¶5
  - OLD: Both estimates rest on a DLB heritability flagged as low power (Z {{res:ldsc_h2.main.dlb.h2_z}}), and their lower confidence limits lay close to zero ({{res:power_ldsc.dlb.mdd.ci_lower}} and {{res:power_ldsc.dlb.ptsd.ci_lower}}).
  - NEW: These estimates rest on a DLB heritability flagged as low power (Z {{res:ldsc_h2.main.dlb.h2_z}}), and their lower confidence limits lay close to zero ({{res:power_ldsc.dlb.mdd.ci_lower}} and {{res:power_ldsc.dlb.ptsd.ci_lower}}).

- ¶5
  - OLD: DLB was not correlated with insomnia ({{res:ldsc_rg.main.dlb.insomnia.rg}}) or SCZ ({{res:ldsc_rg.main.dlb.scz.rg}}), with wide intervals in both cases.
  - NEW: Correlations of DLB with insomnia ({{res:ldsc_rg.main.dlb.insomnia.rg}}) and SCZ ({{res:ldsc_rg.main.dlb.scz.rg}}) were not distinguishable from zero and had wide intervals.

- ¶5
  - OLD: As a secondary pair, AD and DLB were correlated ({{res:ldsc_rg.main.ad.dlb.rg}}).
  - NEW: In the secondary family, AD and DLB were correlated ({{res:ldsc_rg.main.ad.dlb.rg}}).

- ¶6
  - OLD: The AD estimates changed little in the pre-specified sensitivity analyses (Supplementary Table S4).
  - NEW: In the pre-specified sensitivity analyses the AD estimates changed little (Supplementary Table S4).

- ¶6
  - OLD: With MDD including UK Biobank, rg with AD was {{res:ldsc_rg.sens_mdd_ukbb.ad.mdd_ukbb.rg}}; with the PTSD case/control file it was {{res:ldsc_rg.sens_ptsd_cc.ad.ptsd_cc.rg}}.
  - OLD: After removal of the APOE region from AD, rg ranged from {{res:ldsc_rg.sens_noapoe.ad_noapoe.ptsd.rg}} for PTSD to {{res:ldsc_rg.sens_noapoe.ad_noapoe.scz.rg}} for SCZ.
  - NEW: Using MDD including UK Biobank gave an rg with AD of {{res:ldsc_rg.sens_mdd_ukbb.ad.mdd_ukbb.rg}}, the PTSD case/control file gave {{res:ldsc_rg.sens_ptsd_cc.ad.ptsd_cc.rg}}, and after removal of the APOE region from AD the estimates ranged from {{res:ldsc_rg.sens_noapoe.ad_noapoe.ptsd.rg}} for PTSD to {{res:ldsc_rg.sens_noapoe.ad_noapoe.scz.rg}} for SCZ.

- ¶6
  - OLD: The DLB × MDD and DLB × PTSD estimates were similar with the alternative MDD and PTSD files ({{res:ldsc_rg.sens_mdd_ukbb.dlb.mdd_ukbb.rg}} and {{res:ldsc_rg.sens_ptsd_cc.dlb.ptsd_cc.rg}}).
  - NEW: The alternative MDD and PTSD files gave similar DLB estimates ({{res:ldsc_rg.sens_mdd_ukbb.dlb.mdd_ukbb.rg}} and {{res:ldsc_rg.sens_ptsd_cc.dlb.ptsd_cc.rg}}).

- ¶7
  - OLD: With FinnGen AD, the correlation with PTSD was positive ({{res:sensitivity_finngen.ldsc.finngen.ptsd.rg}}; uncorrected P {{res:sensitivity_finngen.ldsc.finngen.ptsd.p_uncorrected}}), but it did not survive correction across the four FinnGen tests (BH-adjusted P {{res:sensitivity_finngen.ldsc.finngen.ptsd.p_bh_within4}}).
  - NEW: With FinnGen AD, the correlation with PTSD was positive ({{res:sensitivity_finngen.ldsc.finngen.ptsd.rg}}; uncorrected P {{res:sensitivity_finngen.ldsc.finngen.ptsd.p_uncorrected}}) but did not survive correction across the four FinnGen tests (BH-adjusted P {{res:sensitivity_finngen.ldsc.finngen.ptsd.p_bh_within4}}).

- ¶7
  - OLD: The FinnGen correlations with MDD ({{res:sensitivity_finngen.ldsc.finngen.mdd.rg}}), insomnia ({{res:sensitivity_finngen.ldsc.finngen.insomnia.rg}}) and SCZ ({{res:sensitivity_finngen.ldsc.finngen.scz.rg}}) were close to those obtained with the primary AD GWAS.
  - NEW: Correlations of FinnGen AD with MDD ({{res:sensitivity_finngen.ldsc.finngen.mdd.rg}}), insomnia ({{res:sensitivity_finngen.ldsc.finngen.insomnia.rg}}) and SCZ ({{res:sensitivity_finngen.ldsc.finngen.scz.rg}}) were close to those obtained with the primary AD GWAS.

- ¶8 (heading/block)
  - OLD: {{figure:Figure2_ldsc_rg.png|Genome-wide genetic correlations of the four psychiatric traits with AD and DLB were small, and only the DLB estimates with MDD and PTSD passed FDR correction, on a DLB heritability flagged as low power. Points show rg with 95% CI from LD score regression for the primary AD GWAS, FinnGen AD and DLB; open markers show AD with the APOE region removed. The dashed line marks rg = 0.}}
  - NEW: {{figure:Figure2_ldsc_rg.png|Genome-wide genetic correlations of the four psychiatric traits with AD were small; only the DLB estimates with MDD and PTSD passed FDR correction, on a DLB heritability flagged as low power. Points show rg with 95% CI from LD score regression for the primary AD GWAS, FinnGen AD and DLB; open markers show AD with the APOE region removed. The dashed line marks rg = 0.}}

- ¶10
  - OLD: Of the {{res:lava_ukb.summary.loci_analysed}} loci analysed with the UK Biobank reference, few carried local heritability for both members of a primary pair, so {{res:lava_ukb.summary.bivar_tests_primary}} bivariate tests were possible across the eight primary pairs (Figure 3).
  - NEW: Of the {{res:lava_ukb.summary.loci_analysed}} loci analysed with the UK Biobank reference, the few with local heritability in both traits of a primary pair allowed {{res:lava_ukb.summary.bivar_tests_primary}} bivariate tests across the eight primary pairs (Figure 3).

- ¶10
  - OLD: The number of testable loci was {{res:power_lava_ukb.ad.mdd.loci_testable}} for AD × MDD, {{res:power_lava_ukb.ad.ptsd.loci_testable}} for AD × PTSD, {{res:text.lava_testable_ad_insomnia}} for AD × insomnia and {{res:power_lava_ukb.ad.scz.loci_testable}} for AD × SCZ.
  - NEW: Testable loci numbered {{res:power_lava_ukb.ad.mdd.loci_testable}} for AD × MDD, {{res:power_lava_ukb.ad.ptsd.loci_testable}} for AD × PTSD, {{res:text.lava_testable_ad_insomnia}} for AD × insomnia and {{res:power_lava_ukb.ad.scz.loci_testable}} for AD × SCZ.

- ¶10
  - OLD: Insomnia passed the univariate filter at only {{res:power_lava_ukb.ad.insomnia.loci_univ_psychiatric}} loci, and DLB at {{res:power_lava_ukb.dlb.mdd.loci_univ_dementia}}, so the DLB pairs had {{res:text.lava_testable_dlb_range}}.
  - NEW: Insomnia passed the univariate filter at only {{res:power_lava_ukb.ad.insomnia.loci_univ_psychiatric}} loci and DLB at {{res:power_lava_ukb.dlb.mdd.loci_univ_dementia}}, which left the DLB pairs with {{res:text.lava_testable_dlb_range}}.

- ¶12
  - OLD: Nominal local correlations were observed at {{res:power_lava_ukb.ad.mdd.loci_nominal_p05}} of {{res:power_lava_ukb.ad.mdd.loci_testable}} testable loci for AD × MDD (expected under the null {{res:lava_exploratory.ad.mdd.expected}}), {{res:power_lava_ukb.ad.scz.loci_nominal_p05}} of {{res:power_lava_ukb.ad.scz.loci_testable}} for AD × SCZ (expected {{res:lava_exploratory.ad.scz.expected}}) and {{res:power_lava_ukb.ad.ptsd.loci_nominal_p05}} of {{res:power_lava_ukb.ad.ptsd.loci_testable}} for AD × PTSD (expected {{res:lava_exploratory.ad.ptsd.expected}}).
  - NEW: Nominal local correlations occurred at {{res:power_lava_ukb.ad.mdd.loci_nominal_p05}} of {{res:power_lava_ukb.ad.mdd.loci_testable}} testable loci for AD × MDD (expected under the null {{res:lava_exploratory.ad.mdd.expected}}), {{res:power_lava_ukb.ad.scz.loci_nominal_p05}} of {{res:power_lava_ukb.ad.scz.loci_testable}} for AD × SCZ (expected {{res:lava_exploratory.ad.scz.expected}}) and {{res:power_lava_ukb.ad.ptsd.loci_nominal_p05}} of {{res:power_lava_ukb.ad.ptsd.loci_testable}} for AD × PTSD (expected {{res:lava_exploratory.ad.ptsd.expected}}).

- ¶12
  - OLD: These loci are exploratory and are listed in Supplementary Table S5.
  - NEW: These exploratory loci are listed in Supplementary Table S5.

- ¶12
  - OLD: For AD × MDD, {{res:lava_exploratory.ad.mdd.nominal_positive_rho}} nominal correlations were positive and {{res:lava_exploratory.ad.mdd.nominal_negative_rho}} negative.
  - OLD: For AD × SCZ, {{res:lava_exploratory.ad.scz.nominal_positive_rho}} of {{res:lava_exploratory.ad.scz.nominal_p05}} nominal correlations were positive.
  - NEW: Of the nominal AD × MDD correlations, {{res:lava_exploratory.ad.mdd.nominal_positive_rho}} were positive and {{res:lava_exploratory.ad.mdd.nominal_negative_rho}} negative, whereas {{res:lava_exploratory.ad.scz.nominal_positive_rho}} of the {{res:lava_exploratory.ad.scz.nominal_p05}} nominal AD × SCZ correlations were positive.

- ¶13
  - OLD: A locus on chromosome 17 containing MAPT, KANSL1 and CRHR1 ({{res:lava_exploratory.locus.2207.ad_mdd.locus}}) was nominal for AD × MDD, AD × PTSD and AD × SCZ.
  - OLD: Local rho was {{res:lava_reference_check.locus.2207.ad_mdd.rho_ukb}} for AD × MDD, {{res:lava_reference_check.locus.2207.ad_ptsd.rho_ukb}} for AD × PTSD and {{res:lava_reference_check.locus.2207.ad_scz.rho_ukb}} for AD × SCZ.
  - NEW: A locus on chromosome 17 containing MAPT, KANSL1 and CRHR1 ({{res:lava_exploratory.locus.2207.ad_mdd.locus}}) was nominal for AD × MDD, AD × PTSD and AD × SCZ, with local rho of {{res:lava_reference_check.locus.2207.ad_mdd.rho_ukb}}, {{res:lava_reference_check.locus.2207.ad_ptsd.rho_ukb}} and {{res:lava_reference_check.locus.2207.ad_scz.rho_ukb}}, respectively.

- ¶13
  - OLD: With the 1000 Genomes reference the corresponding estimates were {{res:lava_reference_check.locus.2207.ad_mdd.rho_g1000}}, {{res:lava_reference_check.locus.2207.ad_ptsd.rho_g1000}} and {{res:lava_reference_check.locus.2207.ad_scz.rho_g1000}}, each with the same sign and within the UK Biobank confidence interval.
  - NEW: The 1000 Genomes reference gave {{res:lava_reference_check.locus.2207.ad_mdd.rho_g1000}}, {{res:lava_reference_check.locus.2207.ad_ptsd.rho_g1000}} and {{res:lava_reference_check.locus.2207.ad_scz.rho_g1000}}, each with the same sign and within the UK Biobank confidence interval.

- ¶13
  - OLD: The adjacent locus ({{res:lava_exploratory.locus.2206.ad_mdd.locus}}) behaved the same way for AD × MDD ({{res:lava_reference_check.locus.2206.ad_mdd.rho_ukb}} and {{res:lava_reference_check.locus.2206.ad_mdd.rho_g1000}}).
  - NEW: The adjacent locus ({{res:lava_exploratory.locus.2206.ad_mdd.locus}}) behaved in the same way for AD × MDD ({{res:lava_reference_check.locus.2206.ad_mdd.rho_ukb}} and {{res:lava_reference_check.locus.2206.ad_mdd.rho_g1000}}).

- ¶13
  - OLD: A locus on chromosome 11 containing SPI1 and CELF1 ({{res:lava_exploratory.locus.1658.ad_mdd.locus}}), a known AD risk region [@bellenguez2022new#c10], was nominal for AD × MDD ({{res:lava_exploratory.locus.1658.ad_mdd.rho}}) but was not testable with the 1000 Genomes reference, because a trait did not pass the univariate filter there.
  - NEW: A locus on chromosome 11 containing SPI1 and CELF1 ({{res:lava_exploratory.locus.1658.ad_mdd.locus}}), a known AD risk region [@bellenguez2022new#c10], was nominal for AD × MDD ({{res:lava_exploratory.locus.1658.ad_mdd.rho}}) but could not be tested with the 1000 Genomes reference, where a trait did not pass the univariate filter.

- ¶15
  - OLD: With the 1000 Genomes reference, {{res:lava_g1000.summary.bivar_tests_primary}} primary bivariate tests were possible and {{res:lava_g1000_fdr_pairs.summary.n_fdr_pairs_g1000}} locus–pairs passed FDR correction (Supplementary Table S6).
  - NEW: With that reference, {{res:lava_g1000.summary.bivar_tests_primary}} primary bivariate tests were possible and {{res:lava_g1000_fdr_pairs.summary.n_fdr_pairs_g1000}} locus–pairs passed FDR correction (Supplementary Table S6).

- ¶15
  - OLD: Of the {{res:lava_g1000_fdr_pairs.summary.n_fdr_pairs_g1000}} FDR-significant pairs, {{res:lava_g1000_fdr_pairs.summary.n_tested_ukb}} was testable with UK Biobank and was nominal there: the AD × SCZ locus on chromosome 16 ({{res:lava_exploratory.locus.2128.ad_scz.locus}}; UK Biobank rho {{res:lava_g1000_fdr_pairs.locus.2128.ad_scz.rho_ukb}}, P {{res:lava_g1000_fdr_pairs.locus.2128.ad_scz.p_ukb}}).
  - NEW: Of the {{res:lava_g1000_fdr_pairs.summary.n_fdr_pairs_g1000}} FDR-significant pairs, {{res:lava_g1000_fdr_pairs.summary.n_tested_ukb}} was testable with UK Biobank and nominal there, namely the AD × SCZ locus on chromosome 16 ({{res:lava_exploratory.locus.2128.ad_scz.locus}}; UK Biobank rho {{res:lava_g1000_fdr_pairs.locus.2128.ad_scz.rho_ukb}}, P {{res:lava_g1000_fdr_pairs.locus.2128.ad_scz.p_ukb}}).

- ¶15
  - OLD: The remaining {{res:lava_g1000_fdr_pairs.summary.n_not_tested_ukb}} were not testable with UK Biobank because at least one trait did not pass the univariate filter.
  - NEW: The remaining {{res:lava_g1000_fdr_pairs.summary.n_not_tested_ukb}} could not be tested with UK Biobank because at least one trait did not pass the univariate filter.

- ¶15
  - OLD: The chromosome 17 loci were nominal with UK Biobank and had the same sign with 1000 Genomes, but they did not pass FDR correction with either reference (Supplementary Table S6).
  - NEW: The chromosome 17 loci were nominal with UK Biobank and kept their sign with 1000 Genomes, but they did not pass FDR correction with either reference (Supplementary Table S6).

- ¶16
  - OLD: The strand-mismatch exclusion applied to the 1000 Genomes inputs was checked against the main analysis (Supplementary Table S8).
  - NEW: As a check, the strand-mismatch exclusion used for the 1000 Genomes inputs was also applied to the main analysis (Supplementary Table S8).

- ¶18
  - OLD: Colocalization was not performed, because its pre-specified condition was not met: {{res:text.coloc_condition}} (testable locus–pairs: {{res:coloc.summary.lava_primary_tests}}).
  - NEW: Colocalization was not performed, because {{res:text.coloc_condition}} ({{res:coloc.summary.lava_primary_tests}} testable locus–pairs) and its pre-specified condition was therefore not met.

- ¶20
  - OLD: Instrument numbers, strength and diagnostics for the sixteen primary directions are given in Table 2, and the estimates are shown in Figure 4.
  - NEW: Table 2 gives instrument numbers, strength and diagnostics for the sixteen primary directions, and Figure 4 shows the estimates.

- ¶20
  - OLD: The only primary direction that passed FDR correction (PTSD → AD, OR {{res:mr.ptsd__ad.or_ivw}}; FDR-corrected P {{res:mr.ptsd__ad.p_ivw_fdr}}) was classified as sensitive to pleiotropy, and the overlap-corrected (MRlap) estimate was not nominally significant (standardized beta {{res:mr.ptsd__ad.beta_std_mrlap_corrected}}, P {{res:mr.ptsd__ad.p_mrlap_corrected}}).
  - NEW: PTSD → AD was the only primary direction that passed FDR correction (OR {{res:mr.ptsd__ad.or_ivw}}; FDR-corrected P {{res:mr.ptsd__ad.p_ivw_fdr}}).

- ¶20
  - OLD: The pleiotropy classification followed from the SIMEX MR-Egger intercept (P {{res:mr.ptsd__ad.simex_intercept_p}}), used because I²GX was {{res:mr.ptsd__ad.isq_gx}}.
  - NEW: It was classified as sensitive to pleiotropy on the basis of the SIMEX MR-Egger intercept (P {{res:mr.ptsd__ad.simex_intercept_p}}), which was used because I²GX was {{res:mr.ptsd__ad.isq_gx}}, and its overlap-corrected (MRlap) estimate was not nominally significant (standardized beta {{res:mr.ptsd__ad.beta_std_mrlap_corrected}}, P {{res:mr.ptsd__ad.p_mrlap_corrected}}).

- ¶22
  - OLD: Genetic liability to MDD (OR {{res:mr.mdd__ad.or_ivw}}) and insomnia (OR {{res:mr.insomnia__ad.or_ivw}}) showed no association with AD.
  - NEW: No association with AD was seen for liability to MDD (OR {{res:mr.mdd__ad.or_ivw}}) or insomnia (OR {{res:mr.insomnia__ad.or_ivw}}).

- ¶22
  - OLD: No psychiatric trait was associated with DLB, but the minimum detectable ORs for these directions were large, from {{res:mr.scz__dlb.min_detectable_or}} for SCZ to {{res:mr.insomnia__dlb.min_detectable_or}} for insomnia (Table 2).
  - NEW: No psychiatric trait was associated with DLB, although the minimum detectable ORs for these directions were large, from {{res:mr.scz__dlb.min_detectable_or}} for SCZ to {{res:mr.insomnia__dlb.min_detectable_or}} for insomnia (Table 2).

- ¶23
  - OLD: In the reverse direction, genetic liability to AD showed no association with MDD ({{res:mr.ad__mdd.or_ivw}}), PTSD ({{res:mr.ad__ptsd.or_ivw}}), insomnia ({{res:mr.ad__insomnia.or_ivw}}) or SCZ ({{res:mr.ad__scz.or_ivw}}).
  - NEW: In the reverse direction, AD liability showed no association with MDD ({{res:mr.ad__mdd.or_ivw}}), PTSD ({{res:mr.ad__ptsd.or_ivw}}), insomnia ({{res:mr.ad__insomnia.or_ivw}}) or SCZ ({{res:mr.ad__scz.or_ivw}}).

- ¶23
  - OLD: For AD → insomnia, the MRlap-corrected estimate was nominally significant (standardized beta {{res:mr.ad__insomnia.beta_std_mrlap_corrected}}; P {{res:mr.ad__insomnia.p_mrlap_corrected}}) while the IVW estimate was not (P {{res:mr.ad__insomnia.p_ivw}}).
  - NEW: For AD → insomnia, the MRlap-corrected estimate was nominally significant (standardized beta {{res:mr.ad__insomnia.beta_std_mrlap_corrected}}; P {{res:mr.ad__insomnia.p_mrlap_corrected}}), whereas the IVW estimate was not (P {{res:mr.ad__insomnia.p_ivw}}).

- ¶25
  - OLD: Steiger filtering removed {{res:mr_steiger_prevalence.summary.mdd_dlb_removed_k1}} of {{res:mr_steiger_prevalence.summary.mdd_dlb_harmonised}} harmonized instruments for MDD → DLB (Table 2).
  - NEW: Steiger filtering removed {{res:mr_steiger_prevalence.summary.mdd_dlb_removed_k1}} of {{res:mr_steiger_prevalence.summary.mdd_dlb_harmonised}} harmonized instruments for MDD → DLB (Table 2), and {{res:mr_steiger_prevalence.summary.mdd_dlb_removed_half}} and {{res:mr_steiger_prevalence.summary.mdd_dlb_removed_double}} with every prevalence halved or doubled.

- ¶25
  - OLD: With every prevalence halved or doubled, the number removed was {{res:mr_steiger_prevalence.summary.mdd_dlb_removed_half}} and {{res:mr_steiger_prevalence.summary.mdd_dlb_removed_double}}, and across the eight DLB directions this {{res:text.steiger_prevalence_change}}, {{res:text.steiger_prevalence_ivw}} (Supplementary Table S9).
  - NEW: Halving or doubling the prevalences {{res:text.steiger_prevalence_change}}, {{res:text.steiger_prevalence_ivw}} (Supplementary Table S9).

- ¶26
  - OLD: Exclusion of APOE-region instruments did not change the estimates for psychiatric exposures, whose instruments did not include the APOE region; PTSD → AD remained {{res:mr.ptsd__ad__noapoe.or_ivw}}.
  - NEW: Excluding APOE-region instruments left the estimates for psychiatric exposures unchanged, because their instruments did not include the APOE region; PTSD → AD remained {{res:mr.ptsd__ad__noapoe.or_ivw}}.

- ¶26
  - OLD: For AD as exposure, the APOE-excluded estimates were {{res:mr.ad__mdd__noapoe.or_ivw}} for MDD, {{res:mr.ad__ptsd__noapoe.or_ivw}} for PTSD, {{res:mr.ad__insomnia__noapoe.or_ivw}} for insomnia and {{res:mr.ad__scz__noapoe.or_ivw}} for SCZ (Supplementary Table S10).
  - NEW: With AD as exposure, the APOE-excluded estimates were {{res:mr.ad__mdd__noapoe.or_ivw}} for MDD, {{res:mr.ad__ptsd__noapoe.or_ivw}} for PTSD, {{res:mr.ad__insomnia__noapoe.or_ivw}} for insomnia and {{res:mr.ad__scz__noapoe.or_ivw}} for SCZ (Supplementary Table S10).

- ¶26
  - OLD: With MDD including UK Biobank, MDD → AD was {{res:mr.mdd_ukbb__ad.or_ivw}} and AD → MDD {{res:mr.ad__mdd_ukbb.or_ivw}}.
  - NEW: Including UK Biobank in the MDD file gave {{res:mr.mdd_ukbb__ad.or_ivw}} for MDD → AD and {{res:mr.ad__mdd_ukbb.or_ivw}} for AD → MDD.

- ¶27
  - OLD: In the FinnGen consistency analysis, no psychiatric trait was associated with FinnGen AD: MDD {{res:sensitivity_finngen.mr.mdd__ad_finngen.or_ivw}}, PTSD {{res:sensitivity_finngen.mr.ptsd__ad_finngen.or_ivw}}, insomnia {{res:sensitivity_finngen.mr.insomnia__ad_finngen.or_ivw}} and SCZ {{res:sensitivity_finngen.mr.scz__ad_finngen.or_ivw}} (Figure 4C).
  - OLD: In the reverse direction the FinnGen estimates were close to the null, from {{res:sensitivity_finngen.mr.ad_finngen__mdd.or_ivw}} for MDD to {{res:sensitivity_finngen.mr.ad_finngen__scz.or_ivw}} for SCZ.
  - NEW: In the FinnGen consistency analysis, no psychiatric trait was associated with FinnGen AD (MDD {{res:sensitivity_finngen.mr.mdd__ad_finngen.or_ivw}}, PTSD {{res:sensitivity_finngen.mr.ptsd__ad_finngen.or_ivw}}, insomnia {{res:sensitivity_finngen.mr.insomnia__ad_finngen.or_ivw}} and SCZ {{res:sensitivity_finngen.mr.scz__ad_finngen.or_ivw}}; Figure 4C), and the reverse-direction estimates were close to the null, from {{res:sensitivity_finngen.mr.ad_finngen__mdd.or_ivw}} for MDD to {{res:sensitivity_finngen.mr.ad_finngen__scz.or_ivw}} for SCZ.

## 05_discussion.md

- ¶2
  - OLD: Genome-wide, local and MR analyses gave no robust evidence of genetic overlap between MDD, PTSD, insomnia or SCZ and AD (Figures 2–4).
  - NEW: Across genome-wide, local and MR analyses, there was no robust evidence of genetic overlap between AD and MDD, PTSD, insomnia or SCZ (Figures 2–4).

- ¶2
  - OLD: Genome-wide correlations with AD were close to zero, and their upper confidence limits excluded positive values above {{res:power_ldsc.ad.ptsd.excluded_above}} to {{res:power_ldsc.ad.scz.excluded_above}}.
  - OLD: None of the {{res:lava_ukb.summary.bivar_tests_primary}} testable local correlations passed FDR correction.
  - NEW: Genome-wide correlations with AD were close to zero, with upper confidence limits that excluded positive values above {{res:power_ldsc.ad.ptsd.excluded_above}} to {{res:power_ldsc.ad.scz.excluded_above}}, and none of the {{res:lava_ukb.summary.bivar_tests_primary}} testable local correlations passed FDR correction.

- ¶2
  - OLD: Of the sixteen MR directions, only PTSD → AD passed FDR correction, and it did not withstand the pre-specified pleiotropy and overlap checks (Table 2).
  - NEW: PTSD → AD was the only one of sixteen MR directions to pass FDR correction, and it did not withstand the pre-specified pleiotropy and overlap checks (Table 2).

- ¶2
  - OLD: For DLB the picture differed: genome-wide correlations with MDD and PTSD passed FDR correction at the margin (FDR-corrected P {{res:ldsc_rg.main.dlb.mdd.p_fdr}} for both), but on a DLB heritability flagged as low power (Z {{res:ldsc_h2.main.dlb.h2_z}}).
  - NEW: DLB behaved differently, with genome-wide correlations with MDD and PTSD that passed FDR correction at the margin (FDR-corrected P {{res:ldsc_rg.main.dlb.mdd.p_fdr}} for both), on a heritability flagged as low power (Z {{res:ldsc_h2.main.dlb.h2_z}}).

- ¶3
  - OLD: The AD results agree with earlier LDSC analyses, which found no genetic correlation between clinically diagnosed AD and MDD [@gibson2017assessing#c1].
  - NEW: These AD results agree with earlier LDSC analyses that found no genetic correlation between clinically diagnosed AD and MDD [@gibson2017assessing#c1] and with a UK Biobank-free analysis reporting a negligible correlation with depression [@monereosanchez2021genetic#c1].

- ¶3
  - OLD: A UK Biobank-free analysis reported a negligible correlation with depression [@monereosanchez2021genetic#c1], and an early atlas of genetic correlations concluded that the genetic basis of AD is distinct from psychiatric conditions [@buliksullivan2015atlas#c8].
  - NEW: The first atlas of LDSC correlations likewise found the genetic basis of AD to be distinct from that of psychiatric conditions [@buliksullivan2015atlas#c8].

- ¶3
  - OLD: A recent study using the same AD and SCZ summary statistics as the present one reported genome-wide correlations near zero for depression and SCZ [@kumar2026genetic#c2; @kumar2026genetic#c9; @kumar2026genetic#c10].
  - OLD: Concordance with that study is therefore not independent replication [@kumar2026genetic#c9].
  - NEW: A recent study reported near-zero genome-wide correlations of AD with depression and SCZ using the same AD and SCZ summary statistics as the present one [@kumar2026genetic#c2; @kumar2026genetic#c9; @kumar2026genetic#c10], so agreement with it is not independent replication [@kumar2026genetic#c9].

- ¶3
  - OLD: Null genome-wide estimates can still coexist with substantial polygenic overlap when effects run in both directions [@monereosanchez2021genetic#c4; @monereosanchez2021genetic#c5].
  - NEW: Null genome-wide estimates can nonetheless coexist with substantial polygenic overlap when effects run in both directions [@monereosanchez2021genetic#c4; @monereosanchez2021genetic#c5].

- ¶4
  - OLD: Local analysis was intended to detect such opposing signals, which can cancel in a genome-wide estimate [@werme2022integrated#c1; @werme2022integrated#c3].
  - NEW: The local analysis was meant to detect such opposing signals, which can cancel in a genome-wide estimate [@werme2022integrated#c1; @werme2022integrated#c3].

- ¶4
  - OLD: With the UK Biobank reference, few loci carried local heritability in both traits, and the nominal AD × MDD correlations were split in sign ({{res:lava_exploratory.ad.mdd.nominal_positive_rho}} positive, {{res:lava_exploratory.ad.mdd.nominal_negative_rho}} negative).
  - NEW: With the UK Biobank reference, local heritability in both traits was uncommon, and the nominal AD × MDD correlations were split in sign ({{res:lava_exploratory.ad.mdd.nominal_positive_rho}} positive, {{res:lava_exploratory.ad.mdd.nominal_negative_rho}} negative).

- ¶4
  - OLD: These loci did not pass FDR correction and are exploratory (Supplementary Table S5).
  - NEW: These loci did not pass FDR correction and remain exploratory (Supplementary Table S5).

- ¶4
  - OLD: Kumar et al. reported 17 local AD–depression and 23 local AD–SCZ loci at an uncorrected threshold of P < 5 × 10⁻³, using the same LAVA locus partition [@kumar2026genetic#c3; @kumar2026genetic#c5; @kumar2026genetic#c11].
  - NEW: Kumar et al. reported 17 local AD–depression and 23 local AD–SCZ loci at an uncorrected threshold of P < 5 × 10⁻³ with the same LAVA locus partition [@kumar2026genetic#c3; @kumar2026genetic#c5; @kumar2026genetic#c11].

- ¶4
  - OLD: The difference from the present null result can reflect the threshold, the multiple-testing correction and the LD reference, which that report does not specify for the local analysis [@kumar2026genetic#c11].
  - NEW: The difference from the present null result may reflect the threshold, the multiple-testing correction and the LD reference, which that report does not specify for its local analysis [@kumar2026genetic#c11].

- ¶5
  - OLD: The reference panel mattered: with the 1000 Genomes panel, {{res:lava_g1000_fdr_pairs.summary.n_fdr_pairs_g1000}} primary locus–pairs passed FDR correction, but {{res:lava_g1000_fdr_pairs.summary.n_not_tested_ukb}} of them were not testable with the UK Biobank reference, and summed local heritability was higher with 1000 Genomes for every trait ({{res:lava_reference_diagnostic.supplementary.range}}-fold; Supplementary Table S7).
  - NEW: With the 1000 Genomes panel, {{res:lava_g1000_fdr_pairs.summary.n_fdr_pairs_g1000}} primary locus–pairs passed FDR correction, yet {{res:lava_g1000_fdr_pairs.summary.n_not_tested_ukb}} of them were not testable with the UK Biobank reference, and summed local heritability was higher with 1000 Genomes for every trait ({{res:lava_reference_diagnostic.supplementary.range}}-fold; Supplementary Table S7).

- ¶5
  - OLD: The LAVA developers recommend the UK Biobank reference for European-ancestry data because the smaller 1000 Genomes panel may inflate type 1 error and bias local heritability [@werme2025lava#c1; @werme2025lava#c2].
  - OLD: The pattern observed here is consistent with that concern (Supplementary Table S7).
  - NEW: The LAVA developers recommend the UK Biobank reference for European-ancestry data because the smaller 1000 Genomes panel may inflate type 1 error and bias local heritability [@werme2025lava#c1; @werme2025lava#c2], and the pattern observed here is consistent with that concern (Supplementary Table S7).

- ¶5
  - OLD: The recommendation rests on a report that has not been peer reviewed, and the present data cannot establish inflation, so the 1000 Genomes results are treated as a sensitivity analysis and not as findings (Supplementary Table S6).
  - NEW: Their recommendation rests on a report that has not been peer reviewed, and the present data cannot establish inflation, so the 1000 Genomes results are treated as a sensitivity analysis and not as findings (Supplementary Table S6).

- ¶5
  - OLD: The chromosome 17 loci containing MAPT and KANSL1 gave the same sign with both references (Supplementary Table S6), but they remained nominal and are not interpreted biologically.
  - NEW: The chromosome 17 loci containing MAPT and KANSL1 kept the same sign with both references (Supplementary Table S6) but remained nominal and are not interpreted biologically.

- ¶6
  - OLD: The inverse PTSD → AD estimate (OR {{res:mr.ptsd__ad.or_ivw}}) requires caution.
  - OLD: Its classification as sensitive to pleiotropy followed from the SIMEX MR-Egger intercept (P {{res:mr.ptsd__ad.simex_intercept_p}}), and the overlap-corrected MRlap estimate was not nominally significant (P {{res:mr.ptsd__ad.p_mrlap_corrected}}).
  - NEW: The inverse PTSD → AD estimate (OR {{res:mr.ptsd__ad.or_ivw}}) requires caution, because its classification as sensitive to pleiotropy followed from the SIMEX MR-Egger intercept (P {{res:mr.ptsd__ad.simex_intercept_p}}) and the overlap-corrected MRlap estimate was not nominally significant (P {{res:mr.ptsd__ad.p_mrlap_corrected}}).

- ¶6
  - OLD: With FinnGen AD as outcome, the estimate was not significant and its confidence interval was wide (OR {{res:sensitivity_finngen.mr.ptsd__ad_finngen.or_ivw}}).
  - OLD: Power was lower in FinnGen, with a minimum detectable OR of {{res:mr_ptsd_ad_finngen.ptsd__ad_finngen.min_detectable_or_plan}} against {{res:mr_ptsd_ad_finngen.ptsd__ad.min_detectable_or_plan}} with the primary AD GWAS.
  - NEW: With FinnGen AD as outcome, the estimate was not significant and had a wide confidence interval (OR {{res:sensitivity_finngen.mr.ptsd__ad_finngen.or_ivw}}), and power was lower there, with a minimum detectable OR of {{res:mr_ptsd_ad_finngen.ptsd__ad_finngen.min_detectable_or_plan}} against {{res:mr_ptsd_ad_finngen.ptsd__ad.min_detectable_or_plan}} with the primary AD GWAS.

- ¶7
  - OLD: A bias in the primary AD GWAS offers one possible explanation, because proxy-based AD GWAS can give misleading genetic correlations [@wu2024pervasive#c1].
  - NEW: One possible explanation is bias in the primary AD GWAS, since proxy-based AD GWAS can give misleading genetic correlations [@wu2024pervasive#c1].

- ¶7
  - OLD: In proxy GWAS of AD based on parental history, the non-AD component was negatively correlated with MDD and SCZ, reported as "cor. = −0.11, P = 0.012" and "cor. = −0.13, P = 8.3 × 10⁻³" [@wu2024pervasive#c4].
  - OLD: That study reported no value for PTSD [@wu2024pervasive#c4].
  - NEW: In proxy GWAS of AD based on parental history, the non-AD component correlated negatively with MDD and SCZ, reported as "cor. = −0.11, P = 0.012" and "cor. = −0.13, P = 8.3 × 10⁻³" [@wu2024pervasive#c4].

- ¶7
  - OLD: Without adjustment for survival bias, spurious negative genetic correlations between proxy AD GWAS and other health outcomes are expected [@wu2024pervasive#c5].
  - NEW: Without adjustment for survival bias, spurious negative genetic correlations with other health outcomes are expected [@wu2024pervasive#c5].

- ¶7
  - OLD: The primary AD GWAS combined clinical and proxy cases without releasing them separately [@wu2024pervasive#c6; @bellenguez2022new#c3], and meta-analysis alone does not remove this bias [@wu2024pervasive#c7].
  - NEW: The primary AD GWAS combined clinical and proxy cases without releasing them separately [@wu2024pervasive#c6; @bellenguez2022new#c3], and meta-analysis alone does not remove the bias [@wu2024pervasive#c7].

- ¶7
  - OLD: Extending the bias to PTSD is therefore an inference: given the genetic overlap of PTSD with MDD [@nievergelt2024genome#c7], an inverse estimate would be consistent with it.
  - NEW: Because that study reported no value for PTSD [@wu2024pervasive#c4], extending the bias to PTSD is an inference, and an inverse estimate would be consistent with it given the genetic overlap of PTSD with MDD [@nievergelt2024genome#c7].

- ¶7
  - OLD: FinnGen is not free of bias either, because its AD status comes from diagnostic codes and its controls were not age-matched, which may exacerbate survival bias [@wu2024pervasive#c8].
  - NEW: FinnGen is not free of bias either, as its AD status comes from diagnostic codes and its controls were not age-matched, which may exacerbate survival bias [@wu2024pervasive#c8].

- ¶8
  - OLD: The FinnGen and primary AD GWAS also differed in their genome-wide correlation with PTSD ({{res:sensitivity_finngen.ldsc.finngen.ptsd.rg}} against {{res:ldsc_rg.main.ad.ptsd.rg}}).
  - NEW: The two AD GWAS also differed in their genome-wide correlation with PTSD ({{res:sensitivity_finngen.ldsc.finngen.ptsd.rg}} with FinnGen against {{res:ldsc_rg.main.ad.ptsd.rg}} with the primary AD GWAS).

- ¶8
  - OLD: The FinnGen estimate did not survive correction across four tests (BH-adjusted P {{res:sensitivity_finngen.ldsc.finngen.ptsd.p_bh_within4}}), so chance cannot be excluded.
  - NEW: Because the FinnGen estimate did not survive correction across four tests (BH-adjusted P {{res:sensitivity_finngen.ldsc.finngen.ptsd.p_bh_within4}}), chance cannot be excluded.

- ¶8
  - OLD: Several explanations are possible for this difference (Figure 2), and none is established.
  - NEW: Several explanations are possible for this difference, and none is established (Figure 2).

- ¶9
  - OLD: The other MR directions were consistent with earlier work (Figure 4).
  - NEW: The remaining MR directions agreed with earlier work (Figure 4).

- ¶9
  - OLD: Genetic liability to MDD showed no association with AD (OR {{res:mr.mdd__ad.or_ivw}}), and genetic liability to insomnia showed none either (OR {{res:mr.insomnia__ad.or_ivw}}).
  - OLD: An earlier MR study that tested insomnia among other sleep phenotypes also found no causal effect of sleep patterns or MDD on AD [@huang2020sleep#c2; @huang2020sleep#c9].
  - NEW: Neither MDD nor insomnia liability was associated with AD (OR {{res:mr.mdd__ad.or_ivw}} and {{res:mr.insomnia__ad.or_ivw}}), in line with an earlier MR study that tested insomnia among other sleep phenotypes and found no causal effect of sleep patterns or MDD on AD [@huang2020sleep#c2; @huang2020sleep#c9].

- ¶9
  - OLD: For AD → insomnia, the MRlap-corrected estimate was nominally inverse ({{res:mr.ad__insomnia.beta_std_mrlap_corrected}}), in the same direction as an earlier report of AD liability and lower insomnia risk [@huang2020sleep#c1].
  - NEW: For AD → insomnia, the MRlap-corrected estimate was nominally inverse ({{res:mr.ad__insomnia.beta_std_mrlap_corrected}}), in the direction of an earlier report linking AD liability to a lower risk of insomnia [@huang2020sleep#c1].

- ¶9
  - OLD: Earlier reverse-direction associations depended on APOE ε4 [@huang2020sleep#c7], and the APOE-excluded AD → insomnia estimate here was {{res:mr.ad__insomnia__noapoe.or_ivw}}.
  - NEW: In that report, reverse-direction associations with sleep duration depended on APOE ε4 [@huang2020sleep#c7], and the APOE-excluded AD → insomnia estimate here was {{res:mr.ad__insomnia__noapoe.or_ivw}}.

- ¶9
  - OLD: Genetic liability to AD showed no association with MDD (OR {{res:mr.ad__mdd.or_ivw}}).
  - OLD: The SCZ → AD association was nominal only and did not pass FDR correction (FDR-corrected P {{res:mr.scz__ad.p_ivw_fdr}}).
  - NEW: AD liability showed no association with MDD (OR {{res:mr.ad__mdd.or_ivw}}), and the SCZ → AD association was nominal only, without passing FDR correction (FDR-corrected P {{res:mr.scz__ad.p_ivw_fdr}}).

- ¶10
  - OLD: The DLB GWAS had limited power for common variants of small effect [@chia2021genome#c8] and includes 2,591 cases, against more than 60,000 in recent AD GWAS [@watkins2026understanding#c1].
  - NEW: The DLB GWAS had limited power for common variants of small effect [@chia2021genome#c8] and included 2,591 cases, against more than 60,000 in recent AD GWAS [@watkins2026understanding#c1].

- ¶10
  - OLD: DLB is often missed or misdiagnosed as AD, and mixed pathology is common [@mckeith2017diagnosis#c3; @mckeith2017diagnosis#c4].
  - NEW: Many DLB cases are missed or misdiagnosed as AD, and mixed pathology is common [@mckeith2017diagnosis#c3; @mckeith2017diagnosis#c4].

- ¶10
  - OLD: Depressive symptoms are common in DLB [@mckeith2017diagnosis#c2; @watkins2026understanding#c6], so shared clinical features or misclassification could contribute to a genetic correlation.
  - NEW: Because depressive symptoms are common in DLB [@mckeith2017diagnosis#c2; @watkins2026understanding#c6], shared clinical features or misclassification could contribute to a genetic correlation.

- ¶10
  - OLD: MR could not address the DLB question: the minimum detectable ORs for psychiatric exposures on DLB ranged from {{res:mr.mdd__dlb.min_detectable_or}} to {{res:mr.insomnia__dlb.min_detectable_or}} (Table 2).
  - NEW: MR was not informative for DLB, with minimum detectable ORs for psychiatric exposures ranging from {{res:mr.mdd__dlb.min_detectable_or}} to {{res:mr.insomnia__dlb.min_detectable_or}} (Table 2).

- ¶11
  - OLD: The data do not support a causal effect of genetic liability to MDD, PTSD, insomnia or SCZ on AD (Table 2; Figure 4).
  - NEW: These results do not support a causal effect of genetic liability to MDD, PTSD, insomnia or SCZ on AD (Table 2; Figure 4).

- ¶11
  - OLD: This would be consistent with the view that part of the late-life association between depression and dementia reflects preclinical dementia [@livingston2024dementia#c1].
  - NEW: Such a pattern would be consistent with the view that part of the late-life association between depression and dementia reflects preclinical dementia [@livingston2024dementia#c1].

- ¶11
  - OLD: For DLB, the MR analyses had low power, and the absence of association there is not informative (Table 2).
  - NEW: The inference does not extend to DLB, for which the MR analyses had low power (Table 2).

- ¶12
  - OLD: Among the strengths of the design, hypotheses, thresholds and an interpretation rule were fixed in an analysis plan frozen before cross-trait analyses, and every departure is documented (Supplementary Table S1).
  - NEW: A strength of the study is that hypotheses, thresholds and an interpretation rule were fixed in an analysis plan frozen before cross-trait analyses, with every departure documented (Supplementary Table S1).

- ¶12
  - OLD: The primary MDD file excluded UK Biobank, which removed overlap with the primary AD GWAS by design (Table 1).
  - NEW: Overlap between the MDD and AD GWAS was removed by design, because the primary MDD file excluded UK Biobank (Table 1).

- ¶12
  - OLD: The local analysis used fixed per-pair seeds so that it can be reproduced exactly <!--depends:GATE3_RESULT--> (Supplementary Table S1).
  - NEW: Fixed per-pair seeds allow the local analysis to be reproduced exactly <!--depends:GATE3_RESULT--> (Supplementary Table S1).

- ¶13
  - OLD: Sample overlap through UK Biobank could not be removed for PTSD and insomnia [@bellenguez2022new#c5; @nievergelt2024genome#c3], and overlap biases MR toward the observational estimate [@mounier2023bias#c3].
  - NEW: Sample overlap through UK Biobank could not be removed for PTSD and insomnia [@bellenguez2022new#c5; @nievergelt2024genome#c3], and such overlap biases MR toward the observational estimate [@mounier2023bias#c3].

- ¶13
  - OLD: The primary AD GWAS includes proxy cases with lower specificity than a clinical diagnosis [@bellenguez2022new#c3; @bellenguez2022new#c8].
  - NEW: Proxy cases in the primary AD GWAS have lower specificity than a clinical diagnosis [@bellenguez2022new#c3; @bellenguez2022new#c8].

- ¶13
  - OLD: The psychiatric phenotypes were broad: depression cases were partly self-reported [@adams2025trans#c4], and PTSD cases were defined from diagnostic codes in health records [@nievergelt2024genome#c4].
  - NEW: Depression cases were partly self-reported [@adams2025trans#c4] and PTSD cases were defined from diagnostic codes in health records [@nievergelt2024genome#c4], so both psychiatric phenotypes were broad.

- ¶14
  - OLD: Future work would benefit from clinically diagnosed AD GWAS without proxy cases, or from separate release of case–control and proxy results [@wu2024pervasive#c6; @wu2024pervasive#c7].
  - NEW: Future studies would benefit from clinically diagnosed AD GWAS without proxy cases, or from separate release of case–control and proxy results [@wu2024pervasive#c6; @wu2024pervasive#c7].

- ¶14
  - OLD: A substantially larger DLB GWAS is needed before its genetic correlations with MDD and PTSD can be interpreted [@watkins2026understanding#c1].
  - NEW: Interpreting the DLB correlations with MDD and PTSD will require a substantially larger DLB GWAS [@watkins2026understanding#c1].

- ¶14
  - OLD: Narrower depression subtypes may show more concordant effects with AD than broad depression [@monereosanchez2021genetic#c7], and late-life psychiatric phenotypes would address the question of prodromal symptoms more directly than lifetime liability, because part of the late-life association between depression and dementia reflects preclinical dementia [@livingston2024dementia#c1].
  - NEW: Narrower depression subtypes may show more concordant effects with AD than broad depression [@monereosanchez2021genetic#c7], and late-life psychiatric phenotypes would address prodromal symptoms more directly than lifetime liability [@livingston2024dementia#c1].


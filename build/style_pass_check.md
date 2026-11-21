# Style-pass check: 30 sampled pairs (seed 20261123)

Independent review of build/style_pass_sample30.json. For each pair I checked meaning, citations (quote in sources/notes), {{res:}} placeholders, hedges and anchors. Placeholders, citation keys and anchors were also diffed by script. Where content left a sentence, I looked for it in the neighbouring sentence of the current manuscript file.

| id | sec | verdict | reason |
|---|---|---|---|
| 7 | 01_abstract.md | PASS | The pleiotropy clause and the overlap-corrected P ({{res:mr.ptsd__ad.p_mrlap_corrected}}) moved to the preceding abstract sentence ("classified as sensitive to pleiotropy and lost nominal significance after correction for sample overlap"). FinnGen OR is kept. |
| 11 | 02_introduction.md | PASS | Same claim; zhu#c1 ("most patients develop at least some NPS ... highly variable") still supports it; intro_nps anchor kept. |
| 12 | 02_introduction.md | PASS | Same 85% claim, kumar#c7 kept and supportive; "such a symptom" refers back to the previous sentence. |
| 13 | 02_introduction.md | PASS | Rewritten from passive to active voice only; 51%/65.2% and the three zhu citations unchanged. |
| 15 | 02_introduction.md | PASS (note) | Lead-in "Symptoms can also precede the diagnosis:" dropped. The point is still implied by "incident dementia" (sassi#c1), and sassi#c3 makes it explicit in para 3. Citations and HR 2.70 kept. |
| 18 | 02_introduction.md | PASS | The "10 to 14 years" claim and livingston#c4 moved into the preceding sentence (intro_psych). livingston#c1 still supports the remaining claim. |
| 22 | 02_introduction.md | PASS | Merge of two sentences; meng#c2 and livingston#c2 each stay on their own clause; intro_revcaus anchor kept. |
| 25 | 02_introduction.md | PASS (note) | Merge. The new "so" makes the lifetime-liability interpretation follow from genetic instruments; skrivankova#c7/c8 support this. "Bidirectional MR" became "applying it in both directions", which c4 still supports. |
| 28 | 02_introduction.md | PASS | "opposing directions" became "opposite sign"; werme#c1 still supports it; intro_local anchor kept. |
| 40 | 03_methods.md | PASS | Voice change only. |
| 44 | 03_methods.md | PASS (pre-existing) | The edit kept the meaning and both citations. The problem predates the edit: buliksullivan#c1 (intercept = confounding) and werme#c6 (overlap modelled as residual) do not directly support "need only Z scores and sample sizes". |
| 47 | 03_methods.md | PASS | Wording change only ("AD endpoint"); kurki citations unchanged. |
| 50 | 03_methods.md | PASS | Merge; MHC and APOE coordinates unchanged. |
| 60 | 03_methods.md | PASS | Merge; werme#c5/c6 still attached to the overlap clause. |
| 69 | 03_methods.md | PASS | Merge; hemani#c1 is attached to the TwoSampleMR clause. |
| 72 | 03_methods.md | PASS | "These were" became "The values were"; all prevalences and citations unchanged. |
| 83 | 04_results.md | PASS (note) | "All six traits ... except DLB" became "Every trait except DLB". The count "six" is dropped but the scope is unchanged. The h2 Z placeholder and the low-power flag are kept. |
| 87 | 04_results.md | PASS | "Both" became "These"; placeholders and low-power hedge unchanged. |
| 96 | 04_results.md | FAIL | Drops "few", the qualitative statement that few loci had local heritability in both traits. That statement explains why the number of bivariate tests is small. |
| 99 | 04_results.md | PASS | "were observed" became "occurred"; all nine placeholders and "nominal" kept. |
| 108 | 04_results.md | PASS | "were not testable" became "could not be tested". |
| 119 | 04_results.md | PASS | Absorbs the halved/doubled counts from id 120 (same pair group); placeholders attached to the same quantities. |
| 120 | 04_results.md | PASS (note) | Its counts moved to id 119. The text strings keep the meaning. Minor redundancy: "Across the eight DLB directions ... in any DLB direction". |
| 126 | 05_discussion.md | PASS | Merge; placeholders and "FDR" unchanged. |
| 138 | 05_discussion.md | PASS (note) | Lead-in "The reference panel mattered:" dropped. The contrast it announced is still stated by the rest of the sentence and the following text. Placeholders kept. |
| 143 | 05_discussion.md | PASS | Merge; "there" refers to FinnGen; OR and both min-detectable-OR placeholders kept. |
| 144 | 05_discussion.md | PASS | "possible explanation" hedge kept; wu#c1 supports it. |
| 147 | 05_discussion.md | PASS | "this bias" became "the bias"; citations unchanged. |
| 158 | 05_discussion.md | FAIL | Adds a causal link ("With 2,591 cases ... had limited power") that the old sentence did not make. The cited chia#c8 quote says "despite our large sample size, we had limited power", which runs against that framing. |
| 167 | 05_discussion.md | PASS | Rephrased; depends:GATE3_RESULT anchor kept. |

**Totals: 28 PASS, 2 FAIL.** Notes on PASS items are informational, and id 44 is a citation-support problem that predates the style edit.

## FAIL items and suggested minimal fixes

- **id 96 (04_results.md, para 10):** restore "few". Suggested: "Of the {{res:lava_ukb.summary.loci_analysed}} loci analysed with the UK Biobank reference, the few with local heritability in both traits of a primary pair allowed {{res:lava_ukb.summary.bivar_tests_primary}} bivariate tests across the eight primary pairs (Figure 3)."
- **id 158 (05_discussion.md, para 10):** drop the causal framing and keep two coordinated claims, each with its own citation. Suggested: "The DLB GWAS had limited power for common variants of small effect [@chia2021genome#c8] and included 2,591 cases, against more than 60,000 in recent AD GWAS [@watkins2026understanding#c1]."

## Other observation (not caused by the style pass)

- id 44: consider a citation that states LDSC/LAVA inputs (Z and N), or drop the "need only" justification.

## Resolution (2026-11-22)
- id 96: "few" restored ("the few with local heritability in both traits of a primary pair allowed ...").
- id 158: reverted to two linked claims with their own citations ("The DLB GWAS had limited power ... [chia2021genome#c8] and included 2,591 cases, against more than 60,000 in recent AD GWAS [watkins2026understanding#c1]").
- id 120 (note): redundant "Across the eight DLB directions" removed.
- id 44 (pre-existing): "LDSC and LAVA need only Z scores and sample sizes" now cited to buliksullivan2015atlas#c1 (LDSC requires only GWAS summary statistics) and werme2022integrated#c10 (new claim: LAVA can use Z scores directly, without p-values or effect sizes).

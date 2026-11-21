# Reading brief for source notes (Faz 5)

You are writing reading notes for a manuscript. Follow this brief exactly. Accuracy matters more than speed.

## The manuscript
Title: "Genetic overlap between neuropsychiatric traits and Alzheimer's disease and dementia with Lewy bodies: a local genetic correlation and bidirectional Mendelian randomization study" (Frontiers in Dementia, Original Research). Uses only public GWAS summary statistics: AD (Bellenguez 2022; FinnGen R13 clinical AD as sensitivity), DLB (Chia 2021), MDD (PGC MDD2025, Adams 2025, no 23andMe, no UK Biobank), PTSD (PGC-PTSD Freeze 3, Nievergelt 2024), insomnia (Watanabe 2022, UK Biobank-only open file), schizophrenia (PGC3, Trubetskoy 2022). Methods: LDSC via GenomicSEM (genome-wide rg), LAVA (local rg, UK Biobank LD reference), bidirectional two-sample MR (IVW multiplicative random effects; MR-Egger with I²GX and SIMEX; weighted median; weighted mode; MR-PRESSO; leave-one-out; Steiger filtering; MRlap for sample overlap; APOE-excluded re-analysis), coloc, STROBE-MR. Population prevalences used as assumptions: AD 0.05, DLB 0.005, MDD 0.15, PTSD 0.07, insomnia 0.10, SCZ 0.01 (each needs a primary source).

## Claims the manuscript may need to support (use these labels in "Relevance")
- I1 Burden and prognostic importance of neuropsychiatric symptoms (NPS) in dementia; NPS as early manifestations (MBI).
- I2 Epidemiological associations of depression, PTSD, insomnia, schizophrenia with dementia/AD/DLB; reverse causation and confounding problem.
- I3 Genetic approaches (genetic correlation, MR) to this problem; existing MR / rg findings and their limits: DLB rarely studied; APOE dominance; genome-wide rg can hide opposite local signals.
- M1 Description of each GWAS data source used (sample, ancestry, phenotype definition, UK Biobank / proxy content, cohorts).
- M2 Method descriptions: LDSC, GenomicSEM, LAVA, MR estimators and assumptions, MR-PRESSO, Steiger, I²GX/SIMEX, sample-overlap bias and MRlap, coloc, PLINK, 1000 Genomes, STROBE-MR, TwoSampleMR/MR-Base.
- M3 Population prevalence values (AD, DLB, MDD, PTSD, insomnia, SCZ).
- D1 Comparison with prior studies of psychiatric traits × AD/DLB (agreement, disagreement, reasons).
- D2 Proxy (parental history) AD GWAS biases; clinical vs proxy phenotype.
- D3 LD-reference / population mismatch (e.g. Finnish founder population); LDSC assumptions.
- D4 DLB clinical features (psychiatric symptoms, hallucinations, depression) and genetics; DLB GWAS power.
- D5 Biological interpretation supported by the source (pathways, loci) — only what the source states.
- D6 Limitations relevant to this design (ancestry, overlap, weak instruments, lifetime vs late-life phenotype, survival bias).

## Procedure for each source key
1. Read the WHOLE plain-text file `\\wsl$\Ubuntu\home\user\q1paper\sources\text\<key>.txt` with the Read tool, in chunks (offset/limit) until the end. Abstract-only reading is forbidden. Read introduction, methods, results, discussion, limitations, table and figure captions.
2. Write the note to `\\wsl$\Ubuntu\home\user\q1paper\sources\notes\<key>.md` using exactly the template below (all six headings, in this order, spelled exactly).
3. Claims: 3 to 8 claim lines per KEEP-worthy source; each line has the exact format
   `- c1 | <section, e.g. Methods> | "<verbatim excerpt>" | <what it supports in our manuscript, with label I1–D6>`
   - The excerpt MUST be copied character-for-character from the .txt file (the plain text, not memory, not a PDF). Copy a contiguous span of 8–40 words. Do not paraphrase, do not join non-adjacent sentences, do not fix typos, do not add or drop words. Avoid spans containing table fragments, reference numbers in brackets, or line-break artefacts if a cleaner contiguous span exists. Inside the quotes do not use the double-quote character; choose a span without double quotes.
   - Numbers (sample sizes, estimates) are very useful claims: copy them exactly as written.
   - Number claims c1, c2, … consecutively.
4. Decision: recommend KEEP (supports at least one concrete claim above, peer-reviewed, not superseded) or DROP (off-topic, methodologically weak, superseded, preprint when a published version exists, or redundant with a stronger source) with a one-line justification. Data-source and method papers actually used by the study are always KEEP.
5. Do NOT run any command, do NOT edit registry.csv, do NOT delete files. Only write note files.

## Template (copy exactly)
```
## Bibliographic record
Authors (first 3 + et al.); year; title; journal; DOI; study type; access route (PMC-XML or OA-PDF)

## Section-by-section reading log
- Abstract: …
- Introduction: …
- Methods: (design, sample, ancestry, phenotype definition, exposure/outcome, statistics)
- Results: (key estimates with CI/p, table/figure references)
- Discussion: …
- Limitations stated by authors: …
- Supplementary material: consulted / not available

## Quality appraisal
Sample size adequacy; bias risks; MR assumptions (if MR); peer-reviewed?; conflicts with other sources

## Relevance to this manuscript
Which labels (I1–D6) this source supports and how, or why it does not

## Decision
KEEP | DROP — one-line justification

## Claims
- c1 | <section> | "<verbatim excerpt>" | <what it supports (label)>
```
(For a DROP recommendation the Claims section may contain one line or be left with a single line `- none`.)

## Final answer to the orchestrator
Return a compact table: key | recommended decision | labels supported | number of claims | any problem (e.g. text file truncated, references only, wrong paper).

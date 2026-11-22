# Submission checklist — Frontiers in Dementia, Original Research

Build: 2026-11-22. Status: **not ready to submit** until the Gate 3 items below are closed.

## Files in this folder

| File | Content | Check |
|---|---|---|
| Manuscript.docx | Title page, abstract, keywords, main text, statements, references, Tables 1–2, figure captions | check_docx: one font (Times New Roman), 12 pt, black only |
| Figure1_design.tif … Figure4_mr.tif | Figures 1–4, RGB TIFF, 600 dpi, uploaded separately in order of citation | Frontiers accepts TIF/JPEG/EPS, RGB, ≥300 dpi |
| Supplementary_Tables.xlsx | Contents sheet + Supplementary Tables S1–S12 (sheets S1, S2, S3, S4a–b, S5a–b, S6a–c, S7, S8, S9a–b, S10a–b, S11, S12) | Every sheet copied from an existing output; no value computed in the build |
| Supplementary_File_S1_STROBE-MR.docx | STROBE-MR checklist (verbatim items, BMJ 2021 Table 3, CC BY 4.0) with location in the manuscript | check_docx clean |

## Checks run on this build

- [x] audit_manuscript.py: 2 errors, both the `[GATE3_RESULT]` placeholder (Methods, Discussion); 1 style warning (5 sentences start with "In the"). No other placeholder remains.
- [x] verify_refs.py: 38/38 references verified (Crossref / software record). Cited set = KEEP set = 38.
- [x] check_docx.py on Manuscript.docx and Supplementary_File_S1_STROBE-MR.docx: clean.
- [x] Word count (main text): 6,465 (limit 12,000). Figures 4, tables 2.
- [x] Abstract: one paragraph, no citations, figure or table references (Frontiers sets no word limit for this article type on the archived pages).
- [x] Keywords: 8 (Frontiers recommends 5–8).
- [x] Review type single-blind: no anonymized file needed.
- [x] Statements present: Data availability (GitHub repository; DOI archive on acceptance), Ethics, Author contributions (CRediT, single author), Funding, Acknowledgments (FinnGen verbatim; AI tool versions and models), Conflict of interest, Generative AI statement (agreed text, only place).
- [x] Every Supplementary Table / File cited in the text exists (S1–S12, File S1).

## Open before submission

1. **Gate 3** (end-to-end rerun, running in ~/q1paper_gate3; at 04_mr). When it finishes: `tools/compare_gate3.py`; if identical, fill `[GATE3_RESULT]` (Methods) and replace the `depends:GATE3_RESULT` marker (Discussion); rerun audit (must be 0 errors); rebuild.
2. **After Gate 3 (deferred to keep the comparison clean)** in `07_figures.R`, then rerun 07_figures / 07b_tables:
   - Table 1 / Figure 1 overlap notes: PTSD includes UK Biobank and FinnGen; MDD (without UK Biobank) includes FinnGen.
   - Figure 1 box 5 and Figure 4 panel C title "Independent AD sample" → "register-based AD GWAS without proxy cases (FinnGen)" (PTSD GWAS includes FinnGen, so "independent" is inaccurate).
   - Figure 4 header "plan §8 class" → plain wording ("classification under the pre-specified interpretation rule").
   - Then `tools/build_supplement.py` to regenerate the TIFFs.
3. **Investigator**: read Supplementary File S1 "Where reported" column; items marked partly reported or not discussed (5, 10c, 16b gene–environment equivalence, 17c) are stated honestly and may be accepted as they are or addressed in text.
4. **Submission system** (entered by the author, not in the files): author name, affiliation, ORCID 0000-0001-6575-8988, corresponding e-mail, suggested reviewers if requested, Research Topic selection if applicable.
5. **Repository**: private now; make public (or archive with a DOI) at acceptance, as stated in the Data availability statement.

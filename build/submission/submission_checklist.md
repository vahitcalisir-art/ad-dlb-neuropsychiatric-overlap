# Submission checklist — Frontiers in Dementia, Original Research

Build: 2026-11-22 16:07. Status: **ready to submit**; only the submission-system fields (item 1 below) are entered by the author.

## Files in this folder

| File | Content | Check |
|---|---|---|
| Manuscript.docx | Title page, abstract, keywords, main text, statements, references, Tables 1–2, figure captions | check_docx: one font (Times New Roman), 12 pt, black only |
| Figure1_design.tif … Figure4_mr.tif | Figures 1–4, RGB TIFF (LZW), 600 dpi, uploaded separately in order of citation | Frontiers accepts TIF/JPEG/EPS, RGB, ≥300 dpi |
| Supplementary_Tables.xlsx | Contents sheet + Supplementary Tables S1–S12 (sheets S1, S2, S3, S4a–b, S5a–b, S6a–c, S7, S8, S9a–b, S10a–b, S11, S12) | Every sheet copied from an existing output; no value computed in the build |
| Supplementary_File_S1_STROBE-MR.docx | STROBE-MR checklist (verbatim items, BMJ 2021 Table 3, CC BY 4.0) with location in the manuscript | check_docx clean |

## Checks run on this build

- [x] Gate 3 (end-to-end rerun from raw summary statistics in ~/q1paper_gate3, chain 01–07 plus 05c, 05d, 07b, 07c): `tools/compare_gate3.py` exit 0. results.json 3,795 values and 35 tables (419,585 cells) identical; 4 figures byte-identical. Ignored by an explicit metadata whitelist: 165 cells (file paths, run times, file timestamps). Not rerun: 03b (rescue of loci lost to worker failures) and the LAVA seed-check diagnostic; the rerun processed all loci from the start with the same seeds (build/gate3_comparison.md; deviation C11 in Supplementary Table S1).
- [x] Figure label fixes after Gate 3 (07_figures.R): Figure 1 box 5 and Figure 4 panel C "Register-based AD GWAS without proxy cases (FinnGen)"; Figure 1 overlap notes MDD "FinnGen", MDD with UKB "UKB; FinnGen", PTSD "UKB and FinnGen" (Table 1 already stated these); Figure 4 header "class under the pre-specified interpretation rule", wrapped to two lines. Comparison after the fix: only these label cells differ (3 in data_sources.csv, 32 in figure4_data.csv); all estimates identical (build/gate3_comparison_after_label_fix.md).
- [x] audit_manuscript.py: 0 errors; 1 style warning (5 sentences start with "In the").
- [x] verify_refs.py: 38/38 references verified (Crossref / software record). Cited set = KEEP set = 38.
- [x] check_docx.py on Manuscript.docx and Supplementary_File_S1_STROBE-MR.docx: clean.
- [x] Word count (main text): 6,602 (title page; limit 12,000). Figures 4, tables 2.
- [x] Abstract: one paragraph, no citations, figure or table references (Frontiers sets no word limit for this article type on the archived pages).
- [x] Keywords: 8 (Frontiers recommends 5–8).
- [x] Review type single-blind: no anonymized file needed.
- [x] Statements present: Data availability (GitHub repository; DOI archive on acceptance), Ethics, Author contributions (CRediT, single author), Funding, Acknowledgments (FinnGen verbatim; AI tool versions and models), Conflict of interest, Generative AI statement (agreed text, only place).
- [x] Every Supplementary Table / File cited in the text exists (S1–S12, File S1).
- [x] STROBE-MR items: item 5 and 16b in the text; 10c not applicable; 17c not discussed, with reason.

## Open before submission

1. **Submission system** (entered by the author, not in the files): author name, affiliation, ORCID 0000-0001-6575-8988, corresponding e-mail, suggested reviewers if requested, Research Topic selection if applicable.
2. **Repository**: private now; make public (or archive with a DOI) at acceptance, as stated in the Data availability statement.
3. **Backup bundle** `~/q1paper_git_backup_before_scrub.bundle`: delete after submission.

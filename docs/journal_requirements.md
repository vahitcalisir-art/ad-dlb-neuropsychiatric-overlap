# Frontiers in Dementia: author requirements (verified)

Accessed: 2026-11-19

Sources:
- A: https://www.frontiersin.org/journals/dementia/for-authors/article-types
- B: https://www.frontiersin.org/guidelines/author-guidelines and https://www.frontiersin.org/journals/dementia/for-authors/author-guidelines
- C: https://www.frontiersin.org/for-authors/where-to-publish/article-types (cross-journal overview, not journal-specific)
- D: published Frontiers in Dementia articles in Europe PMC (PMC11576301, 2024; PMC13613979, 2026)
- E: Frontiers_Template.docx in Frontiers_Word_Templates.zip (supplied by the author)

| Item | Requirement | Source | Matches §0? |
|---|---|---|---|
| Word limit (Original Research) | "maximum word count of 12,000" | A | Yes (WORDS_MAX 12000) |
| What counts | Main body, footnotes, in-text citations; excludes abstract, section titles, figure/table captions, funding, acknowledgments, references | B | Note only |
| Word/figure count on first page | "Please indicate the number of words and the number of figures and tables included in your manuscript on the first page." | B | **Not in build_docx title page** (pending) |
| Required structure | "1. Abstract 2. Introduction 3. Materials and Methods 4. Results 5. Discussion" | A | Yes |
| Abstract | Single paragraph, "should be structured, for example, according to the IMRAD format"; no citations, figures or tables | B | Yes: one paragraph in IMRAD order, no subheadings |
| Abstract word limit | Not stated on journal page A; 350 words on cross-journal page C | A, C | **Unconfirmed**; 350 used as the working ceiling |
| Figures/tables limit | Not stated on A; 15 on C | A, C | §3 Faz 3 (4 figures + 3 tables) is stricter |
| Keywords | "minimum of five and a maximum of eight" | B | Yes (meta.json has 8) |
| Line spacing | "The entire document should be single-spaced and must contain page and line numbers" | B | **No: §0 says double. config.json LINE_SPACING → single (Faz 0 step 4)** |
| Line and page numbers | Required | B | Yes |
| Language | American English | B | Yes |
| Gene symbols | Italic (HGNC) | B | Yes (§1.5-1 allows italic) |
| Figures | Submitted individually, in citation order; "300 dpi at final size"; width 85 mm or 180 mm; TIFF/JPEG (EPS on acceptance), RGB; smallest text ≥ 8 pt | B | **Partly: §1.5-4 and FIGURE_STYLE say PNG** (pending) |
| Figure captions | "placed at the end of the manuscript" | B | Yes (FLOAT_PLACEMENT=end) |
| Tables | "inserted at the end of the manuscript in an editable format"; caption immediately before the table | B | Yes |
| Reference style | Guidelines: either Harvard (author-date) or Vancouver (numbered); per-journal list did not load (help center blank, Zendesk link 404). Published Frontiers in Dementia articles (2024 editorial, 2026 Original Research) use **Harvard author-year** in-text citations, e.g. "(Bang et al., 2015)". Template E says Health journals use Vancouver, but this is generic. Both styles list the first six authors followed by et al., plus the DOI. | B, D, E | **No: §0 says Vancouver** (pending) |
| Generative AI | Use "must be acknowledged in the acknowledgements section of the manuscript and the methods section if applicable" and must list "the name, version, model, and source" of the tool; uploading prompts as supplementary files is encouraged | B | **Partly**: §1.5-6 puts Acknowledgments in only if there is a real thanks, and puts AI in a separate section (pending) |
| Data availability, ethics | Generated during submission; human research needs an ethics statement in Methods | B | Yes |
| Author contributions | Required, even for sole authors | B, E | Yes |
| Funding | Required section, with grant numbers | B | Yes |
| Conflict of interest | Template E wording: "The authors declare that the research was conducted in the absence of any commercial or financial relationships that could be …" | E | Yes |
| Scope summary | 200-word scope summary at submission (not published) | B | Add to FINAL_REPORT |
| APC | CHF 2,195 (A-type) | fees page | Add to FINAL_REPORT |

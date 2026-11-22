#!/usr/bin/env python3
"""Build the supplementary material and submission figures into build/submission/.

- Supplementary_Tables.xlsx: a Contents sheet plus one sheet per Supplementary Table (S1-S12). Every sheet is
  copied from an existing output (results/tables, analysis/logs) or, for S1, from analysis/deviations.md; no value
  is computed here.
- Supplementary_File_S1_STROBE-MR.docx: the STROBE-MR checklist (Skrivankova et al., BMJ 2021, Table 3, CC BY 4.0;
  item wording sliced verbatim from sources/text) with the location of each item in the manuscript.
- Figure1-4.tif: RGB TIFF copies of results/figures/*.png at their native 600 dpi (Frontiers accepts TIF/JPEG/EPS).
Usage: python3 tools/build_supplement.py
"""
import csv
import re
from pathlib import Path

from docx import Document
from docx.enum.section import WD_ORIENT
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Cm, Pt, RGBColor
from openpyxl import Workbook
from openpyxl.styles import Alignment, Font
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "build" / "submission"
OUT.mkdir(parents=True, exist_ok=True)
T = ROOT / "results" / "tables"
LOGS = ROOT / "analysis" / "logs"

# ---------------------------------------------------------------- S1: plan departures from deviations.md
EXCLUDE = {"C6", "C8", "C9"}          # sources and manuscript wording only; not departures from the analysis plan
KEEP_ITEMS = {"C7": {1, 2}}            # C7 items 3-5 concern manuscript wording and sources
WORDING = [("pre-registered", "pre-specified"), ("Faz 5 notes", "source notes")]  # manuscript terminology


def deviations_rows():
    text = (ROOT / "analysis" / "deviations.md").read_text(encoding="utf-8")
    rows = []
    for block in re.split(r"\n(?=## )", text)[1:]:
        head, _, body = block.partition("\n")
        head = head[3:].strip()
        m = re.match(r"(C\d+|D\d+)( addendum)?", head)
        entry = m.group(0)
        base = m.group(1)
        if base in EXCLUDE:
            continue
        date = re.search(r"\d{4}-\d{2}-\d{2}", head).group(0)
        title = re.split(r" — |\) — ", head, maxsplit=2)[-1].strip(" ()")
        lines = [l.rstrip() for l in body.strip().splitlines() if l.strip()]
        if base in KEEP_ITEMS:
            kept, cur = [], None
            for l in lines:
                mm = re.match(r"(\d+)\. ", l)
                if mm:
                    cur = int(mm.group(1))
                if cur in KEEP_ITEMS[base]:
                    kept.append(l)
            lines = kept
        body = "\n".join(lines)
        for a, b in WORDING:
            body = body.replace(a, b)
            title = title.replace(a, b)
        assert not re.search(r"[ğışĞİŞ]", body + title), f"non-English text in {entry}"
        rows.append([entry, date, title, body])
    return [["Entry", "Date", "Title", "Description (plan section, change, reason, timing relative to results)"]] + rows


def read_csv(path, delim=","):
    with open(path, encoding="utf-8") as f:
        return [r for r in csv.reader(f, delimiter=delim)]


def only_rows(rows, col, keep):
    i = rows[0].index(col)
    return [rows[0]] + [r for r in rows[1:] if keep(r[i])]


TABLES = [
    ("S1", "Departures from the frozen analysis plan",
     "Every change made after the analysis plan was frozen (SHA-256 checksum), with date, plan section, reason and "
     "whether results had been seen. C = data-processing correction; D = deviation from, or clarification of, a plan "
     "section. Entries that concern only sources or manuscript wording are not listed.", [("S1", deviations_rows)]),
    ("S2", "Harmonization and quality control: SNPs remaining after each step",
     "One row per summary-statistics file; columns give the number of SNPs remaining after each successive step "
     "(build mapping, removal of SNPs without rsID, non-autosomal SNPs, reference matching, allele mismatch, MAF, INFO, "
     "palindromic, MHC and multi-allelic filters). palindromic_rule records the rule applied to the file.",
     [("S2", lambda: read_csv(LOGS / "munge_counts.csv"))]),
    ("S3", "LAVA input for binary traits",
     "Case and control counts entered in LAVA, each equal to half the effective sample size, with the population "
     "prevalence used for the liability-scale local heritability.",
     [("S3", lambda: read_csv(LOGS / "lava_input_info.txt", "\t"))]),
    ("S4", "Genome-wide genetic correlation and heritability, main and sensitivity analyses",
     "S4a: LDSC genetic correlations for every run (main; MDD including UK Biobank; PTSD case/control file; APOE "
     "region removed; FinnGen). S4b: SNP heritability on the observed and liability scales.",
     [("S4a", lambda: read_csv(T / "ldsc_rg.csv")), ("S4b", lambda: read_csv(T / "ldsc_h2.csv"))]),
    ("S5", "Local genetic correlation with the UK Biobank reference (main analysis)",
     "S5a: primary locus-pairs with uncorrected P < 0.05 (nominal, exploratory; none passed FDR correction). "
     "S5b: all bivariate LAVA results with the UK Biobank reference.",
     [("S5a", lambda: read_csv(T / "lava_nominal_primary_ukb.csv")), ("S5b", lambda: read_csv(T / "lava_bivar_ukb.csv"))]),
    ("S6", "Reference panel sensitivity analysis (1000 Genomes)",
     "S6a: primary locus-pairs that passed FDR correction with the 1000 Genomes reference, with the UK Biobank result "
     "where testable. S6b: nominal UK Biobank primary loci re-examined with 1000 Genomes. S6c: all bivariate LAVA "
     "results with the 1000 Genomes reference.",
     [("S6a", lambda: read_csv(T / "supp_lava_g1000_fdr_pairs.csv")),
      ("S6b", lambda: read_csv(T / "lava_nominal_reference_check.csv")),
      ("S6c", lambda: read_csv(T / "lava_bivar_g1000.csv"))]),
    ("S7", "Summed local heritability by reference panel",
     "Ratio of summed local heritability with the 1000 Genomes reference to that with the UK Biobank reference, over "
     "loci analysed with both references.", [("S7", lambda: read_csv(T / "supp_lava_reference_panel_ratio.csv"))]),
    ("S8", "Strand-mismatch exclusion applied to the main LAVA analysis",
     "Locus-pairs re-estimated after removing palindromic SNPs whose allele frequency lay on the opposite side of 0.5 "
     "from the reference; main and check estimates side by side.", [("S8", lambda: read_csv(T / "lava_strand_check_ukb.csv"))]),
    ("S9", "Steiger filtering: prevalence sensitivity",
     "S9a: DLB directions with every population prevalence halved (0.5) and doubled (2). S9b: insomnia directions with "
     "the insomnia prevalence set to 0.30 instead of 0.10, other prevalences unchanged. IVW re-estimated on each "
     "retained set (descriptive).",
     [("S9a", lambda: read_csv(T / "mr_steiger_prevalence_dlb.csv")), ("S9b", lambda: read_csv(T / "mr_steiger_insomnia_prev030.csv"))]),
    ("S10", "Mendelian randomization: all directions and estimators",
     "S10a: every MR direction (primary; APOE-excluded; MDD including UK Biobank; FinnGen) with all estimators, "
     "heterogeneity and pleiotropy statistics, MRlap and the classification. b = log odds ratio. S10b: MRlap observed "
     "and corrected estimates (standardized betas).",
     [("S10a", lambda: read_csv(T / "mr_all.csv")), ("S10b", lambda: read_csv(T / "mr_mrlap.csv"))]),
    ("S11", "Instrument-level associations",
     "Final instruments of every MR direction (after F statistic, harmonization and Steiger filtering), with SNP-exposure "
     "and SNP-outcome associations on the log odds scale.", [("S11", lambda: read_csv(T / "supp_mr_instruments.csv"))]),
    ("S12", "Leave-one-out estimates",
     "IVW estimate (log odds ratio) of every MR direction re-estimated with each instrument left out in turn.",
     [("S12", lambda: read_csv(T / "supp_mr_leave_one_out.csv"))]),
]

NUM = re.compile(r"^-?\d+(\.\d+)?([eE][-+]?\d+)?$")


def cell(v):
    if NUM.match(v or ""):
        f = float(v)
        return int(f) if re.match(r"^-?\d+$", v) else f
    return v


wb = Workbook()
ws = wb.active
ws.title = "Contents"
ws.append(["Supplementary Table", "Sheet(s)", "Title", "Description"])
for c in ws[1]:
    c.font = Font(bold=True)
for no, title, legend, sheets in TABLES:
    ws.append([f"Supplementary Table {no}", ", ".join(s for s, _ in sheets), title, legend])
    for sheet, fn in sheets:
        rows = fn()
        sh = wb.create_sheet(sheet)
        sh.append([f"Supplementary Table {sheet}. {title}"])
        sh["A1"].font = Font(bold=True)
        for r in rows:
            sh.append([cell(v) for v in r])
        for c in sh[2]:
            c.font = Font(bold=True)
        if sheet == "S1":
            sh.column_dimensions["C"].width = 50
            sh.column_dimensions["D"].width = 120
            for r in sh.iter_rows(min_row=3):
                for c in r:
                    c.alignment = Alignment(wrap_text=True, vertical="top")
for col, w in zip("ABCD", (22, 16, 60, 120)):
    ws.column_dimensions[col].width = w
for r in ws.iter_rows(min_row=2):
    for c in r:
        c.alignment = Alignment(wrap_text=True, vertical="top")
wb.save(OUT / "Supplementary_Tables.xlsx")

# ---------------------------------------------------------------- STROBE-MR checklist (Supplementary File S1)
src = (ROOT / "sources" / "text" / "skrivankova2021strengthening2.txt").read_text(encoding="utf-8")
MARKERS = [("1", "1 Title and abstract "), ("2", "Introduction 2 Background "), ("3", "3 Objectives "),
           ("4", "Methods 4 Study design and data sources "), ("5", "5 Assumptions "),
           ("6", "6 Statistical methods: main analysis "), ("7", "7 Assessment of assumptions "),
           ("8", "8 Sensitivity analyses and additional analyses "), ("9", "9 Software and pre-registration "),
           ("10", "Results 10 Descriptive data "), ("11", "11 Main results "), ("12", "12 Assessment of assumptions "),
           ("13", "13 Sensitivity analyses and additional analyses "), ("14", "Discussion 14 Key results "),
           ("15", "15 Limitations "), ("16", "16 Interpretation "), ("17", "17 Generalisability "),
           ("18", "Other information 18 Funding "), ("19", "19 Data and data sharing "),
           ("20", "20 Conflicts of interest ")]
start = src.index("Table 3 STROBE-MR checklist")
pos, spans = start, []
for no, mk in MARKERS:
    i = src.index(mk, pos)
    spans.append((no, mk, i))
    pos = i + len(mk)
end = src.index(" SD=standard deviation", pos)
items = []
for k, (no, mk, i) in enumerate(spans):
    j = spans[k + 1][2] if k + 1 < len(spans) else end
    label = mk.strip()
    for sec in ("Introduction ", "Methods ", "Results ", "Discussion ", "Other information "):
        if label.startswith(sec):
            label = label[len(sec):]
    label = label[len(no) + 1:]
    items.append((no, label, src[i + len(mk):j].strip()))
    assert items[-1][2] in src

LOC = {
    "1": "Title; Abstract (methods sentence).",
    "2": "Introduction, paragraphs 1-3 (background and exposures; observational evidence and reverse causation; why "
         "genetic correlation and MR are informative).",
    "3": "Introduction, final paragraph (objectives); Materials and methods, Study design and analysis plan "
         "(hypotheses fixed in the frozen analysis plan); Mendelian randomization, first paragraph (MR estimates causal "
         "effects under the three instrumental variable assumptions).",
    "4": "a) Data sources; Table 1 (study populations, ancestry). Recruitment periods are given in the source GWAS "
         "publications (summary data only). b) Data sources; Table 1 (case and control numbers); no a priori power "
         "calculation; minimum detectable odds ratios reported (Mendelian randomization; Table 2). c) Harmonization and "
         "quality control; Mendelian randomization (instrument selection, clumping, F statistic, Steiger filtering); "
         "Supplementary Table S2. d) Data sources (case definitions of each GWAS, FinnGen register-based definition); "
         "Table 1. e) Ethics statement.",
    "5": "Mendelian randomization, first paragraph (relevance, independence and exclusion restriction) and third "
         "paragraph (InSIDE for MR-Egger; at least half of the weight from valid instruments for the weighted "
         "median; largest weights from valid instruments for the weighted mode).",
    "6": "a) Mendelian randomization (effects per unit increase in the log odds of genetic liability; MRlap on the "
         "standardized scale). b) Mendelian randomization (thresholds, clumping, F > 10, Steiger filtering). c) "
         "Mendelian randomization (multiplicative random-effects IVW; Wald ratio for a single instrument); covariates "
         "as adjusted in each source GWAS (summary data). d) Mendelian randomization (instruments absent from the "
         "outcome GWAS dropped without LD proxies). e) Multiple testing.",
    "7": "Mendelian randomization (F statistic, Steiger filtering and its prevalence sensitivity, MR-Egger intercept "
         "and SIMEX, I²GX, Cochran's Q and Rücker's Q′, MR-PRESSO, leave-one-out, pre-specified interpretation rule).",
    "8": "Mendelian randomization (sensitivity estimators, APOE-excluded analyses, MRlap, Steiger prevalence checks); "
         "Sensitivity analysis with FinnGen; Genome-wide genetic correlation (sensitivity files).",
    "9": "a) Software and reproducibility (software and versions, fixed seeds). b) Study design and analysis plan "
         "(plan frozen with a SHA-256 checksum before cross-trait analyses; not deposited in a public registry); "
         "Supplementary Table S1.",
    "10": "a) Table 1 (cases and controls of each GWAS); Supplementary Table S2 (SNPs at each quality-control step); "
          "Table 2 (instruments at each stage). b) Not applicable beyond Table 1 (summary statistics only). c) Not "
          "applicable: cohort-level estimates are not available from summary statistics. d) i. Data sources and "
          "Discussion (all samples of European ancestry). ii. Data sources (UK Biobank overlap by GWAS); LDSC "
          "cross-trait intercepts as an empirical index of overlap (Genome-wide genetic correlation); MRlap; the exact "
          "number of overlapping individuals is not available from summary data.",
    "11": "a) Supplementary Table S11. b) Results, Mendelian randomization; Figure 4; Table 2; Supplementary Table S10. "
          "c) Not applicable (estimates per unit log odds of genetic liability). d) Figure 4.",
    "12": "a) Results, Mendelian randomization (classification under the interpretation rule); Table 2. b) Table 2 "
          "(I²GX, Cochran's Q P, MR-Egger intercept P, MR-PRESSO global P); Supplementary Table S10.",
    "13": "a) Results, Mendelian randomization; Table 2; Supplementary Tables S10 and S12. b) Results (APOE-excluded, MDD "
          "including UK Biobank, FinnGen, Steiger prevalence checks); Supplementary Tables S9 and S10. c) Bidirectional "
          "MR for every pair (Results; Figure 4). d) Genome-wide and local genetic correlations (Results); comparison "
          "with observational studies (Introduction, Discussion). e) Supplementary Table S12 (leave-one-out, tabulated).",
    "14": "Discussion, first paragraphs; Conclusion.",
    "15": "Discussion, limitations paragraph (ancestry, sample overlap and its direction of bias, proxy cases, broad "
          "phenotypes, lifetime liability, selective survival, weak instruments and low power).",
    "16": "a) Discussion; Conclusion. b) Discussion (prodromal symptoms; APOE and proxy-case mechanisms; estimates "
          "interpreted as effects of genetic liability); gene-environment equivalence: Discussion, limitations paragraph. c) Discussion "
          "(interpretation of neuropsychiatric symptoms); no intervention effect sizes are inferred.",
    "17": "Discussion, limitations paragraph: (a) European ancestry only; (b) lifetime genetic liability versus late-life "
          "symptoms; (c) not discussed: the exposures are binary disorders analysed as genetic liability, and the summary-level "
          "estimators used here estimate a single effect per unit log odds, which does not allow comparison across "
          "levels of exposure.",
    "18": "Funding statement. Funding of the source studies is given in their publications.",
    "19": "Data availability statement (source of each GWAS; code and summary results repository).",
    "20": "Conflict of interest statement.",
}
assert set(LOC) == {n for n, _, _ in items}

import sys
sys.path.insert(0, str(ROOT / "tools"))
from build_docx import Builder  # same single-font / single-size / black normalisation as the manuscript
doc = Document()
nb = object.__new__(Builder)
import json
nb.doc, nb.font, nb.size = doc, "Times New Roman", 12
nb.cfg = json.loads((ROOT / "config.json").read_text(encoding="utf-8"))
nb.setup_styles()
sec = doc.sections[0]
sec.orientation = WD_ORIENT.LANDSCAPE
sec.page_width, sec.page_height = sec.page_height, sec.page_width
for side in ("left_margin", "right_margin", "top_margin", "bottom_margin"):
    setattr(sec, side, Cm(2))
st = doc.styles["Normal"]
st.font.name = "Times New Roman"
st.font.size = Pt(12)
st.font.color.rgb = RGBColor(0, 0, 0)
st.element.rPr.rFonts.set(qn("w:eastAsia"), "Times New Roman")


def para(text, bold=False):
    p = doc.add_paragraph()
    r = p.add_run(text)
    r.bold = bold
    r.font.name = "Times New Roman"
    r.font.size = Pt(12)
    r.font.color.rgb = RGBColor(0, 0, 0)
    return p


para("Supplementary File S1. STROBE-MR checklist", bold=True)
para("Genetic overlap between neuropsychiatric traits and Alzheimer's disease and dementia with Lewy bodies: a local "
     "genetic correlation and bidirectional Mendelian randomization study")
para("Checklist items are reproduced verbatim from Table 3 of Skrivankova VW, Richmond RC, Woolf BAR, et al. "
     "Strengthening the reporting of observational studies in epidemiology using mendelian randomisation (STROBE-MR): "
     "explanation and elaboration. BMJ 2021;375:n2233 (doi: 10.1136/bmj.n2233), published under the Creative Commons "
     "Attribution (CC BY 4.0) licence. The fourth column gives where each item is addressed in the manuscript.")
tab = doc.add_table(rows=1, cols=4)
nb._borders(tab)
for c, h in zip(tab.rows[0].cells, ("Item", "Section", "Checklist item", "Where reported")):
    c.text = ""
    r = c.paragraphs[0].add_run(h)
    r.bold = True
for no, label, text in items:
    row = tab.add_row().cells
    for c, v in zip(row, (no, label, text, LOC[no])):
        c.text = v
widths = (Cm(1.3), Cm(4), Cm(11.5), Cm(8.9))
for r in tab.rows:
    for c, w in zip(r.cells, widths):
        c.width = w
for r in tab.rows:
    for c in r.cells:
        for p in c.paragraphs:
            for run in p.runs:
                run.font.name = "Times New Roman"
                run.font.size = Pt(12)
                run.font.color.rgb = RGBColor(0, 0, 0)
for part in (doc.element.body, doc.styles.element):
    nb.normalize_part(part)
doc.save(OUT / "Supplementary_File_S1_STROBE-MR.docx")

# ---------------------------------------------------------------- figures
for png in sorted((ROOT / "results" / "figures").glob("Figure*.png")):
    im = Image.open(png)
    dpi = im.info.get("dpi", (600, 600))
    im.convert("RGB").save(OUT / (png.stem + ".tif"), dpi=tuple(round(d) for d in dpi), compression="tiff_lzw")

print("OK:", ", ".join(sorted(p.name for p in OUT.iterdir())))

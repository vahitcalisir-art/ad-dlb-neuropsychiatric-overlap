#!/usr/bin/env python3
"""Manuscript -> DOCX builder.

Tek font, tek punto, tek renk (siyah). Kalın ve italik serbest; başka hiçbir
biçim farkı üretilmez. Atıflar CITATION_STYLE ayarına göre yazar-yıl ya da numaralı (Vancouver) biçimlenir.
{{res:...}} yer tutucuları results/results.json'dan doldurulur.

Kullanım: python3 tools/build_docx.py [--meta supplement_meta.json --out supplement.docx]
"""
import argparse
import csv
import json
import re
import sys
from pathlib import Path

from docx import Document
from docx.enum.section import WD_ORIENT
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_LINE_SPACING
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Cm, Pt

ROOT = Path(__file__).resolve().parent.parent
W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"

CITE_RE = re.compile(r"\[(@[^\]]+)\]")
RES_RE = re.compile(r"\{\{res:([A-Za-z0-9_.\-]+)\}\}")
BLOCK_RE = re.compile(r"^\{\{(table|figure):([^|}]+)\|(.+)\}\}\s*$")
COMMENT_RE = re.compile(r"<!--.*?-->", re.S)
INLINE_RE = re.compile(r"(\*\*[^*]+\*\*|\*[^*]+\*)")


def load_json(p):
    with open(p, encoding="utf-8") as f:
        return json.load(f)


def res_walk(results, path):
    """results.json anahtarları nokta içerebilir (ör. ldsc_rg -> "main.ad.ptsd" -> rg); yol, en uzun eşleşen
    anahtar önce denenerek çözülür. Bulunamazsa None."""
    parts = path.split(".")

    def walk(cur, i):
        if i == len(parts):
            return cur
        if not isinstance(cur, dict):
            return None
        for j in range(len(parts), i, -1):
            k = ".".join(parts[i:j])
            if k in cur:
                v = walk(cur[k], j)
                if v is not None:
                    return v
        return None
    return walk(results, 0)


def res_lookup(results, path):
    cur = res_walk(results, path)
    if cur is None:
        sys.exit(f"HATA: results.json içinde '{path}' yok.")
    if isinstance(cur, (dict, list)):
        sys.exit(f"HATA: '{path}' bir yaprak değer değil.")
    return str(cur)


class Builder:
    def __init__(self, cfg, meta_file="meta.json"):
        self.cfg = cfg
        self.font = cfg["FONT"]
        self.size = float(cfg["FONT_SIZE_PT"])
        self.ms = ROOT / "manuscript"
        self.meta = load_json(self.ms / meta_file)
        rp = ROOT / "results" / "results.json"
        self.results = load_json(rp) if rp.exists() else {}
        self.order = []          # atıf anahtarları, ilk geçiş sırası
        self.table_no = 0
        self.figure_no = 0
        self.end_mode = cfg.get("FLOAT_PLACEMENT", "inline") == "end"
        self.style = cfg.get("CITATION_STYLE", "vancouver")
        self.labels = {}            # key -> (yazar etiketi, yıl+ek)
        self.counts_par = None
        self.deferred_tables = []   # (no, name, caption)
        self.deferred_figures = []  # (no, file, caption)
        self.doc = Document()

    # ---------- biçim normalizasyonu ----------
    def _set_rpr(self, rpr):
        for tag in ("rFonts", "sz", "szCs", "color", "highlight", "shd", "u"):
            for el in rpr.findall(W + tag):
                rpr.remove(el)
        rf = OxmlElement("w:rFonts")
        for a in ("ascii", "hAnsi", "cs", "eastAsia"):
            rf.set(qn("w:" + a), self.font)
        rpr.insert(0, rf)
        half = str(int(round(self.size * 2)))
        for tag in ("w:sz", "w:szCs"):
            el = OxmlElement(tag)
            el.set(qn("w:val"), half)
            rpr.append(el)
        col = OxmlElement("w:color")
        col.set(qn("w:val"), "000000")
        rpr.append(col)

    def normalize_part(self, root):
        """Bir XML parçasındaki tüm rPr'leri tek font/punto/siyaha zorlar."""
        for rpr in list(root.iter(W + "rPr")):
            self._set_rpr(rpr)
        # tema fontu ve renk kalıntıları
        for el in root.iter():
            for attr in list(el.attrib):
                if attr.endswith("Theme") or attr.endswith("themeColor") \
                        or attr.endswith("themeTint") or attr.endswith("themeShade"):
                    del el.attrib[attr]

    def setup_styles(self):
        styles_root = self.doc.styles.element
        # docDefaults
        dd = styles_root.find(W + "docDefaults")
        rpd = dd.find(W + "rPrDefault")
        if rpd is None:
            rpd = OxmlElement("w:rPrDefault")
            dd.insert(0, rpd)
        rpr = rpd.find(W + "rPr")
        if rpr is None:
            rpr = OxmlElement("w:rPr")
            rpd.append(rpr)
        self._set_rpr(rpr)
        # renkli hazır tablo stillerini kaldır (yalnız varsayılan tablo stili kalır)
        for st in styles_root.findall(W + "style"):
            if st.get(W + "type") == "table" and st.get(W + "default") != "1":
                styles_root.remove(st)
        for shd in list(styles_root.iter(W + "shd")):
            shd.getparent().remove(shd)
        for el in styles_root.iter():
            if el.get(W + "color") not in (None, "auto", "000000"):
                el.set(W + "color", "000000")
        # her stil için açık rPr
        for st in styles_root.findall(W + "style"):
            r = st.find(W + "rPr")
            if r is None:
                r = OxmlElement("w:rPr")
                st.append(r)
            self._set_rpr(r)
        self.normalize_part(styles_root)
        # numbering parçası varsa
        try:
            num = self.doc.part.numbering_part.element
            self.normalize_part(num)
        except Exception:
            pass
        normal = self.doc.styles["Normal"]
        pf = normal.paragraph_format
        ls = self.cfg["LINE_SPACING"]
        pf.line_spacing_rule = {"single": WD_LINE_SPACING.SINGLE,
                                "1.5": WD_LINE_SPACING.ONE_POINT_FIVE,
                                "double": WD_LINE_SPACING.DOUBLE}[ls]
        pf.space_before = Pt(0)
        pf.space_after = Pt(0)

    def setup_section(self):
        s = self.doc.sections[0]
        s.page_width, s.page_height = Cm(21.0), Cm(29.7)
        s.orientation = WD_ORIENT.PORTRAIT
        m = Cm(float(self.cfg["MARGIN_CM"]))
        s.top_margin = s.bottom_margin = s.left_margin = s.right_margin = m
        sp = s._sectPr
        if self.cfg.get("LINE_NUMBERS", True):
            ln = OxmlElement("w:lnNumType")
            ln.set(qn("w:countBy"), "1")
            ln.set(qn("w:restart"), "continuous")
            sp.append(ln)
        # sayfa numarası (alt bilgi, ortada)
        fp = s.footer.paragraphs[0]
        fp.alignment = WD_ALIGN_PARAGRAPH.CENTER
        run = fp.add_run()
        for kind, text in (("begin", None), (None, "PAGE"), ("end", None)):
            if kind:
                fc = OxmlElement("w:fldChar")
                fc.set(qn("w:fldCharType"), kind)
                run._r.append(fc)
            else:
                it = OxmlElement("w:instrText")
                it.set(qn("xml:space"), "preserve")
                it.text = text
                run._r.append(it)
        self._force_run(run)

    # ---------- run yardımcıları ----------
    def _force_run(self, run, bold=None, italic=None):
        run.font.name = self.font
        run.font.size = Pt(self.size)
        rpr = run._r.get_or_add_rPr()
        self._set_rpr(rpr)
        if bold is not None:
            run.bold = bold
        if italic is not None:
            run.italic = italic
        return run

    def add_inline(self, par, text, bold_all=False):
        for tok in INLINE_RE.split(text):
            if not tok:
                continue
            if tok.startswith("**") and tok.endswith("**"):
                self._force_run(par.add_run(tok[2:-2]), bold=True)
            elif tok.startswith("*") and tok.endswith("*") and len(tok) > 2:
                self._force_run(par.add_run(tok[1:-1]), italic=True,
                                bold=True if bold_all else None)
            else:
                self._force_run(par.add_run(tok), bold=True if bold_all else None)

    def para(self, text="", bold=False, align=None, indent_first=False):
        p = self.doc.add_paragraph()
        if align == "center":
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        elif align == "justify" and self.cfg.get("JUSTIFY", True):
            p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
        if indent_first:
            p.paragraph_format.first_line_indent = Cm(0.75)
        if text:
            self.add_inline(p, text, bold_all=bold)
        return p

    def blank(self):
        self.para("")

    # ---------- metin dönüşümleri ----------
    def resolve(self, text):
        text = COMMENT_RE.sub("", text)
        text = RES_RE.sub(lambda m: res_lookup(self.results, m.group(1)), text)

        def cite(m):
            keys = []
            for item in m.group(1).split(";"):
                key = item.strip().lstrip("@").split("#")[0].strip()
                if key not in self.order:
                    self.order.append(key)
                if key not in keys:
                    keys.append(key)
            if self.style == "author-year":
                keys.sort(key=lambda k: (self.labels[k][1], self.labels[k][0]))
                return "(" + "; ".join(f"{self.labels[k][0]}, {self.labels[k][1]}" for k in keys) + ")"
            nums = []
            for item in m.group(1).split(";"):
                key = item.strip().lstrip("@").split("#")[0].strip()
                if key not in self.order:
                    self.order.append(key)
                nums.append(self.order.index(key) + 1)
            nums = sorted(set(nums))
            # ardışıkları aralığa çevir: 1,2,3 -> 1-3
            out, i = [], 0
            while i < len(nums):
                j = i
                while j + 1 < len(nums) and nums[j + 1] == nums[j] + 1:
                    j += 1
                out.append(f"{nums[i]}–{nums[j]}" if j - i >= 2 else
                           ",".join(str(n) for n in nums[i:j + 1]))
                i = j + 1
            return "[" + ",".join(out) + "]"

        text = CITE_RE.sub(cite, text)
        text = re.sub(r"\s+([.,;:])", r"\1", text)
        return re.sub(r"[ \t]+", " ", text).strip()

    # ---------- bloklar ----------
    def add_table(self, name, caption, deferred=False):
        if not deferred:
            self.table_no += 1
            if self.end_mode:
                self.deferred_tables.append((self.table_no, name, self.resolve(caption)))  # atıf numarası metin sırasına göre
                return
        no = self.table_no if not deferred else deferred
        path = ROOT / "results" / "tables" / name
        if not path.exists():
            sys.exit(f"HATA: tablo dosyası yok: {path}")
        with open(path, encoding="utf-8") as f:
            rows = list(csv.reader(f))
        p = self.para()
        self._force_run(p.add_run(f"Table {no}. "), bold=True)
        self.add_inline(p, self.resolve(caption))
        t = self.doc.add_table(rows=len(rows), cols=len(rows[0]))
        t.alignment = WD_TABLE_ALIGNMENT.CENTER
        self._borders(t)
        for i, row in enumerate(rows):
            for j, val in enumerate(row):
                cell = t.cell(i, j)
                cp = cell.paragraphs[0]
                cp.paragraph_format.line_spacing_rule = WD_LINE_SPACING.SINGLE
                self._force_run(cp.add_run(val), bold=(i == 0))
        self.blank()

    def _borders(self, table):
        tbl = table._tbl
        tblPr = tbl.tblPr
        b = OxmlElement("w:tblBorders")
        for edge in ("top", "bottom", "insideH"):
            e = OxmlElement(f"w:{edge}")
            e.set(qn("w:val"), "single")
            e.set(qn("w:sz"), "4")
            e.set(qn("w:color"), "000000")
            b.append(e)
        for edge in ("left", "right", "insideV"):
            e = OxmlElement(f"w:{edge}")
            e.set(qn("w:val"), "nil")
            b.append(e)
        tblPr.append(b)

    def add_figure(self, file, caption):
        self.figure_no += 1
        path = ROOT / "results" / "figures" / file
        if not path.exists():
            sys.exit(f"HATA: şekil dosyası yok: {path}")
        if self.end_mode:
            # Frontiers: şekiller ayrı dosya olarak yüklenir, açıklamalar metin sonunda
            dest = ROOT / "build" / "figures"
            dest.mkdir(parents=True, exist_ok=True)
            from PIL import Image
            img = Image.open(path)
            dpi = img.info.get("dpi", (0, 0))[0]
            min_dpi = int(self.cfg.get("FIGURE_MIN_DPI", 300))
            if round(dpi) < min_dpi:
                sys.exit(f"HATA: {file} çözünürlüğü {dpi:.0f} dpi < {min_dpi} dpi. Şekil {min_dpi} dpi ile yeniden üretilmeli.")
            fmt = self.cfg.get("FIGURE_EXPORT_FORMAT", "tiff").lower()
            rgb = img.convert("RGB")
            if fmt == "tiff":
                rgb.save(dest / f"Figure{self.figure_no}.tif", compression="tiff_lzw", dpi=(dpi, dpi))
            else:
                rgb.save(dest / f"Figure{self.figure_no}.jpg", quality=95, dpi=(dpi, dpi))
            self.deferred_figures.append((self.figure_no, file, self.resolve(caption)))
            return
        p = self.doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p.add_run().add_picture(str(path), width=Cm(float(self.cfg["FIGURE_WIDTH_CM"])))
        c = self.para()
        self._force_run(c.add_run(f"Figure {self.figure_no}. "), bold=True)
        self.add_inline(c, self.resolve(caption))
        self.blank()

    def add_markdown(self, path):
        lines = path.read_text(encoding="utf-8").splitlines()
        buf = []

        def flush():
            if buf:
                txt = self.resolve(" ".join(s.strip() for s in buf))
                if txt:
                    self.para(txt, align="justify")
                buf.clear()

        for ln in lines:
            s = ln.rstrip()
            if not s.strip():
                flush()
                continue
            m = BLOCK_RE.match(s.strip())
            if m:
                flush()
                kind, a, cap = m.groups()
                (self.add_table if kind == "table" else self.add_figure)(a.strip(), cap.strip())
                continue
            if s.startswith("## "):
                flush()
                self.para(self.resolve(s[3:]), bold=True)
                continue
            if s.startswith("# "):
                flush()
                self.blank()
                self.para(self.resolve(s[2:]), bold=True)
                continue
            buf.append(s)
        flush()

    # ---------- kaynakça ----------
    @staticmethod
    def _authors(csl, max_n=6):
        names = []
        for a in csl.get("author", []):
            fam = a.get("family") or a.get("literal") or ""
            giv = a.get("given", "")
            ini = "".join(x[0] for x in re.split(r"[\s\-.]+", giv) if x)
            names.append(f"{fam} {ini}".strip())
        if len(names) > max_n:
            names = names[:max_n] + ["et al."]
        return ", ".join(names)

    def _csl(self, key):
        p = ROOT / "sources" / "meta" / f"{key}.json"
        if not p.exists():
            sys.exit(f"HATA: {key} için doğrulanmış künye yok (sources/meta/{key}.json). "
                     "Önce tools/verify_refs.py çalıştırılmalı.")
        return load_json(p)

    @staticmethod
    def _year(c):
        for k in ("published-print", "published-online", "issued", "published"):
            dp = (c.get(k) or {}).get("date-parts")
            if dp and dp[0] and dp[0][0]:
                return str(dp[0][0])
        return "n.d."

    def prepare_labels(self):
        """Yazar-yıl etiketleri; aynı etiket+yıl çakışırsa 2020a/2020b."""
        keys = []
        for sec in self.meta["sections"]:
            for g in CITE_RE.findall((self.ms / sec).read_text(encoding="utf-8")):
                for item in g.split(";"):
                    k = item.strip().lstrip("@").split("#")[0].strip()
                    if k and k not in keys:
                        keys.append(k)
        base = {}
        for k in keys:
            c = self._csl(k)
            au = c.get("author", [])
            fam = [a.get("family") or a.get("literal") or "Anonymous" for a in au] or ["Anonymous"]
            lab = fam[0] if len(fam) == 1 else (f"{fam[0]} and {fam[1]}" if len(fam) == 2 else f"{fam[0]} et al.")
            if not au or lab.startswith("Anonymous") or k in lab or self._year(c) == "n.d.":
                sys.exit(f"HATA: {k} için künyede yazar ya da yıl eksik; atıf etiketi üretilemiyor (sources/meta/{k}.json)")
            base[k] = (lab, self._year(c), (c.get("title") or "").lower())
        groups = {}
        for k, (lab, y, t) in base.items():
            groups.setdefault((lab, y), []).append((t, k))
        for (lab, y), items in groups.items():
            items.sort()
            for i, (_t, k) in enumerate(items):
                suf = "abcdefghijklmnopqrstuvwxyz"[i] if len(items) > 1 else ""
                self.labels[k] = (lab, y + suf)

    def format_ref_harvard(self, key):
        c = self._csl(key)
        mx = int(self.cfg.get("REF_MAX_AUTHORS", 6))
        names = []
        for a in c.get("author", []):
            fam = a.get("family") or a.get("literal") or ""
            giv = a.get("given", "")
            ini = " ".join(x[0] + "." for x in re.split(r"[\s.]+", giv) if x and x[0].isalpha())
            names.append(f"{fam}, {ini}".strip(", ") if ini else fam)
        if not names:
            au = "Anonymous"
        elif len(names) > mx:
            au = ", ".join(names[:mx]) + ", et al."
        elif len(names) == 1:
            au = names[0]
        else:
            au = ", ".join(names[:-1]) + ", and " + names[-1]
        title = (c.get("title") or "").rstrip(".")
        jr = c.get("container-title-short") or c.get("container-title") or ""
        vol = c.get("volume", "")
        pages = str(c.get("page", "") or c.get("article-number", "")).replace("-", "\u2013")
        if c.get("type") == "software-documentation":
            return (f"{au} ({self.labels[key][1]}). {title}. {jr}. Available at: {c.get('URL', '')} "
                    f"(commit {str(c.get('commit', ''))[:12]}; accessed {c.get('accessed', '')}).")
        s = f"{au} ({self.labels[key][1]}). {title}. {jr}"
        if vol:
            s += f" {vol}" + (f", {pages}" if pages else "")
        s += "."
        if c.get("DOI"):
            s += f" doi: {c['DOI']}"
        return s

    def format_ref(self, key):
        p = ROOT / "sources" / "meta" / f"{key}.json"
        if not p.exists():
            sys.exit(f"HATA: {key} için doğrulanmış künye yok (sources/meta/{key}.json). "
                     "Önce tools/verify_refs.py çalıştırılmalı.")
        c = load_json(p)
        title = (c.get("title") or "").rstrip(".")
        jr = c.get("container-title-short") or c.get("container-title") or ""
        if isinstance(jr, list):
            jr = jr[0] if jr else ""
        year = ""
        for k in ("published-print", "published-online", "issued", "published"):
            dp = c.get(k, {}).get("date-parts")
            if dp and dp[0] and dp[0][0]:
                year = str(dp[0][0])
                break
        vol, pages = c.get("volume", ""), c.get("page", "") or c.get("article-number", "")
        pages = str(pages).replace("-", "–")
        au = self._authors(c)
        s = f"{au}{'' if au.endswith('.') else '.'} {title}. {jr} ({year})"
        if vol:
            s += f" {vol}" + (f":{pages}" if pages else "")
        s += "."
        if c.get("DOI"):
            s += f" doi: {c['DOI']}"
        return s

    # ---------- ana akış ----------
    def main_text_words(self):
        n = 0
        for sec in self.meta.get("main_text_sections", []):
            for ln in (self.ms / sec).read_text(encoding="utf-8").splitlines():
                t = ln.strip()
                if not t or t.startswith("#") or BLOCK_RE.match(t):
                    continue
                n += len(self.resolve(t).split())
        return n

    def build(self, out):
        if self.style == "author-year":
            self.prepare_labels()
        self.setup_styles()
        self.setup_section()
        m = self.meta
        self.para(m["title"], bold=True, align="center")
        self.blank()
        if m.get("authors_line"):
            self.para(m["authors_line"], align="center")
        for aff in m.get("affiliations", []):
            self.para(aff, align="center")
        self.blank()
        if m.get("correspondence"):
            self.para("Correspondence: " + m["correspondence"])
        if m.get("keywords"):
            self.para("Keywords: " + "; ".join(m["keywords"]))
        if m.get("main_text_sections"):
            self.counts_par = self.para()
        for sec in m["sections"]:
            self.add_markdown(self.ms / sec)
        if self.order:
            self.blank()
            self.para("References", bold=True)
            if self.style == "author-year":
                for key in sorted(self.order, key=lambda k: (self.labels[k][0].lower(), self.labels[k][1])):
                    p = self.para(self.format_ref_harvard(key), align="justify")
                    p.paragraph_format.left_indent = Cm(0.75)
                    p.paragraph_format.first_line_indent = Cm(-0.75)
            else:
                for i, key in enumerate(self.order, 1):
                    self.para(f"{i}. {self.format_ref(key)}")
        if self.deferred_figures:
            self.blank()
            self.para("Figure legends", bold=True)
            for no, _f, cap in self.deferred_figures:
                c = self.para(align="justify")
                self._force_run(c.add_run(f"Figure {no}. "), bold=True)
                self.add_inline(c, self.resolve(cap))
        if self.deferred_tables:
            self.blank()
            self.para("Tables", bold=True)
            for no, name, cap in self.deferred_tables:
                self.add_table(name, cap, deferred=no)
        if self.counts_par is not None:
            saved = list(self.order)
            words = self.main_text_words()
            self.order = saved
            self.add_inline(self.counts_par, f"Word count: {words} (main text). "
                            f"Figures: {self.figure_no}. Tables: {self.table_no}.")
        # son güvence: tüm parçaları bir kez daha normalize et
        self.normalize_part(self.doc.styles.element)
        out.parent.mkdir(parents=True, exist_ok=True)
        self.doc.save(out)
        (ROOT / "build" / (out.stem + "_citation_order.json")).write_text(
            json.dumps(self.order, indent=1), encoding="utf-8")
        print(f"OK: {out}  | atıflanan benzersiz kaynak: {len(self.order)} | "
              f"tablo: {self.table_no} | şekil: {self.figure_no}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", default=str(ROOT / "config.json"))
    ap.add_argument("--meta", default="meta.json", help="manuscript/ altındaki meta dosyası")
    ap.add_argument("--out", default=None, help="build/ altındaki çıktı adı")
    a = ap.parse_args()
    cfg = load_json(a.config)
    out = ROOT / "build" / (a.out or cfg["OUTPUT_DOCX"])
    Builder(cfg, a.meta).build(out)


if __name__ == "__main__":
    main()

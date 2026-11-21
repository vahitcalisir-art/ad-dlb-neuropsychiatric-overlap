#!/usr/bin/env python3
"""DOCX biçim denetimi: tek font, tek punto, yalnız siyah, vurgu/gölge/tema yok.

Kullanım: python3 tools/check_docx.py build/manuscript.docx [--config config.json]
Çıkış kodu 0 = temiz, 1 = ihlal var.
"""
import argparse
import json
import re
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PARTS = re.compile(r"^word/(document|styles|numbering|footer\d*|header\d*|footnotes|endnotes)\.xml$")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("docx")
    ap.add_argument("--config", default=str(ROOT / "config.json"))
    a = ap.parse_args()
    cfg = json.loads(Path(a.config).read_text(encoding="utf-8"))
    font, half = cfg["FONT"], str(int(round(float(cfg["FONT_SIZE_PT"]) * 2)))
    errors = []
    with zipfile.ZipFile(a.docx) as z:
        for name in z.namelist():
            if not PARTS.match(name):
                continue
            x = z.read(name).decode("utf-8")
            for m in re.finditer(r"<w:rFonts\b([^>]*)/?>", x):
                attrs = dict(re.findall(r'w:(\w+)="([^"]*)"', m.group(1)))
                for k, v in attrs.items():
                    if k.endswith("Theme"):
                        errors.append(f"{name}: tema fontu ({k}={v})")
                    elif k in ("ascii", "hAnsi", "cs", "eastAsia") and v != font:
                        errors.append(f"{name}: yabancı font {v}")
            for tag in ("sz", "szCs"):
                for v in re.findall(rf'<w:{tag} w:val="(\d+)"', x):
                    if v != half:
                        errors.append(f"{name}: farklı punto w:{tag}={v} (beklenen {half})")
            for v in re.findall(r'<w:color w:val="([^"]+)"', x):
                if v.lower() not in ("000000", "auto"):
                    errors.append(f"{name}: renk {v}")
            if re.search(r'themeColor=', x):
                errors.append(f"{name}: tema rengi")
            if "<w:highlight" in x:
                errors.append(f"{name}: vurgulama (highlight)")
            for v in re.findall(r'<w:shd [^>]*w:fill="([^"]+)"', x):
                if v.lower() not in ("auto", "ffffff"):
                    errors.append(f"{name}: arka plan rengi {v}")
            if name == "word/styles.xml":
                dd = re.search(r"<w:docDefaults>.*?</w:docDefaults>", x, re.S)
                if not dd or f'w:ascii="{font}"' not in dd.group(0):
                    errors.append("styles.xml: docDefaults fontu açıkça tanımlı değil")
    uniq = sorted(set(errors))
    if uniq:
        print("BİÇİM İHLALİ:")
        for e in uniq:
            print("  -", e)
        sys.exit(1)
    print(f"BİÇİM TEMİZ: tek font ({font}), tek punto ({int(half)/2:g} pt), yalnız siyah.")


if __name__ == "__main__":
    main()

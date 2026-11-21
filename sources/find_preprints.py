#!/usr/bin/env python3
"""DOWNLOADED kayıtlardan tam metni yayımlanmış sürüm olmayanları (preprint / gönderilmiş taslak) listeler."""
import csv
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PRE = re.compile(r"biorxiv|medrxiv|arxiv|researchsquare|ssrn|preprints\.org", re.I)
for r in csv.DictReader(open(ROOT / "sources" / "registry.csv", encoding="utf-8")):
    if r["status"] != "DOWNLOADED":
        continue
    t = (ROOT / "sources" / "text" / f"{r['key']}.txt").read_text(encoding="utf-8", errors="ignore")[:6000].lower()
    flags = []
    if PRE.search(r["oa_url"]):
        flags.append("preprint-url")
    if "biorxiv" in t or "medrxiv" in t or "preprint" in t[:3000]:
        flags.append("preprint-text")
    if not r["oa_url"].startswith("https://www.ebi.ac.uk"):
        flags.append("pdf:" + r["oa_url"][:80])
    if flags:
        print(f"{r['key']:32s} pmcid={r['pmcid'] or '-':12s} " + " | ".join(flags))

#!/usr/bin/env python3
"""Okuma notlarını denetler (Faz 5): zorunlu başlıklar, Claims satır biçimi ve her alıntının
sources/text/<key>.txt içinde birebir geçmesi. Normalizasyon tools/audit_manuscript.py ile aynıdır,
böylece burada geçen bir alıntı derleme denetiminde de geçer.
Kullanım: python3 sources/check_notes.py [key ...]
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))
from audit_manuscript import norm, CLAIM_RE  # noqa: E402  (aynı normalizasyon ve satır deseni)

CFG = json.loads((ROOT / "config.json").read_text(encoding="utf-8"))

# Okuma denetimi (kullanıcı isteği, 2026-11-20): kaynağın düz metninde bulunan her ana bölüm için okuma
# günlüğünde dolu bir satır olmalı. Bölüm adları büyük harfle başlayan başlık sözcükleri olarak aranır.
SECTIONS = {
    "Introduction": r"\b(Introduction|INTRODUCTION|Background|BACKGROUND)\b",
    "Methods": r"\b(Methods|METHODS|Materials and methods|Materials and Methods|MATERIALS AND METHODS|Online Methods|Method)\b",
    "Results": r"\b(Results|RESULTS|Findings|FINDINGS)\b",
    "Discussion": r"\b(Discussion|DISCUSSION)\b",
}
EMPTY = re.compile(r"^\W*(n/?a|none|not (available|applicable|present|reported)|-|…)?\W*$", re.I)


def log_lines(nt):
    m = re.search(r"## Section-by-section reading log\s*\n(.*?)(?=\n## )", nt, re.S)
    out = {}
    for ln in (m.group(1) if m else "").splitlines():
        # "- Methods (Model and Materials and methods): ..." gibi parantezli etiketler de kabul edilir
        mm = re.match(r"\s*-\s*([A-Za-z ]+?)\s*(\([^)]*\))?\s*:\s*(.*)$", ln)
        if mm:
            out[mm.group(1).strip().lower()] = mm.group(3).strip()
    return out
# full reading notes (local, not in the repository) if present; otherwise the public notes
NOTES_DIR = ROOT / "build" / "notes_full" if (ROOT / "build" / "notes_full").is_dir() else ROOT / "sources" / "notes"
keys = sys.argv[1:] or sorted(p.stem for p in NOTES_DIR.glob("*.md"))
bad_total = 0
for key in keys:
    note = NOTES_DIR / f"{key}.md"
    txt = ROOT / "sources" / "text" / f"{key}.txt"
    if not note.exists():
        print(f"{key}: NOT YOK"); bad_total += 1; continue
    nt = note.read_text(encoding="utf-8")
    missing = [h for h in CFG["NOTE_REQUIRED_HEADINGS"] if h not in nt]
    dec = re.search(r"## Decision\s*\n\s*(KEEP|DROP)", nt)
    raw = txt.read_text(encoding="utf-8", errors="ignore") if txt.exists() else ""
    source = norm(raw)
    logs = log_lines(nt)
    present = [s for s, pat in SECTIONS.items() if re.search(pat, raw)]
    uncovered = [s for s in present
                 if len(logs.get(s.lower(), "")) < 20 or EMPTY.match(logs.get(s.lower(), ""))]
    if len(logs.get("abstract", "")) < 20:
        uncovered.insert(0, "Abstract")
    if not raw:
        uncovered = ["(kaynak metni yok)"]
    claims, bad, malformed = 0, [], []
    in_claims = False
    for ln in nt.splitlines():
        if ln.startswith("## "):
            in_claims = ln.strip() == "## Claims"
            continue
        if not in_claims or not ln.strip().startswith("- c"):
            continue
        m = CLAIM_RE.match(ln.strip())
        if not m:
            malformed.append(ln.strip()[:60]); continue
        claims += 1
        if norm(m.group(3)) not in source:
            bad.append(m.group(1))
    status = "OK" if not (missing or bad or malformed or uncovered) else "SORUN"
    if status != "OK":
        bad_total += 1
    print(f"{key}: {status} | karar={dec.group(1) if dec else '?'} | iddia={claims} | "
          f"bulunamayan={','.join(bad) or '-'} | biçim hatası={len(malformed)} | eksik başlık={missing or '-'} | "
          f"okunmamış bölüm={','.join(uncovered) or '-'}")
sys.exit(1 if bad_total else 0)

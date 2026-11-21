#!/usr/bin/env python3
"""Faz 5 düzeltmesi (2026-11-20): tam metni preprint veya gönderilmiş taslak olan kayıtları sıfırlar
(tam metin ve düz metin silinir, durum CANDIDATE) ve yayımlanmış sürümü yeniden indirir
(PMC XML: Europe PMC veya NCBI; Unpaywall'da preprint konumları atlanır). Okuma notları korunur;
alıntılar yeni metne karşı sources/check_notes.py ile denetlenir.
Kullanım: python3 sources/refetch_published.py key1 key2 ...
"""
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))
import sources as S  # noqa: E402

reg = S.load()
for key in sys.argv[1:]:
    r = reg[key]
    old = r.get("oa_url", "")
    for p in (ROOT / r["fulltext_path"] if r.get("fulltext_path") else None, ROOT / "sources" / "text" / f"{key}.txt"):
        if p and p.exists():
            p.unlink()
    r.update(status="CANDIDATE", fulltext_path="", sha256="", oa_url="", retrieved="",
             note=(r.get("note", "") + f" | refetch 2026-11-20: previous text was not the published version ({old[:90]})").strip(" |"))
    S.save(reg)
    res = S.fetch_one(reg, key)
    S.save(reg)
    print(f"{key}: {res} | {reg[key].get('oa_url', '')[:90]}")

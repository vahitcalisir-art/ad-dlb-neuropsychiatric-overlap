#!/usr/bin/env python3
"""KEEP kaynaklarının künyesini Crossref'ten doğrular, geri çekilme (retraction)
ve düzeltme durumunu kontrol eder, sources/meta/<key>.json yazar.

Hata durumları (çıkış kodu 1):
  - DOI Crossref'te yok
  - Crossref başlığı registry başlığıyla uyuşmuyor (benzerlik < 0.90)
  - Makale geri çekilmiş (Crossref updated-by / Europe PMC "Retracted Publication")
Kullanım: python3 tools/verify_refs.py
"""
import csv
import difflib
import json
import re
import sys
import time
from pathlib import Path

import requests

ROOT = Path(__file__).resolve().parent.parent
CFG = json.loads((ROOT / "config.json").read_text(encoding="utf-8"))
UA = {"User-Agent": f"q1-manuscript-system (mailto:{CFG['CONTACT_EMAIL']})"}


def clean(s):
    s = re.sub(r"<[^>]+>", "", s or "")
    return re.sub(r"[^a-z0-9 ]", "", s.lower()).strip()


def main():
    with open(ROOT / "sources" / "registry.csv", encoding="utf-8") as f:
        reg = [r for r in csv.DictReader(f) if r["status"] == "KEEP"]
    out_dir = ROOT / "sources" / "meta"
    out_dir.mkdir(parents=True, exist_ok=True)
    errors = []
    for r in reg:
        key, doi = r["key"], r["doi"].strip()
        if not doi:
            errors.append(f"{key}: DOI yok")
            continue
        c = requests.get(f"https://api.crossref.org/works/{doi}", headers=UA, timeout=60)
        if c.status_code != 200:
            errors.append(f"{key}: Crossref'te bulunamadı ({doi})")
            continue
        m = c.json()["message"]
        title = re.sub(r"<[^>]+>", "", (m.get("title") or [""])[0])
        sim = difflib.SequenceMatcher(None, clean(title), clean(r["title"])).ratio()
        if sim < 0.90:
            errors.append(f"{key}: başlık uyuşmazlığı ({sim:.2f}) Crossref='{title[:70]}' registry='{r['title'][:70]}'")
        upd = [u for u in m.get("updated-by", []) if "retract" in (u.get("type", "") + u.get("label", "")).lower()]
        e = requests.get("https://www.ebi.ac.uk/europepmc/webservices/rest/search",
                         params={"query": f'DOI:"{doi}" AND PUB_TYPE:"Retracted Publication"', "format": "json"},
                         headers=UA, timeout=60)
        epmc_retracted = e.status_code == 200 and e.json().get("hitCount", 0) > 0
        if upd or epmc_retracted:
            errors.append(f"{key}: GERİ ÇEKİLMİŞ YAYIN — kullanılamaz")
        corr = [u for u in m.get("updated-by", []) if "correct" in (u.get("type", "") + u.get("label", "")).lower()]
        meta = {
            "DOI": m.get("DOI", doi),
            "title": title,
            "container-title": (m.get("container-title") or [""])[0],
            "container-title-short": (m.get("short-container-title") or [""])[0],
            "author": [{k: a[k] for k in ("family", "given", "name") if k in a} | (
                {"literal": a["name"]} if "name" in a and "family" not in a else {}) for a in m.get("author", [])],
            "issued": m.get("issued", {}),
            "published-print": m.get("published-print", {}),
            "published-online": m.get("published-online", {}),
            "volume": m.get("volume", ""),
            "issue": m.get("issue", ""),
            "page": m.get("page", ""),
            "article-number": m.get("article-number", ""),
            "type": m.get("type", ""),
            "corrections": [u.get("DOI") for u in corr],
            "verified_title_similarity": round(sim, 3),
        }
        (out_dir / f"{key}.json").write_text(json.dumps(meta, indent=1, ensure_ascii=False), encoding="utf-8")
        flag = " (DÜZELTME VAR: notta değerlendir)" if corr else ""
        print(f"{key}: doğrulandı{flag}")
        time.sleep(0.3)
    if errors:
        print("\nKÜNYE HATALARI:")
        for e in errors:
            print("  -", e)
        sys.exit(1)
    print(f"\n{len(reg)} kaynak doğrulandı.")


if __name__ == "__main__":
    main()

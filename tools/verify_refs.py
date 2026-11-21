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
    return re.sub(r"\s+", " ", re.sub(r"[^a-z0-9 ]", "", re.sub(r"\s+", " ", s.lower()))).strip()


def get_retry(url, tries=4, **kw):
    """Geçici ağ hatalarında yeniden dener; sonunda başarısızsa None döner (çağıran HATA kaydeder)."""
    for i in range(tries):
        try:
            return requests.get(url, timeout=60, **kw)
        except requests.RequestException:
            time.sleep(5 * (i + 1))
    return None


def verify_software(r, out_dir, errors):
    """DOI'siz yazılım belgesi (GitHub README): commit GitHub API'de var mı ve dosya o committe duruyor mu
    doğrulanır; künye alanları (URL, commit, erişim tarihi) meta'ya yazılır."""
    key = r["key"]
    m = re.search(r"github\.com/([^/]+)/([^/]+)|githubusercontent\.com/([^/]+)/([^/]+)", r.get("oa_url", ""))
    commit = re.search(r"commit ([0-9a-f]{7,40})", r.get("journal", "") + " " + r.get("note", ""))
    if not m or not commit:
        errors.append(f"{key}: DOI yok ve GitHub URL/commit künyesi eksik")
        return
    owner, repo = [g for g in m.groups() if g][:2]
    c = get_retry(f"https://api.github.com/repos/{owner}/{repo}/commits/{commit.group(1)}",
                  headers={"User-Agent": "q1-manuscript-system", "Accept": "application/vnd.github+json"})
    if c is None or c.status_code != 200:
        errors.append(f"{key}: GitHub commit doğrulanamadı ({owner}/{repo}@{commit.group(1)})")
        return
    cj = c.json()
    meta = {"type": "software-documentation", "title": r["title"], "author": [{"family": "Werme", "given": "J"}, {"family": "de Leeuw", "given": "C A"}]
            if key == "werme2025lava" else [{"family": r.get("first_author", "")}],
            "issued": {"date-parts": [[int(r["year"])]]} if r.get("year", "").isdigit() else {},
            "URL": f"https://github.com/{owner}/{repo}", "commit": cj.get("sha", commit.group(1)),
            "commit_date": cj.get("commit", {}).get("committer", {}).get("date", ""),
            "accessed": r.get("retrieved", ""), "container-title": "GitHub repository " + f"{owner}/{repo}"}
    (out_dir / f"{key}.json").write_text(json.dumps(meta, indent=1, ensure_ascii=False), encoding="utf-8")
    print(f"{key}: yazılım belgesi doğrulandı ({owner}/{repo}@{meta['commit'][:12]})")


def main():
    with open(ROOT / "sources" / "registry.csv", encoding="utf-8") as f:
        reg = [r for r in csv.DictReader(f) if r["status"] == "KEEP"]
    out_dir = ROOT / "sources" / "meta"
    out_dir.mkdir(parents=True, exist_ok=True)
    errors = []
    for r in reg:
        key, doi = r["key"], r["doi"].strip()
        if not doi:
            if "github" in (r.get("oa_url", "") + r.get("journal", "")).lower():
                verify_software(r, out_dir, errors)
            else:
                errors.append(f"{key}: DOI yok")
            continue
        c = get_retry(f"https://api.crossref.org/works/{doi}", headers=UA)
        if c is None:
            errors.append(f"{key}: Crossref'e ulaşılamadı ({doi}); doğrulama tamamlanmadı")
            continue
        if c.status_code != 200:
            errors.append(f"{key}: Crossref'te bulunamadı ({doi})")
            continue
        m = c.json()["message"]
        title = re.sub(r"<[^>]+>", "", (m.get("title") or [""])[0])
        # Crossref keeps subtitles in a separate field; the registry title may include them
        sub = re.sub(r"<[^>]+>", "", (m.get("subtitle") or [""])[0])
        sim = max(difflib.SequenceMatcher(None, clean(t), clean(r["title"])).ratio()
                  for t in ([title, f"{title}: {sub}"] if sub else [title]))
        if sim < 0.90:
            errors.append(f"{key}: başlık uyuşmazlığı ({sim:.2f}) Crossref='{title[:70]}' registry='{r['title'][:70]}'")
        upd = [u for u in m.get("updated-by", []) if "retract" in (u.get("type", "") + u.get("label", "")).lower()]
        e = get_retry("https://www.ebi.ac.uk/europepmc/webservices/rest/search",
                      params={"query": f'DOI:"{doi}" AND PUB_TYPE:"Retracted Publication"', "format": "json"},
                      headers=UA)
        if e is None or e.status_code != 200:
            errors.append(f"{key}: geri çekilme denetimi (Europe PMC) tamamlanamadı")
            continue
        epmc_retracted = e.json().get("hitCount", 0) > 0
        if upd or epmc_retracted:
            errors.append(f"{key}: GERİ ÇEKİLMİŞ YAYIN — kullanılamaz")
        corr = [u for u in m.get("updated-by", []) if "correct" in (u.get("type", "") + u.get("label", "")).lower()]
        # Crossref may list group authors (consortia) first with sequence "first"; when personal authors exist,
        # group authors are placed after them so that the first author and the author-year label are correct
        # (e.g. Bulik-Sullivan 2015). Group-authored papers without personal authors keep the group author.
        auth = m.get("author", [])
        pers = [a for a in auth if "family" in a]
        grp = [a for a in auth if "family" not in a]
        reordered = bool(pers and grp and "family" not in auth[0])
        if pers and grp:
            auth = pers + grp
        meta = {
            "author_order_note": "group authors moved after personal authors" if reordered else "",
            "DOI": m.get("DOI", doi),
            "title": title,
            "container-title": (m.get("container-title") or [""])[0],
            "container-title-short": (m.get("short-container-title") or [""])[0],
            "author": [{k: a[k] for k in ("family", "given", "name") if k in a} | (
                {"literal": a["name"]} if "name" in a and "family" not in a else {}) for a in auth],
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

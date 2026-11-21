#!/usr/bin/env python3
"""Kaynak yaşam döngüsü: ara -> indir -> metne çevir -> karar (KEEP/DROP) -> sil.

Yalnız yasal açık erişim kanalları kullanılır: Europe PMC (PMC tam metin XML),
Unpaywall (yayıncı/depo OA PDF). Shadow-library (Sci-Hub vb.) KESİNLİKLE yasak.
Açık erişimi olmayan kaynak NO_ACCESS olur; kullanıcı PDF'i yasal yoldan
sources/inbox/<key>.pdf olarak koyarsa `ingest` ile alınır.

Komutlar:
  search "<sorgu>" [--max N]       Europe PMC'de ara, aday ekle (CANDIDATE)
  add-doi <DOI>                    Tek bir DOI'yi aday olarak ekle
  fetch [--key K]                  Adayların tam metnini indir (DOWNLOADED / NO_ACCESS)
  ingest                           sources/inbox/*.pdf dosyalarını al
  keep <key>                       Okuması bitmiş kaynağı KEEP yap
  drop <key> "<gerekçe>"           DROP: tam metin + düz metin silinir, gerekçe loglanır
  status                           Özet tablo
"""
import argparse
import csv
import datetime as dt
import hashlib
import json
import re
import shutil
import subprocess
import sys
import time
import unicodedata
from pathlib import Path

import requests

ROOT = Path(__file__).resolve().parent.parent
CFG = json.loads((ROOT / "config.json").read_text(encoding="utf-8"))
SRC = ROOT / "sources"
REG = SRC / "registry.csv"
FIELDS = ["key", "doi", "pmid", "pmcid", "title", "first_author", "year", "journal",
          "is_oa", "status", "fulltext_path", "sha256", "oa_url", "retrieved", "note"]
EPMC = "https://www.ebi.ac.uk/europepmc/webservices/rest"
UA = {"User-Agent": f"q1-manuscript-system (mailto:{CFG['CONTACT_EMAIL']})"}


def load():
    if not REG.exists():
        return {}
    with open(REG, encoding="utf-8") as f:
        return {r["key"]: r for r in csv.DictReader(f)}


def save(reg):
    REG.parent.mkdir(parents=True, exist_ok=True)
    with open(REG, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=FIELDS)
        w.writeheader()
        for r in reg.values():
            w.writerow({k: r.get(k, "") for k in FIELDS})


def sha256(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for b in iter(lambda: f.read(1 << 20), b""):
            h.update(b)
    return h.hexdigest()


def make_key(reg, author, year, title):
    a = unicodedata.normalize("NFKD", author or "anon").encode("ascii", "ignore").decode()
    a = re.sub(r"[^a-z]", "", a.lower()) or "anon"
    stop = {"a", "an", "the", "of", "and", "in", "on", "for", "to", "with", "is", "are"}
    w = next((x for x in re.findall(r"[a-z]+", (title or "").lower()) if x not in stop), "x")
    base, k, i = f"{a}{year}{w}", f"{a}{year}{w}", 1
    while k in reg:
        i += 1
        k = f"{base}{i}"
    return k


def get(url, **kw):
    for attempt in range(4):
        try:
            r = requests.get(url, headers=UA, timeout=60, **kw)
            if r.status_code == 429:
                time.sleep(5 * (attempt + 1))
                continue
            return r
        except requests.RequestException:
            time.sleep(3 * (attempt + 1))
    return None


def add_record(reg, rec):
    doi = (rec.get("doi") or "").lower()
    if doi and any(r["doi"].lower() == doi for r in reg.values()):
        return None
    key = make_key(reg, rec.get("first_author"), rec.get("year"), rec.get("title"))
    rec.update(key=key, status="CANDIDATE")
    reg[key] = rec
    return key


def cmd_search(a):
    reg = load()
    q = a.query
    if CFG.get("SEARCH_FROM_YEAR"):
        q = f"({q}) AND PUB_YEAR:[{CFG['SEARCH_FROM_YEAR']} TO 3000]"
    q += " AND (SRC:MED OR SRC:PMC)"
    added, cursor = 0, "*"
    while added < a.max:
        params = {"query": q, "format": "json", "resultType": "core", "pageSize": 100, "cursorMark": cursor}
        if a.sort:  # ör. "CITED desc" (Europe PMC); varsayılan imleçli sıralama yayın tarihi ağırlıklıdır
            params["sort"] = a.sort
        r = get(f"{EPMC}/search", params=params)
        if r is None or r.status_code != 200:
            sys.exit(f"Europe PMC erişilemedi: {r.status_code if r else 'bağlantı yok'}")
        js = r.json()
        res = js.get("resultList", {}).get("result", [])
        if not res:
            break
        for it in res:
            if "retracted" in json.dumps(it.get("pubTypeList", {})).lower():
                continue
            rec = {"doi": it.get("doi", ""), "pmid": it.get("pmid", ""), "pmcid": it.get("pmcid", ""),
                   "title": it.get("title", "").rstrip("."),
                   "first_author": (it.get("authorList", {}).get("author") or [{}])[0].get("lastName", ""),
                   "year": it.get("pubYear", ""),
                   "journal": (it.get("journalInfo", {}).get("journal", {}) or {}).get("title", ""),
                   "is_oa": it.get("isOpenAccess", "N"), "note": f"search: {a.query}"}
            if not rec["doi"]:
                continue
            if add_record(reg, rec):
                added += 1
            if added >= a.max:
                break
        nxt = js.get("nextCursorMark")
        if not nxt or nxt == cursor:
            break
        cursor = nxt
    save(reg)
    print(f"{added} aday eklendi. Toplam kayıt: {len(reg)}")


def cmd_add_doi(a):
    reg = load()
    r = get(f"{EPMC}/search", params={"query": f'DOI:"{a.doi}"', "format": "json", "resultType": "core"})
    res = r.json().get("resultList", {}).get("result", []) if r is not None and r.status_code == 200 else []
    if res:
        it = res[0]
        rec = {"doi": a.doi, "pmid": it.get("pmid", ""), "pmcid": it.get("pmcid", ""),
               "title": it.get("title", "").rstrip("."),
               "first_author": (it.get("authorList", {}).get("author") or [{}])[0].get("lastName", ""),
               "year": it.get("pubYear", ""), "journal": (it.get("journalInfo", {}).get("journal", {}) or {}).get("title", ""),
               "is_oa": it.get("isOpenAccess", "N"), "note": "manual DOI"}
    else:
        c = get(f"https://api.crossref.org/works/{a.doi}")
        if c is None or c.status_code != 200:
            sys.exit("DOI ne Europe PMC'de ne Crossref'te bulundu.")
        m = c.json()["message"]
        rec = {"doi": a.doi, "title": (m.get("title") or [""])[0],
               "first_author": (m.get("author") or [{}])[0].get("family", ""),
               "year": str((m.get("issued", {}).get("date-parts") or [[""]])[0][0]),
               "journal": (m.get("container-title") or [""])[0], "is_oa": "?", "note": "manual DOI"}
    k = add_record(reg, rec)
    save(reg)
    print(f"eklendi: {k}" if k else "zaten kayıtlı")


def xml_to_text(xml):
    xml = re.sub(r"<ref-list.*?</ref-list>", " ", xml, flags=re.S)   # kaynakça hariç
    xml = re.sub(r"<(table-wrap|fig)\b.*?</\1>", lambda m: " " + re.sub(r"<[^>]+>", " ", m.group(0)) + " ", xml, flags=re.S)
    txt = re.sub(r"<[^>]+>", " ", xml)
    import html
    return re.sub(r"\s+", " ", html.unescape(txt)).strip()


def pdf_to_text(pdf):
    if shutil.which("pdftotext"):
        out = subprocess.run(["pdftotext", "-layout", str(pdf), "-"], capture_output=True, text=True)
        if out.returncode == 0 and len(out.stdout) > 2000:
            return out.stdout
    from pypdf import PdfReader
    return "\n".join((p.extract_text() or "") for p in PdfReader(str(pdf)).pages)


def store(reg, key, path, url):
    txt = xml_to_text(path.read_text(encoding="utf-8", errors="ignore")) if path.suffix == ".xml" else pdf_to_text(path)
    if len(txt) < 3000:
        path.unlink(missing_ok=True)
        return False
    (SRC / "text").mkdir(parents=True, exist_ok=True)
    (SRC / "text" / f"{key}.txt").write_text(txt, encoding="utf-8")
    r = reg[key]
    r.update(status="DOWNLOADED", fulltext_path=str(path.relative_to(ROOT)), sha256=sha256(path),
             oa_url=url, retrieved=dt.date.today().isoformat())
    return True


def fetch_one(reg, key):
    r = reg[key]
    ft = SRC / "fulltext"
    ft.mkdir(parents=True, exist_ok=True)
    if r.get("pmcid"):
        url = f"{EPMC}/{r['pmcid']}/fullTextXML"
        x = get(url)
        if x is not None and x.status_code == 200 and "<body" in x.text:
            p = ft / f"{key}.xml"
            p.write_text(x.text, encoding="utf-8")
            if store(reg, key, p, url):
                return "PMC-XML"
        # Europe PMC REST yazar elyazmalarında 500 dönebiliyor; aynı PMC kaydı NCBI E-utilities ile alınır
        # (PubMed Central §1.1-6'da izinli kaynaktır).
        url = ("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pmc&id="
               + r["pmcid"].replace("PMC", ""))
        x = get(url)
        if (x is not None and x.status_code == 200 and "<body" in x.text
                and "does not allow downloading" not in x.text):
            p = ft / f"{key}.xml"
            p.write_text(x.text, encoding="utf-8")
            if store(reg, key, p, url):
                return "PMC-XML (NCBI)"
    if r.get("doi"):
        u = get(f"https://api.unpaywall.org/v2/{r['doi']}", params={"email": CFG["CONTACT_EMAIL"]})
        if u is not None and u.status_code == 200:
            locs = u.json().get("oa_locations") or []
            for loc in locs:
                pdf = loc.get("url_for_pdf")
                if not pdf:
                    continue
                # §1.3-4: yayımlanmış sürümü olan makalenin preprint'i kullanılmaz
                if loc.get("version") == "submittedVersion":
                    continue
                d = get(pdf, allow_redirects=True)
                if d is not None and d.status_code == 200 and d.content[:5] == b"%PDF-":
                    p = ft / f"{key}.pdf"
                    p.write_bytes(d.content)
                    if store(reg, key, p, pdf):
                        return "OA-PDF"
    r["status"] = "NO_ACCESS"
    return "NO_ACCESS"


def cmd_fetch(a):
    reg = load()
    keys = [a.key] if a.key else [k for k, r in reg.items() if r["status"] in ("CANDIDATE",)]
    for k in keys:
        res = fetch_one(reg, k)
        print(f"{k}: {res}")
        save(reg)
        time.sleep(0.5)


def cmd_ingest(a):
    reg = load()
    inbox = SRC / "inbox"
    for pdf in sorted(inbox.glob("*.pdf")) if inbox.exists() else []:
        key = pdf.stem
        if key not in reg:
            print(f"{pdf.name}: registry'de böyle bir anahtar yok, atlandı")
            continue
        dest = SRC / "fulltext" / pdf.name
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.move(str(pdf), dest)
        ok = store(reg, key, dest, "user-supplied (legal access)")
        print(f"{key}: {'DOWNLOADED' if ok else 'metin çıkarılamadı'}")
    save(reg)


def cmd_keep(a):
    reg = load()
    r = reg[a.key]
    note = SRC / "notes" / f"{a.key}.md"
    if r["status"] != "DOWNLOADED" or not note.exists():
        sys.exit("KEEP için kaynak indirilmiş ve okuma notu yazılmış olmalı.")
    r["status"] = "KEEP"
    save(reg)
    print(f"{a.key}: KEEP")


def cmd_drop(a):
    reg = load()
    r = reg[a.key]
    for p in (ROOT / r["fulltext_path"] if r.get("fulltext_path") else None,
              SRC / "text" / f"{a.key}.txt"):
        if p and p.exists():
            p.unlink()
    r.update(status="DROP", fulltext_path="", sha256="", note=(r.get("note", "") + f" | DROP: {a.reason}").strip(" |"))
    with open(SRC / "deleted.log", "a", encoding="utf-8") as f:
        f.write(f"{dt.datetime.now().isoformat(timespec='seconds')}\t{a.key}\t{r.get('doi','')}\t{a.reason}\n")
    save(reg)
    print(f"{a.key}: DROP (dosyalar silindi)")


def cmd_status(a):
    reg = load()
    c = {}
    for r in reg.values():
        c[r["status"]] = c.get(r["status"], 0) + 1
    print(json.dumps(c, indent=1, ensure_ascii=False))


def main():
    ap = argparse.ArgumentParser()
    sp = ap.add_subparsers(dest="cmd", required=True)
    s = sp.add_parser("search"); s.add_argument("query"); s.add_argument("--max", type=int, default=50)
    s.add_argument("--sort", default=None, help='Europe PMC sort, ör. "CITED desc"'); s.set_defaults(f=cmd_search)
    s = sp.add_parser("add-doi"); s.add_argument("doi"); s.set_defaults(f=cmd_add_doi)
    s = sp.add_parser("fetch"); s.add_argument("--key"); s.set_defaults(f=cmd_fetch)
    s = sp.add_parser("ingest"); s.set_defaults(f=cmd_ingest)
    s = sp.add_parser("keep"); s.add_argument("key"); s.set_defaults(f=cmd_keep)
    s = sp.add_parser("drop"); s.add_argument("key"); s.add_argument("reason"); s.set_defaults(f=cmd_drop)
    s = sp.add_parser("status"); s.set_defaults(f=cmd_status)
    a = ap.parse_args()
    a.f(a)


if __name__ == "__main__":
    main()

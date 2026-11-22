#!/usr/bin/env python3
"""Taslak denetimi — istisnasız kurallar.

1. Atıf bütünlüğü: her [@key#cN] -> registry'de KEEP, okuma notunda cN iddiası,
   iddianın birebir alıntısı kaynağın tam metninde gerçekten geçiyor, tam metin
   SHA-256'sı registry ile aynı.
2. Bölüm kuralları: Giriş'te her cümle atıflı; Tartışma'da her cümle atıflı ya da
   kendi bulgumuza bağlı; Bulgular'da her sayı results.json'dan; Özet'te her cümle
   bulguya ya da gövdedeki atıflı bir cümleye bağlı.
3. Kaynak sayısı [MIN, MAX]; KEEP kümesi = atıflanan küme; artık dosya yok.
4. Yapay zekâ izi taraması.
Çıktı: build/audit_report.md. Çıkış kodu 0 = geçti, 1 = ihlal var.
"""
import csv
import hashlib
import json
import re
import statistics
import sys
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CFG = json.loads((ROOT / "config.json").read_text(encoding="utf-8"))

CITE_RE = re.compile(r"\[(@[^\]]+)\]")
RES_RE = re.compile(r"\{\{res:[^}]+\}\}")
BLOCK_RE = re.compile(r"^\{\{(table|figure):")
ANCHOR_RE = re.compile(r"<!--id:([A-Za-z0-9_\-]+)-->")
FROM_RE = re.compile(r"<!--from:([A-Za-z0-9_\-]+)-->")
COMMENT_RE = re.compile(r"<!--.*?-->", re.S)
TF_RE = re.compile(r"\b(Supplementary\s+)?(Table|Figure|Tables|Figures)\s+S?\d+[A-Za-z]?(\s*(and|,|–|-)\s*S?\d+[A-Za-z]?)*")
CLAIM_RE = re.compile(r'^-\s*(c\d+)\s*\|\s*([^|]+?)\s*\|\s*"(.+)"\s*\|\s*(.+)$')

ABBR = ["et al.", "e.g.", "i.e.", "vs.", "cf.", "approx.", "Fig.", "No.", "Dr.", "Inc.", "Ltd.", "St."]

# İngilizce bilimsel metinde yapay zekâ üslubunu ele veren kalıplar (genişletilebilir)
AI_PHRASES = [
    r"\bdelv(e|es|ed|ing)\b", r"\btapestry\b", r"\bpivotal\b", r"\bintricate\b",
    r"\bmultifaceted\b", r"\brealm\b", r"\blandscape\b", r"\bunderscor(e|es|ed|ing)\b",
    r"\bshed(s|ding)? (new )?light\b", r"\bnavigat(e|es|ing) the\b", r"\bparamount\b",
    r"\bcrucial\b", r"\bvital role\b", r"\bplays? a (key|crucial|critical|pivotal|significant) role\b",
    r"\bit is (important|worth|crucial) to (note|mention|highlight)\b", r"\bnotably\b",
    r"\binterestingly\b", r"\bimportantly\b", r"\bremarkabl[ey]\b", r"\bgroundbreaking\b",
    r"\bcomprehensive (overview|understanding|analysis)\b", r"\bin today's\b",
    r"\bever[- ]evolving\b", r"\bin the (era|age) of\b", r"\bholistic\b", r"\bseamless(ly)?\b",
    r"\bleverag(e|es|ed|ing)\b", r"\bharness(es|ed|ing)?\b", r"\bfoster(s|ed|ing)?\b",
    r"\bgame[- ]chang", r"\bcutting[- ]edge\b", r"\bnot only\b.*\bbut also\b",
    r"\ba growing body of\b", r"\bin conclusion\b", r"\bin summary\b", r"\bto summari[sz]e\b",
    r"\bthis (section|paper|article|study) (will|aims to|seeks to|delves)\b",
    r"\bwill be (discussed|presented|examined|explored)\b", r"\bas (mentioned|noted|discussed) (above|earlier|previously)\b",
    r"\bnuanced\b", r"\brobust(ly)? (framework|understanding)\b", r"\bkey (insights?|takeaways?)\b",
    r"\bvaluable insights?\b", r"\bpaves? the way\b", r"\bunlock(s|ed|ing)?\b", r"\bsheds?\b",
    r"\bboasts?\b", r"\bmeticulous(ly)?\b", r"\bcommendabl[ey]\b", r"\bstands? as\b",
    r"\bserves? as a testament\b", r"\btestament to\b", r"\bunderpin(s|ned|ning)?\b",
    r"\bin light of\b", r"\bit should be noted\b", r"\bevidently\b", r"\bundeniabl[ey]\b",
]
TRANSITION_OPENERS = ["Furthermore", "Moreover", "Additionally", "In addition", "Consequently",
                      "Thus", "Hence", "Overall", "Taken together", "Collectively"]
FIRST_PERSON = re.compile(r"\b(we|our|ours|us|I|my|me)\b", re.I)


def norm(s):
    s = unicodedata.normalize("NFKC", s)
    s = s.replace("‐", "-").replace("‑", "-").replace("–", "-").replace("—", "-")
    s = s.replace("−", "-").replace("­", "")
    s = re.sub(r"[‘’“”\"']", "", s)
    s = re.sub(r"-\s+", "-", s)          # satır sonu tirelemesi
    s = re.sub(r"\s+", " ", s).lower()
    return s.strip()


def sha256(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for b in iter(lambda: f.read(1 << 20), b""):
            h.update(b)
    return h.hexdigest()


def split_sentences(par):
    t = par
    for i, a in enumerate(ABBR):
        t = t.replace(a, a.replace(".", f"§{i}§"))
    # ondalık sayıları ve yer tutucuları koru
    t = re.sub(r"(\d)\.(\d)", r"\1¤\2", t)
    parts = re.split(r"(?<=[.!?])\s+(?=[A-Z\[\(<{*])", t)
    out = []
    for p in parts:
        for i, a in enumerate(ABBR):
            p = p.replace(a.replace(".", f"§{i}§"), a)
        p = p.replace("¤", ".").strip()
        # cümle sonundan sonra yazılmış <!--id:..--> / <!--from:..--> önceki cümleye aittir
        m = re.match(r"^((?:<!--.*?-->\s*)+)(.*)$", p, re.S)
        if m and out:
            out[-1] += " " + m.group(1).strip()
            p = m.group(2).strip()
        if p:
            out.append(p)
    return out


def paragraphs(path):
    pars, buf = [], []
    for ln in path.read_text(encoding="utf-8").splitlines():
        s = ln.strip()
        if not s:
            if buf:
                pars.append(" ".join(buf))
                buf = []
            continue
        if s.startswith("#") or BLOCK_RE.match(s):
            if buf:
                pars.append(" ".join(buf))
                buf = []
            continue
        buf.append(s)
    if buf:
        pars.append(" ".join(buf))
    return pars


# full reading notes (local, not in the repository) if present; otherwise the public notes with shortened passages
NOTES_DIR = ROOT / "build" / "notes_full" if (ROOT / "build" / "notes_full").is_dir() else ROOT / "sources" / "notes"


def main():
    errors, warns = [], []
    reg_path = ROOT / "sources" / "registry.csv"
    with open(reg_path, encoding="utf-8") as f:
        registry = {r["key"]: r for r in csv.DictReader(f)}
    keep = {k for k, r in registry.items() if r["status"] == "KEEP"}

    # ---- okuma notları ve iddialar ----
    claims = {}
    for key in keep:
        r = registry[key]
        note = NOTES_DIR / f"{key}.md"
        if not note.exists():
            errors.append(f"[NOT] {key}: okuma notu yok")
            continue
        nt = note.read_text(encoding="utf-8")
        for req in CFG["NOTE_REQUIRED_HEADINGS"]:
            if req not in nt:
                errors.append(f"[NOT] {key}: zorunlu başlık eksik: {req}")
        claims[key] = {}
        for ln in nt.splitlines():
            m = CLAIM_RE.match(ln.strip())
            if m:
                claims[key][m.group(1)] = (m.group(2), m.group(3))
        ft = ROOT / r["fulltext_path"] if r.get("fulltext_path") else None
        if not ft or not ft.exists():
            errors.append(f"[TAM METİN] {key}: tam metin dosyası yok")
        elif sha256(ft) != r.get("sha256", ""):
            errors.append(f"[TAM METİN] {key}: SHA-256 uyuşmuyor (dosya değişmiş)")
        txt = ROOT / "sources" / "text" / f"{key}.txt"
        if not txt.exists():
            errors.append(f"[METİN] {key}: çıkarılmış düz metin yok (sources/text/{key}.txt)")
        if not (ROOT / "sources" / "meta" / f"{key}.json").exists():
            errors.append(f"[KÜNYE] {key}: Crossref doğrulaması yapılmamış")

    text_cache = {}

    def source_text(key):
        if key not in text_cache:
            p = ROOT / "sources" / "text" / f"{key}.txt"
            text_cache[key] = norm(p.read_text(encoding="utf-8", errors="ignore")) if p.exists() else ""
        return text_cache[key]

    # ---- bölüm denetimi ----
    meta = json.loads((ROOT / "manuscript" / "meta.json").read_text(encoding="utf-8"))
    rules = CFG["SECTION_RULES"]
    cited, used_claims = [], set()
    anchors_cited, from_refs = set(), []
    all_sentences, words = [], 0
    num_wl = [re.compile(p) for p in CFG["NUMBER_WHITELIST"]]
    method_terms = [re.compile(r"\b" + re.escape(t) + r"\b", re.I) for t in CFG["METHOD_TERMS_REQUIRING_CITATION"]]

    for sec in meta["sections"]:
        rule = rules.get(sec, "none")
        path = ROOT / "manuscript" / sec
        raw_all = path.read_text(encoding="utf-8")
        for bad in ("TODO", "TBD", "XXX", "[citation needed]", "??", "GATE3_RESULT"):
            if bad in raw_all:
                errors.append(f"[{sec}] yer tutucu/eksik işaret: {bad}")
        for pi, par in enumerate(paragraphs(path), 1):
            for si, s in enumerate(split_sentences(par), 1):
                loc = f"{sec} ¶{pi} c{si}"
                cites = CITE_RE.findall(s)
                has_cite = bool(cites)
                has_res = bool(RES_RE.search(s)) or bool(TF_RE.search(COMMENT_RE.sub("", s)))
                for a in ANCHOR_RE.findall(s):
                    if has_cite:
                        anchors_cited.add(a)
                from_refs += [(loc, x) for x in FROM_RE.findall(s)]
                plain = COMMENT_RE.sub("", RES_RE.sub(" ", CITE_RE.sub(" ", s)))
                plain_text = re.sub(r"\s+", " ", plain).strip()
                if not plain_text or rule == "none":
                    continue
                all_sentences.append((loc, plain_text))
                words += len(plain_text.split())

                # atıf geçerliliği
                for group in cites:
                    for item in group.split(";"):
                        item = item.strip()
                        m = re.fullmatch(r"@([A-Za-z0-9_\-]+)#(c\d+)", item)
                        if not m:
                            errors.append(f"[{loc}] atıf biçimi hatalı ({item}); doğru biçim [@anahtar#cN]")
                            continue
                        key, cid = m.groups()
                        if key not in cited:
                            cited.append(key)
                        if key not in keep:
                            errors.append(f"[{loc}] {key} registry'de KEEP değil")
                            continue
                        if cid not in claims.get(key, {}):
                            errors.append(f"[{loc}] {key}#{cid}: okuma notunda böyle bir iddia yok")
                            continue
                        used_claims.add((key, cid))
                        excerpt = claims[key][cid][1]
                        if norm(excerpt) not in source_text(key):
                            errors.append(f"[{loc}] {key}#{cid}: alıntı kaynak metninde birebir bulunamadı")

                # bölüm kuralları
                if rule == "cite_every_sentence" and not has_cite:
                    errors.append(f"[{loc}] atıfsız cümle: \"{plain_text[:90]}\"")
                elif rule == "cite_or_result" and not (has_cite or has_res):
                    errors.append(f"[{loc}] ne atıf ne bulgu bağlantısı var: \"{plain_text[:90]}\"")
                elif rule == "results":
                    if not (has_res or has_cite):
                        errors.append(f"[{loc}] Bulgular cümlesi results.json/tablo/şekle bağlı değil: \"{plain_text[:90]}\"")
                elif rule == "abstract":
                    if has_cite:
                        errors.append(f"[{loc}] Özet'te atıf olmaz")
                    if not (has_res or FROM_RE.search(s)):
                        errors.append(f"[{loc}] Özet cümlesi ne bulguya ne gövdedeki atıflı bir cümleye bağlı")
                elif rule == "methods":
                    if any(t.search(plain_text) for t in method_terms) and not has_cite:
                        errors.append(f"[{loc}] yöntem/veri/yazılım adı geçiyor ama atıf yok: \"{plain_text[:90]}\"")

                # sayı denetimi: bulgu sayıları yalnız results.json'dan
                if rule in ("results", "cite_or_result", "abstract"):
                    chk = TF_RE.sub(" ", plain_text)
                    for wl in num_wl:
                        chk = wl.sub(" ", chk)
                    if re.search(r"\d", chk) and not (rule == "cite_or_result" and has_cite):
                        errors.append(f"[{loc}] elle yazılmış sayı (results.json yer tutucusu kullanılmalı): \"{plain_text[:90]}\"")

                # yapay zekâ izi
                for pat in AI_PHRASES + CFG.get("EXTRA_BANNED_PATTERNS", []):
                    if re.search(pat, plain_text, re.I):
                        errors.append(f"[{loc}] yasak kalıp /{pat}/: \"{plain_text[:90]}\"")
                if "—" in plain_text or " -- " in plain_text:
                    errors.append(f"[{loc}] uzun tire (em dash) kullanımı")
                # data-provider acknowledgements that must be reproduced verbatim (config VERBATIM_REQUIRED, each with
                # its source page archived) are exempt from the first-person check only
                if CFG["PERSON"] == "passive" and FIRST_PERSON.search(plain_text) \
                        and plain_text not in CFG.get("VERBATIM_REQUIRED", {}):
                    errors.append(f"[{loc}] birinci şahıs: \"{plain_text[:90]}\"")
                if len(plain_text.split()) > CFG["MAX_SENTENCE_WORDS"]:
                    warns.append(f"[{loc}] çok uzun cümle ({len(plain_text.split())} kelime)")

    # yer tutucu çözümü: her {{res:...}} results.json'da bir yaprak değere çözülmeli (build_docx ile aynı kural)
    def res_walk(results, path):  # build_docx.res_walk ile aynı (docx bağımlılığı olmadan)
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
    rj = ROOT / "results" / "results.json"
    resj = json.loads(rj.read_text(encoding="utf-8")) if rj.exists() else {}
    for sec in meta["sections"]:
        for m in re.finditer(r"\{\{res:([A-Za-z0-9_.\-]+)\}\}", (ROOT / "manuscript" / sec).read_text(encoding="utf-8")):
            v = res_walk(resj, m.group(1))
            if v is None or isinstance(v, (dict, list)):
                errors.append(f"[{sec}] yer tutucu results.json'da yaprak değere çözülmüyor: {m.group(1)}")

    # künye: atıflanan her kaynağın doğrulanmış künyesinde yazar soyadı ve yıl olmalı (etikette anahtar kalmaz)
    for k in cited:
        mp = ROOT / "sources" / "meta" / f"{k}.json"
        if mp.exists():
            mj = json.loads(mp.read_text(encoding="utf-8"))
            fams = [a.get("family") or a.get("literal") for a in mj.get("author", [])]
            yr = any(((mj.get(f) or {}).get("date-parts") or [[None]])[0][0] for f in ("published-print", "published-online", "issued"))
            if not fams or not all(fams) or not yr:
                errors.append(f"[KÜNYE] {k}: künyede yazar soyadı ya da yıl eksik; atıf etiketi üretilemez")

    # şekil/tablo numaraları: bloklar metindeki sırayla numaralanır (FigureN_ dosya adı N ile eşleşmeli) ve
    # metindeki her "Figure N"/"Table N" anması var olan bir bloğa işaret etmeli; ilk anma sırası artan olmalı
    fig_blocks, tab_blocks, fig_mentions, tab_mentions = [], [], [], []
    for sec in meta["sections"]:
        for ln in (ROOT / "manuscript" / sec).read_text(encoding="utf-8").splitlines():
            mb = BLOCK_RE.match(ln.strip())
            if mb:
                full = re.match(r"^\{\{(table|figure):([^|}]+)\|", ln.strip())
                (fig_blocks if full.group(1) == "figure" else tab_blocks).append((sec, full.group(2).strip()))
                continue
            plain_ln = COMMENT_RE.sub("", ln)
            for mm in re.finditer(r"(?<!Supplementary )\b(Figure|Table)s?\s+(\d+)", plain_ln):
                (fig_mentions if mm.group(1) == "Figure" else tab_mentions).append((sec, int(mm.group(2))))
    for i, (sec, f) in enumerate(fig_blocks, 1):
        mf = re.match(r"Figure(\d+)_", f)
        if not mf or int(mf.group(1)) != i:
            errors.append(f"[{sec}] şekil numarası tutarsız: {i}. şekil bloğu '{f}' dosyasını kullanıyor")
    for kind, blocks, ments in (("Figure", fig_blocks, fig_mentions), ("Table", tab_blocks, tab_mentions)):
        seen = []
        for sec, n in ments:
            if n < 1 or n > len(blocks):
                errors.append(f"[{sec}] '{kind} {n}' anılıyor ama {len(blocks)} {kind.lower()} bloğu var")
            if n not in seen:
                if seen and n != max(seen) + 1 and n > max(seen):
                    errors.append(f"[{sec}] {kind} {n}, {kind} {max(seen) + 1} anılmadan önce anılıyor")
                seen.append(n)

    for loc, a in from_refs:
        if a not in anchors_cited:
            errors.append(f"[{loc}] Özet bağlantısı '{a}' gövdede atıflı bir cümleye işaret etmiyor")

    # ---- üslup istatistikleri ----
    lens = [len(t.split()) for _, t in all_sentences]
    if len(lens) > 20:
        cv = statistics.pstdev(lens) / statistics.mean(lens)
        if cv < CFG["MIN_SENTENCE_LENGTH_CV"]:
            errors.append(f"[ÜSLUP] cümle uzunlukları fazla tekdüze (CV={cv:.2f} < {CFG['MIN_SENTENCE_LENGTH_CV']})")
        opens = sum(1 for _, t in all_sentences if any(t.startswith(o) for o in TRANSITION_OPENERS))
        ratio = opens / len(all_sentences)
        if ratio > CFG["MAX_TRANSITION_OPENER_RATIO"]:
            errors.append(f"[ÜSLUP] bağlaçla başlayan cümle oranı yüksek ({ratio:.0%})")
        starts = {}
        for _, t in all_sentences:
            w2 = " ".join(t.split()[:2])
            starts[w2] = starts.get(w2, 0) + 1
        for w2, n in starts.items():
            if n >= 5:
                warns.append(f"[ÜSLUP] '{w2}…' ile başlayan {n} cümle")

    # ---- kaynak kümesi ----
    n = len(cited)
    if not (CFG["MIN_REFERENCES"] <= n <= CFG["MAX_REFERENCES"]):
        errors.append(f"[KAYNAK] atıflanan benzersiz kaynak {n}; izin verilen aralık "
                      f"{CFG['MIN_REFERENCES']}–{CFG['MAX_REFERENCES']}")
    for k in sorted(keep - set(cited)):
        errors.append(f"[KAYNAK] {k} KEEP ama metinde kullanılmıyor: ya kullanılmalı ya DROP edilip silinmeli")
    keep_files = {Path(registry[k]["fulltext_path"]).name for k in keep if registry[k].get("fulltext_path")}
    ft_dir = ROOT / "sources" / "fulltext"
    if ft_dir.exists():
        for f in ft_dir.iterdir():
            if f.is_file() and f.name not in keep_files:
                errors.append(f"[KAYNAK] artık dosya (silinmeli): sources/fulltext/{f.name}")
    for k, r in registry.items():
        if r["status"] not in ("KEEP", "DROP"):
            errors.append(f"[KAYNAK] {k}: karar verilmemiş (status={r['status']})")
    if words < CFG["MIN_WORDS"]:
        errors.append(f"[UZUNLUK] {words} kelime < asgari {CFG['MIN_WORDS']}")
    if words > CFG["MAX_WORDS"]:
        errors.append(f"[UZUNLUK] {words} kelime > azami {CFG['MAX_WORDS']}")

    # ---- rapor ----
    out = ROOT / "build" / "audit_report.md"
    out.parent.mkdir(exist_ok=True)
    rep = [f"# Denetim raporu", "", f"- Atıflanan benzersiz kaynak: {n}",
           f"- Kullanılan iddia sayısı: {len(used_claims)}", f"- Denetlenen cümle: {len(all_sentences)}",
           f"- Kelime (gövde, atıf/yer tutucu hariç): {words}", f"- HATA: {len(errors)}", f"- UYARI: {len(warns)}", ""]
    rep += ["## Hatalar"] + [f"- {e}" for e in errors] + ["", "## Uyarılar"] + [f"- {w}" for w in warns]
    out.write_text("\n".join(rep) + "\n", encoding="utf-8")
    print("\n".join(rep[:9]))
    for e in errors[:60]:
        print("  HATA", e)
    if len(errors) > 60:
        print(f"  … toplam {len(errors)} hata, tamamı build/audit_report.md içinde")
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()

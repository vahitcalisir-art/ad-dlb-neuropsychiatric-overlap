#!/usr/bin/env python3
"""Pair old (git tag pre-style-pass) and new sentences of the manuscript and write build/style_pass_diff.md.

Pairing is done within each paragraph (the style pass keeps the paragraph structure). Each new sentence is matched to
the old sentence(s) it most resembles: shared citation keys and results.json keys weigh most, then content words.
Old sentences merged into one new sentence form one pair. Unmatched old sentences are listed as removed so that a
reviewer can check that no claim was dropped. Also writes build/style_pass_pairs.json for the independent check.
Usage: python3 tools/style_pass_diff.py [section.md ...]
"""
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))
from audit_manuscript import split_sentences  # noqa: E402  same sentence splitter as the audit

SECS = sys.argv[1:] or ["01_abstract.md", "02_introduction.md", "03_methods.md", "04_results.md", "05_discussion.md"]
KEY = re.compile(r"@[A-Za-z0-9_\-]+#c\d+|\{\{res:[^}]+\}\}|\(Figure[^)]*\)|\(Table[^)]*\)|Supplementary (?:Table|File) S\d+")
STOP = set("the a an of and or to in on for with by was were is are be as at from that this these which its their it than not".split())


def paras(text):
    out, cur = [], []
    for ln in text.splitlines():
        if not ln.strip() or ln.startswith("#"):
            if cur:
                out.append(" ".join(cur)); cur = []
            if ln.startswith("#"):
                out.append(ln)
            continue
        cur.append(ln.strip())
    if cur:
        out.append(" ".join(cur))
    return out


def sig(s):
    keys = set(KEY.findall(s))
    words = {w for w in re.findall(r"[a-z]{3,}", KEY.sub(" ", s.lower())) if w not in STOP}
    return keys, words


def score(a, b):
    ka, wa = sig(a); kb, wb = sig(b)
    k = len(ka & kb) / max(1, len(ka | kb))
    w = len(wa & wb) / max(1, len(wa | wb))
    return 2 * k + w


pairs, md = [], ["# Style pass: old and new sentences", "",
                 "Old = git tag pre-style-pass; new = working tree. Pairs are matched within paragraphs; merged sentences are grouped.", ""]
for sec in SECS:
    old = subprocess.run(["git", "-C", str(ROOT), "show", f"pre-style-pass:manuscript/{sec}"],
                         capture_output=True, text=True, check=True).stdout
    new = (ROOT / "manuscript" / sec).read_text(encoding="utf-8")
    po, pn = paras(old), paras(new)
    md += [f"## {sec}", ""]
    if len(po) != len(pn):
        md += [f"**Paragraph count changed: {len(po)} → {len(pn)}; pairing done on the whole section.**", ""]
        po, pn = [" ".join(p for p in po if not p.startswith("#"))], [" ".join(p for p in pn if not p.startswith("#"))]
    for pi, (a, b) in enumerate(zip(po, pn), 1):
        if a.startswith("#") or a.startswith("{{"):
            if a != b:
                pairs.append({"sec": sec, "para": pi, "old": [a], "new": b})
                md += [f"- ¶{pi} (heading/block)", f"  - OLD: {a}", f"  - NEW: {b}", ""]
            continue
        so, sn = split_sentences(a), split_sentences(b)
        groups = {j: [] for j in range(len(sn))}
        for i, s in enumerate(so):
            if not sn:
                break
            j = max(range(len(sn)), key=lambda j: score(s, sn[j]))
            if score(s, sn[j]) > 0.05:
                groups[j].append(i)
        used = {i for v in groups.values() for i in v}
        for j, s in enumerate(sn):
            olds = [so[i] for i in groups[j]]
            if olds == [s]:
                continue
            pairs.append({"sec": sec, "para": pi, "old": olds, "new": s})
            old_lines = [f"  - OLD: {o}" for o in olds] or ["  - OLD: (none: new sentence)"]
            md += [f"- ¶{pi}"] + old_lines + [f"  - NEW: {s}", ""]
        for i, s in enumerate(so):
            if i not in used:
                pairs.append({"sec": sec, "para": pi, "old": [s], "new": None})
                md += [f"- ¶{pi} REMOVED", f"  - OLD: {s}", ""]
(ROOT / "build" / "style_pass_diff.md").write_text("\n".join(md) + "\n", encoding="utf-8")
(ROOT / "build" / "style_pass_pairs.json").write_text(json.dumps(pairs, indent=1, ensure_ascii=False), encoding="utf-8")
print(f"{len(pairs)} changed pairs written to build/style_pass_diff.md and build/style_pass_pairs.json")

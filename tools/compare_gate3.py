#!/usr/bin/env python3
"""Gate 3: compare the end-to-end rerun (~/q1paper_gate3/results) with the main results (results/).

Every leaf of results.json and every cell of results/tables/*.csv is compared as text (values are already
formatted strings, so equality is exact). Keys or files present in only one tree are listed separately: the main
tree also holds outputs of later descriptive scripts and the derived "text" block, which are not part of the chain.
Figures are compared byte-for-byte (informative only: PNG metadata may differ).
Table columns that hold run metadata only (file paths of the tree, run times, file timestamps) are ignored by an
explicit whitelist (META_COLS), which is printed in the report; any other difference is an error.
Writes build/gate3_comparison.md and exits 0 if no common value differs, 1 otherwise.
"""
import fnmatch
import csv
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
A = ROOT / "results"
B = Path(sys.argv[1]) if len(sys.argv) > 1 else Path.home() / "q1paper_gate3" / "results"
SKIP_TOP = {"text"}
# (table file glob, column): run metadata, not analysis results
META_COLS = [("ldsc_inputs.csv", "file"), ("mr_*.csv", "runtime_min"),
             ("mr_output_integrity.csv", "clumped_mtime"), ("mr_output_integrity.csv", "rds_mtime")]
NOT_RERUN = ["03b_lava_seeded_compare.R (rerun of loci missing after an out-of-memory failure; the chain processed all "
             "loci from the start with seeds): results.json lava_seeded_rerun, table lava_seeded_vs_unseeded_ukb.csv",
             "03_lava.R seedcheck mode (diagnostic only): results.json lava_seed_check, table lava_seed_check_ukb.csv"]


def is_meta(name, col):
    return any(fnmatch.fnmatch(name, g) and col == c for g, c in META_COLS)


def leaves(o, pre=""):
    if isinstance(o, dict):
        for k, v in o.items():
            yield from leaves(v, f"{pre}{k}" if not pre else f"{pre} › {k}")
    elif isinstance(o, list):
        for i, v in enumerate(o):
            yield from leaves(v, f"{pre}[{i}]")
    else:
        yield pre, "" if o is None else str(o)


ja = json.loads((A / "results.json").read_text(encoding="utf-8"))
jb = json.loads((B / "results.json").read_text(encoding="utf-8"))
for k in SKIP_TOP:
    ja.pop(k, None); jb.pop(k, None)
la, lb = dict(leaves(ja)), dict(leaves(jb))
common = sorted(set(la) & set(lb))
diff_json = [(k, la[k], lb[k]) for k in common if la[k] != lb[k]]
only_a = sorted(set(la) - set(lb)); only_b = sorted(set(lb) - set(la))

diff_tab, only_tab_a, only_tab_b, n_cells = [], [], [], 0
meta_ignored = {}
ta = {p.name for p in (A / "tables").glob("*.csv")}; tb = {p.name for p in (B / "tables").glob("*.csv")}
only_tab_a, only_tab_b = sorted(ta - tb), sorted(tb - ta)
for name in sorted(ta & tb):
    ra = list(csv.reader(open(A / "tables" / name, encoding="utf-8")))
    rb = list(csv.reader(open(B / "tables" / name, encoding="utf-8")))
    if len(ra) != len(rb) or (ra and rb and ra[0] != rb[0]):
        diff_tab.append((name, "shape/header", f"{len(ra)} rows vs {len(rb)} rows"))
        continue
    for i, (x, y) in enumerate(zip(ra, rb)):
        for j, (u, v) in enumerate(zip(x, y)):
            n_cells += 1
            col = ra[0][j] if j < len(ra[0]) else str(j)
            if u != v and is_meta(name, col):
                meta_ignored[(name, col)] = meta_ignored.get((name, col), 0) + 1
            elif u != v:
                diff_tab.append((name, f"row {i} col {ra[0][j] if j < len(ra[0]) else j}", f"{u} vs {v}"))

def h(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()
fa = {p.name: h(p) for p in (A / "figures").glob("*.png")}; fb = {p.name: h(p) for p in (B / "figures").glob("*.png")}
fig_same = sorted(n for n in set(fa) & set(fb) if fa[n] == fb[n]); fig_diff = sorted(n for n in set(fa) & set(fb) if fa[n] != fb[n])

ok = not diff_json and not diff_tab
md = ["# Gate 3 comparison", "", f"Main: ~/{A.relative_to(Path.home())}", f"Rerun: ~/{B.relative_to(Path.home())}", "",
      f"- results.json leaves compared: {len(common)}; differing: {len(diff_json)}",
      f"- table files compared: {len(ta & tb)} ({n_cells} cells); differing cells/files: {len(diff_tab)}",
      f"- metadata cells ignored (whitelist below): {sum(meta_ignored.values())}",
      f"- figures byte-identical: {len(fig_same)}; differing bytes (informative): {len(fig_diff)}",
      f"- verdict: {'IDENTICAL for all common values' if ok else 'DIFFERENCES FOUND'}", ""]
md += ["## Metadata whitelist (ignored columns)"] + [f"- {g} › {c}: {sum(n for (t, k), n in meta_ignored.items() if k == c and fnmatch.fnmatch(t, g))} differing cells ignored" for g, c in META_COLS] + [""]
md += ["## Scripts not rerun in the Gate 3 tree"] + [f"- {x}" for x in NOT_RERUN] + [""]
md += ["## Differing results.json values"] + [f"- {k}: main `{a}` | rerun `{b}`" for k, a, b in diff_json[:500]] + [""]
md += ["## Differing table cells"] + [f"- {n} {w}: {d}" for n, w, d in diff_tab[:500]] + [""]
md += ["## Only in main results.json (not produced by the chain)"] + [f"- {k}" for k in only_a] + [""]
md += ["## Only in rerun results.json"] + [f"- {k}" for k in only_b] + [""]
md += ["## Tables only in main"] + [f"- {n}" for n in only_tab_a] + ["", "## Tables only in rerun"] + [f"- {n}" for n in only_tab_b] + [""]
md += ["## Figures with differing bytes"] + [f"- {n}" for n in fig_diff] + [""]
(ROOT / "build" / "gate3_comparison.md").write_text("\n".join(md), encoding="utf-8")
print("\n".join(md[:10]))
sys.exit(0 if ok else 1)

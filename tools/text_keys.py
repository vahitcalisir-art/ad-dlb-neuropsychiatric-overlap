#!/usr/bin/env python3
"""Derive count-dependent wording from results/results.json and store it under results.json["text"].

Why: sentences such as "changed by at most 0 instruments" read badly. The manuscript binds to these text keys
({{res:text.<key>}}) so the wording follows the numbers: zero gives a natural negative sentence, non-zero gives the
count. Only values already in results.json are used; nothing is computed from data here.
Run after every step that writes results.json (chain: last step before 07_figures/07b_tables).
Usage: python3 tools/text_keys.py [results.json]
"""
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
P = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "results" / "results.json"
res = json.loads(P.read_text(encoding="utf-8"))


def walk(cur, parts, i=0):
    """Same greedy dotted-key resolution as tools/build_docx.py res_walk (keys may contain dots)."""
    if i == len(parts):
        return cur
    if not isinstance(cur, dict):
        return None
    for j in range(len(parts), i, -1):
        k = ".".join(parts[i:j])
        if k in cur:
            v = walk(cur[k], parts, j)
            if v is not None:
                return v
    return None


def get(path):
    v = walk(res, path.split("."))
    if v is None:
        sys.exit(f"text_keys: results.json key not found: {path}")
    return int(float(v))


def count(n, one, many):
    return f"{n} {one if n == 1 else many}"


t = {}

n = get("lava_ukb.summary.sig_fdr_primary")
tot = get("lava_ukb.summary.bivar_tests_primary")
t["lava_ukb_fdr_primary"] = ("none passed FDR correction" if n == 0
                             else f"{count(n, 'locus–pair', 'locus–pairs')} of {tot} passed FDR correction")

n = get("power_lava_ukb.ad.insomnia.loci_testable")
t["lava_testable_ad_insomnia"] = "none" if n == 0 else str(n)

lo = get("power_lava_ukb.dlb.ptsd.loci_testable")
hi = get("power_lava_ukb.dlb.mdd.loci_testable")
lo, hi = min(lo, hi), max(lo, hi)
t["lava_testable_dlb_range"] = (f"at most {hi} testable {'locus' if hi == 1 else 'loci'}" if lo == 0
                                else f"between {lo} and {hi} testable loci")

n = get("lava_strand_check.summary.n_changed")
t["strand_check_changed"] = ("none changed sign or significance after the exclusion" if n == 0
                             else f"{count(n, 'locus–pair', 'locus–pairs')} changed sign or significance after the exclusion")

n = get("mr_steiger_prevalence.summary.max_change_in_removed")
t["steiger_prevalence_change"] = ("did not change the set of removed instruments in any DLB direction" if n == 0
                                  else f"changed the number of removed instruments by at most {n} across the DLB directions")
t["steiger_prevalence_ivw"] = ("so the IVW estimates were unchanged" if n == 0
                               else "and the IVW estimates on each retained set are given")

n = get("coloc.summary.lava_primary_sig_fdr")
t["coloc_condition"] = ("no primary locus–pair passed FDR correction in the main LAVA analysis" if n == 0
                        else f"{count(n, 'primary locus–pair', 'primary locus–pairs')} passed FDR correction in the main LAVA analysis")

# Insert/replace only the trailing "text" block, leaving the rest of the file byte-identical (results.json is
# written by R; re-serializing it would change its formatting and complicate exact comparisons).
raw = P.read_text(encoding="utf-8").rstrip()
marker = ',\n  "text": {'
if marker in raw:
    raw = raw[:raw.index(marker)].rstrip() + "\n}"
assert raw.endswith("}")
block = json.dumps(t, indent=2, ensure_ascii=False).replace("\n", "\n  ")
new = raw[:-1].rstrip() + ',\n  "text": ' + block + "\n}\n"
json.loads(new)  # must still be valid JSON
P.write_text(new, encoding="utf-8")
print(json.dumps(t, indent=1, ensure_ascii=False))

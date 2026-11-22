#!/bin/bash
# Gate 3 (STRICT_RULES): end-to-end re-run of every analysis script from raw data in a separate tree
# (~/q1paper_gate3). Raw data and reference panels are symlinked read-only; every derived file
# (munged, LDSC/LAVA inputs, results, logs) is rebuilt. ~/q1paper/results and results.json are not touched.
# ~/q1paper/results_gate3 -> ~/q1paper_gate3/results. 4 workers for LAVA, MR and MRlap; empty-output checks:
# 03_lava.R stops on any worker that returns no result (exit 4), 03c and 04b check completeness.
set -u
SRC=~/q1paper; G=~/q1paper_gate3
mkdir -p "$G/data" "$G/analysis/logs" "$G/results"
cp -r "$SRC/analysis/R" "$G/analysis/"; cp "$SRC"/analysis/*.md "$SRC"/analysis/*.sha256 "$SRC"/analysis/*.sh "$G/analysis/" 2>/dev/null
cp "$SRC"/data/*.md "$SRC"/data/*.sh "$G/data/" 2>/dev/null
ln -sfn "$SRC/data/raw" "$G/data/raw"; ln -sfn "$SRC/data/ref" "$G/data/ref"
cp "$SRC/config.json" "$G/" 2>/dev/null
ln -sfn "$G/results" "$SRC/results_gate3"
cd "$G"
SNAP=runsnap/gate3_$(date +%Y%m%d_%H%M); mkdir -p "$SNAP"; cp analysis/R/*.R "$SNAP"/
echo "$(date '+%F %H:%M') gate3.sh (tree $G; snapshot $SNAP) bash PID $$" >> "$SRC/analysis/logs/pids.txt"
export LAVA_CORES=4 MR_CORES=4 MRLAP_CORES=4
run() {  # $1 = log name, $2 = script, rest = args
  local log=$1 sc=$2; shift 2
  echo "== $log start $(date)"
  Rscript "$SNAP/$sc" "$@" > "analysis/logs/$log.log" 2>&1 &
  local pid=$!; echo "$(date '+%F %H:%M') $sc $* (gate3) PID $pid" >> "$SRC/analysis/logs/pids.txt"
  wait $pid; local rc=$?
  echo "== $log exit=$rc $(date)  mem: $(free -m | awk 'NR==2{print $3"MB"} NR==3{print "swap "$3"MB"}' | tr '\n' ' ')"
  grep -aE "BİTTİ|WORKER_FAILURE|INTEGRITY|işlenen lokus|Error in|halted" "analysis/logs/$log.log" | cut -c1-250 | tail -4
  return $rc
}
bash analysis/write_session_info.sh > /dev/null 2>&1 || true
run 01_munge 01_munge.R || { echo "GATE3 STOP at 01"; exit 1; }
run 02_ldsc 02_ldsc.R || { echo "GATE3 STOP at 02"; exit 1; }
run 03_lava_ukb 03_lava.R ukb || { echo "GATE3 STOP at 03 ukb"; exit 1; }
run 03_lava_ukb_strandcheck 03_lava.R ukb strandcheck || { echo "GATE3 STOP at strandcheck"; exit 1; }
run 03_lava_g1000 03_lava.R g1000 || { echo "GATE3 STOP at 03 g1000"; exit 1; }
run 03c_lava_integrity 03c_lava_integrity.R || { echo "GATE3 STOP at 03c"; exit 1; }
run 04_mr 04_mr.R || { echo "GATE3 STOP at 04"; exit 1; }
run 04b_mr_output_integrity 04b_mr_output_integrity.R || { echo "GATE3 STOP at 04b"; exit 1; }
run 05_mr_sensitivity 05_mr_sensitivity.R || { echo "GATE3 STOP at 05"; exit 1; }
run 05b_ptsd_ad_finngen 05b_ptsd_ad_finngen.R || { echo "GATE3 STOP at 05b"; exit 1; }
run 06_coloc 06_coloc.R || { echo "GATE3 STOP at 06"; exit 1; }
run 06b_power_summary 06b_power_summary.R || { echo "GATE3 STOP at 06b"; exit 1; }
run 06c_lava_reference_diagnostic 06c_lava_reference_diagnostic.R || { echo "GATE3 STOP at 06c"; exit 1; }
run 06d_lava_g1000_fdr_pairs 06d_lava_g1000_fdr_pairs.R || { echo "GATE3 STOP at 06d"; exit 1; }
run 07_figures 07_figures.R || { echo "GATE3 STOP at 07"; exit 1; }
echo "GATE3 ALL DONE $(date)"

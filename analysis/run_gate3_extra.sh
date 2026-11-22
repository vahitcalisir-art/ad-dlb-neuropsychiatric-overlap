#!/bin/bash
# Gate 3 extra: run the fast descriptive scripts not in the chain (05c, 05d, 07b, 07c) in ~/q1paper_gate3.
set -u
SRC=~/q1paper; G=~/q1paper_gate3; cd "$G"
SNAP=runsnap/gate3_extra_$(date +%Y%m%d_%H%M); mkdir -p "$SNAP"; cp "$SRC"/analysis/R/*.R "$SNAP"/
echo "$(date '+%F %H:%M') gate3_extra.sh (tree $G; snapshot $SNAP) bash PID $$" >> "$SRC/analysis/logs/pids.txt"
export MR_CORES=4
for sc in 05c_steiger_prevalence 05d_steiger_insomnia_prev030 07b_tables 07c_instrument_table; do
  echo "== $sc start $(date)"
  Rscript "$SNAP/$sc.R" > "analysis/logs/$sc.log" 2>&1 &
  pid=$!; echo "$(date '+%F %H:%M') $sc.R (gate3 extra) PID $pid" >> "$SRC/analysis/logs/pids.txt"
  wait $pid; rc=$?
  echo "== $sc exit=$rc $(date)"; tail -3 "analysis/logs/$sc.log" | cut -c1-250
  [ $rc -eq 0 ] || { echo "GATE3X STOP at $sc"; exit 1; }
done
echo "GATE3X ALL DONE $(date)"

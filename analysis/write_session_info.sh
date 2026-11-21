#!/usr/bin/env bash
# Faz 0 adım 3: araç ve paket sürümlerini analysis/logs/session_info.txt'ye yazar.
set -euo pipefail
cd "$(dirname "$0")/.."
out=analysis/logs/session_info.txt
{
  echo "# session_info  ($(date -Iseconds))"
  echo
  echo "## System"
  . /etc/os-release; echo "OS: $PRETTY_NAME"
  echo "Kernel: $(uname -r)"
  echo "CPU cores: $(nproc)"
  free -h | sed -n '1,3p'
  echo
  echo "## Tools"
  echo "PLINK: $("$HOME/bin/plink" --version)"
  echo "pdftotext: $(pdftotext -v 2>&1 | head -1)"
  echo "unzip: $(unzip -v | head -1)"
  echo "Times New Roman: $(fc-list | grep -c 'Times New Roman') font files"
  echo
  echo "## Python ($(.venv/bin/python --version))"
  .venv/bin/python -m pip freeze
  echo
  echo "## R"
  Rscript -e '
    pk <- c("GenomicSEM","LAVA","MRlap","MRPRESSO","TwoSampleMR","ieugwasr","coloc","data.table","jsonlite","remotes","simex")
    for (p in pk) cat(sprintf("%-12s %s\n", p, as.character(packageVersion(p))))
    cat("\n"); print(sessionInfo())'
} > "$out" 2>&1
echo "yazıldı: $out"

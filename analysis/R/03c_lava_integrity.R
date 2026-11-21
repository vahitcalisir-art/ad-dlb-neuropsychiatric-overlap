#!/usr/bin/env Rscript
# 03c_lava_integrity.R — retrospective completeness check of the seeded LAVA runs (investigator request
# 2026-11-21, after silent worker failures in the first seeded 1000 Genomes run). For each reference:
#   (1) raw checkpoint has one element per analysed locus (MHC excluded) and every element is a worker result
#       (list with status; NULL / try-error = worker returned nothing);
#   (2) element i belongs to locus i (LOC order);
#   (3) processed + not processed = expected loci; no error statuses;
#   (4) every "ok" locus has univariate rows in lava_univ_<ref>.csv for its traits, and every bivariate locus is ok.
# Exit status 5 and "LAVA_INTEGRITY_FAIL" if anything is missing. Output: results/tables/lava_integrity.csv;
# results.json "lava_integrity".
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))
suppressPackageStartupMessages(library(LAVA))

loci <- read.loci(P_("data", "raw", "lava_ref", "blocks_s2500_m25_f1_w200.GRCh37_hg19.locfile"))
mhc <- loci$CHR == 6 & loci$STOP >= 25e6 & loci$START <= 34e6  # same definition as 03_lava.R
expected <- loci$LOC[!mhc]
out <- rbindlist(lapply(c("ukb", "g1000"), function(ref) {
  raw <- readRDS(P_("results", "rds", sprintf("lava_%s_raw_full.rds", ref)))
  okel <- vapply(raw, function(x) is.list(x) && !is.null(x$status), TRUE)
  loc_raw <- vapply(seq_along(raw), function(i) if (okel[i]) as.integer(raw[[i]]$status$LOC[1]) else NA_integer_, 1L)
  st <- fread(P_("results", "tables", sprintf("lava_status_%s.csv", ref)))
  un <- fread(P_("results", "tables", sprintf("lava_univ_%s.csv", ref)))
  bv <- fread(P_("results", "tables", sprintf("lava_bivar_%s.csv", ref)))
  ok_loc <- st[status == "ok", LOC]
  data.table(reference = ref, loci_expected = length(expected), raw_elements = length(raw),
             worker_results = sum(okel), worker_missing = sum(!okel),
             order_match = length(raw) == length(expected) && all(loc_raw[okel] == expected[okel]),
             status_rows = nrow(st), processed = length(ok_loc), not_processed = st[status == "not_processed", .N],
             errors = st[grepl("^error", status), .N], status_complete = setequal(st$LOC, expected),
             ok_loci_with_univ = sum(ok_loc %in% un$LOC), bivar_loci_not_ok = sum(!unique(bv$LOC) %in% ok_loc))
}))
out[, pass := raw_elements == loci_expected & worker_missing == 0 & order_match & status_complete & errors == 0 &
              processed + not_processed == loci_expected & ok_loci_with_univ == processed & bivar_loci_not_ok == 0]
print(out)
fwrite(out, P_("results", "tables", "lava_integrity.csv"))
for (i in seq_len(nrow(out))) with(out[i], res_set("lava_integrity", reference, list(
  loci_expected = fmt_int(loci_expected), worker_results = fmt_int(worker_results), worker_missing = fmt_int(worker_missing),
  processed = fmt_int(processed), not_processed = fmt_int(not_processed), errors = fmt_int(errors), pass = as.character(pass))))
if (!all(out$pass)) { log_line("LAVA_INTEGRITY_FAIL"); quit(save = "no", status = 5) }
log_line("LAVA_INTEGRITY_OK"); log_line("BİTTİ")

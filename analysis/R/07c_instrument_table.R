#!/usr/bin/env Rscript
# 07c_instrument_table.R — instrument-level associations for every MR direction (STROBE-MR item 11a;
# Supplementary Table S11). Reads the stored 04_mr.R results (final instrument set after F, harmonisation and
# Steiger filtering) and writes them unchanged; no estimation. Output: results/tables/supp_mr_instruments.csv
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))
OUTD <- P_("results", "rds", "mr")
dirs <- fread(P_("results", "tables", "mr_directions.csv"))
rows <- list()
for (i in seq_len(nrow(dirs))) {
  f <- file.path(OUTD, paste0(dirs$id[i], ".rds"))
  if (!file.exists(f)) { log_line("no rds:", dirs$id[i]); next }
  r <- readRDS(f); d <- as.data.table(r$dat)
  if (!nrow(d)) next
  if (nrow(d) != r$info$n_final) stop("instrument count mismatch for ", dirs$id[i])
  rows[[length(rows) + 1]] <- d[, .(direction = dirs$id[i], set = dirs$set[i], exposure = dirs$exposure[i], outcome = dirs$outcome[i],
    SNP, effect_allele = effect_allele.exposure, other_allele = other_allele.exposure,
    eaf_exposure = eaf.exposure, beta_exposure = beta.exposure, se_exposure = se.exposure, p_exposure = pval.exposure,
    beta_outcome = beta.outcome, se_outcome = se.outcome, p_outcome = pval.outcome, F_statistic = F)]
}
out <- rbindlist(rows)
fwrite(out, P_("results", "tables", "supp_mr_instruments.csv"))
log_line("directions:", uniqueN(out$direction), "rows:", nrow(out))
# Supplementary Table S12: stored leave-one-out estimates (TwoSampleMR mr_leaveoneout, run in 04_mr.R), unchanged
loo <- list()
for (i in seq_len(nrow(dirs))) {
  f <- file.path(OUTD, paste0(dirs$id[i], ".rds"))
  if (!file.exists(f)) next
  r <- readRDS(f); l <- r$loo
  if (is.null(l) || !nrow(l)) next
  l <- as.data.table(l)
  loo[[length(loo) + 1]] <- l[, .(direction = dirs$id[i], set = dirs$set[i], exposure = dirs$exposure[i], outcome = dirs$outcome[i],
    snp_left_out = SNP, b, se, p)]
}
loo <- rbindlist(loo)
fwrite(loo, P_("results", "tables", "supp_mr_leave_one_out.csv"))
log_line("leave-one-out directions:", uniqueN(loo$direction), "rows:", nrow(loo))
log_line("BİTTİ")

#!/usr/bin/env Rscript
# 03b_lava_seeded_compare.R — compares the seeded full UK Biobank LAVA run (deviations C4) with the earlier
# unseeded run archived in results/superseded/unseeded_lava/. Descriptive; no new test.
# Reports: tested locus–pairs in each run, FDR 5% counts per family, sign changes, significance changes.
# Exit status 2 (and "SEEDED_PRIMARY_FDR_CHANGE") if the primary family has any locus–pair at FDR 5%
# (investigator instruction 2026-11-21: stop and report).
# Usage: Rscript analysis/R/03b_lava_seeded_compare.R
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))

old <- fread(P_("results", "superseded", "unseeded_lava", "lava_bivar_ukb.csv"))
new <- fread(P_("results", "tables", "lava_bivar_ukb.csv"))
k <- c("LOC", "phen1", "phen2")
m <- merge(old[, c(k, "family", "rho", "p", "p_fdr"), with = FALSE], new[, c(k, "family", "rho", "p", "p_fdr"), with = FALSE],
           by = k, all = TRUE, suffixes = c("_old", "_new"))
m[, family := fcoalesce(family_new, family_old)]
both <- m[!is.na(p_old) & !is.na(p_new)]
both[, sign_change := sign(rho_old) != sign(rho_new)]
both[, sig_change := (p_fdr_old < 0.05) != (p_fdr_new < 0.05)]
fwrite(m, P_("results", "tables", "lava_seeded_vs_unseeded_ukb.csv"))

s <- rbindlist(lapply(c("primary", "secondary"), function(f) data.table(
  family = f, tests_old = m[family == f & !is.na(p_old), .N], tests_new = m[family == f & !is.na(p_new), .N],
  only_old = m[family == f & is.na(p_new), .N], only_new = m[family == f & is.na(p_old), .N],
  fdr_old = m[family == f, sum(p_fdr_old < 0.05, na.rm = TRUE)], fdr_new = m[family == f, sum(p_fdr_new < 0.05, na.rm = TRUE)],
  nominal_old = m[family == f, sum(p_old < 0.05, na.rm = TRUE)], nominal_new = m[family == f, sum(p_new < 0.05, na.rm = TRUE)],
  sign_changes = both[family == f, sum(sign_change)], sig_changes = both[family == f, sum(sig_change)],
  max_abs_rho_diff = both[family == f, if (.N) max(abs(rho_old - rho_new)) else NA_real_],
  median_rel_p_diff = both[family == f, if (.N) median(abs(p_new / p_old - 1)) else NA_real_])))
print(s)
if (both[sig_change == TRUE, .N]) print(both[sig_change == TRUE])
for (i in seq_len(nrow(s))) with(s[i], res_set("lava_seeded_rerun", family, list(
  tests_unseeded = fmt_int(tests_old), tests_seeded = fmt_int(tests_new), only_unseeded = fmt_int(only_old), only_seeded = fmt_int(only_new),
  fdr_unseeded = fmt_int(fdr_old), fdr_seeded = fmt_int(fdr_new), nominal_unseeded = fmt_int(nominal_old), nominal_seeded = fmt_int(nominal_new),
  sign_changes = fmt_int(sign_changes), significance_changes = fmt_int(sig_changes),
  max_abs_rho_diff = fmt_num(max_abs_rho_diff, 4), median_rel_p_diff = fmt_num(median_rel_p_diff, 3))))
n_prim <- s[family == "primary", fdr_new]
log_line("seeded primary FDR:", n_prim, " secondary FDR unseeded/seeded:", s[family == "secondary", fdr_old], s[family == "secondary", fdr_new])
if (n_prim != 0) { log_line("SEEDED_PRIMARY_FDR_CHANGE"); quit(save = "no", status = 2) }
log_line("BİTTİ")

#!/usr/bin/env Rscript
# 05b_ptsd_ad_finngen.R — places the FinnGen R13 PTSD → AD MR result next to the primary (Bellenguez 2022)
# PTSD → AD result (investigator request 2026-11-21). Descriptive juxtaposition of existing 04/05 outputs;
# no new test (FinnGen remains descriptive, plan §4b). Reads results/tables/mr_all.csv.
# Output: results/tables/mr_ptsd_ad_bellenguez_vs_finngen.csv; results.json "mr_ptsd_ad_finngen".
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))

m <- fread(P_("results", "tables", "mr_all.csv"))[id %in% c("ptsd__ad", "ptsd__ad_finngen")]
stopifnot(nrow(m) == 2)
z <- qnorm(0.975)
or_ci <- function(b, se) sprintf("%s (%s–%s)", fmt_num(exp(b), 3), fmt_num(exp(b - z * se), 3), fmt_num(exp(b + z * se), 3))
tab <- m[, .(id, outcome_gwas = fifelse(outcome == "ad", "Bellenguez 2022 (clinical + proxy)", "FinnGen R13 (ICD-based)"),
             n_iv, ivw_or_ci = or_ci(ivw_b, ivw_se), ivw_p, ivw_p_fdr,
             egger_or_ci = or_ci(egger_b, egger_se), egger_p, wm_or_ci = or_ci(wm_b, wm_se), wm_p,
             wmode_or_ci = or_ci(wmode_b, wmode_se), wmode_p,
             egger_int_p, isq_gx, simex_int_p, q_ivw_p, presso_global_p, presso_n_outliers,
             # MRlap works on standardised effects (Z/sqrt(N)); its estimates are betas on that scale, not log-odds
             mrlap_n_iv, mrlap_observed_beta_std = mrlap_observed, mrlap_observed_p,
             mrlap_corrected_beta_std_ci = sprintf("%s (%s to %s)", fmt_num(mrlap_corrected, 3), fmt_num(mrlap_corrected - z * mrlap_corrected_se, 3),
                                                   fmt_num(mrlap_corrected + z * mrlap_corrected_se, 3)),
             mrlap_corrected_p, mrlap_diff_p,
             classification, mrlap_qualifies, min_detectable_OR, min_detectable_OR_se)]
fwrite(tab, P_("results", "tables", "mr_ptsd_ad_bellenguez_vs_finngen.csv"))
print(t(tab))
for (i in seq_len(nrow(tab))) with(tab[i], res_set("mr_ptsd_ad_finngen", id, list(
  outcome_gwas = outcome_gwas, n_iv = fmt_int(n_iv), ivw_or_ci = ivw_or_ci, ivw_p = fmt_p(ivw_p),
  ivw_p_fdr = if (is.na(ivw_p_fdr)) "not in primary family (descriptive)" else fmt_p(ivw_p_fdr),
  egger_or_ci = egger_or_ci, egger_p = fmt_p(egger_p), wm_or_ci = wm_or_ci, wm_p = fmt_p(wm_p),
  wmode_or_ci = wmode_or_ci, wmode_p = fmt_p(wmode_p), egger_intercept_p = fmt_p(egger_int_p),
  isq_gx = fmt_num(isq_gx, 2), simex_intercept_p = fmt_p(simex_int_p), cochran_q_p = fmt_p(q_ivw_p),
  presso_global_p = as.character(presso_global_p),  # MR-PRESSO may return text such as "<1e-04" (as in 05) presso_outliers = fmt_int(presso_n_outliers),
  mrlap_n_iv = fmt_int(mrlap_n_iv), mrlap_observed_beta_std = fmt_num(mrlap_observed_beta_std, 3), mrlap_observed_p = fmt_p(mrlap_observed_p),
  mrlap_corrected_beta_std_ci = mrlap_corrected_beta_std_ci, mrlap_corrected_p = fmt_p(mrlap_corrected_p),
  mrlap_scale = "standardised effect (MRlap uses Z/sqrt(N)); not an odds ratio",
  classification = classification, min_detectable_or_plan = fmt_num(min_detectable_OR, 2),
  min_detectable_or_se = fmt_num(min_detectable_OR_se, 2))))
log_line("BİTTİ")

#!/usr/bin/env Rscript
# 05c_steiger_prevalence.R — Steiger prevalence sensitivity for the DLB directions (investigator request
# 2026-11-21). Plan §0.3 pre-specifies repeating Steiger filtering with every prevalence halved and doubled and
# reporting changes in the retained instruments; this script additionally re-estimates the IVW (multiplicative
# random effects) on each retained set, descriptively (no new test, no change to the primary estimate).
# The pre-Steiger instrument set is rebuilt exactly as in 04_mr.R: the direction's PLINK clumped list at the
# threshold used, F > 10, present in the outcome, harmonised with the same action. The k = 1 run must reproduce
# the stored 04_mr.R result (n_final and IVW beta); otherwise the script stops.
# Output: results/tables/mr_steiger_prevalence_dlb.csv; results.json "mr_steiger_prevalence".
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))
suppressPackageStartupMessages(library(TwoSampleMR))
set.seed(SEED)
F_MIN <- 10
TMP <- P_("analysis", "logs", "clump"); OUTD <- P_("results", "rds", "mr")
mr_file_id <- function(id) if (id == "ptsd") "ptsd_cc" else id
load_trait <- function(id, snps) {
  d <- read_munged(mr_file_id(id), c("SNP", "CHR", "BP", "A1", "A2", "BETA", "SE", "P", "EAF", "REF_EAF", "NCASE", "NCONTROL", "NEFF", "APOE"))
  d <- d[SNP %in% snps]
  d[, eaf := fcoalesce(as.numeric(EAF), as.numeric(REF_EAF))][, c("EAF", "REF_EAF") := NULL]
  d[is.finite(BETA) & is.finite(SE) & SE > 0]
}
to_tsmr <- function(d, type, name, prev) {
  s <- paste0(".", type)
  out <- data.frame(SNP = d$SNP, beta = d$BETA, se = d$SE, effect_allele = d$A1, other_allele = d$A2,
                    eaf = d$eaf, pval = d$P, ncase = d$NCASE, ncontrol = d$NCONTROL, samplesize = d$NEFF,
                    units = "log odds", prevalence = prev, id = name, name = name, stringsAsFactors = FALSE)
  names(out) <- c("SNP", paste0(c("beta", "se", "effect_allele", "other_allele", "eaf", "pval", "ncase",
                                  "ncontrol", "samplesize", "units", "prevalence", "id"), s), type)
  out[[paste0("mr_keep", s)]] <- TRUE
  out
}
dirs <- fread(P_("results", "tables", "mr_directions.csv"))[set == "primary" & (exposure == "dlb" | outcome == "dlb")]
rows <- list()
for (i in seq_len(nrow(dirs))) {
  d <- dirs[i]; r <- readRDS(file.path(OUTD, paste0(d$id, ".rds")))
  thr <- r$info$threshold; tag <- paste0(d$exposure, "__", d$outcome)
  cf <- file.path(TMP, tag, paste0(tag, "_", thr, ".clumped"))
  if (!file.exists(cf)) cf <- file.path(TMP, paste0(tag, "_", thr, ".clumped"))
  kept <- fread(cf)$SNP
  ex <- load_trait(d$exposure, kept)[P < thr][, F := (BETA / SE)^2][F > F_MIN]
  ou <- load_trait(d$outcome, ex$SNP)
  exp_dat <- to_tsmr(ex[SNP %in% ou$SNP], "exposure", d$exposure, TRAITS[[mr_file_id(d$exposure)]]$prev)
  out_dat <- to_tsmr(ou, "outcome", d$outcome, TRAITS[[mr_file_id(d$outcome)]]$prev)
  act <- if ("insomnia" %in% c(d$exposure, d$outcome)) 3 else 2
  dat <- suppressMessages(harmonise_data(exp_dat, out_dat, action = act)); dat <- dat[dat$mr_keep, ]
  for (k in c(1, 0.5, 2)) {
    dd <- dat; dd$prevalence.exposure <- dd$prevalence.exposure * k; dd$prevalence.outcome <- dd$prevalence.outcome * k
    keep <- suppressMessages(steiger_filtering(dd))$steiger_dir
    sel <- dat[!is.na(keep) & keep, ]
    ivw <- if (nrow(sel) >= 2) suppressMessages(mr(sel, method_list = "mr_ivw_mre")) else if (nrow(sel) == 1) suppressMessages(mr(sel, method_list = "mr_wald_ratio")) else NULL
    rows[[length(rows) + 1]] <- data.table(id = d$id, exposure = d$exposure, outcome = d$outcome, prevalence_factor = k,
      n_harmonised = nrow(dat), n_removed = sum(!keep, na.rm = TRUE) + sum(is.na(keep)), n_retained = nrow(sel),
      ivw_b = if (is.null(ivw)) NA_real_ else ivw$b[1], ivw_se = if (is.null(ivw)) NA_real_ else ivw$se[1],
      ivw_p = if (is.null(ivw)) NA_real_ else ivw$pval[1])
  }
  base <- rows[[length(rows) - 2]]
  stored_b <- r$mr[method == "Inverse variance weighted (multiplicative random effects)" | method == "Wald ratio", b][1]
  if (base$n_retained != r$info$n_final || !isTRUE(all.equal(base$ivw_b, stored_b, tolerance = 1e-8)))
    stop("k = 1 does not reproduce 04_mr.R for ", d$id, ": n ", base$n_retained, " vs ", r$info$n_final, "; b ", base$ivw_b, " vs ", stored_b)
  log_line(d$id, "reproduced; removed (k=1, 0.5, 2):", paste(sapply(tail(rows, 3), `[[`, "n_removed"), collapse = ", "))
}
out <- rbindlist(rows)
out[, or_ci := sprintf("%s (95%% CI %s to %s)", fmt_num(exp(ivw_b), 2), fmt_num(exp(ivw_b - 1.959964 * ivw_se), 2), fmt_num(exp(ivw_b + 1.959964 * ivw_se), 2))]
fwrite(out, P_("results", "tables", "mr_steiger_prevalence_dlb.csv"))
print(out[, .(id, prevalence_factor, n_harmonised, n_removed, n_retained, or_ci, ivw_p = signif(ivw_p, 2))])
for (j in seq_len(nrow(out))) with(out[j], res_set("mr_steiger_prevalence", sprintf("%s.k%s", id, sub("\\.", "_", as.character(prevalence_factor))), list(
  n_harmonised = fmt_int(n_harmonised), n_removed = fmt_int(n_removed), n_retained = fmt_int(n_retained), or_ivw = or_ci, p_ivw = fmt_p(ivw_p))))
mx <- out[, .(rng = max(n_removed) - min(n_removed)), by = id]
res_set("mr_steiger_prevalence", "summary", list(
  directions = fmt_int(nrow(dirs)), note = "descriptive; Steiger filtering repeated with every prevalence halved and doubled (plan 0.3); IVW re-estimated on each retained set",
  mdd_dlb_removed_k1 = fmt_int(out[id == "mdd__dlb" & prevalence_factor == 1, n_removed]),
  mdd_dlb_harmonised = fmt_int(out[id == "mdd__dlb" & prevalence_factor == 1, n_harmonised]),
  mdd_dlb_removed_half = fmt_int(out[id == "mdd__dlb" & prevalence_factor == 0.5, n_removed]),
  mdd_dlb_removed_double = fmt_int(out[id == "mdd__dlb" & prevalence_factor == 2, n_removed]),
  mdd_dlb_or_half = out[id == "mdd__dlb" & prevalence_factor == 0.5, or_ci],
  mdd_dlb_or_double = out[id == "mdd__dlb" & prevalence_factor == 2, or_ci],
  max_change_in_removed = fmt_int(max(mx$rng))))
log_line("BİTTİ")

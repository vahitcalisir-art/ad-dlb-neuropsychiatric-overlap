#!/usr/bin/env Rscript
# 05d_steiger_insomnia_prev030.R — additional descriptive Steiger check for the insomnia directions
# (investigator request 2026-11-22, deviation C10). The insomnia prevalence of 0.10 is a working assumption;
# Watanabe et al. (2022) used a population prevalence of 30% (note watanabe2022genome c6), which lies outside the
# plan's halved/doubled range (0.05-0.20). Steiger filtering is repeated with the insomnia prevalence set to 0.30
# and every other prevalence unchanged, for the four primary insomnia directions. The pre-Steiger instrument set is
# rebuilt exactly as in 04_mr.R / 05c; the 0.10 run must reproduce the stored 04_mr.R result, otherwise the script
# stops. IVW (multiplicative random effects) is re-estimated on each retained set. No new test; primary unchanged.
# Output: results/tables/mr_steiger_insomnia_prev030.csv; results.json "mr_steiger_insomnia030".
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))
suppressPackageStartupMessages(library(TwoSampleMR))
set.seed(SEED)
F_MIN <- 10; PREV_ALT <- 0.30
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
dirs <- fread(P_("results", "tables", "mr_directions.csv"))[set == "primary" & (exposure == "insomnia" | outcome == "insomnia")]
stopifnot(nrow(dirs) == 4, TRAITS$insomnia$prev == 0.10)
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
  dat <- suppressMessages(harmonise_data(exp_dat, out_dat, action = 3)); dat <- dat[dat$mr_keep, ]
  for (pv in c(0.10, PREV_ALT)) {
    dd <- dat
    if (d$exposure == "insomnia") dd$prevalence.exposure <- pv else dd$prevalence.outcome <- pv
    keep <- suppressMessages(steiger_filtering(dd))$steiger_dir
    sel <- dat[!is.na(keep) & keep, ]
    ivw <- if (nrow(sel) >= 2) suppressMessages(mr(sel, method_list = "mr_ivw_mre")) else if (nrow(sel) == 1) suppressMessages(mr(sel, method_list = "mr_wald_ratio")) else NULL
    rows[[length(rows) + 1]] <- data.table(id = d$id, exposure = d$exposure, outcome = d$outcome, insomnia_prev = pv,
      n_harmonised = nrow(dat), n_removed = sum(!keep, na.rm = TRUE) + sum(is.na(keep)), n_retained = nrow(sel),
      snps = paste(sort(sel$SNP), collapse = ";"),
      ivw_b = if (is.null(ivw)) NA_real_ else ivw$b[1], ivw_se = if (is.null(ivw)) NA_real_ else ivw$se[1],
      ivw_p = if (is.null(ivw)) NA_real_ else ivw$pval[1])
  }
  base <- rows[[length(rows) - 1]]
  stored_b <- r$mr[method == "Inverse variance weighted (multiplicative random effects)" | method == "Wald ratio", b][1]
  if (base$n_retained != r$info$n_final || !isTRUE(all.equal(base$ivw_b, stored_b, tolerance = 1e-8)))
    stop("prev 0.10 does not reproduce 04_mr.R for ", d$id, ": n ", base$n_retained, " vs ", r$info$n_final, "; b ", base$ivw_b, " vs ", stored_b)
  log_line(d$id, "reproduced; removed (0.10, 0.30):", paste(sapply(tail(rows, 2), `[[`, "n_removed"), collapse = ", "))
}
out <- rbindlist(rows)
out[, or_ci := sprintf("%s (95%% CI %s to %s)", fmt_num(exp(ivw_b), 2), fmt_num(exp(ivw_b - 1.959964 * ivw_se), 2), fmt_num(exp(ivw_b + 1.959964 * ivw_se), 2))]
same <- out[, .(same_set = snps[insomnia_prev == 0.10] == snps[insomnia_prev == PREV_ALT]), by = id]
fwrite(out[, !"snps"], P_("results", "tables", "mr_steiger_insomnia_prev030.csv"))
print(out[, .(id, insomnia_prev, n_harmonised, n_removed, n_retained, or_ci, ivw_p = signif(ivw_p, 2))]); print(same)
for (j in seq_len(nrow(out))) with(out[j], res_set("mr_steiger_insomnia030", sprintf("%s.p%s", id, sub("0\\.", "", sprintf("%.2f", insomnia_prev))), list(
  n_harmonised = fmt_int(n_harmonised), n_removed = fmt_int(n_removed), n_retained = fmt_int(n_retained), or_ivw = or_ci, p_ivw = fmt_p(ivw_p))))
res_set("mr_steiger_insomnia030", "summary", list(
  directions = fmt_int(nrow(dirs)), n_changed = fmt_int(sum(!same$same_set)),
  note = "descriptive; insomnia prevalence 0.30 (Watanabe 2022) instead of 0.10, other prevalences unchanged; IVW re-estimated on each retained set"))
log_line("BİTTİ")

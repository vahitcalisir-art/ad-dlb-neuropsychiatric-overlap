#!/usr/bin/env Rscript
# 04b_mr_output_integrity.R — race-condition check of the parallel 04_mr.R outputs (investigator request
# 2026-11-21, after the MRlap shared-working-directory race found in 05). Descriptive; no new analysis.
# For every direction in mr_directions.csv verifies that results/rds/mr/<id>.rds belongs to that direction:
#   (1) r$id and r$row match the file name; (2) exposure/outcome labels inside the harmonised data match;
#   (3) n_final == nrow(dat), and leave-one-out has n_final + 1 rows (each SNP + "All");
#   (4) every final instrument is in the PLINK .clumped file of that direction (tag unique per direction) and
#       the number of clumped SNPs equals info$n_clumped; (5) the .clumped file was written before the rds;
#   (6) MR-PRESSO / SIMEX / Steiger come from the same object (run in-memory; checked for presence vs n);
#   (7) the clump tag of each direction is unique (no two directions share a PLINK output prefix);
#   (8) runlog row (n_iv, threshold) agrees with the rds.
# Output: results/tables/mr_output_integrity.csv; results.json "mr_output_integrity".
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))

dirs <- fread(P_("results", "tables", "mr_directions.csv"))
runlog <- fread(P_("analysis", "logs", "mr_runlog.csv"))
TMP <- P_("analysis", "logs", "clump"); OUTD <- P_("results", "rds", "mr")
dirs[, tag_base := paste0(exposure, fifelse(drop_apoe, "_noapoe", ""), "__", outcome)]
stopifnot(!anyDuplicated(dirs$tag_base))

chk <- rbindlist(lapply(seq_len(nrow(dirs)), function(i) {
  d <- dirs[i]; f <- file.path(OUTD, paste0(d$id, ".rds"))
  if (!file.exists(f)) return(data.table(id = d$id, rds_exists = FALSE))
  r <- readRDS(f); dat <- r$dat; info <- r$info; n <- if (is.null(info$n_final)) NA_integer_ else info$n_final
  cf <- file.path(TMP, d$tag_base, paste0(d$tag_base, "_", info$threshold, ".clumped"))  # per-direction dir (04_mr.R since 2026-11-21)
  if (!file.exists(cf)) cf <- file.path(TMP, paste0(d$tag_base, "_", info$threshold, ".clumped"))  # earlier flat layout
  cl <- if (!is.null(info$threshold) && file.exists(cf)) fread(cf)$SNP else character(0)
  rl <- runlog[id == d$id]
  data.table(
    id = d$id, set = d$set, rds_exists = TRUE, status = r$status,
    id_match = identical(r$id, d$id) && r$row$exposure == d$exposure && r$row$outcome == d$outcome && r$row$drop_apoe == d$drop_apoe,
    labels_match = is.null(dat) || (all(dat$exposure == d$exposure) && all(dat$outcome == d$outcome)),
    n_final = n, n_dat_match = is.null(dat) || nrow(dat) == n,
    loo_match = is.null(r$loo) || nrow(r$loo) == n + 1L,
    loo_snps_match = is.null(r$loo) || setequal(setdiff(r$loo$SNP, "All"), dat$SNP),
    clumped_file = file.exists(cf), n_clumped_file = length(cl), n_clumped_info = if (is.null(info$n_clumped)) NA else info$n_clumped,
    clumped_count_match = is.null(info$n_clumped) || length(cl) == info$n_clumped,
    iv_in_clumped = is.null(dat) || all(dat$SNP %in% cl),
    clumped_before_rds = !file.exists(cf) || file.mtime(cf) <= file.mtime(f),
    clumped_mtime = if (file.exists(cf)) format(file.mtime(cf)) else NA_character_, rds_mtime = format(file.mtime(f)),
    presso_expected = isTRUE(n >= 4), presso_present = !is.null(r$presso) && !"presso_error" %in% names(r$presso),
    simex_expected = isTRUE(n >= 3) && isTRUE(r$isq < 0.9), simex_present = !is.null(r$simex) && !"simex_error" %in% names(r$simex),
    runlog_match = nrow(rl) == 1 && identical(as.integer(rl$n_iv), as.integer(n)) &&
      (is.null(info$threshold) || isTRUE(all.equal(as.numeric(rl$threshold), as.numeric(info$threshold)))))
}), fill = TRUE)
chk[, all_ok := rds_exists & id_match & labels_match & n_dat_match & loo_match & loo_snps_match &
      clumped_count_match & iv_in_clumped & clumped_before_rds & (presso_present | !presso_expected) &
      (simex_present | !simex_expected) & runlog_match]
fwrite(chk, P_("results", "tables", "mr_output_integrity.csv"))
print(chk[, .(id, status, n_final, n_clumped_file, n_clumped_info, all_ok)])
bad <- chk[all_ok %in% FALSE | is.na(all_ok)]
if (nrow(bad)) print(bad)
res_set("mr_output_integrity", "summary", list(
  directions = fmt_int(nrow(chk)), all_checks_passed = fmt_int(sum(chk$all_ok, na.rm = TRUE)),
  failed = if (nrow(bad)) paste(bad$id, collapse = ", ") else "none",
  clump_tags_unique = "TRUE",
  note = "04_mr.R workers share only the PLINK clump directory; output prefixes are unique per direction; TwoSampleMR, MR-PRESSO, SIMEX, Steiger and leave-one-out run in memory"))
log_line(if (nrow(bad)) "MR_INTEGRITY_FAIL" else "MR_INTEGRITY_OK", nrow(bad))
log_line("BİTTİ")

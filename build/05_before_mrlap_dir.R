#!/usr/bin/env Rscript
# 05_mr_sensitivity.R — Plan §4.7 (MRlap), §6.1 (çoklu test), §8 (yorumlama kuralı), §4b (FinnGen).
# Girdi: results/rds/mr/*.rds (04_mr.R). Çıktı: results/tables/mr_*.csv, results.json (mr, sensitivity_finngen).
# Kullanım: MRLAP_CORES=4 Rscript analysis/R/05_mr_sensitivity.R [--skip-mrlap]
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))
suppressPackageStartupMessages({ library(MRlap); library(parallel) })
set.seed(SEED)
args <- commandArgs(trailingOnly = TRUE)
SKIP_MRLAP <- "--skip-mrlap" %in% args
MRD <- P_("results", "rds", "mr")
mr_file_id <- function(id) if (id == "ptsd") "ptsd_cc" else id

# ---------------- MRlap (§4.7, §4b.3) ----------------
LD  <- P_("data", "ref", "ldsc_ld")
HM3 <- P_("data", "ref", "w_hm3.snplist")
if (!file.exists(HM3)) {  # HapMap3 SNP listesi: 1000G Phase 3 ağırlık SNP'leri + 1000G .bim alelleri
  w <- rbindlist(lapply(1:22, function(i) fread(P_("data", "ref", "ldsc_wld", sprintf("%d.l2.ldscore.gz", i)), select = "SNP")))
  bim <- rbindlist(lapply(1:22, function(i) fread(P_("data", "raw", "ldsc_ref", "1000G_EUR_Phase3_plink", sprintf("1000G.EUR.QC.%d.bim", i)),
                                                  header = FALSE, select = c(2, 5, 6), col.names = c("SNP", "A1", "A2"))))
  fwrite(bim[SNP %in% w$SNP], HM3, sep = "\t")
}
mrlap_set <- c("primary", "sens_mdd_ukbb", "finngen")
rds <- list.files(MRD, "\\.rds$", full.names = TRUE)
R <- lapply(rds, readRDS); names(R) <- vapply(R, `[[`, "", "id")

run_mrlap <- function(r) {
  row <- r$row
  thr <- if (is.null(r$info$threshold)) 5e-8 else r$info$threshold      # aynı enstrüman eşiği (yedek eşik dahil)
  rd <- function(id) {
    d <- read_munged(mr_file_id(id), c("SNP", "CHR", "BP", "A1", "A2", "BETA", "SE", "NEFF"))
    d[is.finite(BETA) & is.finite(SE), .(rsid = SNP, chr = CHR, pos = BP, alt = A1, ref = A2, beta = BETA, se = SE, N = NEFF)]
  }
  out <- tryCatch({
    owd <- setwd(P_("analysis", "logs")); on.exit(setwd(owd))
    m <- MRlap(exposure = rd(row$exposure), exposure_name = row$exposure, outcome = rd(row$outcome), outcome_name = row$outcome,
               ld = LD, hm3 = HM3, MR_threshold = thr, MR_pruning_dist = 10000, MR_pruning_LD = 0.001,
               MR_plink = path.expand("~/bin/plink"), MR_bfile = P_("data", "ref", "clump", "EUR"),
               save_logfiles = FALSE, verbose = FALSE)
    mc <- m$MRcorrection
    data.table(id = r$id, mrlap_threshold = thr, mrlap_n_iv = mc$m_IVs,
               mrlap_observed = mc$observed_effect, mrlap_observed_se = mc$observed_effect_se, mrlap_observed_p = mc$observed_effect_p,
               mrlap_corrected = mc$corrected_effect, mrlap_corrected_se = mc$corrected_effect_se, mrlap_corrected_p = mc$corrected_effect_p,
               mrlap_diff_p = mc$p_difference, mrlap_status = "ok")
  }, error = function(e) data.table(id = r$id, mrlap_status = paste("error:", conditionMessage(e))))
  gc(verbose = FALSE); out
}
ML_FILE <- P_("results", "tables", "mr_mrlap.csv")
if (!SKIP_MRLAP) {
  todo <- Filter(function(r) identical(r$status, "ok") && r$row$set %in% mrlap_set, R)
  log_line("MRlap yön sayısı:", length(todo))
  ml <- rbindlist(mclapply(todo, run_mrlap, mc.cores = as.integer(Sys.getenv("MRLAP_CORES", "1")), mc.preschedule = FALSE), fill = TRUE)
  fwrite(ml, ML_FILE)
}
ml <- if (file.exists(ML_FILE)) fread(ML_FILE) else data.table(id = character())

# ---------------- özet tablo ----------------
getm <- function(r, pat) { if (is.null(r$mr)) return(c(NA, NA, NA)); x <- r$mr[grepl(pat, method)]; if (!nrow(x)) c(NA, NA, NA) else unlist(x[1, .(b, se, pval)]) }
summ <- rbindlist(lapply(R, function(r) {
  row <- r$row; ivw <- getm(r, "Inverse variance weighted|Wald ratio")
  eg <- getm(r, "MR Egger"); wm <- getm(r, "Weighted median"); wmo <- getm(r, "Weighted mode")
  het_ivw <- if (!is.null(r$het)) r$het[grepl("Inverse", method)] else NULL
  het_eg  <- if (!is.null(r$het)) r$het[grepl("Egger", method)] else NULL
  pr <- r$presso
  data.table(id = r$id, set = row$set, exposure = row$exposure, outcome = row$outcome, drop_apoe = row$drop_apoe,
             status = r$status, threshold = r$info$threshold, n_iv = r$info$n_final, mean_F = r$info$mean_F,
             total_R2 = r$info$total_R2, min_detectable_OR = r$info$min_detectable_OR,
             n_steiger_removed = r$info$n_steiger_removed, steiger_change_half = r$info$steiger_change_half,
             steiger_change_double = r$info$steiger_change_double, n_missing_outcome = r$info$n_missing_outcome,
             ivw_b = ivw[1], ivw_se = ivw[2], ivw_p = ivw[3],
             egger_b = eg[1], egger_se = eg[2], egger_p = eg[3],
             wm_b = wm[1], wm_se = wm[2], wm_p = wm[3], wmode_b = wmo[1], wmode_se = wmo[2], wmode_p = wmo[3],
             q_ivw = if (length(het_ivw) && nrow(het_ivw)) het_ivw$Q else NA, q_ivw_p = if (length(het_ivw) && nrow(het_ivw)) het_ivw$Q_pval else NA,
             q_egger = if (length(het_eg) && nrow(het_eg)) het_eg$Q else NA, q_egger_p = if (length(het_eg) && nrow(het_eg)) het_eg$Q_pval else NA,
             egger_int = if (!is.null(r$pleio)) r$pleio$egger_intercept else NA, egger_int_se = if (!is.null(r$pleio)) r$pleio$se else NA,
             egger_int_p = if (!is.null(r$pleio)) r$pleio$pval else NA,
             isq_gx = if (!is.null(r$isq)) r$isq else NA,
             simex_int = if (!is.null(r$simex$simex_intercept)) r$simex$simex_intercept else NA,
             simex_int_p = if (!is.null(r$simex$simex_intercept_p)) r$simex$simex_intercept_p else NA,
             simex_slope = if (!is.null(r$simex$simex_slope)) r$simex$simex_slope else NA,
             simex_slope_p = if (!is.null(r$simex$simex_slope_p)) r$simex$simex_slope_p else NA,
             presso_global_p = if (!is.null(pr$global_p)) as.character(pr$global_p) else NA,
             presso_oc_b = if (!is.null(pr$oc_beta)) pr$oc_beta else NA, presso_oc_se = if (!is.null(pr$oc_se)) pr$oc_se else NA,
             presso_oc_p = if (!is.null(pr$oc_p)) pr$oc_p else NA, presso_n_outliers = if (!is.null(pr$n_outliers)) pr$n_outliers else NA,
             presso_distortion_p = if (!is.null(pr$distortion_p)) pr$distortion_p else NA,
             runtime_min = if (!is.null(r$runtime_min)) r$runtime_min else NA)
}), fill = TRUE)
summ <- merge(summ, ml, by = "id", all.x = TRUE)

# §6.1: BH FDR ve Bonferroni yalnız 16 birincil IVW testi üzerinde
summ[set == "primary", `:=`(ivw_p_fdr = p.adjust(ivw_p, "BH"), ivw_p_bonf = pmin(1, ivw_p * .N))]
# §4b.5: FinnGen yalnız tutarlılık; bilgi amaçlı kendi içinde düzeltme
summ[set == "finngen", `:=`(ivw_p_bh_within = p.adjust(ivw_p, "BH"), ivw_p_bonf_within = pmin(1, ivw_p * .N))]

# §8 yorumlama kuralı (yalnız birincil yönler için sınıflandırma; diğerleri tutarlılık için aynı ölçütlerle betimlenir)
classify <- function(s, fdr) {
  if (is.na(s$ivw_b)) return(list(cls = "not estimable", c2 = NA, c3 = NA))
  same <- sum(sign(c(s$egger_b, s$wm_b, s$wmode_b, s$presso_oc_b)) == sign(s$ivw_b), na.rm = TRUE)
  c2 <- same >= 2
  int_p <- if (!is.na(s$isq_gx) && s$isq_gx < 0.9) s$simex_int_p else s$egger_int_p   # §4.6 / §8 (iii)
  c3 <- if (is.na(int_p)) NA else int_p > 0.05
  c1 <- !is.na(fdr) && fdr < 0.05
  cls <- if (!c1) "no evidence" else if (isTRUE(c2) && isTRUE(c3)) "consistent evidence" else "evidence sensitive to pleiotropy"
  list(cls = cls, c2 = c2, c3 = c3, n_same = same, int_used = if (!is.na(s$isq_gx) && s$isq_gx < 0.9) "SIMEX" else "conventional")
}
for (i in seq_len(nrow(summ))) {
  s <- summ[i]; fdr <- if (s$set == "primary") s$ivw_p_fdr else s$ivw_p   # birincil dışı: nominal p ile betimleme
  k <- classify(s, fdr)
  summ[i, `:=`(n_sensitivity_same_direction = k$n_same, cond_ii = k$c2, cond_iii = k$c3,
               egger_intercept_used = k$int_used, classification = k$cls)]
}
# MRlap niteleme (§8 son cümle): düzeltilmiş tahmin yön değiştirir veya nominal anlamlılığını kaybederse
summ[, mrlap_qualifies := mrlap_status == "ok" & ivw_p < 0.05 & (sign(mrlap_corrected) != sign(ivw_b) | mrlap_corrected_p >= 0.05)]
summ[set != "primary", classification := paste0("[descriptive, not used for significance] ", classification)]

# Tanımlayıcı güç ölçüsü (deviations D4): plandaki §4.10 değeri (maruziyetin SD'si başına, R² ve sonuç N'inden)
# korunur; yanına IVW standart hatasından, IVW tahminiyle aynı ölçekte (maruziyetin log-odds birimi başına)
# en küçük saptanabilir OR eklenir: exp((z_0.975 + z_0.80) × SE_IVW). Çıkarım kuralı değişmez.
summ[, min_detectable_OR_se := exp((qnorm(0.975) + qnorm(0.8)) * ivw_se)]
setorder(summ, set, exposure, outcome)
fwrite(summ, P_("results", "tables", "mr_all.csv"))
fwrite(summ[set == "primary"], P_("results", "tables", "mr_primary.csv"))

# ---------------- results.json ----------------
OR <- function(b, se) fmt_ci(exp(b), exp(b - 1.959964 * se), exp(b + 1.959964 * se))
for (i in seq_len(nrow(summ))) with(summ[i], {
  vals <- list(n_iv = fmt_int(n_iv), threshold = fmt_p(threshold), mean_F = fmt_num(mean_F, 1),
    or_ivw = OR(ivw_b, ivw_se), p_ivw = fmt_p(ivw_p),
    or_egger = OR(egger_b, egger_se), p_egger = fmt_p(egger_p),
    or_wm = OR(wm_b, wm_se), p_wm = fmt_p(wm_p), or_wmode = OR(wmode_b, wmode_se), p_wmode = fmt_p(wmode_p),
    or_presso_oc = OR(presso_oc_b, presso_oc_se), presso_global_p = as.character(presso_global_p), presso_outliers = as.character(presso_n_outliers),
    q_ivw = fmt_num(q_ivw, 1), q_ivw_p = fmt_p(q_ivw_p), egger_intercept = fmt_num(egger_int, 4), egger_intercept_p = fmt_p(egger_int_p),
    isq_gx = fmt_num(isq_gx, 2), simex_intercept_p = fmt_p(simex_int_p), egger_intercept_used = egger_intercept_used,
    min_detectable_or = fmt_num(min_detectable_OR, 2),
    min_detectable_or_units = "per SD of genetically predicted exposure liability (plan 4.10; from instrument R² and outcome effective N, 80% power, two-sided alpha 0.05)",
    min_detectable_or_se = fmt_num(min_detectable_OR_se, 2),
    min_detectable_or_se_units = "per unit increase in log odds of the exposure, same scale as the IVW OR (exp((1.96 + 0.84) × IVW SE); descriptive, deviations D4)",
    or_mrlap_corrected = if (isTRUE(mrlap_status == "ok")) OR(mrlap_corrected, mrlap_corrected_se) else "NA",
    p_mrlap_corrected = if (isTRUE(mrlap_status == "ok")) fmt_p(mrlap_corrected_p) else "NA",
    classification = classification)
  if (set == "primary") vals <- c(vals, list(p_ivw_fdr = fmt_p(ivw_p_fdr), p_ivw_bonferroni = fmt_p(ivw_p_bonf)))
  if (grepl("^finngen", set)) {
    if (set == "finngen") vals <- c(vals, list(p_ivw_bh_within = fmt_p(ivw_p_bh_within), p_ivw_bonf_within = fmt_p(ivw_p_bonf_within)))
    res_set("sensitivity_finngen", paste0("mr.", id), c(vals, list(note = "consistency check only; not used to declare significance (plan 4b.5)")))
  } else res_set("mr", id, vals)
})
log_line("özet:"); print(summ[set == "primary", .(id, n_iv, isq_gx = round(isq_gx, 2), OR = round(exp(ivw_b), 3), p = signif(ivw_p, 2),
                                                   fdr = signif(ivw_p_fdr, 2), classification)])
log_line("BİTTİ"); print(sessionInfo())

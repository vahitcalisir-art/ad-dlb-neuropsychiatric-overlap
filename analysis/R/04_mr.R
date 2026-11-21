#!/usr/bin/env Rscript
# 04_mr.R — Plan §4 (ve §4b): iki yönlü iki örneklem MR.
# Her yön için: enstrüman seçimi (§4.2–4.4), harmonizasyon ve Steiger (§4.5), IVW (çok etkili rastgele
# etkiler), MR-Egger, ağırlıklı medyan, ağırlıklı mod, MR-PRESSO, leave-one-out, Cochran Q / Rücker Q′,
# I²GX ve gerekirse SIMEX-Egger (§4.6), APOE dışlanmış yeniden analiz (§4.8), güç (§4.10).
# MRlap (§4.7), çoklu test (§6.1) ve yorumlama kuralı (§8): 05_mr_sensitivity.R.
# Kullanım: Rscript analysis/R/04_mr.R [yön_kimliği ...]   (boşsa tümü)
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))
suppressPackageStartupMessages({ library(TwoSampleMR); library(MRPRESSO); library(simex); library(parallel) })
set.seed(SEED)

PLINK <- path.expand("~/bin/plink")
BFILE <- P_("data", "ref", "clump", "EUR")
THR_MAIN <- 5e-8; THR_FALLBACK <- 5e-6; MIN_IV <- 3L       # §4.2
CLUMP_R2 <- 0.001; CLUMP_KB <- 10000                       # §4.3
F_MIN <- 10                                                # §4.4
PRESSO_NB <- 10000; SIMEX_B <- 1000                        # §4.6
APOE_REG <- c(19, 44.4e6, 46.5e6)
OUTD <- P_("results", "rds", "mr"); dir.create(OUTD, showWarnings = FALSE, recursive = TRUE)
TMP <- P_("analysis", "logs", "clump"); dir.create(TMP, showWarnings = FALSE)

# MR'da PTSD için case/control dosyası kullanılır (plan §0.1.4)
mr_file_id <- function(id) if (id == "ptsd") "ptsd_cc" else id

# ---- yön listesi ----
mk <- function(exp, out, set, apoe = FALSE) data.table(exposure = exp, outcome = out, set = set, drop_apoe = apoe)
dirs <- rbindlist(c(
  lapply(PSYCH, function(p) rbind(mk(p, "ad", "primary"), mk("ad", p, "primary"),
                                  mk(p, "dlb", "primary"), mk("dlb", p, "primary"))),
  list(rbind(mk("mdd_ukbb", "ad", "sens_mdd_ukbb"), mk("ad", "mdd_ukbb", "sens_mdd_ukbb"),
             mk("mdd_ukbb", "dlb", "sens_mdd_ukbb"), mk("dlb", "mdd_ukbb", "sens_mdd_ukbb"))),
  lapply(PSYCH, function(p) rbind(mk(p, "ad_finngen", "finngen"), mk("ad_finngen", p, "finngen")))
))
# §4.8: AD içeren her yön APOE dışlanarak yinelenir
ad_ids <- c("ad", "ad_finngen")
dirs <- rbind(dirs, dirs[exposure %in% ad_ids | outcome %in% ad_ids][, `:=`(drop_apoe = TRUE, set = paste0(set, "_noapoe"))])
dirs[, id := paste0(exposure, "__", outcome, fifelse(drop_apoe, "__noapoe", ""))]
avail <- function(x) file.exists(P_("data", "munged", paste0(TRAITS[[mr_file_id(x)]]$file, ".tsv.gz")))
dirs <- dirs[vapply(exposure, avail, TRUE) & vapply(outcome, avail, TRUE)]
args <- commandArgs(trailingOnly = TRUE)
if (length(args)) dirs <- dirs[id %in% args]
if (!length(args)) if (!length(args)) fwrite(dirs, P_("results", "tables", "mr_directions.csv"))  # alt küme çalıştırmada tam liste korunur  # alt küme çalıştırmada tam liste korunur
log_line("yön sayısı:", nrow(dirs))

# Bellek: paralel çalışmada her işçi yalnız gereken satırları tutar (maruziyette P < 5e-6, sonuçta enstrümanlar).
load_trait <- function(id, p_max = NULL, snps = NULL) {
  d <- read_munged(mr_file_id(id), c("SNP", "CHR", "BP", "A1", "A2", "BETA", "SE", "P", "EAF", "REF_EAF",
                                     "NCASE", "NCONTROL", "NEFF", "APOE"))
  if (!is.null(p_max)) d <- d[P < p_max]
  if (!is.null(snps)) d <- d[SNP %in% snps]
  d[, eaf := fcoalesce(as.numeric(EAF), as.numeric(REF_EAF))][, c("EAF", "REF_EAF") := NULL]
  d <- d[is.finite(BETA) & is.finite(SE) & SE > 0]
  gc(verbose = FALSE)
  d
}

clump <- function(sig, thr, tag, wdir) {
  if (!nrow(sig)) return(character(0))
  f <- file.path(wdir, tag)   # wdir: one temporary directory per direction (no shared PLINK prefixes between workers)
  fwrite(sig[, .(SNP, P = pmax(P, 1e-300))], paste0(f, ".p"), sep = "\t")
  system2(PLINK, c("--bfile", BFILE, "--clump", paste0(f, ".p"), "--clump-p1", thr, "--clump-p2", thr,
                   "--clump-r2", CLUMP_R2, "--clump-kb", CLUMP_KB, "--clump-field", "P", "--clump-snp-field", "SNP",
                   "--out", f), stdout = FALSE, stderr = FALSE)
  cf <- paste0(f, ".clumped")
  if (!file.exists(cf)) return(character(0))
  fread(cf)$SNP
}

select_instruments <- function(ex, exp_id) {
  info <- list()
  wdir <- file.path(TMP, exp_id); unlink(wdir, recursive = TRUE); dir.create(wdir, recursive = TRUE)
  for (thr in c(THR_MAIN, THR_FALLBACK)) {
    sig <- ex[P < thr]
    kept <- clump(sig, thr, paste0(exp_id, "_", thr), wdir)
    iv <- ex[SNP %in% kept][, F := (BETA / SE)^2]
    info <- list(threshold = thr, n_sig = nrow(sig), n_sig_in_ref = sum(sig$SNP %in% ref_snps),
                 n_clumped = length(kept), n_F_le_10 = iv[F <= F_MIN, .N])
    iv <- iv[F > F_MIN]
    info$n_after_F <- nrow(iv)
    if (nrow(iv) >= MIN_IV || thr == THR_FALLBACK) break
  }
  list(iv = iv, info = info)
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

simex_egger <- function(dat) {  # Bowden et al. 2016 (I²GX < 0.9): yönlendirilmiş Egger + SIMEX
  bx <- dat$beta.exposure; by <- dat$beta.outcome; sx <- dat$se.exposure; sy <- dat$se.outcome
  # simex modeli update(model, data = model$model) ile yeniden kurar; model çerçevesinde ağırlık sütunu
  # "(weights)" adını aldığı için ağırlık değişkeni formülün ortamından bulunmalıdır (Bowden et al. 2016 kodu
  # bunu küresel değişkenlerle sağlar). Değişkenler ayrı bir ortamda tutulur ve formüle bağlanır.
  e <- new.env()
  e$BYG <- by * sign(bx); e$BXG <- abs(bx); e$w <- 1 / sy^2
  f <- BYG ~ BXG; environment(f) <- e
  fit <- eval(bquote(lm(.(f), weights = w, x = TRUE, y = TRUE)))   # formül nesnesi çağrıya gömülür
  set.seed(SEED)
  s <- simex(fit, B = SIMEX_B, measurement.error = sx, SIMEXvariable = "BXG", fitting.method = "quad", asymptotic = FALSE)
  co <- summary(s)$coefficients$jackknife
  data.table(simex_intercept = co[1, 1], simex_intercept_se = co[1, 2], simex_intercept_p = co[1, 4],
             simex_slope = co[2, 1], simex_slope_se = co[2, 2], simex_slope_p = co[2, 4])
}

ref_snps <- fread(paste0(BFILE, ".bim"), select = 2, header = FALSE)[[1]]

run_direction <- function(row) {
  set.seed(SEED)   # her yön aynı sabit tohumla başlar (weighted mode bootstrap'ı, MR-PRESSO, SIMEX)
  exp_id <- row$exposure; out_id <- row$outcome
  log_line("yön:", row$id)
  ex <- load_trait(exp_id, p_max = THR_FALLBACK)            # yedek eşik dahil tüm aday enstrümanlar
  if (row$drop_apoe) ex <- ex[APOE == 0L]                   # §4.8: APOE bölgesindeki enstrümanlar çıkarılır
  sel <- select_instruments(ex, paste0(exp_id, if (row$drop_apoe) "_noapoe" else "", "__", out_id))
  iv <- sel$iv; info <- sel$info
  ou_iv <- load_trait(out_id, snps = iv$SNP)
  info$n_missing_outcome <- nrow(iv) - nrow(ou_iv)          # §4.5: proxy kullanılmaz
  exp_dat <- to_tsmr(iv[SNP %in% ou_iv$SNP], "exposure", exp_id, TRAITS[[mr_file_id(exp_id)]]$prev)
  out_dat <- to_tsmr(ou_iv, "outcome", out_id, TRAITS[[mr_file_id(out_id)]]$prev)
  res <- list(id = row$id, row = row, info = info)
  if (!nrow(exp_dat)) { res$status <- "no_instruments"; return(res) }
  # Uykusuzlukta EAF yok: palindromik SNP'lerin yönü frekansla belirlenemez, tümü çıkarılır (action 3; deviations C2)
  h_action <- if ("insomnia" %in% c(exp_id, out_id)) 3 else 2
  info$harmonise_action <- h_action
  dat <- suppressMessages(harmonise_data(exp_dat, out_dat, action = h_action))
  info$n_harmonised <- sum(dat$mr_keep)
  dat <- dat[dat$mr_keep, ]
  # Steiger (§4.5) + prevalans ×0,5 / ×2 sağlamlığı (§0.3)
  st <- function(k) { d <- dat; d$prevalence.exposure <- d$prevalence.exposure * k; d$prevalence.outcome <- d$prevalence.outcome * k
                      suppressMessages(steiger_filtering(d))$steiger_dir }
  sd1 <- st(1); sdh <- st(0.5); sd2 <- st(2)
  info$n_steiger_removed <- sum(!sd1, na.rm = TRUE)
  info$steiger_change_half <- sum(xor(sd1, sdh), na.rm = TRUE)
  info$steiger_change_double <- sum(xor(sd1, sd2), na.rm = TRUE)
  dat <- dat[!is.na(sd1) & sd1, ]
  n <- nrow(dat); info$n_final <- n
  # güç ve güç ölçüleri
  dat$F <- (dat$beta.exposure / dat$se.exposure)^2
  r2 <- dat$F / (dat$F + dat$samplesize.exposure - 2)
  info$mean_F <- mean(dat$F); info$total_R2 <- sum(r2)
  info$min_detectable_OR <- exp((qnorm(0.975) + qnorm(0.8)) / sqrt(sum(r2) * median(dat$samplesize.outcome) / 4))  # §4.10
  res$info <- info; res$dat <- dat
  if (n == 0) { res$status <- "no_instruments_after_filters"; return(res) }
  methods <- if (n >= 3) c("mr_ivw_mre", "mr_egger_regression", "mr_weighted_median", "mr_weighted_mode")
             else if (n == 2) "mr_ivw_mre" else "mr_wald_ratio"
  res$mr <- as.data.table(suppressMessages(mr(dat, method_list = methods)))
  if (n >= 2) res$het <- as.data.table(suppressMessages(mr_heterogeneity(dat,
                    method_list = if (n >= 3) c("mr_ivw", "mr_egger_regression") else "mr_ivw")))
  if (n >= 3) {
    res$pleio <- as.data.table(suppressMessages(mr_pleiotropy_test(dat)))
    res$isq <- Isq(abs(dat$beta.exposure), dat$se.exposure)
    if (res$isq < 0.9) res$simex <- tryCatch(simex_egger(dat), error = function(e) data.table(simex_error = conditionMessage(e)))
    res$loo <- as.data.table(suppressMessages(mr_leaveoneout(dat, method = mr_ivw_mre)))
  }
  if (n >= 4) {
    res$presso <- tryCatch({
      pr <- mr_presso(BetaOutcome = "beta.outcome", BetaExposure = "beta.exposure", SdOutcome = "se.outcome",
                      SdExposure = "se.exposure", data = as.data.frame(dat), OUTLIERtest = TRUE, DISTORTIONtest = TRUE,
                      SignifThreshold = 0.05, NbDistribution = PRESSO_NB, seed = SEED)
      mt <- as.data.table(pr$`Main MR results`)
      g <- pr$`MR-PRESSO results`
      out <- data.table(global_rss = g$`Global Test`$RSSobs, global_p = g$`Global Test`$Pvalue,
                        raw_beta = mt[1, `Causal Estimate`], raw_se = mt[1, Sd], raw_p = mt[1, `P-value`],
                        oc_beta = mt[2, `Causal Estimate`], oc_se = mt[2, Sd], oc_p = mt[2, `P-value`],
                        n_outliers = if (!is.null(g$`Distortion Test`)) length(g$`Distortion Test`$`Outliers Indices`) else 0L,
                        distortion_p = if (!is.null(g$`Distortion Test`)) g$`Distortion Test`$Pvalue else NA_real_)
      out
    }, error = function(e) data.table(presso_error = conditionMessage(e)))
  }
  res$status <- "ok"
  res
}

# Paralel: her yön ayrı bir işçide (MR-PRESSO tek çekirdekli ve en uzun adım). Çekirdek sayısı MR_CORES
# ortam değişkeniyle verilir (varsayılan 1). Çok enstrümanlı maruziyetler önce başlatılır (yük dengesi).
CORES <- as.integer(Sys.getenv("MR_CORES", "1"))
heavy <- c(mdd = 1, mdd_ukbb = 1, scz = 2, ptsd = 3, ad = 4, ad_finngen = 5, insomnia = 6, dlb = 7)
dirs <- dirs[order(heavy[exposure])]
log_line("çekirdek:", CORES)
RUNLOG <- P_("analysis", "logs", "mr_runlog.csv")
done <- mclapply(seq_len(nrow(dirs)), function(i) {
  row <- dirs[i]
  t0 <- Sys.time()
  # bir yönün hatası diğerlerini durdurmaz: hata yakalanır, loga ve rds'ye yazılır
  r <- tryCatch(run_direction(row), error = function(e) list(id = row$id, row = row, status = paste("error:", conditionMessage(e))))
  t1 <- Sys.time()
  r$runtime_min <- as.numeric(difftime(t1, t0, units = "mins"))
  saveRDS(r, file.path(OUTD, paste0(row$id, ".rds")))
  log_line("  ->", row$id, r$status, if (!is.null(r$info$n_final)) paste("n_iv =", r$info$n_final, "thr =", r$info$threshold) else "")
  data.table(id = row$id, set = row$set, exposure = row$exposure, outcome = row$outcome, drop_apoe = row$drop_apoe,
             start = format(t0, "%Y-%m-%d %H:%M:%S"), end = format(t1, "%Y-%m-%d %H:%M:%S"),
             runtime_min = round(r$runtime_min, 2), status = r$status,
             threshold = if (is.null(r$info$threshold)) NA else r$info$threshold,
             n_iv = if (is.null(r$info$n_final)) NA else r$info$n_final,
             mean_F = if (is.null(r$info$mean_F)) NA else round(r$info$mean_F, 2),
             min_F = if (is.null(r$dat)) NA else round(min(r$dat$F), 2),
             isq_gx = if (is.null(r$isq)) NA else round(r$isq, 4), seed = SEED)
}, mc.cores = CORES, mc.preschedule = FALSE)
ok <- vapply(done, is.data.table, TRUE)
runlog <- rbindlist(done[ok], fill = TRUE)
if (any(!ok)) runlog <- rbind(runlog, data.table(id = dirs$id[!ok], status = paste("worker failure:", vapply(done[!ok], function(x) paste(as.character(x), collapse = " "), ""))), fill = TRUE)
if (file.exists(RUNLOG) && length(args)) runlog <- rbind(fread(RUNLOG)[!id %in% runlog$id], runlog, fill = TRUE)
fwrite(runlog, RUNLOG)
log_line("durumlar:", paste(names(table(runlog$status)), table(runlog$status), collapse = "; "))
err <- runlog[!status %in% "ok"]
if (nrow(err)) { log_line("HATALI / SONUÇSUZ YÖNLER:"); print(err[, .(id, status)]) }
log_line("BİTTİ"); print(sessionInfo())

#!/usr/bin/env Rscript
# 03_lava.R — Plan §3: lokal genetik korelasyon (LAVA v0.1.5).
# Kullanım: Rscript analysis/R/03_lava.R ukb     (ana analiz, UK Biobank LD referansı)
#           Rscript analysis/R/03_lava.R g1000   (duyarlılık, 1000G EUR)
#           Rscript analysis/R/03_lava.R ukb update insomnia
#             (güncelleme: yalnız hedef özelliği içeren tek/iki değişkenli testler yeniden hesaplanır,
#              diğer satırlar mevcut sonuçtan korunur; deviations.md C2)
#           Rscript analysis/R/03_lava.R ukb seedcheck
#             (primer aile testleri ve ikincil ailenin BH eşiğindeki lokus-çifti, lokus-çifti tohumuyla yeniden
#              hesaplanır ve iki kez çalıştırılarak yeniden üretilebilirlik doğrulanır; results.json "lava_seed_check")
#           Rscript analysis/R/03_lava.R ukb strandcheck
#             (ana analizde FDR %5'te anlamlı lokus-çiftleri, olası iplik uyumsuzluğu olan palindromikler
#              çıkarılmış girdilerle yeniden hesaplanır; results.json "lava_strand_check"; deviations.md C3)
# 1000G duyarlılık analizi ve strandcheck, olası iplik uyumsuzluğu olan palindromikler çıkarılmış girdiler kullanır (C3).
# Girdi: data/munged/*.tsv.gz, results/rds/ldsc_main.rds (örneklem örtüşmesi, §3.2).
# İkili özellikler etkin N ve 0,5 vaka oranıyla girilir (deviations.md D1).
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))
suppressPackageStartupMessages({ library(LAVA); library(parallel) })
set.seed(SEED)

REF <- commandArgs(trailingOnly = TRUE)[1]
if (is.na(REF)) REF <- "ukb"
stopifnot(REF %in% c("ukb", "g1000"))
ref_prefix <- switch(REF, ukb = P_("data", "ref", "lava_ukb", "lava-ukb-v1.1"),
                          g1000 = P_("data", "ref", "g1000_eur", "g1000_eur"))
ARGS <- commandArgs(trailingOnly = TRUE)
UPDATE <- length(ARGS) >= 3 && ARGS[2] == "update"
TARGET <- if (UPDATE) ARGS[3] else NULL
OLD_RDS <- P_("results", "rds", sprintf("lava_%s.rds", REF))
if (UPDATE) stopifnot(file.exists(OLD_RDS))
STRANDCHECK <- length(ARGS) >= 2 && ARGS[2] == "strandcheck"
if (STRANDCHECK) stopifnot(REF == "ukb", file.exists(OLD_RDS))
SEEDCHECK <- length(ARGS) >= 2 && ARGS[2] == "seedcheck"
if (SEEDCHECK) stopifnot(REF == "ukb", file.exists(OLD_RDS))
STRAND_QC <- REF == "g1000" || STRANDCHECK
UNIV_P <- 1e-4                                  # §3.4
CORES <- max(1L, detectCores() - 2L)
traits <- c("ad", "dlb", "mdd", "ptsd", "insomnia", "scz")
# LAVA v0.1.5'te iki değişkenli p değeri (integral.p/bivariate.integral; 10^4 yineleme, p < 1e-4 ise 10^5,
# p < 1e-6 ise 10^6) ve %95 GA (ci.bivariate; 10^4 çekiliş) Monte Carlo ile (matrixsampling::rwishart)
# hesaplanır; tek değişkenli test deterministiktir. Yeniden üretilebilirlik için her lokus-çifti kendi sabit
# tohumuyla çalıştırılır: SEED + 1000*LOC + 10*i + j (i, j = özelliklerin traits içindeki sırası);
# böylece sonuç çekirdek sayısından ve iş sırasından bağımsızdır.
pair_seed <- function(L, p1, p2) SEED + 1000L * as.integer(L) + 10L * match(p1, traits) + match(p2, traits)
bivar_seeded <- function(locus, p1, p2) {
  set.seed(pair_seed(locus$id, p1, p2))
  as.data.table(run.bivar(locus, phenos = c(p1, p2)))
}

# ---- özet istatistik dosyaları (SNP A1 A2 N Z), MHC hariç ----
LS <- P_("data", if (STRAND_QC) "lava_sumstats_strandqc" else "lava_sumstats"); dir.create(LS, showWarnings = FALSE)
COMP <- c(A = "T", T = "A", C = "G", G = "C")
sq_counts <- list()
info <- rbindlist(lapply(traits, function(id) {
  f <- file.path(LS, paste0(id, ".txt.gz"))
  d <- read_munged(id, c("SNP", "A1", "A2", "Z", "NEFF", "MHC", "EAF", "REF_EAF"))[MHC == 0L & is.finite(Z) & !is.na(NEFF)]
  if (STRAND_QC) {  # C3: palindromik, MAF <= 0,42 (munge'da sağlandı) ve dosya EAF'ı 0,5'e göre referansın karşı tarafında
    d[, EAF := as.numeric(EAF)]
    flag <- d[, COMP[A1] == A2 & !is.na(EAF) & (EAF - 0.5) * (REF_EAF - 0.5) < 0]
    sq_counts[[id]] <<- data.table(trait = id, n_input = nrow(d), n_palindromic = d[COMP[A1] == A2, .N],
                                   n_removed_strand = sum(flag))
    d <- d[!flag]
  }
  if (!file.exists(f)) fwrite(d[, .(SNP, A1, A2, N = NEFF, Z)], f, sep = "\t")
  half <- round(median(d$NEFF) / 2)
  data.table(phenotype = id, cases = half, controls = half, prevalence = TRAITS[[id]]$prev, filename = f)
}))
if (STRAND_QC) { sq <- rbindlist(sq_counts); print(sq); fwrite(sq, P_("analysis", "logs", "lava_strandqc_counts.csv")) }
info_file <- P_("analysis", "logs", if (STRAND_QC) "lava_input_info_strandqc.txt" else "lava_input_info.txt")
fwrite(info, info_file, sep = "\t")

# ---- örneklem örtüşmesi: LDSC kesişim matrisi -> korelasyon (LAVA vinyeti) ----
fit <- readRDS(P_("results", "rds", "ldsc_main.rds"))
I <- fit$I; dimnames(I) <- list(colnames(fit$S), colnames(fit$S))
I <- I[traits, traits]
I[lower.tri(I)] <- t(I)[lower.tri(I)]
ov <- round(cov2cor(I), 5)
ov_file <- P_("analysis", "logs", "lava_sample_overlap.txt")
write.table(ov, ov_file, quote = FALSE)
log_line("örneklem örtüşme matrisi:"); print(ov)

# ---- lokuslar: MHC ile örtüşenler hariç (§3.1), APOE bayrağı (§3.7) ----
loci <- read.loci(P_("data", "raw", "lava_ref", "blocks_s2500_m25_f1_w200.GRCh37_hg19.locfile"))
mhc <- loci$CHR == 6 & loci$STOP >= 25e6 & loci$START <= 34e6
log_line("lokus:", nrow(loci), " MHC ile örtüşen (hariç):", sum(mhc))
loci <- loci[!mhc, ]
apoe_loc <- loci$LOC[loci$CHR == 19 & loci$STOP >= 44.4e6 & loci$START <= 46.5e6]

log_line("process.input, referans:", REF)
input <- process.input(input.info.file = info_file, sample.overlap.file = ov_file,
                       ref.prefix = ref_prefix, phenos = traits)

if (SEEDCHECK) {  # tohumlu yeniden hesap: primer aile + ikincil ailenin BH eşiğindeki çift
  old <- readRDS(OLD_RDS); ob <- old$bivar
  chk_bh <- ob[, .(d = max(abs(p.adjust(p, "BH") - p_fdr))), by = family]
  print(chk_bh); stopifnot(all(chk_bh$d < 1e-8))                       # p_fdr = aile içi BH (doğrulama)
  border <- ob[p_fdr < 0.05][, .SD[which.max(p)], by = family][family == "secondary"]
  rows <- rbind(ob[family == "primary"], border)
  log_line("seedcheck: primer test:", ob[family == "primary", .N], " sınır çift: LOC", border$LOC, border$phen1, border$phen2)
  chk <- rbindlist(mclapply(unique(rows$LOC), function(L) {
    locus <- process.locus(loci[loci$LOC == L, ], input)
    rr <- rows[LOC == L]
    rbindlist(lapply(seq_len(nrow(rr)), function(k) {
      r <- rr[k]
      a <- bivar_seeded(locus, r$phen1, r$phen2); b <- bivar_seeded(locus, r$phen1, r$phen2)
      data.table(LOC = L, CHR = r$CHR, family = r$family, phen1 = r$phen1, phen2 = r$phen2,
                 n_snps_main = r$n_snps, n_snps_seed = locus$n.snps, seed = pair_seed(L, r$phen1, r$phen2),
                 rho_main = r$rho, rho_lo_main = r$rho.lower, rho_hi_main = r$rho.upper, p_main = r$p, p_fdr_main = r$p_fdr,
                 rho_seed = a$rho, rho_lo_seed = a$rho.lower, rho_hi_seed = a$rho.upper, p_seed = a$p,
                 reproducible = identical(a$p, b$p) && identical(a$rho.lower, b$rho.lower) && identical(a$rho.upper, b$rho.upper))
    }))
  }, mc.cores = CORES, mc.preschedule = FALSE), fill = TRUE)
  chk[, mc_se_p := sqrt(p_seed * (1 - p_seed) / fifelse(p_seed < 1e-6, 1e6, fifelse(p_seed < 1e-4, 1e5, 1e4)))]
  chk[family == "primary", p_fdr_seed := p.adjust(p_seed, "BH")]
  sp <- merge(ob[family == "secondary", .(LOC, phen1, phen2, p)], chk[family == "secondary", .(LOC, phen1, phen2, p_seed)],
              by = c("LOC", "phen1", "phen2"), all.x = TRUE)
  sp[!is.na(p_seed), p := p_seed]; sp[, q := p.adjust(p, "BH")]
  chk[sp[!is.na(p_seed)], on = c("LOC", "phen1", "phen2"), p_fdr_seed := i.q]
  setorder(chk, family, LOC, phen1, phen2)
  fwrite(chk, P_("results", "tables", "lava_seed_check_ukb.csv"))
  n_main <- chk[family == "primary", sum(p_fdr_main < 0.05)]; n_seed <- chk[family == "primary", sum(p_fdr_seed < 0.05)]
  res_set("lava_seed_check", "summary", list(
    lava_version = as.character(packageVersion("LAVA")), seed_rule = "SEED + 1000*LOC + 10*i + j", seed_base = as.character(SEED),
    n_primary_tests = fmt_int(chk[family == "primary", .N]), primary_fdr_main = fmt_int(n_main), primary_fdr_seed = fmt_int(n_seed),
    primary_nominal_main = fmt_int(chk[family == "primary", sum(p_main < 0.05)]), primary_nominal_seed = fmt_int(chk[family == "primary", sum(p_seed < 0.05)]),
    all_reproducible = as.character(all(chk$reproducible)),
    max_abs_rho_diff = fmt_num(max(abs(chk$rho_main - chk$rho_seed)), 4),
    median_rel_p_diff = fmt_num(median(abs(chk$p_seed / chk$p_main - 1)), 3)))
  with(chk[family == "secondary"], res_set("lava_seed_check", "borderline", list(
    locus = sprintf("%s chr%s %s × %s", LOC, CHR, phen1, phen2), p_main = fmt_p(p_main), p_fdr_main = fmt_p(p_fdr_main),
    p_seed = fmt_p(p_seed), p_fdr_seed = fmt_p(p_fdr_seed), mc_se_p = fmt_num(mc_se_p, 4))))
  print(chk[, .(LOC, family, phen1, phen2, rho_main, rho_seed, p_main, p_seed, mc_se_p, p_fdr_main, p_fdr_seed, reproducible)], digits = 4)
  log_line("seedcheck primer FDR ana/tohumlu:", n_main, n_seed, " tümü yeniden üretilebilir:", all(chk$reproducible))
  if (n_seed != n_main) log_line("SEED_CHECK_CHANGE")
  log_line("BİTTİ"); quit(save = "no")
}

if (STRANDCHECK) {  # C3: ana analizdeki anlamlı lokus-çiftlerinin hedefli yeniden hesabı
  old <- readRDS(OLD_RDS); ob <- old$bivar
  cut <- ob[p_fdr < 0.05, .(bh_cutoff = max(p)), by = family]          # aile içi BH eşiği (diğer P'ler sabit)
  sigp <- merge(ob[p_fdr < 0.05], cut, by = "family")
  log_line("strandcheck: anlamlı lokus-çifti:", nrow(sigp), "lokus:", uniqueN(sigp$LOC))
  chk <- rbindlist(mclapply(unique(sigp$LOC), function(L) {
    locus <- process.locus(loci[loci$LOC == L, ], input)
    rows <- sigp[LOC == L]
    rbindlist(lapply(seq_len(nrow(rows)), function(k) {
      r <- rows[k]
      b <- tryCatch(bivar_seeded(locus, r$phen1, r$phen2), error = function(e) NULL)
      if (is.null(b) || !nrow(b)) return(data.table(LOC = L, phen1 = r$phen1, phen2 = r$phen2, status = "failed"))
      data.table(LOC = L, CHR = r$CHR, START = r$START, STOP = r$STOP, family = r$family, phen1 = r$phen1, phen2 = r$phen2,
                 n_snps_main = r$n_snps, n_snps_check = locus$n.snps,
                 rho_main = r$rho, rho_lo_main = r$rho.lower, rho_hi_main = r$rho.upper, p_main = r$p, p_fdr_main = r$p_fdr,
                 rho_check = b$rho, rho_lo_check = b$rho.lower, rho_hi_check = b$rho.upper, p_check = b$p,
                 bh_cutoff = r$bh_cutoff, status = "ok")
    }))
  }, mc.cores = CORES, mc.preschedule = FALSE), fill = TRUE)
  chk[, sign_same := sign(rho_main) == sign(rho_check)]
  chk[, sig_retained := p_check <= bh_cutoff]
  chk[, changed := !sign_same | !sig_retained | status != "ok"]
  fwrite(chk, P_("results", "tables", "lava_strand_check_ukb.csv"))
  for (r in seq_len(nrow(chk))) with(chk[r], res_set("lava_strand_check", sprintf("locus.%s.%s_%s", LOC, phen1, phen2), list(
    family = family, rho_main = fmt_ci(rho_main, rho_lo_main, rho_hi_main), p_main = fmt_p(p_main), p_fdr_main = fmt_p(p_fdr_main),
    rho_check = fmt_ci(rho_check, rho_lo_check, rho_hi_check), p_check = fmt_p(p_check),
    n_snps_main = fmt_int(n_snps_main), n_snps_check = fmt_int(n_snps_check),
    sign_same = as.character(sign_same), significance_retained = as.character(sig_retained))))
  res_set("lava_strand_check", "summary", list(n_pairs = fmt_int(nrow(chk)), n_loci = fmt_int(uniqueN(chk$LOC)),
    n_changed = fmt_int(sum(chk$changed, na.rm = TRUE)), max_abs_rho_diff = fmt_num(max(abs(chk$rho_main - chk$rho_check), na.rm = TRUE), 3)))
  log_line("strandcheck değişen:", sum(chk$changed, na.rm = TRUE))
  if (any(chk$changed, na.rm = TRUE)) { log_line("STRAND_CHECK_CHANGE"); print(chk[changed == TRUE]) }
  log_line("BİTTİ"); quit(save = "no")
}
log_line("lokus analizi başlıyor,", nrow(loci), "lokus,", CORES, "çekirdek")
res <- mclapply(seq_len(nrow(loci)), function(i) {
  out <- tryCatch({
    locus <- process.locus(loci[i, ], input)
    if (is.null(locus)) return(list(status = data.table(LOC = loci$LOC[i], status = "not_processed")))
    if (!is.null(TARGET) && !TARGET %in% locus$phenos)  # hedef bu lokusta LAVA tarafından düşürüldü (negatif varyans)
      return(list(status = data.table(LOC = locus$id, status = "ok_target_dropped")))
    # run.univ.bivar ile aynı mantık (tek değişkenli eşik, hedef), ama her çift kendi tohumuyla:
    univ <- as.data.table(run.univ(locus, locus$phenos))
    pass <- as.character(univ[p < UNIV_P, phen])
    bv <- NULL
    if (length(pass) > 1 && (is.null(TARGET) || TARGET %in% pass)) {
      prs <- if (is.null(TARGET)) t(combn(pass, 2)) else cbind(setdiff(pass, TARGET), TARGET)
      bv <- rbindlist(lapply(seq_len(nrow(prs)), function(k) bivar_seeded(locus, prs[k, 1], prs[k, 2])), fill = TRUE)
    }
    r <- list(univ = univ, bivar = bv)
    meta <- data.table(LOC = locus$id, CHR = locus$chr, START = locus$start, STOP = locus$stop,
                       n_snps = locus$n.snps, n_pcs = locus$K)
    list(univ = cbind(meta, as.data.table(r$univ)),
         bivar = if (!is.null(r$bivar)) cbind(meta, as.data.table(r$bivar)) else NULL,
         status = data.table(LOC = locus$id, status = "ok"))
  }, error = function(e) list(status = data.table(LOC = loci$LOC[i], status = paste("error:", conditionMessage(e)))))
  out
}, mc.cores = CORES, mc.preschedule = FALSE)

# checkpoint: ham lokus sonuçları, sonraki adımlar başarısız olursa yeniden analiz gerekmesin
saveRDS(res, P_("results", "rds", sprintf("lava_%s_raw_%s.rds", REF, if (UPDATE) paste0("update_", TARGET) else "full")))
log_line("ham sonuçlar kaydedildi")
univ   <- rbindlist(lapply(res, `[[`, "univ"), fill = TRUE)
bivar  <- rbindlist(lapply(res, `[[`, "bivar"), fill = TRUE)
status <- rbindlist(lapply(res, `[[`, "status"), fill = TRUE)
if (UPDATE) {  # hedef özelliği içeren satırlar yenisiyle değiştirilir, diğerleri korunur
  old <- readRDS(OLD_RDS)
  keep_cols <- function(x) x[, !names(x) %in% c("APOE_locus", "primary_pair", "family", "p_fdr", "n_tests", "p_bonf", "input_version"), with = FALSE]
  ou <- keep_cols(copy(old$univ)); ob <- keep_cols(copy(old$bivar))
  ou[, input_version := "pre_C2"]; ob[, input_version := "pre_C2"]
  univ <- univ[phen == TARGET][, input_version := "post_C2"]
  bivar <- if (nrow(bivar)) bivar[phen1 == TARGET | phen2 == TARGET][, input_version := "post_C2"] else bivar
  log_line("güncelleme:", TARGET, "univ satır:", nrow(univ), "bivar satır:", nrow(bivar),
           "| korunan univ:", ou[phen != TARGET, .N], "bivar:", ob[phen1 != TARGET & phen2 != TARGET, .N])
  univ <- rbind(ou[phen != TARGET], univ, fill = TRUE)
  bivar <- rbind(ob[phen1 != TARGET & phen2 != TARGET], bivar, fill = TRUE)
  setorder(univ, LOC, phen); setorder(bivar, LOC, phen1, phen2)
}
log_line("işlenen lokus:", status[status == "ok", .N], " işlenemeyen:", status[status == "not_processed", .N],
         " hata:", status[grepl("^error", status), .N])
fwrite(status, P_("results", "tables", sprintf("lava_status_%s.csv", REF)))

# ---- çift sınıfı ve çoklu test (§3.6) ----
univ[, APOE_locus := LOC %in% apoe_loc]
if (nrow(bivar)) {
  bivar[, APOE_locus := LOC %in% apoe_loc]
  bivar[, primary_pair := (phen1 %in% DEMENTIA & phen2 %in% PSYCH) | (phen2 %in% DEMENTIA & phen1 %in% PSYCH)]
  bivar[, family := fifelse(primary_pair, "primary", "secondary")]
  bivar[, p_fdr := p.adjust(p, "BH"), by = family]
  bivar[, n_tests := .N, by = family]
  bivar[, p_bonf := pmin(1, p * n_tests)]
}
fwrite(univ, P_("results", "tables", sprintf("lava_univ_%s.csv", REF)))
fwrite(bivar, P_("results", "tables", sprintf("lava_bivar_%s.csv", REF)))
saveRDS(list(univ = univ, bivar = bivar, status = status, overlap = ov), P_("results", "rds", sprintf("lava_%s.rds", REF)))

# ---- results.json ----
sec <- paste0("lava_", REF)
res_set(sec, "summary", list(
  loci_total = fmt_int(nrow(loci) + sum(mhc)), loci_mhc_excluded = fmt_int(sum(mhc)),
  loci_analysed = fmt_int(status[status %in% c("ok", "ok_target_dropped"), .N]),
  bivar_tests_primary = fmt_int(bivar[family == "primary", .N]),
  bivar_tests_secondary = fmt_int(bivar[family == "secondary", .N]),
  sig_fdr_primary = fmt_int(bivar[family == "primary" & p_fdr < 0.05, .N]),
  sig_bonf_primary = fmt_int(bivar[family == "primary" & p_bonf < 0.05, .N])))
for (pp in unique(bivar[family == "primary", paste(phen1, phen2, sep = "_")])) {
  b <- bivar[paste(phen1, phen2, sep = "_") == pp]
  res_set(sec, paste0("pair.", pp), list(n_tests = fmt_int(nrow(b)), n_sig_fdr = fmt_int(b[p_fdr < 0.05, .N])))
}
sig <- bivar[family == "primary" & p_fdr < 0.05]
for (r in seq_len(nrow(sig))) with(sig[r], res_set(sec, sprintf("locus.%s.%s_%s", LOC, phen1, phen2), list(
  locus = sprintf("chr%d:%s–%s", CHR, fmt_int(START), fmt_int(STOP)),
  rho = fmt_ci(rho, rho.lower, rho.upper), p = fmt_p(p), p_fdr = fmt_p(p_fdr), apoe = as.character(APOE_locus))))
log_line("BİTTİ"); print(sessionInfo())

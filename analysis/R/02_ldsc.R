#!/usr/bin/env Rscript
# 02_ldsc.R — Plan §2: genom geneli genetik korelasyon (GenomicSEM ldsc), §2.4 duyarlılıklar,
# §4b FinnGen rg (dosya varsa). Çoklu test §6.2.
# Kullanım: Rscript analysis/R/02_ldsc.R
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))
suppressPackageStartupMessages(library(GenomicSEM))
set.seed(SEED)

# ---- LD skorları: GenomicSEM'in beklediği adlar (<chr>.l2.ldscore.gz, <chr>.l2.M_5_50) ----
refd <- P_("data", "raw", "ldsc_ref")
LD <- P_("data", "ref", "ldsc_ld"); WLD <- P_("data", "ref", "ldsc_wld")
dir.create(LD, recursive = TRUE, showWarnings = FALSE); dir.create(WLD, recursive = TRUE, showWarnings = FALSE)
for (i in 1:22) {
  file.symlink(file.path(refd, "LDscore", sprintf("LDscore.%d.l2.ldscore.gz", i)), file.path(LD, sprintf("%d.l2.ldscore.gz", i)))
  file.symlink(file.path(refd, "LDscore", sprintf("LDscore.%d.l2.M_5_50", i)), file.path(LD, sprintf("%d.l2.M_5_50", i)))
  file.symlink(file.path(refd, "1000G_Phase3_weights_hm3_no_MHC", sprintf("weights.hm3_noMHC.%d.l2.ldscore.gz", i)),
               file.path(WLD, sprintf("%d.l2.ldscore.gz", i)))
  file.symlink(file.path(refd, "LDscore", sprintf("LDscore.%d.l2.M_5_50", i)), file.path(WLD, sprintf("%d.l2.M_5_50", i)))
}
hm3 <- rbindlist(lapply(1:22, function(i) fread(file.path(WLD, sprintf("%d.l2.ldscore.gz", i)), select = "SNP")))$SNP
log_line("HapMap3 (weights) SNP:", length(hm3))

# ---- LDSC girdi dosyaları (SNP A1 A2 N Z), HapMap3, MHC hariç; A1 = 1000G referans aleli (01_munge) ----
SS <- P_("data", "ldsc_sumstats"); dir.create(SS, showWarnings = FALSE)
make_sumstats <- function(id, drop_apoe = FALSE, tag = id) {
  if (!file.exists(P_("data", "munged", paste0(TRAITS[[id]]$file, ".tsv.gz")))) return(NULL)
  d <- read_munged(id, c("SNP", "A1", "A2", "Z", "NEFF", "MHC", "APOE"))
  d <- d[SNP %in% hm3 & MHC == 0L & is.finite(Z) & !is.na(NEFF)]
  if (drop_apoe) d <- d[APOE == 0L]
  out <- file.path(SS, paste0(tag, ".sumstats.gz"))
  fwrite(d[, .(SNP, A1, A2, N = NEFF, Z)], out, sep = "\t")
  log_line(tag, "LDSC SNP:", nrow(d))
  data.table(tag = tag, trait = id, n_snp = nrow(d), drop_apoe = drop_apoe, file = out)
}
inputs <- rbindlist(list(
  make_sumstats("ad"), make_sumstats("dlb"), make_sumstats("mdd"), make_sumstats("ptsd"),
  make_sumstats("insomnia"), make_sumstats("scz"), make_sumstats("mdd_ukbb"), make_sumstats("ptsd_cc"),
  make_sumstats("ad", drop_apoe = TRUE, tag = "ad_noapoe"), make_sumstats("ad_finngen"),
  make_sumstats("ad_finngen", drop_apoe = TRUE, tag = "ad_finngen_noapoe")))
fwrite(inputs, P_("results", "tables", "ldsc_inputs.csv"))

# ---- ldsc çalıştırıcı ----
prev_of <- function(tag) TRAITS[[sub("_noapoe$", "", tag)]]$prev
run_ldsc <- function(tags, name) {
  tags <- tags[tags %in% inputs$tag]
  log_line("ldsc:", name, paste(tags, collapse = ", "))
  owd <- setwd(P_("analysis", "logs"))
  on.exit(setwd(owd))
  # Gözlenen ölçek (Neff, örneklem prevalansı 0,5 eşdeğeri): sample.prev = NA, population.prev = NA.
  fit <- ldsc(traits = inputs[match(tags, tag), file], sample.prev = rep(NA, length(tags)),
              population.prev = rep(NA, length(tags)), ld = LD, wld = WLD, sep_weights = TRUE, trait.names = tags,
              stand = TRUE, ldsc.log = paste0("ldsc_", name))
  saveRDS(fit, P_("results", "rds", paste0("ldsc_", name, ".rds")))
  list(fit = fit, tags = tags)
}

# vech sırası (alt üçgen, sütun sütun)
vech_index <- function(k) { m <- matrix(0, k, k); m[lower.tri(m, diag = TRUE)] <- seq_len(k * (k + 1) / 2); m }
liab <- function(h2o, K, P = 0.5) { z <- dnorm(qnorm(1 - K)); h2o * K^2 * (1 - K)^2 / (P * (1 - P) * z^2) }

extract <- function(res, name) {
  f <- res$fit; tg <- res$tags; k <- length(tg); idx <- vech_index(k)
  h2 <- rbindlist(lapply(seq_len(k), function(i) {
    est <- f$S[i, i]; se <- sqrt(f$V[idx[i, i], idx[i, i]]); K <- prev_of(tg[i])
    data.table(run = name, trait = tg[i], h2_obs = est, h2_obs_se = se, h2_z = est / se,
               h2_liab = liab(est, K), h2_liab_se = liab(se, K), prevalence = K, intercept = f$I[i, i])
  }))
  rg <- rbindlist(lapply(combn(k, 2, simplify = FALSE), function(p) {
    i <- max(p); j <- min(p)
    est <- f$S_Stand[i, j]; se <- sqrt(f$V_Stand[idx[i, j], idx[i, j]])
    data.table(run = name, trait1 = tg[j], trait2 = tg[i], rg = est, se = se,
               lo = est - 1.959964 * se, hi = est + 1.959964 * se,
               p = 2 * pnorm(-abs(est / se)), cross_intercept = f$I[i, j])
  }))
  list(h2 = h2, rg = rg)
}

runs <- list(
  main          = c("ad", "dlb", "mdd", "ptsd", "insomnia", "scz"),        # §2.1, 15 çift
  sens_mdd_ukbb = c("ad", "dlb", "mdd_ukbb"),                              # §2.4a
  sens_ptsd_cc  = c("ad", "dlb", "ptsd_cc"),                               # §2.4b
  sens_noapoe   = c("ad_noapoe", "mdd", "ptsd", "insomnia", "scz"),        # §2.4c (H3)
  finngen       = c("ad_finngen", "mdd", "ptsd", "insomnia", "scz"),       # §4b
  finngen_noapoe = c("ad_finngen_noapoe", "mdd", "ptsd", "insomnia", "scz")
)
H2 <- list(); RG <- list()
for (nm in names(runs)) {
  if (!all(c(runs[[nm]][1]) %in% inputs$tag)) { log_line("atlandı (girdi yok):", nm); next }
  e <- extract(run_ldsc(runs[[nm]], nm), nm)
  H2[[nm]] <- e$h2; RG[[nm]] <- e$rg
}
H2 <- rbindlist(H2); RG <- rbindlist(RG)

# ---- çift sınıfı ve çoklu test (§6.2) ----
base <- function(x) sub("_(noapoe|ukbb|cc)$", "", sub("^ad_finngen.*", "ad_finngen", x))
RG[, b1 := base(trait1)][, b2 := base(trait2)]
RG[, primary_pair := (b1 %in% c(DEMENTIA, "ad_finngen") & b2 %in% PSYCH) | (b2 %in% c(DEMENTIA, "ad_finngen") & b1 %in% PSYCH)]
RG[run == "main", family := fifelse(primary_pair, "primary", "secondary")]
RG[run != "main", family := "sensitivity"]
RG[family %in% c("primary", "secondary"), p_fdr := p.adjust(p, "BH"), by = family]
RG[family %in% c("primary", "secondary"), p_bonf := pmin(1, p * .N), by = family]
# §4b.5: FinnGen testleri anlamlılık ilanında kullanılmaz; tutarlılık raporu için 4 psikiyatrik × FinnGen AD
# testi kendi içinde BH ve Bonferroni ile düzeltilir (bilgi amaçlı).
RG[run == "finngen" & primary_pair, `:=`(p_fdr_within4 = p.adjust(p, "BH"), p_bonf_within4 = pmin(1, p * .N))]
RG[, c("b1", "b2") := NULL]
H2[, h2_lowpower := h2_z < 4]                                               # §2.5

fwrite(H2, P_("results", "tables", "ldsc_h2.csv"))
fwrite(RG, P_("results", "tables", "ldsc_rg.csv"))

# ---- results.json ----
for (r in seq_len(nrow(H2))) with(H2[r], res_set("ldsc_h2", paste(run, trait, sep = "."), list(
  h2_obs = fmt_ci(h2_obs, h2_obs - 1.959964 * h2_obs_se, h2_obs + 1.959964 * h2_obs_se, 3),
  h2_liab = fmt_num(h2_liab, 3), intercept = fmt_num(intercept, 3), h2_z = fmt_num(h2_z, 1))))
for (r in seq_len(nrow(RG))) with(RG[r], res_set("ldsc_rg", paste(run, trait1, trait2, sep = "."), list(
  rg = fmt_ci(rg, lo, hi), p = fmt_p(p), p_fdr = fmt_p(p_fdr), cross_intercept = fmt_num(cross_intercept, 3))))
# FinnGen duyarlılık analizi ayrı bölümde (yalnız tutarlılık için; §4b.5)
fg <- RG[run %in% c("finngen", "finngen_noapoe") & primary_pair]
for (r in seq_len(nrow(fg))) with(fg[r], res_set("sensitivity_finngen", paste("ldsc", run, trait2, sep = "."), list(
  rg = fmt_ci(rg, lo, hi), p_uncorrected = fmt_p(p),
  p_bh_within4 = if (run == "finngen") fmt_p(p_fdr_within4) else "NA",
  p_bonferroni_within4 = if (run == "finngen") fmt_p(p_bonf_within4) else "NA",
  cross_intercept = fmt_num(cross_intercept, 3),
  note = "consistency check only; not used to declare significance (plan 4b.5)")))
fgh <- H2[grepl("^ad_finngen", trait)]
for (r in seq_len(nrow(fgh))) with(fgh[r], res_set("sensitivity_finngen", paste("ldsc_h2", trait, sep = "."), list(
  h2_obs = fmt_ci(h2_obs, h2_obs - 1.959964 * h2_obs_se, h2_obs + 1.959964 * h2_obs_se, 3), h2_z = fmt_num(h2_z, 1),
  intercept = fmt_num(intercept, 3))))
log_line("BİTTİ")
print(sessionInfo())

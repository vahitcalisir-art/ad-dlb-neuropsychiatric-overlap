#!/usr/bin/env Rscript
# 06d_lava_g1000_fdr_pairs.R — Supplementary table (investigator decision 2026-11-21): every primary-family
# locus–pair significant at FDR 5% with the 1000 Genomes reference (sensitivity analysis), with the UK Biobank
# (main, pre-registered) estimate of the same pair side by side. Descriptive; no new test.
# A pair may be untested with UK Biobank when a trait failed the univariate filter (p < 1e-4) there.
# Output: results/tables/supp_lava_g1000_fdr_pairs.csv; results.json "lava_g1000_fdr_pairs".
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))

g <- fread(P_("results", "tables", "lava_bivar_g1000.csv"))[family == "primary" & p_fdr < 0.05]
u <- fread(P_("results", "tables", "lava_bivar_ukb.csv"))[family == "primary"]
uu <- fread(P_("results", "tables", "lava_univ_ukb.csv"))
k <- c("LOC", "phen1", "phen2")
cols <- c(k, "CHR", "START", "STOP", "rho", "rho.lower", "rho.upper", "p", "p_fdr")
m <- merge(g[, ..cols], u[, c(k, "rho", "rho.lower", "rho.upper", "p", "p_fdr"), with = FALSE], by = k, all.x = TRUE, suffixes = c("_g1000", "_ukb"))
# why untested with UKB: univariate P of each trait at that locus in the UKB run (NA = locus/trait not analysed)
up <- function(L, ph) { x <- uu[LOC == L & phen == ph, p]; if (length(x)) x[1] else NA_real_ }
m[, `:=`(ukb_univ_p_phen1 = mapply(up, LOC, phen1), ukb_univ_p_phen2 = mapply(up, LOC, phen2))]
m[, ukb_status := fifelse(is.na(p_ukb), "not tested with UK Biobank (univariate filter)",
                  fifelse(p_fdr_ukb < 0.05, "FDR < 0.05", fifelse(p_ukb < 0.05, "nominal P < 0.05", "P ≥ 0.05")))]
m[, same_sign := fifelse(is.na(rho_ukb), NA, sign(rho_ukb) == sign(rho_g1000))]
setorder(m, CHR, START, phen1, phen2)
fwrite(m, P_("results", "tables", "supp_lava_g1000_fdr_pairs.csv"))
print(m[, .(LOC, CHR, phen1, phen2, rho_g1000 = round(rho_g1000, 2), p_g1000 = signif(p_g1000, 2),
            rho_ukb = round(rho_ukb, 2), p_ukb = signif(p_ukb, 2), ukb_status, same_sign)])
nom <- m[ukb_status %in% c("nominal P < 0.05", "FDR < 0.05")]
res_set("lava_g1000_fdr_pairs", "summary", list(
  n_fdr_pairs_g1000 = fmt_int(nrow(m)), n_loci = fmt_int(uniqueN(m$LOC)),
  n_tested_ukb = fmt_int(m[!is.na(p_ukb), .N]), n_nominal_ukb = fmt_int(nrow(nom)),
  n_same_sign_ukb = fmt_int(sum(m$same_sign, na.rm = TRUE)),
  nominal_ukb_pairs = paste(sprintf("%s:%s×%s", nom$LOC, nom$phen1, nom$phen2), collapse = "; "),
  n_not_tested_ukb = fmt_int(m[is.na(p_ukb), .N])))
for (i in seq_len(nrow(m))) with(m[i], res_set("lava_g1000_fdr_pairs", sprintf("locus.%s.%s_%s", LOC, phen1, phen2), list(
  chr = as.character(CHR), rho_g1000 = fmt_ci(rho_g1000, rho.lower_g1000, rho.upper_g1000), p_g1000 = fmt_p(p_g1000), p_fdr_g1000 = fmt_p(p_fdr_g1000),
  rho_ukb = if (is.na(rho_ukb)) "not tested" else fmt_ci(rho_ukb, rho.lower_ukb, rho.upper_ukb), p_ukb = if (is.na(p_ukb)) "not tested" else fmt_p(p_ukb),
  ukb_status = ukb_status)))
log_line("BİTTİ")

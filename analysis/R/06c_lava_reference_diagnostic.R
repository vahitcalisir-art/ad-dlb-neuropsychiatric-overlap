#!/usr/bin/env Rscript
# 06c_lava_reference_diagnostic.R — descriptive consistency check of the two LD reference panels
# (UK Biobank, main; 1000 Genomes EUR, sensitivity). No new inferential test.
# For each trait and reference: sum of LAVA local h2 over analysed loci, compared with the genome-wide
# LDSC h2 of the same trait on the same scale.
#   Scale: LAVA was given cases = controls = Neff/2 (deviations D1), so h2.obs is on the observed scale for
#   a sample prevalence of 0.5; LDSC (02_ldsc.R) was run with effective N and sample.prev = NA, i.e. the same
#   observed scale. Liability-scale sums (h2.latent vs LDSC h2_liab, same population prevalences) are added
#   as a cross-check.
#   Caveats recorded in the output: loci where LAVA dropped a trait for a negative variance estimate do not
#   enter the sum (so the sum is truncated upwards for both references); the MHC is excluded from LAVA loci
#   but not from LDSC. Sums are therefore descriptive, not estimates of SNP-heritability.
# Output: results/tables/lava_reference_diagnostic.csv; results.json "lava_reference_diagnostic".
# Usage: Rscript analysis/R/06c_lava_reference_diagnostic.R
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))

traits <- c("ad", "dlb", "mdd", "ptsd", "insomnia", "scz")
UNIV_P <- 1e-4
u <- list(ukb = fread(P_("results", "tables", "lava_univ_ukb.csv")),
          g1000 = fread(P_("results", "tables", "lava_univ_g1000.csv")))
for (r in names(u)) u[[r]] <- u[[r]][, .(LOC, phen, n_pcs = as.numeric(n_pcs), h2.obs = as.numeric(h2.obs),
                                         h2.latent = as.numeric(h2.latent), p)]
ld <- fread(P_("results", "tables", "ldsc_h2.csv"))[run == "main"]

out <- rbindlist(lapply(traits, function(tr) {
  a <- u$ukb[phen == tr]; b <- u$g1000[phen == tr]
  common <- intersect(a$LOC, b$LOC)
  l <- ld[trait == tr]
  rbindlist(lapply(c("ukb", "g1000"), function(r) {
    x <- u[[r]][phen == tr]; xc <- x[LOC %in% common]
    data.table(trait = tr, reference = r,
               n_loci = nrow(x), sum_h2_obs = sum(x$h2.obs), n_loci_common = nrow(xc), sum_h2_obs_common = sum(xc$h2.obs),
               ldsc_h2_obs = l$h2_obs, ldsc_h2_obs_lo = l$h2_obs - 1.96 * l$h2_obs_se, ldsc_h2_obs_hi = l$h2_obs + 1.96 * l$h2_obs_se,
               ratio_obs = sum(x$h2.obs) / l$h2_obs, ratio_obs_common = sum(xc$h2.obs) / l$h2_obs,
               sum_h2_liab = sum(x$h2.latent), ldsc_h2_liab = l$h2_liab, ratio_liab = sum(x$h2.latent) / l$h2_liab,
               n_univ_pass = sum(x$p < UNIV_P), frac_univ_p05 = mean(x$p < 0.05), median_n_pcs = median(x$n_pcs),
               ldsc_low_power = l$h2_lowpower)
  }))
}))
fwrite(out, P_("results", "tables", "lava_reference_diagnostic.csv"))
print(out[, .(trait, reference, n_loci, sum_h2_obs = signif(sum_h2_obs, 3), ldsc_h2_obs = signif(ldsc_h2_obs, 3),
              ratio_obs = round(ratio_obs, 2), ratio_obs_common = round(ratio_obs_common, 2), ratio_liab = round(ratio_liab, 2),
              n_univ_pass, frac_univ_p05 = round(frac_univ_p05, 2), median_n_pcs)])

res_set("lava_reference_diagnostic", "note", list(
  type = "descriptive consistency check; no inferential test",
  scale = "observed scale (sample prevalence 0.5, effective N) for both LAVA h2.obs and LDSC h2_obs; liability scale as cross-check",
  caveats = "loci where a trait was dropped for negative variance are not in the sum (upward truncation, both references); MHC excluded from LAVA loci only"))
for (i in seq_len(nrow(out))) with(out[i], res_set("lava_reference_diagnostic", paste(trait, reference, sep = "."), list(
  n_loci = fmt_int(n_loci), sum_local_h2_obs = fmt_num(sum_h2_obs, 3),
  ldsc_h2_obs = fmt_ci(ldsc_h2_obs, ldsc_h2_obs_lo, ldsc_h2_obs_hi, 3),
  ratio_sum_to_ldsc_obs = fmt_num(ratio_obs, 2), ratio_sum_to_ldsc_obs_common_loci = fmt_num(ratio_obs_common, 2),
  n_loci_common = fmt_int(n_loci_common), ratio_sum_to_ldsc_liab = fmt_num(ratio_liab, 2),
  univariate_passes = fmt_int(n_univ_pass), share_univariate_p_lt_0_05 = fmt_num(frac_univ_p05, 2),
  median_n_pcs = fmt_num(median_n_pcs, 0), ldsc_h2_low_power = as.character(ldsc_low_power))))
# Supplementary table (investigator decision 2026-11-21): only the relative column — 1000 Genomes / UK Biobank
# ratio of summed local h2 over loci analysed with both references — titled "systematic difference between the
# two reference panels". Absolute sum/LDSC columns are not shown (not comparable, see note); causal explanation
# pending a Faz 5 source.
sup <- dcast(out, trait ~ reference, value.var = c("sum_h2_obs_common", "n_loci_common"))
sup <- sup[, .(trait, n_loci_common = n_loci_common_ukb, ratio_g1000_to_ukb_common = sum_h2_obs_common_g1000 / sum_h2_obs_common_ukb)]
sup <- sup[match(traits, trait)]
fwrite(sup, P_("results", "tables", "supp_lava_reference_panel_ratio.csv"))
print(sup)
res_set("lava_reference_diagnostic", "supplementary", list(
  title = "Systematic difference between the two reference panels",
  column = "ratio of summed local SNP-heritability (observed scale), 1000 Genomes EUR / UK Biobank, over loci analysed with both references",
  range = paste(fmt_num(min(sup$ratio_g1000_to_ukb_common), 2), fmt_num(max(sup$ratio_g1000_to_ukb_common), 2), sep = "–"),
  note = "Summed local heritabilities are not comparable with genome-wide LDSC estimates because loci with negative variance estimates are dropped."))
for (i in seq_len(nrow(sup))) with(sup[i], res_set("lava_reference_diagnostic", paste(trait, "ratio_g1000_to_ukb_common", sep = "."),
  list(n_loci_common = fmt_int(n_loci_common), ratio = fmt_num(ratio_g1000_to_ukb_common, 2))))
log_line("BİTTİ")

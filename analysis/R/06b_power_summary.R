#!/usr/bin/env Rscript
# 06b_power_summary.R — context for null results (descriptive; no new tests).
# (1) LDSC: 95% CI bounds of rg for each primary pair (plan §2) -> "correlations larger than X could be excluded".
# (2) LAVA: per primary pair, loci analysed, loci testable (both traits pass the univariate filter, plan §3.4),
#     loci with nominal P < 0.05 and the number expected under the null (0.05 × testable).
# (3) MR minimum detectable OR (plan §4.10) is computed in 04_mr.R and written to results.json by 05_mr_sensitivity.R.
# Usage: Rscript analysis/R/06b_power_summary.R
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))

# ---- (1) LDSC ----
rg <- fread(P_("results", "tables", "ldsc_rg.csv"))[run == "main" & primary_pair == TRUE]
for (i in seq_len(nrow(rg))) with(rg[i], res_set("power_ldsc", paste(trait1, trait2, sep = "."), list(
  rg = fmt_num(rg, 2), ci_lower = fmt_num(lo, 2), ci_upper = fmt_num(hi, 2),
  excluded_above = fmt_num(hi, 2), excluded_below = fmt_num(lo, 2), p = fmt_p(p), p_fdr = fmt_p(p_fdr))))
fwrite(rg[, .(trait1, trait2, rg, se, lo, hi, p, p_fdr)], P_("results", "tables", "power_ldsc.csv"))
log_line("LDSC primary pairs:", nrow(rg))

# ---- (2) LAVA ----
lava_counts <- function(REF) {
  fu <- P_("results", "tables", sprintf("lava_univ_%s.csv", REF)); fb <- P_("results", "tables", sprintf("lava_bivar_%s.csv", REF))
  fs <- P_("results", "tables", sprintf("lava_status_%s.csv", REF))
  if (!file.exists(fu) || !file.exists(fb)) return(NULL)
  univ <- fread(fu); bivar <- fread(fb); n_loci <- fread(fs)[status == "ok", .N]
  pass <- univ[p < 1e-4, .(n_pass = uniqueN(LOC)), by = phen]
  pairs <- CJ(dem = DEMENTIA, psy = PSYCH)
  out <- rbindlist(lapply(seq_len(nrow(pairs)), function(i) {
    d <- pairs$dem[i]; s <- pairs$psy[i]
    b <- bivar[(phen1 == d & phen2 == s) | (phen1 == s & phen2 == d)]
    data.table(ref = REF, dementia = d, psychiatric = s, loci_analysed = n_loci,
               loci_univ_dementia = pass[phen == d, n_pass][1], loci_univ_psychiatric = pass[phen == s, n_pass][1],
               loci_testable = nrow(b), loci_nominal_p05 = b[p < 0.05, .N], expected_nominal = 0.05 * nrow(b),
               loci_fdr05 = if ("p_fdr" %in% names(b)) b[p_fdr < 0.05, .N] else NA_integer_)
  }))
  out[is.na(loci_univ_dementia), loci_univ_dementia := 0L][is.na(loci_univ_psychiatric), loci_univ_psychiatric := 0L]
  out
}
lv <- rbindlist(lapply(c("ukb", "g1000"), lava_counts))
fwrite(lv, P_("results", "tables", "power_lava.csv"))
for (i in seq_len(nrow(lv))) with(lv[i], res_set(paste0("power_lava_", ref), paste(dementia, psychiatric, sep = "."), list(
  loci_analysed = fmt_int(loci_analysed), loci_univ_dementia = fmt_int(loci_univ_dementia),
  loci_univ_psychiatric = fmt_int(loci_univ_psychiatric), loci_testable = fmt_int(loci_testable),
  loci_nominal_p05 = fmt_int(loci_nominal_p05), expected_nominal = fmt_num(expected_nominal, 1),
  loci_fdr05 = fmt_int(loci_fdr05))))
print(lv)

# ---- (4) exploratory listing of nominal local correlations (descriptive; no added test) ----
# Per primary pair: nominal loci (P < 0.05) with position, rho (95% CI), P, protein-coding genes (GENCODE v19,
# GRCh37), APOE-region flag (chr19:44.4–46.5 Mb), sign distribution, and counts with the APOE region excluded.
gtf <- fread(cmd = sprintf("zcat '%s' | awk -F'\t' '$3==\"gene\"'", P_("data", "raw", "gencode19", "gencode.v19.annotation.gtf.gz")),
             header = FALSE, sep = "	", select = c(1, 4, 5, 9), col.names = c("chr", "start", "end", "attr"))
gtf <- gtf[grepl('gene_type "protein_coding"', attr)]
gtf[, `:=`(CHR = suppressWarnings(as.integer(sub("^chr", "", chr))), gene = sub('.*gene_name "([^"]+)".*', "\\1", attr))]
gtf <- gtf[!is.na(CHR)]
genes_in <- function(cc, a, b) paste(unique(gtf[CHR == cc & end >= a & start <= b][order(start), gene]), collapse = ", ")
bv <- fread(P_("results", "tables", "lava_bivar_ukb.csv"))[family == "primary"]
bv[, `:=`(dem = fifelse(phen1 %in% DEMENTIA, phen1, phen2), psy = fifelse(phen1 %in% DEMENTIA, phen2, phen1))]
bv[, apoe_region := CHR == 19 & STOP >= 44.4e6 & START <= 46.5e6]
nom <- bv[p < 0.05]
nom[, genes := mapply(genes_in, CHR, START, STOP)]
setorder(nom, dem, psy, CHR, START)
fwrite(nom[, .(dementia = dem, psychiatric = psy, LOC, CHR, START, STOP, n_snps, rho, rho.lower, rho.upper, p, p_fdr, apoe_region, genes)],
       P_("results", "tables", "lava_nominal_primary_ukb.csv"))
ex <- bv[, .(testable = .N, nominal = sum(p < 0.05), expected = 0.05 * .N,
             nominal_pos = sum(p < 0.05 & rho > 0), nominal_neg = sum(p < 0.05 & rho < 0),
             testable_noapoe = sum(!apoe_region), nominal_noapoe = sum(p < 0.05 & !apoe_region),
             expected_noapoe = 0.05 * sum(!apoe_region), fdr = sum(p_fdr < 0.05)), by = .(dem, psy)]
fwrite(ex, P_("results", "tables", "lava_nominal_summary_ukb.csv"))
for (i in seq_len(nrow(ex))) with(ex[i], res_set("lava_exploratory", paste(dem, psy, sep = "."), list(
  label = "exploratory, descriptive; no test of excess", testable = fmt_int(testable), nominal_p05 = fmt_int(nominal),
  expected = fmt_num(expected, 2), nominal_positive_rho = fmt_int(nominal_pos), nominal_negative_rho = fmt_int(nominal_neg),
  testable_excl_apoe = fmt_int(testable_noapoe), nominal_excl_apoe = fmt_int(nominal_noapoe),
  expected_excl_apoe = fmt_num(expected_noapoe, 2), fdr05 = fmt_int(fdr))))
for (i in seq_len(nrow(nom))) with(nom[i], res_set("lava_exploratory", sprintf("locus.%s.%s_%s", LOC, dem, psy), list(
  locus = sprintf("chr%d:%s–%s", CHR, fmt_int(START), fmt_int(STOP)), rho = fmt_ci(rho, rho.lower, rho.upper),
  p = fmt_p(p), p_fdr = fmt_p(p_fdr), apoe_region = as.character(apoe_region), genes = genes)))
print(ex); print(nom[, .(dem, psy, LOC, CHR, START, STOP, rho = round(rho, 2), p = signif(p, 2), apoe_region, genes = substr(genes, 1, 60))])

# ---- (5) LD-reference check for the exploratory nominal loci: UK Biobank vs 1000 Genomes (side by side) ----
# Flags: sign change; 1000G rho outside the UKB 95% CI ("magnitude differs"); not testable under 1000G.
# Rule (investigator, 2026-11-20): a locus whose sign changes or whose magnitude differs is described only as
# reference-sensitive (e.g. long-range LD at the 17q21.31 inversion); no biological interpretation.
fg <- P_("results", "tables", "lava_bivar_g1000.csv")
if (file.exists(fg)) {
  g <- fread(fg)
  g[, `:=`(dem = fifelse(phen1 %in% DEMENTIA, phen1, phen2), psy = fifelse(phen1 %in% DEMENTIA, phen2, phen1))]
  cmpr <- merge(nom[, .(dem, psy, LOC, CHR, START, STOP, genes, rho_ukb = rho, lo_ukb = rho.lower, hi_ukb = rho.upper, p_ukb = p)],
                g[, .(dem, psy, LOC, rho_g1000 = rho, lo_g1000 = rho.lower, hi_g1000 = rho.upper, p_g1000 = p)],
                by = c("dem", "psy", "LOC"), all.x = TRUE)
  cmpr[, testable_g1000 := !is.na(rho_g1000)]
  cmpr[, sign_same := fifelse(testable_g1000, sign(rho_ukb) == sign(rho_g1000), NA)]
  cmpr[, g1000_within_ukb_ci := fifelse(testable_g1000, rho_g1000 >= lo_ukb & rho_g1000 <= hi_ukb, NA)]
  cmpr[, reference_sensitive := !testable_g1000 | !sign_same | !g1000_within_ukb_ci]
  fwrite(cmpr, P_("results", "tables", "lava_nominal_reference_check.csv"))
  for (i in seq_len(nrow(cmpr))) with(cmpr[i], res_set("lava_reference_check", sprintf("locus.%s.%s_%s", LOC, dem, psy), list(
    locus = sprintf("chr%d:%s–%s", CHR, fmt_int(START), fmt_int(STOP)),
    rho_ukb = fmt_ci(rho_ukb, lo_ukb, hi_ukb), p_ukb = fmt_p(p_ukb),
    rho_g1000 = if (testable_g1000) fmt_ci(rho_g1000, lo_g1000, hi_g1000) else "not testable (univariate filter)",
    p_g1000 = if (testable_g1000) fmt_p(p_g1000) else "NA",
    sign_same = as.character(sign_same), g1000_within_ukb_ci = as.character(g1000_within_ukb_ci),
    reference_sensitive = as.character(reference_sensitive))))
  print(cmpr[, .(dem, psy, LOC, CHR, rho_ukb = round(rho_ukb, 2), rho_g1000 = round(rho_g1000, 2), p_g1000 = signif(p_g1000, 2), sign_same, g1000_within_ukb_ci, reference_sensitive)])
} else log_line("lava_bivar_g1000.csv yok: referans karşılaştırması 1000G LAVA bitince çalışır")
log_line("BİTTİ")

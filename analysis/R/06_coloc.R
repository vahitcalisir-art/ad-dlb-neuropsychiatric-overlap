#!/usr/bin/env Rscript
# 06_coloc.R — Plan §5: colocalisation.
# §5.1: coloc is applied only to locus–pairs of the primary family (dementia × psychiatric)
# that are significant at FDR 5% in the main LAVA analysis (UK Biobank reference, §3.6).
# If no such pair exists, the plan condition is not met: no coloc is run and this is
# recorded in results.json ("coloc") — this is the plan, not a deviation.
# Usage: Rscript analysis/R/06_coloc.R
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))
suppressPackageStartupMessages(library(coloc))
set.seed(SEED)

bivar <- fread(P_("results", "tables", "lava_bivar_ukb.csv"))
sig <- bivar[family == "primary" & p_fdr < 0.05]
log_line("primary-family LAVA locus–pairs tested:", bivar[family == "primary", .N], " significant at FDR 5%:", nrow(sig))

if (!nrow(sig)) {
  res_set("coloc", "summary", list(
    status = "not run: plan condition not met",
    reason = "no dementia × psychiatric locus–pair significant at FDR 5% in the main LAVA analysis (plan §5.1)",
    lava_primary_tests = fmt_int(bivar[family == "primary", .N]), lava_primary_sig_fdr = "0"))
  fwrite(data.table(status = "not run: plan condition not met (no primary LAVA locus–pair at FDR 5%)"),
         P_("results", "tables", "coloc.csv"))
  log_line("coloc not run (plan §5.1 condition not met). BİTTİ")
  quit(save = "no")
}

# ---- §5.2–5.4: coloc.abf on LAVA locus boundaries; PTSD uses the case/control file (plan §0) ----
coloc_id <- function(x) if (x == "ptsd") "ptsd_cc" else x
dataset <- function(id, chr, start, stop) {
  d <- read_munged(coloc_id(id), c("SNP", "CHR", "BP", "BETA", "SE", "MAF", "NCASE", "NCONTROL", "NEFF"))
  d <- d[CHR == chr & BP >= start & BP <= stop & is.finite(BETA) & is.finite(SE) & SE > 0]
  s <- if (all(is.na(d$NCASE))) 0.5 else median(d$NCASE / (d$NCASE + d$NCONTROL), na.rm = TRUE)
  d[, .(SNP, BETA, SE, MAF)][, s := s]
}
out <- rbindlist(lapply(seq_len(nrow(sig)), function(i) {
  r <- sig[i]
  a <- dataset(r$phen1, r$CHR, r$START, r$STOP); b <- dataset(r$phen2, r$CHR, r$START, r$STOP)
  common <- intersect(a$SNP, b$SNP); a <- a[match(common, SNP)]; b <- b[match(common, SNP)]
  mk <- function(x) list(beta = x$BETA, varbeta = x$SE^2, snp = x$SNP, MAF = x$MAF, type = "cc", s = x$s[1])
  f <- function(p12) { pp <- coloc.abf(mk(a), mk(b), p12 = p12)$summary; as.list(pp) }
  m <- f(1e-5); s5 <- f(5e-6)
  data.table(LOC = r$LOC, CHR = r$CHR, START = r$START, STOP = r$STOP, phen1 = r$phen1, phen2 = r$phen2,
             n_snps = m$nsnps, PP.H3 = m$PP.H3.abf, PP.H4 = m$PP.H4.abf,
             PP.H3_p12_5e6 = s5$PP.H3.abf, PP.H4_p12_5e6 = s5$PP.H4.abf)
}))
out[, interpretation := fifelse(PP.H4 > 0.8, "shared causal variant", fifelse(PP.H3 > 0.8, "distinct causal variants", "inconclusive"))]
fwrite(out, P_("results", "tables", "coloc.csv"))
res_set("coloc", "summary", list(status = "run", n_locus_pairs = fmt_int(nrow(out))))
for (i in seq_len(nrow(out))) with(out[i], res_set("coloc", sprintf("locus.%s.%s_%s", LOC, phen1, phen2), list(
  locus = sprintf("chr%d:%s–%s", CHR, fmt_int(START), fmt_int(STOP)), n_snps = fmt_int(n_snps),
  pp_h3 = fmt_num(PP.H3, 2), pp_h4 = fmt_num(PP.H4, 2),
  pp_h3_p12_5e6 = fmt_num(PP.H3_p12_5e6, 2), pp_h4_p12_5e6 = fmt_num(PP.H4_p12_5e6, 2), interpretation = interpretation)))
log_line("BİTTİ"); print(sessionInfo())

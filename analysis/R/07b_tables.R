#!/usr/bin/env Rscript
# 07b_tables.R — main-text tables as formatted CSV for tools/build_docx.py (STRICT_RULES §1.6: every number
# produced by script; a finding appears in a figure or a table, not both).
#   Table 1: data sources (from results/tables/data_sources.csv; counts from the harmonisation QC log).
#            Overlap column states the cohorts shared with other GWAS used here (plan §0.1, §4b.3).
#   Table 2: MR diagnostics for the 16 primary directions (IVW OR is shown in Figure 4, not here):
#            instruments, threshold, mean F, Steiger removals, I²GX, Cochran's Q P, MR-Egger intercept P
#            (conventional or SIMEX, plan §4.6), MR-PRESSO global P, MRlap-corrected beta (standardised) and P,
#            minimum detectable OR (plan §4.10), §8 class.
# Output: results/tables/table1_data_sources.csv, results/tables/table2_mr_diagnostics.csv
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))

src <- fread(P_("results", "tables", "data_sources.csv"))
ovl <- c(bellenguez_ad = "UK Biobank (proxy cases and controls)", chia_dlb = "none known",
         mdd_noukbb = "FinnGen R5", mdd_ukbb = "UK Biobank; FinnGen R5",
         ptsd_z = "UK Biobank; FinnGen (FING)", insomnia = "UK Biobank (sole cohort)",
         scz = "possible Finnish cohorts (unquantified)", finngen_ad = "FinnGen (shared with MDD and PTSD files)")
t1 <- src[, .(Trait = trait, Source = source, Ancestry = ancestry, Role = fifelse(role == "primary", "Primary", "Sensitivity"),
              Cases = fmt_int(ncase), Controls = fmt_int(ncontrol), `Shared cohorts` = ovl[id])]
fwrite(t1, P_("results", "tables", "table1_data_sources.csv"))

m <- fread(P_("results", "tables", "mr_primary.csv"))
lab <- c(ad = "AD", dlb = "DLB", mdd = "MDD", ptsd = "PTSD", insomnia = "Insomnia", scz = "SCZ")
ord <- c("mdd", "ptsd", "insomnia", "scz")
m[, dir_order := fifelse(exposure %in% ord, 1L, 2L)]
m[, psy := fifelse(exposure %in% ord, exposure, outcome)][, dem := fifelse(exposure %in% ord, outcome, exposure)]
setorder(m, dir_order, dem, psy)
# table P format: two significant digits (fmt_p), ">0.99" instead of "1.00", and MR-PRESSO's simulation floor
# ("<1e-04" with 10,000 distributions) as "<1 × 10⁻⁴" (investigator 2026-11-21)
tp <- function(p) {
  if (is.character(p)) {
    if (is.na(p) || p == "") return("not estimable")
    if (grepl("^<", p)) return(paste0("<", sub("^1\\.0 ", "1 ", fmt_p(as.numeric(sub("^<", "", p))))))
    p <- as.numeric(p)
  }
  if (is.na(p)) return("not estimable")
  if (p >= 0.995) return(">0.99")
  fmt_p(p)
}
t2 <- m[, .(Direction = paste(lab[exposure], "→", lab[outcome]),
            `Instruments (n)` = fmt_int(n_iv), `Mean F` = fmt_num(mean_F, 1),
            `Steiger removed (n)` = fmt_int(n_steiger_removed),
            `I²GX` = fmt_num(isq_gx, 2),
            `Cochran Q P` = vapply(q_ivw_p, tp, ""),
            `MR-Egger intercept P` = mapply(function(u, e, s) if (is.na(u) || u == "") tp(e) else if (u == "SIMEX") paste0(tp(s), " (SIMEX)") else tp(e), egger_intercept_used, egger_int_p, simex_int_p),
            `MR-PRESSO global P` = vapply(as.character(presso_global_p), tp, ""),
            `MRlap beta (P)` = fifelse(mrlap_status == "ok", sprintf("%s (%s)", fmt_num(mrlap_corrected, 3), vapply(mrlap_corrected_p, tp, "")), "NA"),
            `Min. detectable OR` = fmt_num(min_detectable_OR, 2),
            Class = classification)]
fwrite(t2, P_("results", "tables", "table2_mr_diagnostics.csv"))
print(t1); print(t2)
log_line("BİTTİ")

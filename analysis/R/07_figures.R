#!/usr/bin/env Rscript
# 07_figures.R — main-text and supplementary figures (STRICT_RULES §1.6; outline.md "Figure plan").
# Every number is read from results/results.json or results/tables/*.csv (or from logs that are
# first written to results/tables/ by this script); no value is typed by hand.
# Design: grayscale, shape/line-type contrasts, Times New Roman, 16 cm print width, zero/reference
# line always drawn, 95% CI always shown, null results shown.
# Usage: Rscript analysis/R/07_figures.R [fig1 fig2 ...]   (default: every figure whose inputs exist)
source(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "utils.R"))
suppressPackageStartupMessages({ library(ggplot2); library(cowplot) })
set.seed(SEED)

FIG <- P_("results", "figures"); PREV <- P_("build", "figures_preview")
dir.create(PREV, showWarnings = FALSE, recursive = TRUE)
W_CM <- 16; FONT <- "Times New Roman"; BASE <- 9
want <- commandArgs(trailingOnly = TRUE)
do <- function(x) !length(want) || x %in% want

# common names and order (identical in every figure)
PSY_LAB <- c(mdd = "MDD", ptsd = "PTSD", insomnia = "Insomnia", scz = "SCZ")
DEM_LAB <- c(ad = "AD (Bellenguez)", ad_finngen = "AD (FinnGen)", dlb = "DLB")
theme_q1 <- function() theme_bw(base_size = BASE, base_family = FONT) +
  theme(panel.grid.minor = element_blank(), panel.grid.major.y = element_blank(),
        strip.background = element_rect(fill = "grey92", colour = "grey40"),
        legend.position = "bottom", legend.key.width = unit(0.6, "cm"),
        text = element_text(colour = "black"), axis.text = element_text(colour = "black"))
save_fig <- function(p, name, h_cm) {
  f <- file.path(FIG, paste0(name, ".png"))
  ggsave(f, p, width = W_CM, height = h_cm, units = "cm", dpi = 600, bg = "white")
  file.copy(f, file.path(PREV, paste0(name, ".png")), overwrite = TRUE)
  log_line("written:", f)
}

# ---- data-source table (used by Figure 1 and Table 1): from the harmonisation QC log ----
qc <- fread(P_("analysis", "logs", "munge_qc.csv"))
src <- data.table(
  id = c("bellenguez_ad", "chia_dlb", "mdd_noukbb", "mdd_ukbb", "ptsd_z", "insomnia", "scz", "finngen_ad"),
  trait = c("AD (Bellenguez)", "DLB", "MDD", "MDD (with UKB)", "PTSD", "Insomnia", "SCZ", "AD (FinnGen)"),
  source = c("Bellenguez 2022", "Chia 2021", "PGC MDD 2025, excl. UKB and 23andMe", "PGC MDD 2025, incl. UKB",
             "PGC-PTSD Freeze 3", "Watanabe 2022, UKB only", "PGC3 (Trubetskoy 2022)", "FinnGen R13 G6_ALZHEIMER"),
  ancestry = c("European", "European", "European", "European", "European", "European", "European", "Finnish"),
  role = c("primary", "primary", "primary", "sensitivity", "primary", "primary", "primary", "sensitivity"),
  overlap_note = c("UKB proxy cases", "", "", "UKB", "", "UKB", "", "FinnGen in MDD and PTSD"))
src <- merge(src, qc[, .(id, ncase = declared_ncase, ncontrol = declared_ncontrol)], by = "id", sort = FALSE)
fwrite(src, P_("results", "tables", "data_sources.csv"))

# =====================================================================================
# Figure 1 — study design (schematic)
# =====================================================================================
if (do("fig1")) {
  dirs <- fread(P_("results", "tables", "mr_directions.csv"))
  nd <- dirs[, .N, by = set]; ndir <- function(s) nd[set == s, N]
  lava_ok <- function(r) { f <- P_("results", "tables", sprintf("lava_status_%s.csv", r)); if (file.exists(f)) fread(f)[status == "ok", .N] else NA }
  boxes_d <- src[, .(lab = sprintf("%s\n%s cases / %s controls\n%s%s", trait, fmt_int(ncase), fmt_int(ncontrol), ancestry,
                                   ifelse(overlap_note == "", "", paste0("; ", overlap_note))),
                     role)]
  boxes_d[, `:=`(x0 = 0, x1 = 6.6, y1 = 12 - (.I - 1) * 1.5, y0 = 12 - (.I - 1) * 1.5 - 1.3)]
  lay <- data.table(
    lab = c(sprintf("1  Genome-wide genetic correlation (LDSC)\n%s primary pairs; APOE-excluded and FinnGen AD sensitivity", 8),
            sprintf("2  Local genetic correlation (LAVA)\n%s loci; UK Biobank LD reference (1000 Genomes sensitivity)", fmt_int(lava_ok("ukb"))),
            "3  Colocalisation (coloc)\nonly for local correlations significant at FDR 5%",
            sprintf("4  Bidirectional Mendelian randomization\n%d primary directions; MDD with UKB (%d); APOE-excluded (%d)",
                    ndir("primary"), ndir("sens_mdd_ukbb"), sum(nd[grepl("noapoe", set), N])),
            sprintf("5  Independent AD sample (FinnGen)\nLDSC and MR, %d directions (+ %d APOE-excluded)", ndir("finngen"), ndir("finngen_noapoe"))),
    role = c("primary", "primary", "primary", "primary", "sensitivity"))
  lay[, `:=`(x0 = 7.6, x1 = 16, y1 = 12 - (.I - 1) * 2.4, y0 = 12 - (.I - 1) * 2.4 - 1.8)]
  p1 <- ggplot() +
    geom_rect(data = boxes_d, aes(xmin = x0, xmax = x1, ymin = y0, ymax = y1, linetype = role), fill = "white", colour = "black", linewidth = 0.35) +
    geom_text(data = boxes_d, aes(x = x0 + 0.15, y = (y0 + y1) / 2, label = lab), hjust = 0, size = 2.35, family = FONT, lineheight = 0.95) +
    geom_rect(data = lay, aes(xmin = x0, xmax = x1, ymin = y0, ymax = y1, linetype = role), fill = "grey95", colour = "black", linewidth = 0.35) +
    geom_text(data = lay, aes(x = x0 + 0.15, y = (y0 + y1) / 2, label = lab), hjust = 0, size = 2.45, family = FONT, lineheight = 0.95) +
    geom_segment(data = lay[-.N], aes(x = 11.8, xend = 11.8, y = y0, yend = y0 - 0.6),
                 arrow = arrow(length = unit(0.12, "cm"), type = "closed"), linewidth = 0.35) +
    annotate("segment", x = 6.6, xend = 7.6, y = 6, yend = 6, arrow = arrow(length = unit(0.15, "cm"), type = "closed"), linewidth = 0.4) +
    annotate("text", x = 0, y = 12.75, vjust = 0.5, lineheight = 0.95, label = "Summary statistics
(GRCh37; harmonised to 1000 Genomes EUR)", hjust = 0, size = 2.7, family = FONT, fontface = "bold") +
    annotate("text", x = 7.6, y = 12.75, label = "Analysis layers", hjust = 0, size = 2.7, family = FONT, fontface = "bold") +
    scale_linetype_manual(values = c(primary = "solid", sensitivity = "dashed"), name = NULL,
                          labels = c(primary = "Primary", sensitivity = "Sensitivity")) +
    coord_cartesian(xlim = c(0, 16), ylim = c(0, 13.4), expand = FALSE) +
    theme_void(base_family = FONT, base_size = BASE) + theme(legend.position = "bottom")
  save_fig(p1, "Figure1_design", 14)
}

# =====================================================================================
# Figure 2 — genome-wide genetic correlation
# =====================================================================================
if (do("fig2")) {
  rg <- fread(P_("results", "tables", "ldsc_rg.csv"))
  h2 <- fread(P_("results", "tables", "ldsc_h2.csv"))
  dem_of <- c(ad = "ad", ad_noapoe = "ad", ad_finngen = "ad_finngen", ad_finngen_noapoe = "ad_finngen", dlb = "dlb")
  d <- rg[run %in% c("main", "sens_noapoe", "finngen", "finngen_noapoe")]
  d[, `:=`(dem = fifelse(trait1 %in% names(dem_of), trait1, trait2), psy = fifelse(trait1 %in% names(dem_of), trait2, trait1))]
  d <- d[dem %in% names(dem_of) & psy %in% names(PSY_LAB)]
  d[, apoe := fifelse(grepl("noapoe", dem), "APOE region excluded", "All variants")]
  d[, dem := dem_of[dem]]
  sig_col <- fifelse(d$run %in% c("finngen", "finngen_noapoe"), "p_fdr_within4", "p_fdr")
  d[, p_adj := as.numeric(ifelse(run %in% c("finngen", "finngen_noapoe"), p_fdr_within4, p_fdr))]
  d[, star := fifelse(!is.na(p_adj) & p_adj < 0.05, "*", "")]
  hz <- h2[run %in% c("main", "finngen") & trait %in% c("ad", "dlb", "ad_finngen"), .(dem = trait, h2_z)]
  strip <- sapply(names(DEM_LAB), function(k) {
    z <- hz[dem == k, h2_z][1]
    sprintf("%s\nh² Z = %s%s", DEM_LAB[k], fmt_num(z, 1), if (!is.na(z) && z < 4) " (low power, exploratory)" else "")
  })
  d[, dem_f := factor(strip[dem], levels = strip)]
  d[, psy_f := factor(PSY_LAB[psy], levels = rev(PSY_LAB))]
  d[, apoe := factor(apoe, levels = c("All variants", "APOE region excluded"))]
  d[, `:=`(lo_c = pmax(lo, -1), hi_c = pmin(hi, 1))]
  pd <- position_dodge(width = 0.55)
  p2 <- ggplot(d, aes(x = rg, y = psy_f, shape = apoe, group = factor(apoe, levels = rev(levels(apoe))))) +
    geom_vline(xintercept = 0, linetype = "dashed", colour = "grey30", linewidth = 0.35) +
    geom_errorbar(aes(xmin = lo_c, xmax = hi_c), width = 0, orientation = "y", position = pd, linewidth = 0.4) +
    geom_point(position = pd, size = 1.8, fill = "white", stroke = 0.5) +
    geom_text(aes(x = hi_c, label = star), position = pd, hjust = -0.4, vjust = 0.75, size = 3, family = FONT) +
    facet_wrap(~dem_f, nrow = 1) +
    scale_shape_manual(values = c("All variants" = 16, "APOE region excluded" = 21), name = NULL) +
    scale_x_continuous(limits = c(floor(min(d$lo_c) * 4) / 4, ceiling(max(d$hi_c) * 4) / 4 + 0.08), breaks = seq(-1, 1, 0.25)) +
    labs(x = "Genetic correlation (rg) with 95% CI", y = NULL) + theme_q1()
  save_fig(p2, "Figure2_ldsc_rg", 7.5)
  fwrite(d[, .(run, dem, psy, apoe, rg, lo, hi, p, p_adj)], P_("results", "tables", "figure2_data.csv"))
}

# =====================================================================================
# Figure 3 — local genetic correlation (built when the final LAVA tables exist)
# =====================================================================================
if (do("fig3") && file.exists(P_("results", "tables", "power_lava.csv"))) {
  bv <- fread(P_("results", "tables", "lava_bivar_ukb.csv"))[family == "primary"]
  pw <- fread(P_("results", "tables", "power_lava.csv"))[ref == "ukb"]
  bv[, `:=`(dem = fifelse(phen1 %in% DEMENTIA, phen1, phen2), psy = fifelse(phen1 %in% DEMENTIA, phen2, phen1))]
  chr_len <- fread(P_("results", "tables", "lava_status_ukb.csv"))  # locus order only
  loc_pos <- unique(fread(P_("results", "tables", "lava_univ_ukb.csv"), select = c("LOC", "CHR", "START", "STOP")))
  setorder(loc_pos, CHR, START); loc_pos[, idx := .I]
  bv <- merge(bv, loc_pos[, .(LOC, idx)], by = "LOC")
  pw[, panel := sprintf("%s × %s\n%s testable %s", DEM_LAB[dementia], PSY_LAB[psychiatric], fmt_int(loci_testable), fifelse(loci_testable == 1, "locus", "loci"))]
  pw[, panel := factor(panel, levels = pw[order(match(dementia, names(DEM_LAB)), match(psychiatric, names(PSY_LAB))), panel])]
  bv <- merge(bv, pw[, .(dem = dementia, psy = psychiatric, panel)], by = c("dem", "psy"))
  bv[, cls := factor(fifelse(p_fdr < 0.05, "FDR < 0.05", fifelse(p < 0.05, "Nominal P < 0.05", "P ≥ 0.05")),
                     levels = c("P ≥ 0.05", "Nominal P < 0.05", "FDR < 0.05"))]
  chr_mid <- loc_pos[, .(mid = mean(idx)), by = CHR][CHR %in% c(1, 6, 13)]
  p3 <- ggplot(bv, aes(x = idx, y = rho)) +
    geom_hline(yintercept = 0, linetype = "dashed", colour = "grey30", linewidth = 0.35) +
    geom_errorbar(aes(ymin = rho.lower, ymax = rho.upper), width = 0, linewidth = 0.35) +
    geom_point(aes(shape = cls), size = 1.7, fill = "white", stroke = 0.5) +
    geom_blank(data = pw, aes(x = NULL, y = NULL)) +
    facet_wrap(~panel, nrow = 2, drop = FALSE) +
    # only classes that occur are shown in the legend (no FDR < 0.05 pair is stated in the caption, §1.6)
    scale_shape_manual(values = c("P ≥ 0.05" = 21, "Nominal P < 0.05" = 16, "FDR < 0.05" = 17), drop = TRUE, name = NULL) +
    scale_x_continuous(limits = range(loc_pos$idx), breaks = chr_mid$mid, labels = paste0("chr", chr_mid$CHR)) +
    scale_y_continuous(limits = c(-1, 1)) +
    labs(x = "Genomic position (LAVA locus order)", y = "Local genetic correlation (rho) with 95% CI") + theme_q1()
  save_fig(p3, "Figure3_lava_local_rg", 10)
}

# =====================================================================================
# Figure 4 — MR: primary directions (IVW with 95% CI; Egger, weighted median, weighted mode) + FinnGen panel
# =====================================================================================
if (do("fig4") && file.exists(P_("results", "tables", "mr_all.csv"))) {
  s <- fread(P_("results", "tables", "mr_all.csv"))[set %in% c("primary", "finngen")]
  LAB <- c(PSY_LAB, ad = "AD", ad_finngen = "AD (FinnGen)", dlb = "DLB")
  s[, dir_lab := sprintf("%s → %s  (k = %s)", LAB[exposure], LAB[outcome], fmt_int(n_iv))]
  s[, panel := fifelse(set == "finngen", "C  Independent AD sample (FinnGen; descriptive, not used for significance)",
               fifelse(exposure %in% names(PSY_LAB), "A  Psychiatric trait → dementia (primary)", "B  Dementia → psychiatric trait (primary)"))]
  s[, psy := fifelse(exposure %in% names(PSY_LAB), exposure, outcome)]
  s[, dem := fifelse(exposure %in% names(PSY_LAB), outcome, exposure)]
  setorder(s, panel, dem, psy)
  s[, cls_short := fifelse(set == "finngen", "", sub("[descriptive, not used for significance] ", "", classification, fixed = TRUE))]
  s[, right_lab := sprintf("%s%s", fmt_num(min_detectable_OR_se, 2), fifelse(cls_short == "" | cls_short == "no evidence", "", paste0("  ", cls_short)))]
  long <- rbindlist(list(
    s[, .(id, panel, dir_lab, method = "IVW (95% CI)", or = exp(ivw_b), lo = exp(ivw_b - 1.959964 * ivw_se), hi = exp(ivw_b + 1.959964 * ivw_se))],
    s[, .(id, panel, dir_lab, method = "MR-Egger", or = exp(egger_b), lo = NA_real_, hi = NA_real_)],
    s[, .(id, panel, dir_lab, method = "Weighted median", or = exp(wm_b), lo = NA_real_, hi = NA_real_)],
    s[, .(id, panel, dir_lab, method = "Weighted mode", or = exp(wmode_b), lo = NA_real_, hi = NA_real_)]))
  long[, method := factor(method, levels = c("IVW (95% CI)", "MR-Egger", "Weighted median", "Weighted mode"))]
  SH <- c("IVW (95% CI)" = 16, "MR-Egger" = 2, "Weighted median" = 0, "Weighted mode" = 5)
  mk <- function(pn, show_legend) {
    d <- long[panel == pn]; r <- s[panel == pn]
    d[, y := factor(dir_lab, levels = rev(r$dir_lab))]; r[, y := factor(dir_lab, levels = rev(r$dir_lab))]
    rng <- range(c(d$or, d$lo, d$hi, 1), na.rm = TRUE); rng <- exp(log(rng) + c(-1, 1) * 0.04 * diff(log(rng)))
    ggplot(d, aes(x = or, y = y)) +
      geom_vline(xintercept = 1, linetype = "dashed", colour = "grey30", linewidth = 0.35) +
      geom_errorbar(data = d[!is.na(lo)], aes(xmin = lo, xmax = hi), width = 0, orientation = "y", linewidth = 0.4) +
      geom_point(aes(shape = method), size = 1.6, stroke = 0.45) +
      geom_text(data = r, aes(x = rng[2] * exp(0.03 * diff(log(rng))), y = y, label = right_lab), inherit.aes = FALSE, hjust = 0, nudge_x = 0,
                size = 2.4, family = FONT) +
      scale_shape_manual(values = SH, name = NULL, drop = FALSE) +
      scale_x_log10(limits = rng, expand = c(0, 0), oob = scales::oob_keep, breaks = pretty(rng, 6), labels = function(b) format(b, drop0trailing = TRUE, trim = TRUE)) +
      coord_cartesian(clip = "off") +
      labs(title = pn, x = NULL, y = NULL) + theme_q1() +
      theme(plot.title = element_text(size = BASE, face = "bold", hjust = 0), plot.title.position = "plot",
            plot.margin = margin(4, 118, 2, 4), legend.position = if (show_legend) "bottom" else "none")
  }
  pans <- unique(s$panel)
  plots <- lapply(seq_along(pans), function(i) mk(pans[i], i == length(pans)))
  plots[[length(plots)]] <- plots[[length(plots)]] + labs(x = "Odds ratio for the outcome per unit increase in log odds of the exposure (log scale)")
  hdr <- ggdraw() + draw_label("Right column: minimum detectable OR (80% power, same scale); plan §8 class if not \"no evidence\"",
                               x = 0.99, hjust = 1, size = BASE - 1, fontfamily = FONT)
  nrow_p <- s[, .N, by = panel][match(pans, panel), N]
  p4 <- plot_grid(hdr, plotlist = plots, ncol = 1, rel_heights = c(1.2, nrow_p[1] + 2, nrow_p[2] + 2, nrow_p[3] + 5), align = "v", axis = "lr")
  save_fig(p4, "Figure4_mr", 18)
  fwrite(merge(long, s[, .(id, set, exposure, outcome, n_iv, min_detectable_OR, min_detectable_OR_se, classification)], by = "id"),
         P_("results", "tables", "figure4_data.csv"))
}
log_line("BİTTİ")

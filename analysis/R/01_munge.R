#!/usr/bin/env Rscript
# 01_munge.R — Faz 1 adım 3: tek dosya harmonizasyonu ve tek dosya kalite kontrolü.
#
# Yalnız girdi hazırlığı yapar. Özellikler arası hiçbir hesap (rg, h², enstrüman seçimi)
# YAPILMAZ; bunlar analiz planı dondurulduktan sonra 02+ betiklerinde yapılır.
#
# Referans: 1000G Phase 3 EUR PLINK (LDSC seti, Zenodo 7768714; GRCh37; 489 kişi).
# Adımlar (her dosya için, sırayla; her adımdan sonra kalan SNP sayısı loglanır):
#   start        : dosyadaki satır sayısı (otozomlar + diğer)
#   mapped       : rsID ile referansa eşlenen, tek nükleotidli, alelleri referansla (doğrudan /
#                  ters / iplik çevrimi) uyuşan otozomal SNP'ler. GRCh38 dosyaları (Bellenguez,
#                  Chia) GRCh37'ye bu eşleme ile taşınır; rsID'si olmayanlar ayrıca sayılır.
#   maf          : MAF >= 0.01 (dosyanın alel frekansı; yoksa referans EUR frekansı)
#   info         : INFO >= 0.9 (yalnız INFO sütunu olan dosyalarda; diğerlerinde değişmez)
#   palindromic  : belirsiz palindromik (A/T, C/G) ve MAF > 0.42 olanlar çıkarılır
#   mhc          : chr6:25–34 Mb (GRCh37) dışındakiler (LDSC/rg seti). MHC SNP'leri dosyada
#                  MHC=1 bayrağıyla tutulur; kullanımı ön kayıtlı plana göre.
#   multiallelic : referansta veya dosyada aynı konumda birden çok kaydı olan varyantlar çıkarılır
# APOE bölgesi (chr19:44.4–46.5 Mb, GRCh37) APOE=1 bayrağıyla işaretlenir.
# Tüm etkiler referans A1 alelini etkili alel yapacak şekilde hizalanır.
#
# Çıktılar:
#   data/munged/<id>.tsv.gz
#   analysis/logs/munge_counts.csv   (adım adım kalan SNP sayısı)
#   analysis/logs/munge_qc.csv       (alel frekansı tutarlılığı, lambda GC, N kontrolü)
#   analysis/logs/01_munge.log       (Rscript çıktısı; çağıran yönlendirir)

suppressPackageStartupMessages(library(data.table))
set.seed(20261120)
setDTthreads(max(1L, parallel::detectCores() - 2L))

args <- commandArgs(trailingOnly = TRUE)
only <- if (length(args)) args else NULL      # isteğe bağlı: yalnız belirtilen id'ler

ROOT <- normalizePath(file.path(dirname(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))), "..", ".."))
RAW  <- file.path(ROOT, "data", "raw")
OUT  <- file.path(ROOT, "data", "munged")
LOG  <- file.path(ROOT, "analysis", "logs")
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)
dir.create(LOG, showWarnings = FALSE, recursive = TRUE)

MAF_MIN <- 0.01; INFO_MIN <- 0.9; PAL_MAF_MAX <- 0.42
MHC  <- c(chr = 6L,  start = 25e6,   end = 34e6)
APOE <- c(chr = 19L, start = 44.4e6, end = 46.5e6)

# ---------------- referans ----------------
cat(format(Sys.time()), "referans okunuyor\n")
refdir <- file.path(RAW, "ldsc_ref")
ref <- rbindlist(lapply(1:22, function(i) {
  b <- fread(file.path(refdir, "1000G_EUR_Phase3_plink", sprintf("1000G.EUR.QC.%d.bim", i)),
             header = FALSE, col.names = c("CHR", "SNP", "CM", "BP", "R1", "R2"),
             colClasses = list(character = c(2, 5, 6)))
  f <- fread(file.path(refdir, "1000G_Phase3_frq", sprintf("1000G.EUR.QC.%d.frq", i)),
             select = c("SNP", "A1", "MAF"))
  b <- merge(b, f, by = "SNP", all.x = TRUE, sort = FALSE)
  # referans A1 = .bim 5. sütun; frq A1'in frekansını R1 frekansına çevir
  b[, REF_EAF := fifelse(A1 == R1, MAF, 1 - MAF)]
  b[, c("CM", "A1", "MAF") := NULL]
  b
}))
ref <- ref[nchar(R1) == 1 & nchar(R2) == 1]
# referansta aynı konumda birden çok kayıt (çok alelli / tekrar) veya tekrar eden rsID
ref[, dup_pos := .N > 1, by = .(CHR, BP)]
ref[, dup_id := .N > 1, by = SNP]
cat("referans SNP:", nrow(ref), " (çok alelli/tekrar konum:", sum(ref$dup_pos), ")\n")

comp <- c(A = "T", T = "A", C = "G", G = "C")

# ---------------- okuyucular (standart sütunlar) ----------------
# rsid chr pos a1(etkili) a2 beta se z p eaf maf ncase ncontrol neff info
zread <- function(path, ...) fread(cmd = sprintf("zcat '%s' | grep -v '^##'", path), ...)

readers <- list(
  bellenguez_ad = function() {
    d <- fread(file.path(RAW, "bellenguez2022", "35379992-GCST90027158-MONDO_0004975.h.tsv.gz"),
               select = c("hm_rsid", "hm_chrom", "hm_pos", "hm_effect_allele", "hm_other_allele",
                          "hm_beta", "standard_error", "p_value", "hm_effect_allele_frequency",
                          "n_cas", "n_con"))
    d[, .(rsid = hm_rsid, chr = hm_chrom, pos = hm_pos, a1 = hm_effect_allele, a2 = hm_other_allele,
          beta = hm_beta, se = standard_error, z = hm_beta / standard_error, p = p_value,
          eaf = hm_effect_allele_frequency, maf = NA_real_, ncase = n_cas, ncontrol = n_con,
          neff = 4 / (1 / n_cas + 1 / n_con), info = NA_real_)]
  },
  chia_dlb = function() {
    d <- fread(file.path(RAW, "chia2021", "33589841-GCST90001390-EFO_0006792.h.tsv.gz"),
               select = c("hm_rsid", "hm_chrom", "hm_pos", "hm_effect_allele", "hm_other_allele",
                          "hm_beta", "standard_error", "p_value", "hm_effect_allele_frequency"))
    nca <- 2591; nco <- 4027
    d[, .(rsid = hm_rsid, chr = hm_chrom, pos = hm_pos, a1 = hm_effect_allele, a2 = hm_other_allele,
          beta = hm_beta, se = standard_error, z = hm_beta / standard_error, p = p_value,
          eaf = hm_effect_allele_frequency, maf = NA_real_, ncase = nca, ncontrol = nco,
          neff = 4 / (1 / nca + 1 / nco), info = NA_real_)]
  },
  mdd_noukbb = function() mdd("pgc-mdd2025_no23andMe-noUKBB_eur_v3-49-24-11.tsv.gz"),
  mdd_ukbb   = function() mdd("pgc-mdd2025_no23andMe_eur_v3-49-24-11.tsv.gz"),
  ptsd_cc = function() {
    d <- zread(file.path(RAW, "ptsd2024", "eur_ptsdcasecontrol_pcs_v4_aug3_2021.vcf.gz"))
    setnames(d, 1, "CHROM")
    d[, .(rsid = ID, chr = CHROM, pos = POS, a1 = A1, a2 = A2, beta = BETA, se = SE, z = BETA / SE,
          p = P, eaf = FREQ, maf = NA_real_, ncase = NCASE, ncontrol = NCON, neff = NEFF, info = NA_real_)]
  },
  ptsd_z = function() {
    d <- zread(file.path(RAW, "ptsd2024", "eur_ptsd_pcs_v4_aug3_2021.vcf.gz"))
    setnames(d, 1, "CHROM")
    d[, .(rsid = ID, chr = CHROM, pos = POS, a1 = A1, a2 = A2, beta = NA_real_, se = NA_real_, z = Z,
          p = P, eaf = FREQ, maf = NA_real_, ncase = NA_real_, ncontrol = NA_real_, neff = NEFF,
          info = NA_real_)]
  },
  insomnia = function() {
    d <- fread(file.path(RAW, "insomnia", "insomnia_ukb2b_EUR_sumstats_20190311_with_chrX_mac_100.txt.gz"),
               select = c("CHR", "BP", "A1", "A2", "NMISS", "OR", "SE", "P", "RSID_UKB", "INFO_UKB", "MAF"))
    tot <- 109548 + 277440
    d[, .(rsid = RSID_UKB, chr = CHR, pos = BP, a1 = A1, a2 = A2, beta = log(OR), se = SE,
          z = log(OR) / SE, p = P, eaf = NA_real_, maf = MAF,
          ncase = NMISS * 109548 / tot, ncontrol = NMISS * 277440 / tot,
          neff = 4 / (1 / (NMISS * 109548 / tot) + 1 / (NMISS * 277440 / tot)), info = INFO_UKB)]
  },
  scz = function() {
    d <- zread(file.path(RAW, "scz2022", "PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv.gz"))
    d[, .(rsid = ID, chr = CHROM, pos = POS, a1 = A1, a2 = A2, beta = BETA, se = SE, z = BETA / SE,
          p = PVAL, eaf = (FCAS * NCAS + FCON * NCON) / (NCAS + NCON), maf = NA_real_,
          ncase = NCAS, ncontrol = NCON, neff = 2 * NEFF, info = IMPINFO)]
    # NEFF, başlıkta "effective sample size total" diye tanımlansa da yarım etkin N'dir:
    # başlıktaki kohort bazlı vaka/kontrol sayılarından sum(4/(1/a+1/b)) = 114,792 (yarısı 57,396,
    # +1,369 trio ≈ 58,765) ve dosyadaki NEFF = 58,749. Diğer dosyalarla aynı ölçek (tam Neff) için 2 ile çarpılır.
  }
)
readers$finngen_ad <- function() {
  # FinnGen R13 G6_ALZHEIMER (GRCh38; alt = etkili alel; beta = log OR). N dosyada yok: R13 manifesti.
  # rsids sütununda birden çok rsID virgülle yazılmış olabilir: ilki alınır (sayısı loglanır).
  d <- fread(cmd = sprintf("zcat '%s'", file.path(RAW, "finngen", "finngen_R13_G6_ALZHEIMER.gz")),
             select = c("#chrom", "pos", "ref", "alt", "rsids", "pval", "beta", "sebeta", "af_alt"))
  setnames(d, "#chrom", "chrom")
  cat("finngen: birden çok rsID içeren satır:", d[grepl(",", rsids), .N], "\n")
  nca <- 16652; nco <- 483534
  d[, .(rsid = sub(",.*$", "", rsids), chr = chrom, pos = pos, a1 = alt, a2 = ref, beta = beta, se = sebeta,
        z = beta / sebeta, p = pval, eaf = af_alt, maf = NA_real_, ncase = nca, ncontrol = nco,
        neff = 4 / (1 / nca + 1 / nco), info = NA_real_)]
}
mdd <- function(f) {
  d <- zread(file.path(RAW, "mdd2025", f))
  setnames(d, 1, "CHROM")
  d[, .(rsid = ID, chr = CHROM, pos = POS, a1 = EA, a2 = NEA, beta = BETA, se = SE, z = BETA / SE,
        p = PVAL, eaf = (FCAS * NCAS + FCON * NCON) / (NCAS + NCON), maf = NA_real_,
        ncase = NCAS, ncontrol = NCON, neff = NEFF, info = IMPINFO)]
}
build <- c(bellenguez_ad = "GRCh38", chia_dlb = "GRCh38", mdd_noukbb = "GRCh37", mdd_ukbb = "GRCh37",
           ptsd_cc = "GRCh37", ptsd_z = "GRCh37", insomnia = "GRCh37", scz = "GRCh37", finngen_ad = "GRCh38")
declared <- list(  # dosya başlığı / README'deki N (N kontrolü için)
  bellenguez_ad = c(85934, 401577), chia_dlb = c(2591, 4027), mdd_noukbb = c(357636, 1281936),
  mdd_ukbb = c(412305, 1588397), ptsd_cc = c(137136, 1085746), ptsd_z = c(137136, 1085746),
  insomnia = c(109548, 277440), scz = c(52017, 75889), finngen_ad = c(16652, 483534))

# ---------------- işleme ----------------
counts <- list(); qc <- list()
ids <- if (is.null(only)) names(readers) else only
for (id in ids) {
  cat("\n==", id, format(Sys.time()), "\n")
  d <- readers[[id]]()
  n <- list(id = id, build_in = build[[id]], start = nrow(d))
  d[, chr := suppressWarnings(as.integer(as.character(chr)))]
  # Çift duyarlıklı sayının altında kalan P değerleri (ör. Bellenguez APOE, 5.75e-659) fread'in
  # sütunu metin okumasına yol açar; sayıya çevrilir, bunlar 0 olur ve QC'de sayılır.
  if (!is.numeric(d$p)) d[, p := suppressWarnings(as.numeric(p))]
  n$p_underflow_zero <- d[!is.na(p) & p == 0, .N]
  d[, a1 := toupper(a1)][, a2 := toupper(a2)]
  n$no_rsid <- d[is.na(rsid) | !grepl("^rs[0-9]+$", rsid), .N]
  n$non_autosomal <- d[is.na(chr) | !(chr %in% 1:22), .N]

  # --- eşleme ---
  m <- merge(d[grepl("^rs[0-9]+$", rsid) & chr %in% 1:22], ref, by.x = "rsid", by.y = "SNP", sort = FALSE)
  n$rsid_in_ref <- nrow(m)
  m <- m[chr == CHR]                                   # kromozom uyumu
  m <- m[nchar(a1) == 1 & nchar(a2) == 1]
  m[, pal := !is.na(comp[R2]) & R1 == comp[R2]]
  m[, dir := fcase(a1 == R1 & a2 == R2, 1L, a1 == R2 & a2 == R1, -1L,
                   !pal & comp[a1] == R1 & comp[a2] == R2, 1L,
                   !pal & comp[a1] == R2 & comp[a2] == R1, -1L, default = 0L)]
  n$allele_mismatch <- m[dir == 0L, .N]
  m <- m[dir != 0L]
  if (build[[id]] == "GRCh37") n$pos_discordant_grch37 <- m[pos != BP, .N] else n$pos_discordant_grch37 <- NA_integer_
  # referans A1 (R1) etkili alel olacak şekilde hizala
  m[dir == -1L, `:=`(beta = -beta, z = -z, eaf = 1 - eaf)]
  n$mapped <- nrow(m)

  # --- MAF ---
  m[, MAF := fcoalesce(pmin(eaf, 1 - eaf), maf, pmin(REF_EAF, 1 - REF_EAF))]
  m[, maf_source := fifelse(!is.na(eaf), "file_eaf", fifelse(!is.na(maf), "file_maf", "ref"))]
  m <- m[!is.na(MAF) & MAF >= MAF_MIN]
  n$maf <- nrow(m)

  # --- INFO ---
  n$info_available <- any(!is.na(m$info))
  if (n$info_available) m <- m[!is.na(info) & info >= INFO_MIN]
  n$info <- nrow(m)

  # --- belirsiz palindromik ---
  # Dosyada etkili alel frekansı (EAF) yoksa palindromik SNP'lerin iplik yönü frekansla doğrulanamaz;
  # bu durumda (uykusuzluk) tüm palindromik SNP'ler çıkarılır (deviations.md C2).
  n$palindromic_rule <- if (all(is.na(m$eaf))) "all_removed_no_eaf" else paste0("maf_gt_", PAL_MAF_MAX, "_removed")
  if (all(is.na(m$eaf))) m <- m[pal == FALSE] else m <- m[!(pal & MAF > PAL_MAF_MAX)]
  n$palindromic <- nrow(m)

  # --- MHC (bayrak; sayım LDSC seti için) ---
  m[, MHC := as.integer(CHR == MHC["chr"] & BP >= MHC["start"] & BP <= MHC["end"])]
  n$mhc <- m[MHC == 0L, .N]

  # --- çok alelli / tekrar konum ---
  m[, dup_in_file := .N > 1, by = .(CHR, BP)]
  m <- m[!dup_pos & !dup_id & !dup_in_file]
  n$multiallelic <- nrow(m)
  n$multiallelic_ldsc_set <- m[MHC == 0L, .N]

  m[, APOE := as.integer(CHR == APOE["chr"] & BP >= APOE["start"] & BP <= APOE["end"])]
  out <- m[, .(SNP = rsid, CHR, BP, A1 = R1, A2 = R2, BETA = beta, SE = se, Z = z, P = p,
               EAF = fifelse(maf_source == "file_eaf", eaf, NA_real_), REF_EAF, MAF, MAF_SOURCE = maf_source,
               NCASE = ncase, NCONTROL = ncontrol, NEFF = neff, INFO = info, MHC, APOE)]
  setorder(out, CHR, BP)
  fwrite(out, file.path(OUT, paste0(id, ".tsv.gz")), sep = "\t", na = "NA")

  # --- tek dosya kalite kontrolü ---
  q <- list(id = id)
  e <- out[!is.na(EAF)]
  q$af_n <- nrow(e)
  q$af_cor_ref <- if (nrow(e)) round(cor(e$EAF, e$REF_EAF), 4) else NA
  q$af_absdiff_gt_0.2 <- if (nrow(e)) e[abs(EAF - REF_EAF) > 0.2, .N] else NA
  q$af_absdiff_gt_0.2_pct <- if (nrow(e)) round(100 * q$af_absdiff_gt_0.2 / nrow(e), 3) else NA
  if (all(is.na(out$EAF))) {  # yalnız MAF varsa (uykusuzluk): MAF ile referans MAF'ı karşılaştır
    rm <- pmin(out$REF_EAF, 1 - out$REF_EAF)
    q$maf_cor_ref <- round(cor(out$MAF, rm, use = "complete.obs"), 4)
  } else q$maf_cor_ref <- NA
  q$af_check <- if (nrow(e)) "EAF vs 1000G EUR reference EAF" else "EAF not available; file MAF vs 1000G EUR reference MAF (frequency check of effect-allele orientation not applicable)"
  chisq <- out$Z^2
  q$lambda_gc <- round(median(chisq, na.rm = TRUE) / qchisq(0.5, 1), 4)
  q$lambda_gc_ldsc_set <- round(median(chisq[out$MHC == 0L], na.rm = TRUE) / qchisq(0.5, 1), 4)
  # P ile Z tutarlılığı (dosya içi)
  pz <- 2 * pnorm(-abs(out$Z))
  ok <- is.finite(pz) & out$P > 0
  q$p_vs_z_cor_log10 <- round(cor(-log10(pz[ok]), -log10(out$P[ok])), 4)
  q$n_gws_5e8 <- out[P < 5e-8, .N]
  # N kontrolü
  q$declared_ncase <- declared[[id]][1]; q$declared_ncontrol <- declared[[id]][2]
  q$max_ncase <- if (all(is.na(out$NCASE))) NA_real_ else round(max(out$NCASE, na.rm = TRUE))
  q$max_ncontrol <- if (all(is.na(out$NCONTROL))) NA_real_ else round(max(out$NCONTROL, na.rm = TRUE))
  q$neff_min <- round(min(out$NEFF, na.rm = TRUE)); q$neff_median <- round(median(out$NEFF, na.rm = TRUE))
  q$neff_max <- round(max(out$NEFF, na.rm = TRUE))
  q$neff_lt_half_max_pct <- round(100 * mean(out$NEFF < 0.5 * q$neff_max, na.rm = TRUE), 3)
  q$se_missing <- sum(is.na(out$SE))
  counts[[id]] <- n; qc[[id]] <- q
  print(unlist(n)); print(unlist(q))
  rm(d, m, out, e); gc(verbose = FALSE)
}

merge_csv <- function(lst, path) {
  new <- rbindlist(lapply(lst, as.data.table), fill = TRUE)
  if (file.exists(path) && !is.null(only)) {
    old <- fread(path)
    new <- rbind(old[!id %in% new$id], new, fill = TRUE)
  }
  fwrite(new, path)
}
merge_csv(counts, file.path(LOG, "munge_counts.csv"))
merge_csv(qc, file.path(LOG, "munge_qc.csv"))
cat("\nBİTTİ", format(Sys.time()), "\n")
print(sessionInfo())

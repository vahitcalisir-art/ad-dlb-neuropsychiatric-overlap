# utils.R — ortak yardımcılar (her analiz betiği source() eder).
suppressPackageStartupMessages({ library(data.table); library(jsonlite) })

.ff <- grep("^--file=", commandArgs(FALSE), value = TRUE)
ROOT <- if (length(.ff)) normalizePath(file.path(dirname(sub("^--file=", "", .ff)), "..", "..")) else normalizePath(getwd())
P_ <- function(...) file.path(ROOT, ...)
for (d in c("results", "results/tables", "results/figures", "results/rds", "analysis/logs"))
  dir.create(P_(d), showWarnings = FALSE, recursive = TRUE)
SEED <- 20261120L

TRAITS <- list(  # id -> munged dosya, etiket, prevalans (plan §0.3; değerler deviations.md D3)
  ad        = list(file = "bellenguez_ad", label = "AD",       prev = 0.05),    # geçici (D3)
  dlb       = list(file = "chia_dlb",      label = "DLB",      prev = 0.001),   # Chia 2021 (D3)
  mdd       = list(file = "mdd_noukbb",    label = "MDD",      prev = 0.15),    # Adams 2025 (D3)
  mdd_ukbb  = list(file = "mdd_ukbb",      label = "MDD (with UKB)", prev = 0.15),
  ptsd      = list(file = "ptsd_z",        label = "PTSD",     prev = 0.05),    # Koenen 2017 (D3)
  ptsd_cc   = list(file = "ptsd_cc",       label = "PTSD (case/control)", prev = 0.05),
  insomnia  = list(file = "insomnia",      label = "Insomnia", prev = 0.10),
  scz       = list(file = "scz",           label = "SCZ",      prev = 0.01),
  ad_finngen = list(file = "finngen_ad",   label = "AD (FinnGen)", prev = 0.05)
)
PSYCH <- c("mdd", "ptsd", "insomnia", "scz")
DEMENTIA <- c("ad", "dlb")

read_munged <- function(id, select = NULL) {
  fread(P_("data", "munged", paste0(TRAITS[[id]]$file, ".tsv.gz")), select = select)
}

# ---- biçimlendirme (results.json yalnız biçimlendirilmiş metin tutar) ----
sup <- c("0" = "⁰", "1" = "¹", "2" = "²", "3" = "³", "4" = "⁴", "5" = "⁵", "6" = "⁶",
         "7" = "⁷", "8" = "⁸", "9" = "⁹", "-" = "⁻")
fmt_p <- function(p) {
  if (is.na(p)) return("NA")
  if (p == 0) return("< 1 × 10⁻³⁰⁰")
  if (p >= 0.995) return("1.00")
  if (p >= 0.001) {  # iki anlamlı basamak: 0.014, 0.056, 0.64
    s <- signif(p, 2); d <- max(2, 1 - floor(log10(s)))
    return(formatC(s, format = "f", digits = d))
  }
  e <- floor(log10(p)); m <- p / 10^e
  m <- round(m, 1); if (m >= 10) { m <- 1; e <- e + 1 }
  paste0(formatC(m, format = "f", digits = 1), " × 10", paste(sup[strsplit(as.character(e), "")[[1]]], collapse = ""))
}
fmt_num <- function(x, d = 2) {
  out <- formatC(x, format = "f", digits = d)
  out <- sub("^-(0\\.0*)$", "\\1", out)          # "-0.000" -> "0.000"
  ifelse(is.na(x), "NA", out)
}
fmt_ci <- function(est, lo, hi, d = 2) sprintf("%s (95%% CI %s to %s)", fmt_num(est, d), fmt_num(lo, d), fmt_num(hi, d))
fmt_int <- function(x) formatC(round(x), format = "d", big.mark = ",")

# results.json'a yaprak değerleri ekle/güncelle: res_set("ldsc", "mdd_ad", list(rg = "...", p = "..."))
res_set <- function(section, key, values) {
  path <- P_("results", "results.json")
  # eşzamanlı betikler için kilit (mkdir atomiktir) ve atomik yazma (geçici dosya + yeniden adlandırma)
  lk <- paste0(path, ".lockdir"); got <- FALSE
  for (i in 1:1200) { if (dir.create(lk, showWarnings = FALSE)) { got <- TRUE; break }; Sys.sleep(0.05) }
  if (!got) stop("results.json kilidi alınamadı: ", lk)
  on.exit(unlink(lk, recursive = TRUE), add = TRUE)
  r <- if (file.exists(path)) fromJSON(path, simplifyVector = FALSE) else list()
  if (is.null(r[[section]])) r[[section]] <- list()
  r[[section]][[key]] <- lapply(values, as.character)
  tmp <- paste0(path, ".tmp", Sys.getpid())
  write(toJSON(r, auto_unbox = TRUE, pretty = TRUE), tmp)
  file.rename(tmp, path)
}
log_line <- function(...) cat(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), ..., "\n")

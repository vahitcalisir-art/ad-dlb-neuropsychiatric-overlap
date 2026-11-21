# One-off relabel for the 2026-11-20 `ukb update insomnia` run (run with the pre-fix code):
# OBSOLETE (2026-11-20 17:15): superseded by the ok_target_dropped fix in 03_lava.R; do not run.
# loci where LAVA dropped insomnia (negative variance) raised "Invalid target phenotype" and were labelled
# as errors; with the fixed 03_lava.R they are "ok_target_dropped". Univ/bivar results are unaffected.
source("analysis/R/utils.R")
f <- P_("results", "tables", "lava_status_ukb.csv"); st <- fread(f)
n <- st[grepl("Invalid target phenotype", status), .N]
st[grepl("Invalid target phenotype", status), status := "ok_target_dropped"]
fwrite(st, f)
r <- readRDS(P_("results", "rds", "lava_ukb.rds")); r$status <- st; saveRDS(r, P_("results", "rds", "lava_ukb.rds"))
j <- jsonlite::fromJSON(P_("results", "results.json"), simplifyVector = FALSE)
j$lava_ukb$summary$loci_analysed <- fmt_int(st[status %in% c("ok", "ok_target_dropped"), .N])
write(jsonlite::toJSON(j, auto_unbox = TRUE, pretty = TRUE), P_("results", "results.json"))
cat("relabelled:", n, " loci_analysed:", j$lava_ukb$summary$loci_analysed, " other errors:", st[grepl("^error", status), .N], "\n")
print(table(st$status))

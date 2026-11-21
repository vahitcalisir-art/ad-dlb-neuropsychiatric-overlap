# Faz 0 adım 3: R paketlerinin kurulumu (kullanıcı kütüphanesine, sudo gerekmez).
# Çalıştırma: Rscript analysis/setup_packages.R 2>&1 | tee analysis/logs/setup_packages.log
lib <- Sys.getenv("R_LIBS_USER")
dir.create(lib, recursive = TRUE, showWarnings = FALSE)
.libPaths(c(lib, .libPaths()))
options(
  repos = c(
    CRAN = "https://packagemanager.posit.co/cran/__linux__/noble/latest",
    MRCIEU = "https://mrcieu.r-universe.dev"
  ),
  HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(),
                          paste(getRversion(), R.version$platform, R.version$arch, R.version$os)),
  Ncpus = max(1L, parallel::detectCores() - 2L)
)

cran <- c("remotes", "data.table", "jsonlite", "coloc", "ieugwasr", "R.utils", "simex")
need <- setdiff(cran, rownames(installed.packages()))
if (length(need)) install.packages(need)

if (!requireNamespace("TwoSampleMR", quietly = TRUE)) install.packages("TwoSampleMR")

gh <- c(GenomicSEM = "GenomicSEM/GenomicSEM",
        LAVA       = "josefin-werme/LAVA",
        MRlap      = "n-mounier/MRlap",
        MRPRESSO   = "rondolab/MR-PRESSO")
for (p in names(gh)) {
  if (!requireNamespace(p, quietly = TRUE)) remotes::install_github(gh[[p]], upgrade = "never")
}

pk <- c(cran, "TwoSampleMR", names(gh))
ok <- vapply(pk, requireNamespace, logical(1), quietly = TRUE)
print(ok)
if (!all(ok)) stop("Kurulamayan paket(ler): ", paste(pk[!ok], collapse = ", "))

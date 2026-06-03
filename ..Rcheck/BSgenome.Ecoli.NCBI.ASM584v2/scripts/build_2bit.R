## build_2bit.R
## ─────────────────────────────────────────────────────────────────────────────
## Run this script ONCE locally to generate the 2bit sequence file and place
## it in inst/extdata/. After running, commit the 2bit file to the repository
## so that users can install directly from GitHub without running this script.
##
## Usage (from repository root):
##   Rscript inst/scripts/build_2bit.R
## ─────────────────────────────────────────────────────────────────────────────

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
if (!requireNamespace("BSgenomeForge", quietly = TRUE))
  BiocManager::install("BSgenomeForge")

library(BSgenomeForge)

## Step 1: Forge the full package in a temporary directory
tmp <- tempdir()
message("Forging BSgenome package in: ", tmp)

forgeBSgenomeDataPkgFromNCBI(
  assembly_accession = "GCF_000005845.2",
  pkg_maintainer     = "Junhui Li <ljh.biostat@gmail.com>",
  destdir            = tmp
)

## Step 2: Copy the 2bit file into inst/extdata/
pkg_dir   <- file.path(tmp, "BSgenome.Ecoli.NCBI.ASM584v2")
twobit_src <- list.files(
  file.path(pkg_dir, "inst", "extdata"),
  pattern = "\\.2bit$",
  full.names = TRUE
)

if (length(twobit_src) == 0)
  stop("No .2bit file found in forged package. Check BSgenomeForge output.")

dest_dir <- file.path(here::here(), "inst", "extdata")
dir.create(dest_dir, showWarnings = FALSE, recursive = TRUE)

file.copy(twobit_src, dest_dir, overwrite = TRUE)

message(
  "2bit file copied to inst/extdata/\n",
  "File: ", basename(twobit_src), "\n",
  "Size: ", round(file.size(file.path(dest_dir, basename(twobit_src))) / 1024),
  " KB\n",
  "\nNext steps:\n",
  "  git add inst/extdata/*.2bit\n",
  "  git commit -m 'Add E. coli ASM584v2 2bit sequence file'\n",
  "  git push"
)

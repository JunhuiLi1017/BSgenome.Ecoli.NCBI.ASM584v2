# BSgenome.Ecoli.NCBI.ASM584v2

<!-- badges: start -->
[![R-CMD-check](https://github.com/junhuilab/BSgenome.Ecoli.NCBI.ASM584v2/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/junhuilab/BSgenome.Ecoli.NCBI.ASM584v2/actions/workflows/R-CMD-check.yaml)
[![License: Artistic-2.0](https://img.shields.io/badge/License-Artistic_2.0-blue.svg)](https://opensource.org/licenses/Artistic-2.0)
<!-- badges: end -->

Full genome sequences for *Escherichia coli* K-12 MG1655 packaged as a
[BSgenome](https://bioconductor.org/packages/BSgenome/) data package for use
within the Bioconductor ecosystem.

| Field | Value |
|---|---|
| **Organism** | *Escherichia coli* K-12 MG1655 |
| **NCBI accession** | GCF_000005845.2 |
| **Assembly name** | ASM584v2 |
| **Chromosome** | U00096.3 |
| **Length** | 4,641,652 bp |
| **Topology** | Circular |
| **Provider** | NCBI RefSeq |

---

## Installation

Install directly from GitHub using the `remotes` package:

```r
if (!requireNamespace("remotes", quietly = TRUE))
  install.packages("remotes")

if (!requireNamespace("BSgenome", quietly = TRUE))
  BiocManager::install("BSgenome")

remotes::install_github("junhuilab/BSgenome.Ecoli.NCBI.ASM584v2")
```

> **Note:** The 2bit sequence file (~1.1 MB) is stored in `inst/extdata/` and
> is downloaded as part of the package. No additional download steps are needed.

---

## Quick Start

```r
library(BSgenome.Ecoli.NCBI.ASM584v2)

# The BSgenome object is available under the package name
genome <- BSgenome.Ecoli.NCBI.ASM584v2

# Inspect the genome
seqnames(genome)      # "U00096.3"
seqlengths(genome)    # 4641652
isCircular(genome)    # TRUE

# Retrieve the full chromosome
chr <- genome[["U00096.3"]]

# Retrieve a subsequence
getSeq(genome, "U00096.3", start = 1, end = 200)
```

---

## Use with TmCalculator

This package is the companion genome resource for the
[TmCalculator](https://bioconductor.org/packages/TmCalculator) Bioconductor
package. The following example computes genome-wide melting temperature (Tm)
in 200 bp non-overlapping windows:

```r
library(BSgenome.Ecoli.NCBI.ASM584v2)
library(TmCalculator)

genome      <- BSgenome.Ecoli.NCBI.ASM584v2
genome_name <- "BSgenome.Ecoli.NCBI.ASM584v2"
chr_name    <- "U00096.3"
chr_length  <- length(genome[[chr_name]])

# Step 1: Generate 200 bp windows
bins_gc <- make_genomiccoord(
  bsgenome     = genome,
  chromosomes  = chr_name,
  window       = 200L,
  slide        = 200L,
  start        = 1,
  end          = chr_length,
  strand       = "+",
  trim_N       = "filter",
  max_N_frac   = 0.10,
  as_vector    = TRUE
)

# Step 2: Convert to GRanges
input_new <- list(pkg_name = genome_name, seq = bins_gc)
gr_batch  <- to_genomic_ranges_fast(input_new)

# Step 3: Compute Tm (nearest-neighbor, SantaLucia 2004, 50 mM NaCl)
tm_result <- tm_calculate(
  gr_batch,
  method   = "tm_nn",
  nn_table = "DNA_NN_SantaLucia_2004",
  Na       = 50
)

# Result: GRanges object with Tm and GC content as metadata columns
head(tm_result$gr)
```

For a full end-to-end workflow including multi-layer circular genome
visualization, see the TmCalculator vignette:

```r
vignette("genome_wide_tm_ecoli", package = "TmCalculator")
```

---

## How This Package Was Built

The genome sequences were downloaded from NCBI RefSeq and packaged using
[BSgenomeForge](https://bioconductor.org/packages/BSgenomeForge/):

```r
library(BSgenomeForge)
forgeBSgenomeDataPkgFromNCBI(
  assembly_accession = "GCF_000005845.2",
  pkg_maintainer     = "Junhui Li <ljh.biostat@gmail.com>",
  destdir            = "."
)
```

The resulting 2bit file was committed to `inst/extdata/` so that users can
install the package directly from GitHub without running BSgenomeForge
themselves.

---

## References

Blattner FR, et al. (1997) The complete genome sequence of *Escherichia coli*
K-12. *Science* 277(5331):1453–1462. https://doi.org/10.1126/science.277.5331.1453

Hayashi K, et al. (2006) Highly accurate genome sequences of *Escherichia coli*
K-12 strains MG1655 and W3110. *Mol Syst Biol* 2:2006.0007.
https://doi.org/10.1038/msb4100049

Pagès H (2024). BSgenomeForge: Forge BSgenome data packages.
Bioconductor. https://bioconductor.org/packages/BSgenomeForge

---

## License

Artistic-2.0. See [LICENSE](LICENSE) for details.

The genome sequence data is provided by NCBI and is in the public domain.

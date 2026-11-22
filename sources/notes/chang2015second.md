> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
Chang CC, Chow CC, Tellier LCAM, et al.; 2015; Second-generation PLINK: rising to the challenge of larger and richer datasets; GigaScience 4:7; DOI 10.1186/s13742-015-0047-8; software paper (PLINK 1.9 / PLINK 2.0 design); access route: PMC-XML (PMC4342193)

## Section-by-section reading log
- Abstract: PLINK 1 is a widely used open-source GWAS/population-genetics toolset; PLINK 1.9 uses bit-level parallelism and algorithmic improvements, accelerating most operations by 1-4 orders of magnitude and handling datasets too large for RAM; PLINK 2.0 format to support genotype likelihoods, phase, multiallelic variants, ref/alt alleles.
- Introduction (Findings): Core functional domains unchanged (data management, summary statistics, stratification, association, IBD); drop-in replacement for PLINK 1.07; VCF/Oxford import/export, GRM calculator.
- Methods: Algorithmic description — bit-level parallelism and popcount for IBS and LD correlation (r) computation; multicore/cluster parallelism; memory efficiency; partial-sum lookup for distance matrices; early-termination HWE and Fisher's exact tests; accelerated Gabriel haplotype block estimation; LASSO; integration of PERMORY, BOOST etc.; multithreaded gzip; VCF import is lossy (phase, multiallelic, likelihoods).
- Results: Benchmark tables (Tables 1-6) across seven machines and synthetic/1000 Genomes phase 1 datasets: e.g. --indep-pairwise LD pruning hundreds to thousands of times faster (Table 4); IBS matrices >100x; permutation tests extended.
- Discussion: PLINK 2.0 design (multiple data representations, explicit reference vs alternate alleles, compression).
- Limitations stated by authors: PLINK 1 binary format cannot represent phase, dosages, multiallelic variants; not suitable for structural-variant/sequencing analyses; should not be used to manage data for both types of analysis because it discards information.
- Supplementary material: not consulted (Additional file 1 is an algorithm description)

## Quality appraisal
Peer-reviewed software paper; standard citation for PLINK 1.9. Note: the text does not describe the --clump procedure or its parameters explicitly; it covers LD (r) computation and LD-based pruning (--indep-pairwise). Clumping parameters used in our study must be reported from our own methods (or the PLINK documentation / Purcell 2007), with this paper cited as the software reference. Not an epidemiological source; no conflicts declared.

## Relevance to this manuscript
- M2: software citation for PLINK 1.9 used for LD clumping of instruments with the 1000 Genomes EUR reference; supports that PLINK computes pairwise LD and LD-based variant selection efficiently. Does not support any specific clumping thresholds.

## Decision
KEEP — software actually used by the study (PLINK 1.9 for clumping); cite as the PLINK reference, but do not attribute clumping parameter choices to it.

## Claims
- c1 | Abstract | "PLINK 1 is a widely used open-source C/C++ toolset for genome-wide association …" | General description of PLINK (M2)
- c2 | Abstract | "In combination, these changes accelerate most operations by 1-4 orders of magnitude, …" | PLINK 1.9 performance (M2)
- c3 | Results | "The PLINK 1.0 –indep-pairwise command is frequently used in preparation for analyses …" | LD-based variant selection in PLINK (M2; closest statement to clumping)
- c4 | Results | "This command is used to select a set of genetic markers which …" | LD-based selection of approximately independent variants (M2)

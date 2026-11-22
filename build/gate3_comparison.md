# Gate 3 comparison

Main: ~/q1paper/results
Rerun: ~/q1paper_gate3/results

- results.json leaves compared: 3795; differing: 0
- table files compared: 35 (419585 cells); differing cells/files: 0
- metadata cells ignored (whitelist below): 165
- figures byte-identical: 4; differing bytes (informative): 0
- verdict: IDENTICAL for all common values

## Metadata whitelist (ignored columns)
- ldsc_inputs.csv › file: 11 differing cells ignored
- mr_*.csv › runtime_min: 62 differing cells ignored
- mr_output_integrity.csv › clumped_mtime: 46 differing cells ignored
- mr_output_integrity.csv › rds_mtime: 46 differing cells ignored

## Scripts not rerun in the Gate 3 tree
- 03b_lava_seeded_compare.R (rerun of loci missing after an out-of-memory failure; the chain processed all loci from the start with seeds): results.json lava_seeded_rerun, table lava_seeded_vs_unseeded_ukb.csv
- 03_lava.R seedcheck mode (diagnostic only): results.json lava_seed_check, table lava_seed_check_ukb.csv

## Differing results.json values

## Differing table cells

## Only in main results.json (not produced by the chain)
- lava_seed_check › borderline › locus
- lava_seed_check › borderline › mc_se_p
- lava_seed_check › borderline › p_fdr_main
- lava_seed_check › borderline › p_fdr_seed
- lava_seed_check › borderline › p_main
- lava_seed_check › borderline › p_seed
- lava_seed_check › summary › all_reproducible
- lava_seed_check › summary › lava_version
- lava_seed_check › summary › max_abs_rho_diff
- lava_seed_check › summary › median_rel_p_diff
- lava_seed_check › summary › n_primary_tests
- lava_seed_check › summary › primary_fdr_main
- lava_seed_check › summary › primary_fdr_seed
- lava_seed_check › summary › primary_nominal_main
- lava_seed_check › summary › primary_nominal_seed
- lava_seed_check › summary › seed_base
- lava_seed_check › summary › seed_rule
- lava_seeded_rerun › primary › fdr_seeded
- lava_seeded_rerun › primary › fdr_unseeded
- lava_seeded_rerun › primary › max_abs_rho_diff
- lava_seeded_rerun › primary › median_rel_p_diff
- lava_seeded_rerun › primary › nominal_seeded
- lava_seeded_rerun › primary › nominal_unseeded
- lava_seeded_rerun › primary › only_seeded
- lava_seeded_rerun › primary › only_unseeded
- lava_seeded_rerun › primary › sign_changes
- lava_seeded_rerun › primary › significance_changes
- lava_seeded_rerun › primary › tests_seeded
- lava_seeded_rerun › primary › tests_unseeded
- lava_seeded_rerun › secondary › fdr_seeded
- lava_seeded_rerun › secondary › fdr_unseeded
- lava_seeded_rerun › secondary › max_abs_rho_diff
- lava_seeded_rerun › secondary › median_rel_p_diff
- lava_seeded_rerun › secondary › nominal_seeded
- lava_seeded_rerun › secondary › nominal_unseeded
- lava_seeded_rerun › secondary › only_seeded
- lava_seeded_rerun › secondary › only_unseeded
- lava_seeded_rerun › secondary › sign_changes
- lava_seeded_rerun › secondary › significance_changes
- lava_seeded_rerun › secondary › tests_seeded
- lava_seeded_rerun › secondary › tests_unseeded

## Only in rerun results.json

## Tables only in main
- lava_seed_check_ukb.csv
- lava_seeded_vs_unseeded_ukb.csv

## Tables only in rerun

## Figures with differing bytes

# NEEDS_PDF — full texts not available through legal open-access routes

Prepared 2026-11-20 after `tools/sources.py fetch` (Europe PMC full-text XML and Unpaywall OA PDFs). The work does not wait for these; open-access equivalents are used where they exist.

How to add one: obtain the PDF through legal access (institutional subscription, author copy, interlibrary loan) and save it as `~/q1paper/sources/inbox/<key>.pdf` (the key is the first column below), then run `python3 tools/sources.py ingest`. Sci-Hub, LibGen and similar sources must not be used.

## Priority 1 — needed for the manuscript (data source or key prior study)

| key | DOI | Why it matters | OA alternative |
|---|---|---|---|
| niu2017prevalence | 10.1016/j.nrl.2016.02.016 | **REQUIRED** — AD prevalence source (deviations D3; meta-analysis of AD prevalence in Europe); not open access | none |
| ohayon2002epidemiology | 10.1053/smrv.2002.0186 | **REQUIRED unless watanabe2022genome states its own prevalence assumption** — insomnia prevalence (deviations D3); not open access | none |
| werme2022integrated | 10.1038/s41588-022-01017-y | **REQUIRED** — LAVA method paper (method used; mandatory). No PMC or Europe PMC author manuscript exists (checked 2026-11-20). Only the bioRxiv preprint was retrieved automatically; the published version is listed by Unpaywall in institutional repositories: https://research.vu.nl/en/publications/aec5dd7a-dd0c-4701-9031-32ddf5d (VU Amsterdam) and https://pure.amsterdamumc.nl/en/publications/0537b070-73d0-4382-9e3b-7 (Amsterdam UMC) — open the landing page and download the published PDF | preprint only (not usable, §1.3-4) |
| mounier2023bias | 10.1002/gepi.22522 | **REQUIRED** — MRlap method paper (method used; mandatory). If its published text states that sample overlap biases MR (verbatim quote), burgess2016bias is dropped (outline §E). No PMC or Europe PMC author manuscript exists (checked 2026-11-20). Published version listed as open access: https://onlinelibrary.wiley.com/doi/pdfdirect/10.1002/gepi.22522 (Wiley) and https://serval.unil.ch/resource/serval:BIB_F65931571130.P001/REF.pdf (University of Lausanne repository). Automated download of these was not attempted further after a tool permission block | preprint only (not usable) |
| watanabe2022genome | 10.1038/s41588-022-01124-w | Source paper of the insomnia GWAS used; must be cited (data papers count toward the reference set). If it states its own insomnia prevalence assumption (verbatim quote), ohayon2002epidemiology is dropped (outline §E) | none |
| chen2026shared | 10.1038/s41380-026-03735-9 | Closest prior study: SCZ × ADRD local rg + bidirectional MR with PGC3 SCZ and Bellenguez AD; full reading needed to confirm overlap and to position this study (Faz 4 step 3) | none |
| hu2024relationship | 10.1016/j.jad.2024.03.149 | Prior bidirectional MR of MDD with AD and DLB; comparison in the Discussion | none |
| guerreiro2016genome | 10.1016/j.neurobiolaging.2015.10.028 | Prior DLB genetic correlation study | none found yet |
| gerring2022local | 10.1016/j.biopsych.2022.03.001 | LAVA local rg across psychiatric traits; method precedent | none found yet |
| lutz2020shared2 | 10.1002/alz.12128 | Prior PTSD–AD shared genetics study | none found yet |
| urso2026incidence | 10.1001/jamaneurol.2026.1206 | Candidate primary source for the DLB prevalence assumption (plan §0.3) | other DLB prevalence reviews to be sought |
| skrivankova2021strengthening | 10.1001/jama.2021.18236 | STROBE-MR checklist (JAMA) | **skrivankova2021strengthening2** (BMJ explanation and elaboration, open access, downloaded) |

Note on preprints: for LAVA and MRlap the bioRxiv preprints are available, but STRICT_RULES §1.3-4 does not allow a preprint when a published version exists (the only exception is a critical data source that exists only as a preprint). The published PDFs are therefore required; the preprint-based notes are kept only until they arrive and are then rewritten against the published text.

## Priority 2 — useful, replaceable

| key | DOI | Topic |
|---|---|---|
| ismail2016neuropsychiatric | 10.1016/j.jalz.2015.05.017 | MBI provisional criteria |
| lyketsos2011neuropsychiatric | 10.1016/j.jalz.2011.05.2410 | NPS in AD (review) |
| liu2013apolipoprotein | 10.1038/nrneurol.2012.263 | APOE and AD (review) |
| pink2015neuropsychiatric | 10.1212/wnl.0000000000001307 | NPS, APOE ε4 and incident dementia |
| geda2006depression | 10.1001/archneur.63.3.435 | Depression, APOE and MCI |
| burke2016associations | 10.1017/s1041610216000405 | Depression, sleep, APOE and AD |
| yaffe2010posttraumatic | 10.1001/archgenpsychiatry.2010.61 | PTSD and dementia risk in veterans |
| qureshi2010greater | 10.1111/j.1532-5415.2010.02977.x | PTSD and dementia in older veterans |
| stavitsky2006progression | 10.1001/archneur.63.10.1450 | Psychiatric symptoms in DLB vs AD |
| ohi2024genetic | 10.1016/j.neubiorev.2024.105900 | SCZ–AD genetic overlap review |
| ye2016shared | 10.3233/jad-151129 | Late-life depression and AD shared genetics |
| liu2026depression | 10.2174/0115672050477354260714063740 | Depression–AD MR |
| sun2026neuropsychiatric | 10.1016/j.inpsyc.2026.100275 | NPS predicting progression in MCI |
| barnes2026apathy | 10.1016/j.parkreldis.2026.108373 | Apathy in DLB |
| flesaker2026state | 10.1002/jts.70091 | PTSD epidemiology review |
| kessler2005prevalence | 10.1001/archpsyc.62.6.617 | NCS-R 12-month prevalence (US) |

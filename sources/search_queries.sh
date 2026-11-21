#!/usr/bin/env bash
# Faz 4 adım 1: Europe PMC sorgu aileleri (STRICT_RULES Faz 4). Her sorgu az sayıda aday ekler;
# toplam aday havuzu 70–100 hedeflenir. Veri ve yöntem makaleleri ayrıca add-doi ile eklendi.
set -u
cd "$(dirname "$0")/.."
S() { echo "== [$2] $1"; .venv/bin/python3 tools/sources.py search "$1" --max "$2"; sleep 1; }
# MR ve genetik korelasyon: psikiyatrik özellik × AD/DLB
S '"mendelian randomization" AND (depression OR "depressive disorder") AND ("Alzheimer disease" OR "Alzheimer'"'"'s disease")' 7
S '"mendelian randomization" AND ("post-traumatic stress" OR PTSD) AND (dementia OR Alzheimer*)' 5
S '"mendelian randomization" AND insomnia AND (Alzheimer* OR dementia)' 5
S '"mendelian randomization" AND schizophrenia AND (Alzheimer* OR dementia)' 5
S '"genetic correlation" AND (depression OR schizophrenia OR "post-traumatic stress" OR insomnia) AND (Alzheimer* OR "Lewy body")' 7
S '("Lewy body dementia" OR "dementia with Lewy bodies") AND (depression OR psychosis OR hallucinations) AND (genetic OR GWAS OR polygenic)' 5
# APOE ε4 ve nöropsikiyatrik belirtiler
S 'APOE AND (depression OR psychosis OR "post-traumatic stress") AND ("neuropsychiatric symptoms" OR dementia)' 6
# Demansta nöropsikiyatrik belirtilerin epidemiyolojisi ve prognozu; MBI
S '"neuropsychiatric symptoms" AND dementia AND (prevalence OR progression OR mortality) AND ("meta-analysis" OR "systematic review" OR cohort)' 7
S '"mild behavioral impairment" AND (dementia OR "cognitive decline")' 5
S '(depression OR PTSD OR insomnia) AND "risk of dementia" AND ("meta-analysis" OR "systematic review")' 6
# Proxy fenotip ve LD referans uyumsuzluğu (tartışma notları N1)
S '("proxy" OR "family history" OR GWAX) AND Alzheimer* AND ("genetic correlation" OR "polygenic" OR "genome-wide")' 5
S '"LD score regression" AND ("reference panel" OR mismatch OR "linkage disequilibrium reference")' 4
# Prevalans kaynakları (plan §0.3)
S '"dementia with Lewy bodies" AND prevalence AND ("systematic review" OR "meta-analysis")' 2
S '"Alzheimer" AND prevalence AND "older adults" AND ("systematic review" OR "meta-analysis")' 2
S '("major depressive disorder" OR "major depression") AND "lifetime prevalence" AND "World Mental Health"' 2
S '("posttraumatic stress disorder" OR PTSD) AND "lifetime prevalence" AND "World Mental Health"' 2
S 'insomnia AND prevalence AND ("systematic review" OR "meta-analysis") AND adults' 2
S 'schizophrenia AND prevalence AND "systematic review"' 2
.venv/bin/python3 tools/sources.py status

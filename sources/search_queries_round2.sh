#!/usr/bin/env bash
# Faz 4 adım 1, tur 2 (2026-11-20): atıf sayısına göre sıralı aramalar (sources.py --sort "CITED desc").
# Tur 1'in tarih ağırlıklı sıralaması kapsam dışı kayıtlar getirdi (bkz. screen_round1.sh).
set -u
cd "$(dirname "$0")/.."
S() { echo "== [$2] $1"; .venv/bin/python3 tools/sources.py search "$1" --max "$2" --sort "CITED desc"; sleep 1; }
S '"mendelian randomization" AND (depression OR "depressive disorder") AND Alzheimer*' 4
S '"genetic correlation" AND (psychiatric OR depression OR schizophrenia) AND Alzheimer*' 4
S '"mendelian randomization" AND (PTSD OR "post-traumatic stress" OR insomnia OR schizophrenia) AND (Alzheimer* OR dementia)' 4
S '"neuropsychiatric symptoms" AND (dementia OR "Alzheimer") AND prevalence AND "meta-analysis"' 3
S '"neuropsychiatric symptoms" AND "mild cognitive impairment" AND (progression OR conversion) AND dementia' 3
S '"mild behavioral impairment" AND (criteria OR checklist)' 2
S 'depression AND "risk of dementia" AND "meta-analysis"' 3
S '("post-traumatic stress" OR PTSD) AND dementia AND "meta-analysis"' 2
S '(insomnia OR "sleep disturbance") AND (dementia OR Alzheimer*) AND "meta-analysis"' 2
S 'schizophrenia AND dementia AND risk AND "meta-analysis"' 2
S '(APOE OR "apolipoprotein E") AND (e4 OR epsilon4 OR ε4) AND depression AND (meta-analysis OR cohort)' 3
S '(APOE OR "apolipoprotein E") AND psychosis AND "Alzheimer"' 2
S '"dementia with Lewy bodies" AND (consortium OR criteria) AND (diagnosis OR prodromal)' 3
S '("Lewy body dementia" OR "dementia with Lewy bodies") AND ("genome-wide association" OR GWAS)' 2
S '(proxy OR "parental history" OR GWAX) AND "Alzheimer" AND ("genome-wide association" OR GWAS)' 3
S '"LD score regression" AND (population OR ancestry) AND (mismatch OR "reference panel")' 2
S 'dementia AND prevalence AND "Global Burden of Disease"' 2
S '"major depressive disorder" AND "lifetime prevalence" AND (cross-national OR "World Mental Health")' 2
S '(PTSD OR "posttraumatic stress disorder") AND "World Mental Health" AND (prevalence OR epidemiology)' 2
S 'insomnia AND epidemiology AND prevalence AND (review OR "general population")' 2
S 'schizophrenia AND prevalence AND "systematic review"' 2
S '"dementia with Lewy bodies" AND (prevalence OR incidence) AND "systematic review"' 2
.venv/bin/python3 tools/sources.py status

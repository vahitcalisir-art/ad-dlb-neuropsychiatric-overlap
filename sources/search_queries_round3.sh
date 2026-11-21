#!/usr/bin/env bash
# Faz 4 adım 1, tur 3 (2026-11-20): başlık alanıyla sınırlanmış hedefli aramalar.
# Amaç: (i) aynı soruyu yanıtlamış önceki MR / genetik korelasyon çalışmalarını bulmak (Faz 4 adım 3, §5 durdurma
# koşulu), (ii) prevalans birincil kaynakları (plan §0.3).
set -u
cd "$(dirname "$0")/.."
S() { echo "== [$2] $1"; .venv/bin/python3 tools/sources.py search "$1" --max "$2" --sort "CITED desc"; sleep 1; }
S 'TITLE:"mendelian randomization" AND TITLE:depress* AND (TITLE:alzheimer* OR TITLE:dementia)' 5
S '(TITLE:"genetic correlation" OR TITLE:"genetic overlap" OR TITLE:"shared genetic") AND TITLE:alzheimer* AND (TITLE:psychiatric OR TITLE:depress* OR TITLE:schizophrenia OR TITLE:"post-traumatic stress" OR TITLE:PTSD)' 6
S 'TITLE:"local genetic correlation" AND (alzheimer* OR dementia OR psychiatric)' 4
S '(TITLE:PTSD OR TITLE:"post-traumatic stress" OR TITLE:"posttraumatic stress") AND (TITLE:dementia OR TITLE:alzheimer*)' 3
S 'TITLE:insomnia AND (TITLE:alzheimer* OR TITLE:dementia) AND (genetic OR "mendelian randomization")' 3
S 'TITLE:lewy AND (TITLE:depress* OR TITLE:psychiatric OR TITLE:schizophrenia OR TITLE:"genetic correlation" OR TITLE:"mendelian randomization")' 4
S '(TITLE:APOE OR TITLE:"apolipoprotein E") AND (TITLE:depress* OR TITLE:neuropsychiatric OR TITLE:psychosis)' 3
S 'TITLE:"posttraumatic stress disorder" AND TITLE:"World Mental Health"' 2
S 'TITLE:"major depressive" AND (TITLE:"cross-national" OR TITLE:"World Mental Health")' 2
S 'TITLE:insomnia AND TITLE:epidemiology AND TITLE:"what we know"' 1
S 'TITLE:"prevalence of schizophrenia" AND TITLE:"systematic review"' 2
.venv/bin/python3 tools/sources.py status

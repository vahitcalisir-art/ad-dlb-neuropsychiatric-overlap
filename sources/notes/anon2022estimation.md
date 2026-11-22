> Public version: verbatim passages are shortened to locating key phrases (at most 12 words); the full passages are kept in the author's local records.

## Bibliographic record
GBD 2019 Dementia Forecasting Collaborators (writing group led by Nichols E, Steinmetz JD, Vollset SE, et al.); 2022; Estimation of the global prevalence of dementia in 2019 and forecasted prevalence in 2050: an analysis for the Global Burden of Disease Study 2019; The Lancet Public Health 7(2):e105–e125; DOI 10.1016/S2468-2667(21)00249-8; modelling study (GBD DisMod-MR 2.1 prevalence estimation plus regression-based forecasting and decomposition); access route PMC-XML (PMC8810394)

## Section-by-section reading log
- Abstract: Global dementia cases estimated at 57·4 (50·4–65·1) million in 2019, forecast 152·8 (130·8–175·9) million in 2050; age-standardised prevalence stable (0·1% change); female:male ratio 1·69 in 2019; growth driven by population growth and ageing.
- Introduction: Declining incidence trends in North America/Europe vs rising case counts; motivation to add country-level estimates and risk-factor trends (high BMI, high fasting plasma glucose, smoking, education) to forecasts.
- Methods: Dementia = GBD cause "Alzheimer's disease and other dementias" (no subtype split); reference case definitions DSM-III to DSM-5 or ICD-8 to ICD-10 assigned by study clinicians in representative surveys; alternative definitions (clinical records, algorithms, NIA-AA, GP records, 10/66, US claims) bias-adjusted via MR-BRT network meta-regression; note that this article does NOT apply the GBD downward correction for dementia due to stroke, Parkinson's, Down syndrome or TBI, so figures differ from GBD online tools; DisMod-MR 2.1 assumed zero remission and no incidence before age 40; forecasts via PAF-based risk scalar plus logit-linear regression with education, age group and region, ARIMA(0,1,0) residuals; 1000 draws; UIs = 2.5th/97.5th percentiles.
- Results: Prevalence higher in women, doubling about every 5 years up to 85. 2050 forecasts: men 0·5% (40–69 y), 6·5% (70–84 y), 23·5% (≥85 y); women 0·6%, 8·5%, 30·5% respectively (Figure 1 shows 2019 values graphically only; 2019 age-specific percentages are not given in text). Big country/region table of case counts; largest increases in north Africa/Middle East and eastern sub-Saharan Africa; decomposition (Figure 4).
- Discussion: 2050 case count similar to World Alzheimer Report 2019 (152 million); higher than Brookmeyer et al. because those were AD-only; mixed pathologies make total dementia more relevant; sex difference partly life expectancy; up to 40% of dementia potentially preventable (Lancet Commission).
- Limitations stated by authors: PAF causality assumption; sparse heterogeneous prevalence data; reliance on DisMod priors where data absent; observed time trends not used; limited risk factors; education capped at 18 years; BMI not lagged; no clinical subtypes (AD, vascular etc.) because of scarce global subtype data; prevalence only, not incidence.
- Supplementary material: not available (appendix referenced but not in text file)

## Quality appraisal
Very large evidence base (systematic review of population surveys, GBD modelling); peer-reviewed (Lancet Public Health). Model-based estimates with wide UIs; heavy imputation in data-poor regions; no AD-specific or DLB-specific prevalence. Figures are all-cause dementia, not AD; the 2050 age-specific values are forecasts, not observed 2019 prevalence. Consistent with World Alzheimer Report totals. Not MR; MR assumptions not applicable.

## Relevance to this manuscript
M3 (population prevalence), trait-by-trait:
- AD (assumed 0.05): Partially supports for older adults only. The source gives all-cause dementia, not AD: "6·5% (5·3 to 8·0) among those aged 70–84 years" (men, 2050 forecast) and "8·5% (7·0 to 10·4) among those aged 70–84 years" (women, 2050 forecast); 23·5% and 30·5% at ≥85 years. Since AD is a subset of all-cause dementia, an AD prevalence of ~5% in an older-adult reference population is plausible but is not directly stated; all-age prevalence is far lower (0·5–0·6% at 40–69 years). The manuscript should describe K = 0.05 as an approximation for older adults, and cite this source as all-cause dementia, not AD.
- DLB (assumed 0.005): Not addressed (no subtype estimates; authors say subtype data are scarce).
- MDD (0.15): Not addressed.
- PTSD (0.07): Not addressed.
- Insomnia (0.10): Not addressed.
- SCZ (0.01): Not addressed.
Also mildly supports I1 (dementia burden, 57·4 million cases in 2019).

## Decision
KEEP — only source in this batch giving population dementia prevalence by older-age band; supports (approximately) the AD K value for liability-scale h² if framed as all-cause dementia in older adults.

## Claims
- c1 | Methods | "The category of dementia, as described in this Article, is referred to …" | Phenotype definition: estimates are all-cause dementia, not AD specifically (M3)
- c2 | Methods | "The reference case definitions for the estimation of dementia prevalence in the …" | Case definition behind the prevalence values (M3)
- c3 | Results | "In 2019, there were an estimated 57·4 (95% UI 50·4–65·1) million individuals …" | Global dementia burden (I1, M3)
- c4 | Results | "Dementia prevalence was higher in women than in men and increased with …" | Prevalence depends strongly on age, so K must refer to an older-adult population (M3, D6)
- c5 | Results | "In 2050, the prevalence of dementia in men globally was forecasted to …" | Older-adult dementia prevalence near the assumed AD K = 0.05 (M3)
- c6 | Results | "In women, the global forecast was projected to be 0·6% (0·5 to …" | Older-adult dementia prevalence by sex (M3)
- c7 | Discussion | "The estimates from Brookmeyer and colleagues were only for Alzheimer's disease, which …" | AD prevalence is lower than all-cause dementia prevalence; caveat for using dementia figures for AD K (M3)
- c8 | Discussion | "this study focused on the overall prevalence of dementia because of a …" | No AD- or DLB-specific prevalence available from GBD (M3, D6)

# PROGRESS

## Faz 0 — Kurulum ve doğrulama (2026-11-19)

### Tamamlanan
- Proje klasörü: WSL2 Ubuntu 24.04.2 LTS, `~/q1paper`. Boş disk 953 GB (en az 80 GB koşulu sağlandı). 12 çekirdek, yaklaşık 9 GB RAM.
- §7 araçları çıkarıldı: config.json, manuscript/meta.json, manuscript/supplement_meta.json, tools/{build_docx,check_docx,audit_manuscript,sources,verify_refs}.py. `py_compile` geçti.
- Python 3.12.3 venv (`~/q1paper/.venv`): python-docx 1.2.0, pypdf 7.1.1, matplotlib 3.11.2, pandas 3.1.1, requests.
- PLINK v1.9.1 (11 Nov 2026), resmi ikili dosya: https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20261111.zip (zip SHA-256 2038e1a73a1ae4ac10d705fef45c9f012f1f7696ce188f72faff80d0ae6d523c), `~/bin/plink`.
- Hedef dergi doğrulandı: `docs/research_topic.md`, `docs/journal_requirements.md`. Volume II açık, son tarih 17 May 2027.

### Uyarlamalar (§1.5-8 / Faz 0 adım 4)
- `config.json` LINE_SPACING: double → single. Gerekçe: Frontiers yazar kılavuzu "The entire document should be single-spaced". §0 ile çelişkide kılavuz esas alınır (Faz 0 adım 4). Hiçbir denetim gevşemedi.

### Bekleyen (kullanıcı kararı gerekiyor; araç değişikliği olduğu için kendiliğinden yapılmadı)
1. Kaynak stili: Frontiers in Dementia'da yayımlanan makaleler Harvard (yazar-yıl) kullanıyor; §0 ve build_docx Vancouver üretiyor.
2. Şekil biçimi: kılavuz TIFF/JPEG, RGB, 300 dpi istiyor; §1.5-4 PNG diyor.
3. Üretken yapay zekâ beyanı: kılavuz Acknowledgments bölümünde (ve gerekirse Yöntem'de) araç adı, sürümü, modeli ve kaynağıyla birlikte istiyor; §1.5-6 Acknowledgments'ı yalnız gerçek bir teşekkür varsa koyuyor.
4. Başlık sayfası: kılavuz kelime, şekil ve tablo sayısının ilk sayfada yazılmasını istiyor; build_docx bunu yazmıyor.

### Eksik (sudo parolası gerekiyor)
- apt paketleri (poppler-utils, r-base, r-base-dev, derleme kütüphaneleri, ttf-mscorefonts-installer). Kurulmadan R paketleri ve `analysis/logs/session_info.txt` yapılamıyor.

### Kapı 0
- `py_compile` geçti, `docs/journal_requirements.md` var: **resmi koşullar sağlandı.**
- Ortam (adım 3) eksik: R ve poppler kurulmadan Faz 1 harmonizasyonu ve Faz 3 başlatılamaz.

## Faz 0 — güncelleme (2026-11-19, ikinci tur)
- STRICT_RULES.md yeni sürümle değiştirildi; tools/, config.json, manuscript/meta.json, manuscript/supplement_meta.json yeniden çıkarıldı. Eski config.json `build/config.before_reextract.json` olarak saklandı. Karşılaştırma: önceki uyarlama (LINE_SPACING=single) yeni config'te zaten var; değişen anahtar yok, yeni anahtarlar FIGURE_EXPORT_FORMAT, FIGURE_MIN_DPI, CITATION_STYLE, REF_MAX_AUTHORS. `py_compile` geçti.
- Önceki "Bekleyen" dört madde (yazar-yıl atıf, TIFF, Acknowledgments'ta yapay zekâ beyanı, ilk sayfada sayılar) kullanıcı onayıyla STRICT_RULES.md'ye işlendi; kapandı.
- Bellek (Faz 0 adım 2): Windows toplam RAM 33.667.739.648 bayt (31,4 GiB). `C:\Users\WIN11\.wslconfig`: memory=27GB, swap=16GB (önceki 10GB/8GB; yedek `.wslconfig.bak-20261119`; mevcut `autoMemoryReclaim=gradual` korundu). Etkinleşmesi için kullanıcının `wsl --shutdown` çalıştırması gerekiyor.
- apt kurulumu bu dağıtımda yapılmamış görünüyor (apt history boş; R, pdftotext, unzip, Times New Roman yok). R paketleri ve session_info.txt bu nedenle bekliyor. Kurulum betiği hazır: `analysis/setup_packages.R`.
- Faz 1 adım 1 (veri kaynaklarının resmi sayfadan ve kullanım koşullarıyla doğrulanması) indirmesiz olarak başlatıldı.
- Not (çelişki değil, metin tutarlılığı): §1.5-4 "build/figures/Figure1.png" diyor, §0 ise TIFF dışa aktarım öngörüyor; §4-2 "kaynak sonda numarayla gelir" diyor, CITATION_STYLE ise author-year. Araç davranışı §0'ı izler.
- STRICT_RULES.md yeniden güncellendi (yalnız §1.5-4: Figure1.png → Figure1.tif; §4-2: atıf yazar-yıl, anlatı atfı kullanılmaz). Kod ve config değişmedi; tools/ ve config.json yeniden çıkarılmadı. Önceki tutarsızlık notu kapandı.

### Faz 0 kapanış (2026-11-19)
- apt kurulumu doğrulandı: R 4.3.3, pdftotext 24.02.0, UnZip 6.00, Times New Roman (msttcorefonts). WSL belleği 26 GB + 16 GB swap (yeni .wslconfig etkin).
- R paketleri (kullanıcı kütüphanesi): GenomicSEM 0.0.5, LAVA 0.1.5, MRlap 0.0.3.3, MRPRESSO 1.0, TwoSampleMR 0.7.14, ieugwasr 1.2.1, coloc 5.2.3, data.table 1.18.6.1, jsonlite 2.0.0. Kurulum logu analysis/logs/setup_packages.log; 23 uyarının tümü GenomicSEM yüklenirken plyr/gdata işlevlerinin dplyr ile örtüşmesi (zararsız).
- analysis/logs/session_info.txt yazıldı.
- **Kapı 0: GEÇTİ.**

## Faz 1 — Veri edinimi (başladı 2026-11-19)
- Kaynak doğrulama raporu: data/source_verification.md (resmi sayfalar, API, README ve dosya başlıklarından; indirme yapılmadan).
- Kullanıcı kararları (2026-11-19):
  1. PGC (MDD2025, PTSD Freeze 3, SCZ PGC3) kullanım koşulları ve CNCR uykusuzluk koşulları (CC BY-NC-SA 4.0 + yeniden tanımlama/damgalama yasağı) araştırmacı tarafından kabul edildi. Dosyalar yeniden barındırılmaz.
  2. Kunkle 2019 (GCST007511) DIŞLANDI: IGAP README'si verinin "potentially sensitive behavioral traits" araştırmasında kullanılmamasını şart koşuyor; psikiyatrik özelliklerin kapsama girip girmediği belirsiz, §1.1-5 gereği temkinli yorumlandı. NIAGADS tam seti başvuru gerektiriyor. UKB'siz AD duyarlılık analizi yapılamıyor; Yöntem ve Sınırlılıklar'da yazılacak.
  3. LAVA LD referansı: ana analiz UK Biobank referansı (LAVA yazarları 1000G ile tip I hata şişmesi ve lokal h² yanlılığı konusunda uyarıyor ve UKB referansını "strongly recommend" ediyor); 1000G EUR ön kayıtlı duyarlılık analizi. Bu, STRICT_RULES Faz 1 tablosundaki LAVA referansı satırından bir uyarlamadır; Faz 2 planına yazılacak. STRICT_RULES.md kullanıcı güncellemedikçe değiştirilmedi.
- LDSC referansı: Broad'ın özgün eur_w_ld_chr adresi 404 veya ücretli (requester-pays) olduğundan kullanılmıyor. STRICT_RULES'taki "1000 Genomes Faz 3 EUR" ile uyumlu Zenodo 7768714 (CC BY 4.0) 1000G_Phase3 dosyaları indiriliyor.
- Uykusuzluk: açık genom geneli dosya yalnız UK Biobank (109.548 / 277.440); 23andMe dahil tam meta-analiz DTA gerektirdiğinden kullanılamıyor. STRICT_RULES'taki "veya en güncel açık sürüm" hükmüne uygun.

### Faz 1 indirmeler tamamlandı (2026-11-20)
- Tüm dosyalar indirildi; yayıncı MD5'i olanların tümü eşleşti (MDD, PTSD, SCZ, uykusuzluk, LDSC, Bellenguez, Chia). LAVA zip'leri `unzip -t`, MRC IEU arşivi `tar tzf` ile doğrulandı. Toplam 19 GB.
- Kesintiler: LAVA UKB chr3-4 bağlantı hatası (devam ettirildi, boyut sunucuyla aynı, zip testi geçti); Bellenguez 2 saatlik arka plan süresinde %91'de kesildi (`-C -` ile devam ettirildi, MD5 eşleşti).
- PTSD case/control dosyasının başlığındaki N, birincil dosyanınkiyle aynı; SNP bazlı sütunlar daha düşük güç gösteriyor (maks. NEFF 460.805). Manifestte SNP bazlı değerler esas alındı.
- `data/DATA_MANIFEST.md` yazıldı: her dosya için erişim adresi, sürüm, yayın, örneklem, soy, genom yapısı, sütunlar, SHA-256, kullanım koşulu; ikili örneklem örtüşmesi tablosu.
- **Kapı 1: GEÇTİ** (her dosya indirilmiş, SHA-256 kayıtlı, manifest eksiksiz, örneklem örtüşmesi her çift için not edilmiş).
- Sıradaki: Faz 1 adım 3 harmonizasyon (`analysis/R/01_munge.R`; yalnız girdi hazırlığı, sonuç üretmez).

### Faz 1 adım 3 — harmonizasyon (2026-11-20)
- Kullanıcı talimatları: ana MDD = UKB'siz sürüm (UKB'li sürüm MRlap düzeltmeli duyarlılık); bu karar ve Kunkle dışlanmasının gerekçe ve sonucu deviations.md'ye değil doğrudan Faz 2 planına yazılır. Bu aşamada yalnız tek dosya QC (alel frekansı, lambda GC, N); özellikler arası hesap yok. Faz 2 planı dondurulmadan önce kullanıcıya bir sayfalık özet gönderilir; **Faz 2→3 kapısı bu nokta için onaylı kapıdır** (diğer kapılar otomatik).
- `analysis/R/01_munge.R` 8 dosyada çalıştı (bellenguez_ad, chia_dlb, mdd_noukbb, mdd_ukbb, ptsd_cc, ptsd_z, insomnia, scz). Çıktılar `data/munged/*.tsv.gz`; adım adım sayımlar `analysis/logs/munge_counts.csv`; QC `analysis/logs/munge_qc.csv`; log `analysis/logs/01_munge.log`.
- Düzeltmeler: (1) Bellenguez'de bir SNP'nin P değeri (5.75e-659) çift duyarlıklı sayı sınırının altında kaldığı için fread sütunu metin okudu; sayıya çevrildi, 0 olan değer `p_underflow_zero` sütununda sayılıyor. (2) PTSD Z dosyasında NCASE/NCONTROL yokken QC'de -Inf yazılıyordu; NA yapıldı ve yalnız ptsd_z yeniden çalıştırıldı. Hiçbir filtre gevşetilmedi.
- QC özeti: EAF içeren dosyalarda etkili alel frekansı referansla r ≥ 0,993 (uykusuzlukta EAF yok; yalnız MAF–referans MAF r = 0,9934, yön kontrolü yerine geçmez — bu satır 2026-11-20'de düzeltildi, bkz. C2); |fark| > 0,2 olan SNP oranı ≤ %0,021; P–Z tutarlılığı r ≥ 0,999; beyan edilen N ile dosyadaki N uyumlu. λGC: Chia 0,99; Bellenguez 1,18; uykusuzluk 1,26; PTSD 1,37 (cc) / 1,47 (Z); MDD 1,66 (noUKBB) / 1,75 (UKB); SCZ 1,70. Yüksek λGC'ler büyük N'li poligenik özelliklerde beklenen düzeyde; enflasyon/poligenite ayrımı LDSC intercept'iyle (Faz 3) yapılacak.
- `analysis/analysis_plan.md` taslağı yazıldı; henüz dondurulmadı (kullanıcı onayı bekleniyor).

## Faz 2 — Ön kayıtlı analiz planı (2026-11-20)
- Kullanıcı planı dört ekleme koşuluyla onayladı ve eklemeler yapılınca yeniden onay beklemeden dondurulup Faz 3'e geçilmesini istedi:
  1. FinnGen R13 klinik AD (`G6_ALZHEIMER`, 16.652 / 483.534; proxy yok, UKB yok) ön kayıtlı duyarlılık analizi (§4b); anlamlılık ilanında kullanılmaz. Örtüşme: MDD noUKBB'de FinnGen R5 (23.424 / 192.220), PTSD'de FING (9.801 / 249.993) → MRlap. Doğrulama raporu `data/finngen_verification.md`; manifest §1.6b.
  2. Her MR analizinde Cochran Q ve I²GX; I²GX < 0,9 ise yorumlama kuralındaki Egger kesişimi SIMEX düzeltmeli (simex 1.8 kuruldu).
  3. Altı prevalansın her biri için Faz 4'te birincil kaynak; bulunamazsa kaynaklı değerle değiştirilip deviations.md'ye yazılır.
  4. LAVA UKB referansının kaynağı manifeste yazıldı (yazarların GitHub REFERENCE.md'si, VU SURF bağlantıları, VERSION_INFO; hakemli yayını yok; lisans/koşul belirtilmemiş; formsuz indirme). "Kamuya açık ve koşulsuz" ölçütünü karşıladığı için ana LAVA referansı olarak kaldı.
- Plan donduruldu: 2026-11-20T07:44:52+03:00, SHA-256 `fb6e1bb83e801a8eaf5f45dcfd88fa359216f6d114cfe01c847271d97999b530` (`analysis/analysis_plan.sha256`); dosya salt okunur yapıldı. `analysis/deviations.md` oluşturuldu (sapma yok).
- **Kapı 2: GEÇTİ** (plan + hash var; analysis/R/ yalnız 01_munge.R içeriyordu, sonuç üretilmemişti).
- FinnGen indirmesi bekliyor: erişim formu (ad, kurum, e-posta, ülke) araştırmacı tarafından doldurulmalı; kişisel bilgi içerdiği için Claude Code doldurmaz. Kova anonim erişime açık olsa da FinnGen'in belirttiği yol form olduğundan form doldurulmadan indirilmez.

## Faz 3 — Analiz (başladı 2026-11-20)
- `analysis/R/utils.R` (ortak yollar, özellik tanımları, results.json biçimlendirme) ve `02_ldsc.R` yazıldı. GenomicSEM ldsc: HapMap3 ağırlıkları için `sep_weights = TRUE` (varsayılan FALSE ağırlık olarak LD skorlarını kullanırdı).
- `02_ldsc.R` çalıştı (ana 15 çift + §2.4a/b/c duyarlılıkları; FinnGen girdisi olmadığı için FinnGen koşuları atlandı). Çıktılar: `results/tables/ldsc_h2.csv`, `ldsc_rg.csv`, `results/rds/ldsc_*.rds`, results.json `ldsc_h2` / `ldsc_rg`.
- Düzeltme C1 (deviations.md): SCZ dosyasındaki `NEFF` yarım etkin N çıktı (kohort sayılarından doğrulandı); 01_munge'de 2× yapıldı, scz yeniden harmonize edildi, 02_ldsc yeniden çalıştırıldı. rg değişmedi; SCZ h² düzeldi (liability 0,178).
- DLB h² Z = 1,5 (< 4): §2.5 gereği DLB çiftlerinin rg'si düşük güçlü olarak işaretlendi.
- D1 (deviations.md): LAVA'da ikili özellikler etkin N + 0,5 vaka oranıyla girilir (§3.3'ün uygulama açıklaması; LAVA sonucu görülmeden yazıldı).
- `03_lava.R` yazıldı; LAVA referansları açılıyor.

### FinnGen (2026-11-20)
- Kullanıcı erişim formunu doldurdu. Manifest kullanıcı kopyası ile resmî adresten indirilen kopya birebir aynı (SHA-256 c9caafa9…). Uç nokta seçimi (G6_ALZHEIMER) indirmeden önce deviations.md D2'ye yazıldı. .gz ve .gz.tbi MD5'leri sunucuyla eşleşti. E-postadaki `release/` yolu R13 için 404; manifestteki yol kullanıldı.
- Harmonizasyon: 21.327.043 → eşleme 9.282.616 → son 7.672.240; rsID'siz 893.606; λGC 1,16; referans alel frekansı r = 0,962.
- LDSC (yalnız tutarlılık; §4b.5): PTSD rg 0,11 (p 0,014; 4 test içinde BH ve Bonferroni 0,056); MDD, uykusuzluk, SCZ kanıt yok. Bellenguez × PTSD −0,05 ile tutarsız. Kullanıcı düzeltmesi: bu bulgu proxy fenotip argümanıyla TUTARLI DEĞİL (argüman proxy'li GWAS'ta daha yüksek korelasyon öngörür; gözlenen tersi). outline.md N1'e yalnız "iki AD GWAS'ı arasında tutarsızlık" olarak, (a) şans, (b) Fin LD yapısı – 1000G EUR uyumsuzluğu, (c) fenotip tanımı, (d) fing örtüşmesi açıklamalarıyla yazıldı; hiçbiri kanıtlanmış gibi sunulmayacak.
- Anahtar kelimeler: "genetic correlation" çıkarıldı (başlıkta var), "FinnGen" eklendi; toplam 8 (Frontiers sınırı).
- Kurki 2023 kaydedildi (`kurki2023finngen`); Acknowledgments cümlesi manifestte; e-postadaki hazır paragraf kullanılmayacak.

### Araç değişikliği (§7 izin verir; hiçbir kontrol gevşetilmedi)
- `tools/sources.py search` komutuna isteğe bağlı `--sort` argümanı eklendi (ör. "CITED desc"). Gerekçe: Europe PMC'nin imleçli varsayılan sıralaması yayın tarihi ağırlıklı olduğundan ilk tur aramalar çoğunlukla kapsam dışı 2026 kayıtları getirdi. Denetim mantığına dokunulmadı.
- `analysis/R/utils.R`: P değerleri iki anlamlı basamakla (0,014; 0,056), yuvarlanınca 1 olanlar "1.00", "-0.000" → "0.000".

## Faz 4 — Literatür edinimi (başladı 2026-11-20)
- Veri ve yöntem makaleleri `add-doi` ile eklendi (24 kayıt). Hata: MRlap için girilen DOI (10.1002/gepi.22506) başka bir makaleye aitti; kayıt gerekçesiyle DROP edildi, doğru makale (Mounier & Kutalik 2023, 10.1002/gepi.22522) eklendi. Konsorsiyum yazarlı iki kaydın anahtarı okunur yapıldı: adams2025trans, auton2015global.
- Aramalar: tur 1 (`sources/search_queries.sh`, 18 sorgu), tur 2 (`search_queries_round2.sh`, atıf sıralı 22 sorgu), tur 3 (`search_queries_round3.sh`, başlık alanıyla sınırlı 11 sorgu: önceki MR/rg çalışmaları ve prevalans kaynakları).
- Başlık+özet taraması: tur 1–3'te toplam 117 DROP, her biri gerekçesiyle `sources/deleted.log`'da (`screen_round1.sh`, `screen_round2.sh`, tur 3 komutları).
- Aday havuzu 74 (hedef 70–100). Önceki en yakın çalışmalar (tam okumayla Faz 5'te konumlandırılacak; aynı soru + aynı veri durumu için §5 durdurma koşulu denetlenecek): Lutz 2020 (MDD–AD; PTSD–AD), Gibson 2017, Monereo-Sánchez 2021, Huang 2020, Hu 2024 (MDD–demans iki yönlü MR), Guerreiro 2016 (DLB rg), Chen 2026 (SCZ–ADRD), Ohi 2024 (SCZ–AD derleme), Gerring 2022 (psikiyatrik lokal rg).
- Tam metin indirme (`fetch`) başlatıldı.
- Fetch sonucu: 50 DOWNLOADED, 24 NO_ACCESS. **Kapı 4: GEÇTİ** (CANDIDATE kalmadı). `build/NEEDS_PDF.md` yazıldı. STROBE-MR için açık erişimli BMJ açıklama makalesi (skrivankova2021strengthening2) eklendi.
- Önceki çalışmalar ve §5 durdurma koşulu: Chen 2026 (SCZ × ADRD; local rg + iki yönlü MR; PGC3 + Bellenguez I+II, özetten) ve Kumar 2026 (Bellenguez × PGC3 LAVA, tam metin) aynı verilerle SCZ × AD çiftine bakmış. Bütün soru (4 özellik × AD/DLB, MR, APOE, FinnGen) yanıtlanmamış olduğundan durdurma uygulanmadı; kullanıcı kararıyla SCZ × AD "replication" değil "overlapping summary statistics kullanan önceki çalışmalarla uyumlu/uyumsuz" olarak sunulacak (outline.md N4).

## Faz 3 — LAVA (UK Biobank referansı) tamamlandı (2026-11-20 11:16)
- 2.495 lokus; 22 MHC ile örtüşen hariç; 2.431 işlendi, 42 işlenemedi (26'sı referansta SNP yok). Birincil çiftlerde tek değişkenli eşiği geçen 23 iki değişkenli test (AD×SCZ 9, AD×MDD 8, AD×PTSD 3, DLB×MDD 2, DLB×SCZ 1); FDR %5'te ve Bonferroni'de anlamlı lokus yok. İkincil çiftlerde 183 testin 84'ü FDR-anlamlı.
- §5 kolokalizasyon yalnız FDR-anlamlı lokuslara uygulanır; uygun lokus olmadığı için coloc çalıştırılmadı (sonuç olarak raporlanacak).
- 1000G LAVA duyarlılığı MR sonrası çalıştırılacak (çekirdek).

## Faz 3 — MR
- `04_mr.R` 46 yön (16 birincil, 8 birincil-APOE'siz, 4+2 MDD-UKB, 8+8 FinnGen) 10 çekirdekte başlatıldı (2026-11-20). Sabit tohum her yönde; süre/enstrüman/F/I²GX `analysis/logs/mr_runlog.csv`. SIMEX-Egger hatası (simex'in update() ile ağırlığı bulamaması) formül ortamı + gömülü formülle düzeltildi; SCZ→AD testinde SIMEX kesişimi −0,0063 (p 0,28), I²GX 0,614.

## Faz 5 — Derin okuma
- 6 paralel okuma ajanı (READING_BRIEF.md) 51 notu yazdı; `sources/check_notes.py` (audit_manuscript ile aynı normalizasyon) tüm alıntıları kaynak metne karşı denetliyor; kullanıcı isteğiyle bölüm kapsamı denetimi eklendi (kaynakta bulunan her ana bölüm için okuma günlüğünde dolu satır).
- Sorun: 10 kaydın tam metni preprint/taslaktı (Unpaywall). `tools/sources.py` düzeltildi (§7 izin verir; kontrol gevşemedi): Europe PMC başarısızsa NCBI E-utilities PMC yedeği; Unpaywall `submittedVersion` konumları atlanır (§1.3-4). `sources/refetch_published.py` ile 8 kayıt yayımlanmış PMC sürümünden yeniden indirildi ve notları yeniden yazıldı (tümü denetimden geçti). werme2022integrated (LAVA) ve mounier2023bias (MRlap) yayımlanmış sürümü açık değil → NEEDS_PDF "REQUIRED"; preprint §1.3-4 gereği kullanılmıyor.
- Kaynak bütçesi outline.md'ye KEEP kararından önce yazıldı (zorunlu veri 8 + yöntem 16; prevalans ≤3; Giriş/Tartışma ≈12).
- DROP (gerekçeli): shi2017local, jansen2019genome (Wu 2024 yeterli), scheltens2021alzheimer, bromet2011cross, saha2005systematic.
- D3 (deviations.md): prevalanslar kullanıcının ölçütleriyle (vaka tanımı uyumu, az ve otoriter kaynak, 0,5×/2× duyarlılık): MDD 0,15 (Adams), SCZ 0,01 (Trubetskoy), DLB 0,005→0,001 (Chia), PTSD 0,07→0,05 (Koenen, yüksek gelirli ülkeler yaşam boyu); AD 0,05 ve uykusuzluk 0,10 geçici (Niu 2017, Ohayon 2002 / Watanabe tam metni gerekli). MR tam çalıştırılmadan önce değiştirildi; LDSC liability h² yeniden hesaplanıyor.
- outline.md N1'e (e) eklendi (Wu 2024 proxy ve hayatta kalma yanlılıkları; her iki AD GWAS'ını farklı mekanizmalarla etkileyebilir; olası, eşit statü); "proxy argümanını desteklemiyor" cümlesi geri çekildi.

- 04_mr.R: uykusuzluk içeren 10 yön kod hatasıyla düştü (EAF sütunu tamamen NA → logical; fcoalesce tür hatası). `as.numeric` ile düzeltildi. Prevalans doğrulaması çıktı dosyalarıyla: dlb__ptsd 0,001/0,05; ptsd__dlb 0,05/0,001; ptsd__ad 0,05/0,05.
- C2 (deviations.md): uykusuzluk dosyasında EAF yok → palindromik SNP'lerin iplik yönü doğrulanamaz. Munge yalnız MAF > 0,42 palindromikleri çıkarmıştı; 1.052.956 palindromik kalmıştı (GWS 440'ın 39'u; HM3 LDSC setinde 4). MR'da referans frekansı TwoSampleMR'a geçtiği için action 2 ters dönmeyi göremezdi. Düzeltme: EAF yoksa tüm palindromikler çıkarılır (`palindromic_rule`); uykusuzluk içeren MR yönlerinde action 3 (`harmonise_action`); munge_qc.csv'ye `af_check` sütunu. Uykusuzluk yeniden harmonize edilir; LDSC, LAVA (UKB + 1000G) ve 10 MR yönü yeniden çalıştırılır. Eski tablolar results/superseded/pre_C2_insomnia_palindromic/ altında.
- Ek bulgu (karar bekliyor): EAF içeren dosyalarda da palindromik SNP'ler frekansla doğrulanmadan hizalanmıştı. Frekansı referansın tersini gösteren palindromikler (|EAF−REF| > 0,2 ve 1−REF'e daha yakın): Bellenguez 1.342, Chia 677, FinnGen 1.929, PTSD cc 2, SCZ 8, MDD 0. LDSC'de etkisi yok denecek kadar az (HM3 palindromikleri zaten dışlıyor); MR'da action 2 iki dosyada da EAF varken göreli yönü düzeltir; LAVA'ya etkisi var.
- Karar (kullanıcı, 2026-11-20): EAF içeren dosyalara "tüm palindromikleri çıkar" kuralı uygulanmaz; katı kural yalnız uykusuzluk (EAF yok) istisnası.
- Doğrulama: munge — palindromik ve dosya MAF > 0,42 olanlar çıkarılır, diğerleri alel etiketiyle (aynı iplik varsayımıyla) hizalanır; frekansla yön çıkarımı munge'da yapılmaz. MR — harmonise_data action 2, tolerans 0,08 (TwoSampleMR varsayılanı): EAF'ı 0,42–0,58 arasındaki palindromikler çıkarılır, diğerlerinin yönü maruziyet ve sonuç EAF'larıyla belirlenir. FinnGen: a1 = alt, eaf = af_alt; palindromik olmayan SNP'lerde referansla r = 0,9666 (yön doğru). Frekansı referansla 0,5'in karşı tarafında olan palindromikler (her ikisi |f−0,5| > 0,08): Bellenguez 1.362, Chia 687, FinnGen 1.920 — LDSC'de etkisiz (HM3), MR'da action 2 ile göreli olarak düzeltilir, LAVA girdilerinde kalır.
- LAVA verimlilik: `03_lava.R ukb update insomnia` modu eklendi (yalnız uykusuzluk içeren univ/bivar yeniden hesaplanır, diğerleri pre_C2 sonuçtan korunur; `input_version` sütunu). Not: LAVA lokus SNP setini tüm fenotiplerin kesişiminden kurar (harmonize.snps); korunan uykusuzluk-dışı çiftler eski kesişimle (uykusuzluk palindromikleri dahil) hesaplanmıştır; her özelliğin kendi hizalaması değişmediği için geçerlidir. 1000G LAVA ilk kez, tam çalıştırılır.
- pkill kendi komutunu da öldürdü; LDSC yarıda kaldı ve zincir (chain2) LDSC'den yeniden başlatıldı. Uykusuzluk munge: 7.486.614 → 6.433.658 SNP; GWS 440 → 401.
- C3 (karar, 2026-11-20): olası iplik uyumsuzluğu olan palindromikler (MAF ≤ 0,42, dosya EAF'ı 0,5'e göre referansın karşı tarafında) 1000G LAVA girdilerinden çıkarılır (data/lava_sumstats_strandqc/); ana UKB LAVA yeniden çalışmaz, FDR %5 anlamlı her lokus-çifti `03_lava.R ukb strandcheck` ile yeniden hesaplanır (results.json lava_strand_check). Yöntem cümleleri outline.md'de.
- Süreç yönetimi: PID'ler analysis/logs/pids.txt'de; durdurma yalnız kill <PID>. chain3.sh chain2'nin PID'ini (242061) bekler, sonra strandcheck çalıştırır.
- MR: uykusuzluk 10 yönü yeniden çalıştı (action 3); 46/46 yön ok.
- C2 sonrası uykusuzluk LDSC: değişim yok denecek kadar küçük (yalnız 4 HM3 SNP çıktı): AD×insomnia rg −0,021 (önce/sonra aynı, 6 basamak), DLB×insomnia 0,015, h² 0,0437 (Z 18,23 → 18,24).
- Coloc (plan §5.1): plan uygulandı — coloc koşulu oluşmadı: ana ailede (demans × psikiyatrik) FDR %5'te anlamlı LAVA lokus-çifti yok. `06_coloc.R` koşulu denetler; çift yoksa coloc çalıştırmaz ve results.json "coloc" altına durum yazar; uykusuzluk güncellemesi ana ailede anlamlı çift üretirse plandaki gibi coloc.abf çalışır (p12 1e-5 ve 5e-6). Yöntem/Bulgular'da bir cümle.
- Null bulguların gücü: `06b_power_summary.R` (tanımlayıcı, yeni test yok): LDSC her ana çift için rg %95 GA sınırları (results.json power_ldsc); LAVA her ana çift için analiz edilen/test edilebilir/nominal p<0,05 lokus ve beklenen sayı (power_lava_ukb, power_lava_g1000); MR en küçük saptanabilir OR 04_mr.R'da (§4.10) hesaplanıyor, 05_mr_sensitivity.R results.json'a yazıyor. Ön izleme (UKB, uykusuzluk güncellemesi öncesi): DLB tek değişkenli eleği yalnız 8 lokusta geçiyor; DLB çiftlerinde test edilebilir lokus 0–2 → "few loci were testable".
- STRICT_RULES §1.6 "Görselleştirme" eklendi (kullanıcı metni aynen; iki kopya da güncel, eski sürüm build/STRICT_RULES_before_1.6.md). Faz 3-3'teki "en çok 4 şekil" ifadesi §1.6-6 ile uyumlu olacak biçimde "5 şekil + 3 tablo (§1.6-6)" yapıldı. `07_power_summary.R` → `06b_power_summary.R` (07_figures.R adı kurallarda ayrılmış).
- Figure plan outline.md'de. Taslaktan gerekçeli farklar: Figure 5 yok (bilgi Fig 2 GA'larında ve Fig 4 satırlarında); LDSC tablosu Supplementary'ye (Fig 2 ile ikilenmesin, §1.6-1); MR tablosu IVW OR'suz tanı tablosu olarak ana Table 2.

### Şekil listesi (§1.6)
| Şekil | Durum | Dosya | Önizleme |
|---|---|---|---|
| Figure 1 — Çalışma tasarımı | üretildi 2026-11-20 | results/figures/Figure1_design.png | build/figures_preview/Figure1_design.png |
| Figure 2 — Genom geneli rg | üretildi 2026-11-20 (LDSC C2 sonrası son hâli) | results/figures/Figure2_ldsc_rg.png | build/figures_preview/Figure2_ldsc_rg.png |
| Figure 3 — Lokal rg | üretildi 2026-11-21 18:07 (tohumlu LAVA; 23 test edilebilir lokus, 8 nominal, FDR yok) | results/figures/Figure3_lava_local_rg.png | build/figures_preview/Figure3_lava_local_rg.png |
| Figure 4 — MR | üretildi 2026-11-21 (05 MRlap düzeltmesi sonrası son hâli; A psikiyatrik→demans, B demans→psikiyatrik, C FinnGen) | results/figures/Figure4_mr.png | build/figures_preview/Figure4_mr.png |
| Supplementary (scatter/funnel/LOO, Steiger, örtüşme, harmonizasyon akışı, LAVA UKB–1000G, iplikçik) | bekliyor | — | — |
Not: Fig 2'deki * = FDR < 0,05 (FinnGen panelinde dört test içi BH); açıklamaya yazılacak. Açıklamaların ilk cümlesi (bulgu cümlesi) Faz 6'da {{res:}} ile yazılır.
- Kararlar (2026-11-20): LDSC null ifadeleri outline'da; LAVA nominal fazlalık yalnız tanımlayıcı ve "exploratory" (fazlalık testi yok); MR'da ikinci (SE tabanlı) en küçük saptanabilir OR (D4), 05_mr_sensitivity.R'a eklendi.
- GENCODE v19 (GRCh37) gen notasyonu indirildi (DATA_MANIFEST, CHECKSUMS); 06b_power_summary.R nominal LAVA lokuslarını genlerle listeler (lava_nominal_primary_ukb.csv, results.json lava_exploratory). Hata düzeltmeleri: data.table içinde `chr` argüman/sütun ad çakışması; Bash aracının `\1` → `` dönüştürmesi.
- Ön sonuç (AD çiftleri güncellemeden etkilenmez): AD×MDD 4/8 nominal (2 pozitif, 2 negatif; beklenen 0,40), AD×SCZ 3/9 (3 pozitif; 0,45), AD×PTSD 1/3 (negatif; 0,15); APOE bölgesinde nominal lokus yok (APOE lokusu bu çiftlerde test edilebilir değil). chr17q21.31 (MAPT/KANSL1 inversiyonu, lokus 2207) üç çiftte nominal: AD×MDD ve AD×PTSD negatif, AD×SCZ pozitif.
- Onaylar (2026-11-20): şekil planı (4 şekil + 2 tablo), §1.6, 06b adı, LAVA durum etiketi, D4, Table 2 numarası.
- Keşifsel LAVA lokusları: 06b_power_summary.R (5) UKB–1000G yan yana karşılaştırma (lava_reference_check; 1000G bitince). İfade kuralları outline.md'de (gen adı yalnız lokus tanımı; 17q21.31 referansa duyarlıysa biyolojik yorum yok).
- Bellenguez notuna c9–c10 eklendi (Table 1, CELF1/SPI1 bilinen AD lokusu; check_notes OK).
- GENCODE: önerilen birincil kaynak Mudge 2025 NAR (doi 10.1093/nar/gkae1078, PMC11701607) — gencodegenes.org "Reference Publication". add-doi + fetch (PMC-XML) yapıldı: mudge2025gencode; okuma notu Faz 5'te. Bütçe: yöntem kaynakları 17, A+B 25; toplam 40'ı aşarsa aynı iddianın ikincil kaynağı elenecek.
- Faz 5 görevi: "opposing local signals" öncülü için hakemli kaynak; bulunmazsa öncül Giriş'ten çıkar.
- Kaynak bütçesi tasarruf seçenekleri outline.md §E'ye yazıldı (tek prevalans kaynağı uygun değil; olası tasarruf Ohayon, Burgess; isteğe bağlı STROBE-MR, Kunkle). Karar Faz 5 sonunda.
- §E kararları (kullanıcı): Ohayon ve Burgess koşullu DROP (Watanabe / MRlap yayımlanmış metninde birebir alıntıyla); STROBE-MR ve Kunkle KALIR. outline.md §E ve NEEDS_PDF.md'ye işlendi.

### 2026-11-20 17:15 — LAVA UKB insomnia update failed; rerun started (chain4)
- The update (started 14:06) completed the locus analysis but halted in post-processing with an R parse error ("unexpected symbol ... fill tus"). Cause: 03_lava.R was edited (ok_target_dropped fix) while the job was running; Rscript reads the script incrementally, so the remaining lines were read at shifted byte offsets. No results were written; existing LAVA tables (11:16, pre-C2) are unchanged. Failed log kept as analysis/logs/03_lava_ukb_update_insomnia_FAILED_editduringrun.log. chain2 and chain3 ended (strandcheck not run).
- Prevention: (1) jobs now run from a frozen script snapshot (runsnap/<stamp>/); (2) 03_lava.R saves raw locus results (results/rds/lava_<ref>_raw_<mode>.rds) immediately after the parallel step.
- analysis/R/fix_lava_status_C2.R is now obsolete (the rerun uses the fixed code that labels target-dropped loci ok_target_dropped directly); not to be run.
- chain4 (bash PID 546; update PID 552): LAVA ukb update insomnia → LAVA g1000 full → LAVA ukb strandcheck. Expected: update ~20:15, g1000 ~23:15, strandcheck shortly after.

### 2026-11-20 22:40 — chain4 finished; STRAND_CHECK_CHANGE → stopped, reported to user
- LAVA ukb update insomnia: OK (19:59). Status: ok 1789, ok_target_dropped 642, not_processed 42. Insomnia univariate passes 4 (before C2: 4). Insomnia bivariate tests 5 (all secondary), nominal 3, FDR 2 — identical to pre-C2; rho identical to 4 decimals, p differs only in the 3rd significant digit.
- Main LAVA (UKB): primary 23 tests, 8 nominal, 0 FDR → coloc condition not met (plan §5.1). Secondary 183 tests, 84 FDR.
- LAVA g1000 (strand-QC inputs): OK (22:28). Primary 536 tests, 91 nominal, 19 FDR; secondary 1179 tests, 388 FDR. Univariate passes far higher than UKB (e.g. insomnia 217 vs 4, DLB 134 vs 8); share of loci with univariate p<0.05 higher for every trait; median local h2 ~1.4–1.9× higher; median PCs 144–150 vs 159–166. To be interpreted; no conclusion drawn yet.
- Strandcheck (UKB, 84 FDR locus-pairs, all secondary; 63 loci): SNP sets identical at all 84 (no strand-candidate SNP present after locus intersection); rho identical; p-values differ (median relative difference 3.4%). 1 pair flagged: locus 848 chr5 MDD×SCZ, p_main 0.02270 = family BH cutoff (largest significant P), p_check 0.02288 → sig_retained FALSE. Flag caused by p-value variation at the cutoff, not by SNP removal. Chain stopped per instruction; 05/06/06b/figures NOT run pending decision.

### 2026-11-21 02:05 — LAVA seed (C4) and reference-panel presentation
- LAVA randomness confirmed in the v0.1.5 source (bivariate P and CI by Monte Carlo; univariate deterministic). `03_lava.R`: per-pair seed SEED + 1000×LOC + 10×i + j in all modes; new mode `seedcheck`.
- seedcheck (UKB, 23 primary tests + borderline locus 848): all reproducible (two identical runs per pair); rho identical; primary FDR 0 → 0 (lowest seeded FDR 0.090); nominal 8 → 8; locus 848 seeded P 0.022, FDR 0.049 (MC SE 0.0015). No stop condition.
- `utils.R` `res_set`: lock (mkdir) + atomic write added, because several scripts can write results.json at the same time.
- outline: seed Methods sentence, approved strand-check Supplementary line, reference-panel sensitivity section (Supplementary / one Results sentence / Discussion rules, Faz 5 source task). deviations C4 written.
- New script `06c_lava_reference_diagnostic.R` (descriptive; results.json "lava_reference_diagnostic"); runs after 05 finishes (05 uses the pre-lock `res_set`).

### 2026-11-21 03:20 — MR sensitivity, coloc, power summary, reference diagnostic, Figures 3–4
- 05 first run (01:52): MRlap failed in 8 of 16 primary directions (and others): parallel workers used one working directory (analysis/logs) and overwrote each other's <trait>.sumstats.gz files. Fix: one directory per direction (analysis/logs/mrlap/<id>) and set.seed(SEED) per direction. Faulty run archived in results/superseded/mrlap_shared_wd_race/. Rerun (02:35–03:15): MRlap ok in all 28 directions (16 primary, 8 FinnGen, 4 MDD-UKB). Previously-ok MRlap estimates changed by ≤ 0.019 (log scale).
- Primary MR (16 IVW tests, BH): PTSD → AD OR 0.833 (P 0.0028, FDR 0.045), §8 class "evidence sensitive to pleiotropy" (I²GX 0.39 → SIMEX intercept P 0.019); MRlap-corrected OR 0.907 (P 0.22) → mrlap_qualifies TRUE. SCZ → AD nominal (P 0.025, FDR 0.20), MRlap-corrected P 0.096. All other directions: no evidence. Insomnia directions (action 3): IVW P 0.09–0.84, all "no evidence".
- 06 coloc: plan condition not met (23 primary tests, 0 at FDR 5%) → not run (plan §5.1).
- 06b: 17q21.31 (locus 2207) and loci 2206, 2128: same sign with 1000 Genomes, 1000G estimate inside the UKB CI → not reference-sensitive by the agreed rule; loci 942 and 1658 not testable with 1000G (flagged).
- 06c reference diagnostic: sum of local h² exceeds the genome-wide LDSC h² with BOTH references (UKB 2.6–7.8×, DLB 70×; 1000G 3.6–12×, DLB 106×); 1000G sums are 1.34–1.79× the UKB sums over common loci. The absolute check therefore does not isolate 1000G-specific inflation; reported to investigator.
- Figures 3 and 4 produced; figure list updated.

### 2026-11-21 18:10 — Seeded LAVA re-run (chain5 + chain6), MR checks, MRlap unit correction
- Seeded full UKB LAVA (base seed 20261120, per-pair seeds): 2,431 loci processed, 42 not processed. Compared with the unseeded run (03b): primary 23 tests, 0 FDR (unchanged), 8 nominal (unchanged); secondary 183 tests, 84 FDR (unchanged), nominal 99 → 100; 0 sign changes, 0 significance changes, max |Δrho| 0. Unseeded results archived in results/superseded/unseeded_lava/.
- Seeded strand check: 0 changes (locus 848 no longer borderline).
- Seeded 1000G (chain5): 2,016 of 2,473 loci returned NULL from mclapply under memory pressure (12 workers OOM-killed, swap full); the script dropped them silently and the chain continued (06b/06c/07 ran on 457 loci). Outputs archived in results/superseded/g1000_incomplete_chain5/. Fixes in 03_lava.R: the main run now stops (exit 4, WORKER_FAILURE) if any worker returns no result; new `rescue` mode re-analyses only the missing loci from the raw checkpoint (per-pair seeds → identical to an uninterrupted run). First rescue attempt with 6 workers stopped by PID (5.6 GB per worker); chain6 rescue with 4 workers 14:49–18:07: 2,430 processed, 43 not processed (same as the unseeded 1000G run).
- Seeded 1000G: primary 536 tests, 91 nominal, 20 FDR (unseeded 19); secondary 1,179 tests, 388 FDR (unchanged); 0 sign changes, 3 FDR-status changes. Descriptive sensitivity only (C4).
- 06 coloc: not run (0 of 23 primary at FDR 5%). 06b: loci 2207 (17q21.31), 2206, 2128 consistent across references; 942 and 1658 not testable with 1000G. 06c: Supplementary table supp_lava_reference_panel_ratio.csv (1000G/UKB summed local h2 over common loci: AD 1.51, DLB 1.45, MDD 1.34, PTSD 1.45, insomnia 1.79, SCZ 1.42) with the one-sentence note; absolute columns kept only in the internal diagnostic file (investigator decision).
- Figures 1–4 regenerated from the seeded run (Figure 3: 23 testable loci, 8 nominal, none FDR — caption must state it).
- MR race-condition check (investigator item 3): 04b_mr_output_integrity.R — all 46 directions pass (id, labels, n_final, leave-one-out SNPs, clumped file and count, timestamps, MR-PRESSO/SIMEX presence, run log). PLINK prefixes were already unique per direction; 04_mr.R now uses one temporary clump directory per direction (insomnia → DLB re-run identical).
- MRlap unit correction: MRlap standardises effects (Z/sqrt(N)); its estimates are betas, not log odds. The earlier exp() labelled "MRlap-corrected OR" was a unit error; results.json now holds beta_std_mrlap_observed / beta_std_mrlap_corrected / p values and mrlap_scale. §8 qualification (sign and P) unaffected. PTSD → AD: MRlap observed beta −0.063 (P 0.26), corrected −0.098 (−0.255 to 0.059; P 0.22).
- 05b: PTSD → AD Bellenguez vs FinnGen (mr_ptsd_ad_bellenguez_vs_finngen.csv, results.json mr_ptsd_ad_finngen). FinnGen IVW OR 0.918 (0.784–1.075), P 0.29; Egger 1.096, WM 0.915, WMode 0.938; SIMEX intercept P 0.64; MRlap corrected beta +0.098 (P 0.50); class no evidence (descriptive); MDOR 1.62 (plan) vs 1.25 Bellenguez.
- Wu 2024: MDD −0.11 and SCZ −0.13 quotes verified in the full text; no PTSD value (50-trait list only in unavailable Supplementary Tables).

### 2026-11-21 19:00 — Investigator decisions (evening) applied; analysis phase closed pending Gate 3
- Results MR sentence (approved wording with FinnGen) and Discussion PTSD → AD paragraph structure written into outline N5; minimum detectable ORs moved to the Discussion power sentence.
- 03c_lava_integrity.R: both seeded LAVA raw checkpoints complete (UKB 2,473/2,473 worker results, 2,431 processed + 42 not processed; 1000G 2,473/2,473, 2,430 + 43); results.json "lava_integrity".
- 06d_lava_g1000_fdr_pairs.R: 20 primary pairs at FDR 5% with 1000G; 1 testable and nominal with UKB (locus 2128, AD × SCZ); 19 not testable with UKB (univariate filter). Loci 2206 and 2207 are nominal with UKB but not among the 1000G FDR pairs (1000G FDR 0.06–0.17). Supplementary table supp_lava_g1000_fdr_pairs.csv; results.json "lava_g1000_fdr_pairs".
- deviations C5 items 5 (19 → 20, unstable near threshold) and 6 (integrity check) added.
- Results 1000G element (a): plan rationale ("LAVA authors' recommendation that 1000 Genomes can inflate type I error") has no source: werme2022integrated is NO_ACCESS (no full text; its 8 claims cannot be verified by check_notes) and its note contains no such statement. Faz 5 blocker.
- audit_manuscript.py cannot run yet (manuscript section files are written in Faz 6). check_notes.py: wu2024pervasive OK; werme2022integrated and mounier2023bias lack source texts (NO_ACCESS).
- Figure 3 caption requirement recorded in the outline figure plan.

### 2026-11-21 19:20 — Gate 3 started; Werme sources; Faz 6 Methods + Results drafted (stopped for investigator review)
- Gate 3 (19:03): end-to-end re-run in ~/q1paper_gate3 (raw data and reference panels symlinked read-only; all derived files rebuilt); ~/q1paper/results_gate3 -> ~/q1paper_gate3/results; ~/q1paper/results untouched. LAVA_CORES/MR_CORES/MRLAP_CORES = 4 (03_lava.R now reads LAVA_CORES); 03_lava.R stops on any empty worker result; 03c and 04b integrity checks in the chain. Comparison script after completion.
- Werme 2022: VU Pure file behind a Cloudflare bot check (not bypassed); bioRxiv v2 ingested (investigator-authorised preprint exception); all 8 note quotes verified + c9 (simulation-based p-values); registry KEEP; deviations C6.
- Plan rationale for the UK Biobank LAVA reference: not in Werme 2022; verbatim in the official LAVA README (werme2025lava, commit e729a245f7b6, new note + registry record). The README cites a non-peer-reviewed preprint (preprints.org 202507.0966; reply 202508.1096). Nature Genetics 2025 "enhanced framework" is Li, Pawitan, Shen (HDL-L), not open access, not used.
- tools: build_docx res_lookup resolves results.json keys containing dots (previously every dotted key such as ldsc_rg."main.ad.ptsd" was unresolvable); audit_manuscript now errors on any {{res:}} placeholder that does not resolve to a leaf (stricter, not looser). Backups in build/.
- Registry: KEEP applied to the 24 cited sources whose notes record KEEP (sources.py keep).
- New: manuscript/terms.md; analysis/R/07b_tables.R (table1_data_sources.csv with corrected shared-cohort column, table2_mr_diagnostics.csv); manuscript/03_methods.md, 04_results.md; placeholder files for the other sections.
- Audit (Methods + Results): 9 section errors, all missing sources — watanabe2022genome (insomnia GWAS, NO_ACCESS), mounier2023bias (MRlap, NO_ACCESS; bioRxiv preprint open), benjamini1995controlling (not in pool), niu2017prevalence (AD prevalence, NO_ACCESS). Global errors (reference count, undecided registry records, Crossref verification, word count) belong to Faz 5 closure / full manuscript.
- Readable draft: d:\tugbadoc\frontiers_dementia\draft_methods_results_2026-11-21.md (+ draft_figures_2026-11-21\).
- Pending after Gate 3: compare Gate 3 vs results; fix 07_figures.R data_sources overlap column (PTSD: UK Biobank and FinnGen; MDD noUKBB: FinnGen R5), deferred so the Gate 3 comparison stays clean.

### 2026-11-21 20:35 — Investigator corrections applied; Discussion drafted (stopped for review)
- Sources: Niu 2017 ingested (published English edition, open access HTML from elsevier.es; Navarra repository unreachable), note + KEEP. Mounier 2023: UNIL Serval (F5 TSPD bot check) and Wiley (403 bot check) not accessible to automated download; needs the investigator's browser download, like Watanabe 2022. BH 1995 pending (investigator).
- verify_refs: retries for transient network errors (failure = error, not skipped); GitHub software-documentation verification (commit exists; URL, commit, access date in meta); Crossref subtitle and whitespace handling in the title comparison; group authors moved after personal authors (Bulik-Sullivan 2015a/b first author fixed). All KEEP verified except: livingston2020dementia flagged RETRACTED by Crossref — the linked notice is "RETRACTED: Addressing hearing loss at all ages" (Lancet Public Health), whose update-to list includes the Livingston DOI; PubMed/Europe PMC show no retraction (only a 2023 erratum, content not readable here) → investigator decision; Europe PMC retraction check intermittently times out (kumar, watkins: rerun before final build).
- Corrections in kurki2023finngen, verbanck2018detection, hemani2017orienting checked: no effect on claims used.
- Tools: build_docx label guard (missing author/year → error) and software reference format; audit checks citation metadata and figure/table numbering; draft renderer uses build_docx labels and prints a reference list.
- Table 2 P formatting (>0.99; <1 × 10⁻⁴). Supplementary numbering: S1 deviations, S2 harmonization counts, S3 LAVA case/control input, S4 LDSC sensitivity, S5 nominal LAVA loci, S6 1000G pairs, S7 reference ratio, S8 strand check, S9 Steiger prevalence, S10 APOE-excluded MR; Supplementary File S1 STROBE-MR.
- 05c_steiger_prevalence.R (DLB directions): reproduced 04_mr exactly at k = 1; halving/doubling prevalences changed nothing.
- Methods/Results fixes per investigator; Discussion written (manuscript/05_discussion.md), audit 0 section errors in Discussion. Methods/Results remaining: watanabe, mounier, benjamini (missing sources) and [GATE3_RESULT].
- Reference count: 39 unique cited (incl. the 3 missing) → the Introduction can add at most one new source unless Discussion sources are dropped.
- Draft: d:\tugbadoc\frontiers_dementia\draft_methods_results_discussion_2026-11-21.md (previous Methods/Results draft removed).

### 2026-11-21 night — Introduction and Abstract drafted (stopped for review)
- Livingston 2024 (UCL accepted manuscript) ingested, note c1–c10, KEEP; replaces Livingston 2020 in the Discussion. Europe PMC record (PMID 39096926) shows no retraction, only a "Comment in".
- Reference trimming per investigator: kunkle2019, chen2026genetic, guo2026sleep, lutz2020shared, livingston2020 dropped; all other uncited candidates dropped; KEEP = cited (36) + 3 pending = 39.
- Introduction (02_introduction.md, 5 paragraphs, ~850 words, every sentence cited) and Abstract (01_abstract.md, ~290 words, numbers from results.json, background sentences linked to anchored cited sentences) written. Audit: 0 errors in both sections; remaining errors are the 3 missing sources (+ livingston2024 metadata until verify_refs rerun completes).
- Queued (investigator, after sources complete): AI statement (fixed wording) in Statements; sentence-by-sentence style pass with pre/post git tags, build/style_pass_diff.md and an independent 30-pair check (seed 20261123).
- Draft: d:\tugbadoc\frontiers_dementia\draft_full_abstract_to_discussion_2026-11-21.md.

### 2026-11-22 — sources complete, draft corrections, statements (before style pass)
- Mounier, Watanabe, BH ingested (copies via sources/inbox; originals in the root folder untouched), notes OK, KEEP, verify_refs 38/38.
- Draft fixes: FinnGen wording; zero-count wording via text keys; NPS paragraph in Discussion (4 sentences); "reproduced exactly" bound to GATE3_RESULT (depends marker; audit now flags GATE3_RESULT until filled).
- Statements (07_statements.md) per Frontiers template order; title page updated (correspondence e-mail, ORCID).
- Audit: 2 errors, both GATE3_RESULT.

### 2026-11-22 — style pass (pre-style-pass → post-style-pass)
- Abstract → Discussion and captions rewritten sentence by sentence; audit after each section (only GATE3_RESULT remains).
- build/style_pass_diff.md (old/new pairs, 174 changed pairs); independent check of 30 random pairs (seed 20261123): 28 PASS, 2 FAIL, both fixed (build/style_pass_check.md); one pre-existing citation mismatch (id 44) fixed.

## 2026-11-22 morning — advisor items 1–6 (Gate 3 still running)
- Data availability: repository URL + "A versioned archive with a DOI will be created on acceptance."
- Insomnia 0.30 Steiger check (05d, deviation C10): identical instrument sets and IVW in 4/4 insomnia directions; Methods/Results sentences added. text_keys.py fixed (truncated sections appended after the "text" block).
- Acknowledgments tool line from session logs: Claude Code 2.1.327–2.1.328, Claude Opus 5.5; Claude Haiku 5.5 for one web-page retrieval subagent.
- Conclusion written (119 words).
- STROBE-MR gaps closed: three IV assumptions (Methods; skrivankova c9), instrument table S11 and leave-one-out S12 (07c_instrument_table.R, stored values only).
- tools/build_supplement.py: Supplementary_Tables.xlsx (S1–S12), Supplementary_File_S1_STROBE-MR.docx, TIFF figures; build/submission/submission_checklist.md. Package copied to d:\tugbadoc\frontiers_dementia\submission\.
- Pending after Gate 3: compare, fill GATE3_RESULT; 07_figures.R overlap notes and FinnGen/"plan §8" figure labels.

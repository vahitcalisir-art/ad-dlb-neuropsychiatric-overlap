#!/usr/bin/env bash
# Faz 1: kullanım koşulu kabulü gerektiren (PGC, CNCR) ve büyük referans dosyaları.
# Koşullar 2026-11-19'da araştırmacı (yazar) tarafından kabul edildi (bkz. DATA_MANIFEST.md).
# Her dosya yayıncının bildirdiği MD5 ile doğrulanır; SHA-256 raw/CHECKSUMS.tsv'ye yazılır.
set -uo pipefail
cd "$(dirname "$0")"
log=raw/CHECKSUMS.tsv
[ -f "$log" ] || printf "file\tbytes\tsha256\turl\tdownloaded\n" > "$log"
fail=0

get() {  # get <dest> <url> <md5 or ->
  local dest=$1 url=$2 md5=$3
  mkdir -p "$(dirname "$dest")"
  if [ -s "$dest" ] && grep -q "^$dest	" "$log"; then echo "zaten var: $dest"; return 0; fi
  echo "indiriliyor: $dest"
  if ! curl -fL --retry 5 --retry-delay 10 -C - -o "$dest" "$url"; then echo "HATA indirme: $url" >&2; fail=1; return 1; fi
  if [ "$md5" != "-" ] && [ "$(md5sum "$dest" | cut -d' ' -f1)" != "$md5" ]; then
    echo "HATA MD5 uyuşmuyor: $dest" >&2; mv "$dest" "$dest.bad"; fail=1; return 1
  fi
  printf "%s\t%s\t%s\t%s\t%s\n" "$dest" "$(stat -c %s "$dest")" "$(sha256sum "$dest" | cut -d' ' -f1)" \
    "$url" "$(date -Iseconds)" >> "$log"
}
FS=https://ndownloader.figshare.com/files

# MDD (PGC MDD2025, figshare 27061255 v5)
get raw/mdd2025/README.pgc-mdd2025.txt                                $FS/52419692 d743266ab7da04276517d3d4e033052a
get raw/mdd2025/pgc-mdd2025_no23andMe_eur_v3-49-24-11.tsv.gz          $FS/51487019 2b02d6123ecd7fdb12f82314c19c4952
get raw/mdd2025/pgc-mdd2025_no23andMe-noUKBB_eur_v3-49-24-11.tsv.gz   $FS/51487022 29d3ce57cfce19ca28eb1643d9e2e428
get raw/mdd2025/pgc-mdd2025_no23andMe_eur_v3.49.24.11.txt             $FS/51486995 98e54d952a2806b62a4d6f36c3d19155
get raw/mdd2025/pgc-mdd2025_no23andMe-noUKBB_eur_v3.49.24.11.txt      $FS/51486998 3367c2fd90cba302b1e59f06e1448927

# PTSD (PGC-PTSD Freeze 3, figshare 26349322 v3)
get raw/ptsd2024/ptsd2024_sumstats_readme.pdf                         $FS/52065149 7e666935eef19a5e7d1c71312311e791
get raw/ptsd2024/eur_ptsd_pcs_v4_aug3_2021.vcf.gz                     $FS/47850151 033685ac31474f59e5a6ec297eca6b49
get raw/ptsd2024/eur_ptsdcasecontrol_pcs_v4_aug3_2021.vcf.gz          $FS/52065146 bf0fb5b16bf91e640af14784e9d3a829

# SCZ (PGC3, figshare 19426775 v7)
get raw/scz2022/PGC3_SCZ_sumstats_release_v3.2_README.pdf             $FS/34865091 eb473dc838d2b74015e51723d28107fd
get raw/scz2022/PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv.gz $FS/34517828 6ebe2376f5cda972d37efa0f214c4df0
get raw/scz2022/scz2022-Extended-Data-Table1.xlsx                     $FS/35775617 8fee2faee10ddf2c9f8a16a54f2c5b84

# Insomnia (Zenodo 24366723, CC BY-NC-SA 4.0)
Z=https://zenodo.org/api/records/24366723/files
get raw/insomnia/insomnia_20190311_README.txt        $Z/insomnia_20190311_README.txt/content        95e55c21c485e6e75a0ac4651264983c
get raw/insomnia/README_atlas_ukb2_sumstats.txt      $Z/README_atlas_ukb2_sumstats.txt/content      0af951356980c6e04402e1902e6cc563
get raw/insomnia/insomnia_ukb2b_EUR_sumstats_20190311_with_chrX_mac_100.txt.gz \
    $Z/insomnia_ukb2b_EUR_sumstats_20190311_with_chrX_mac_100.txt.gz/content 6de6864d4ec36b1c9470a100c4ad8bfe

# LDSC 1000G Phase 3 EUR (Zenodo 7768714, CC BY 4.0)
L=https://zenodo.org/api/records/7768714/files
get raw/ldsc_ref/1000G_Phase3_weights_hm3_no_MHC.tgz $L/1000G_Phase3_weights_hm3_no_MHC.tgz/content a98ac0f089ee285177544a3e6e721ca3
get raw/ldsc_ref/1000G_Phase3_ldscores.tgz           $L/1000G_Phase3_ldscores.tgz/content           e4352ccf778f296835d73985350a863b
get raw/ldsc_ref/1000G_Phase3_frq.tgz                $L/1000G_Phase3_frq.tgz/content                ac29686ffd5b6378789857a522ebca77
get raw/ldsc_ref/1000G_Phase3_plinkfiles.tgz         $L/1000G_Phase3_plinkfiles.tgz/content         a7773ab485827b533cb300c76356d76b

# LAVA UK Biobank LD reference v1.1 (ana LAVA referansı; kullanıcı kararı 2026-11-19)
S=https://vu.data.surfsara.nl/index.php/s
for pair in chr1-2:7NBVIvtPRdu7Qhz chr3-4:fy6ITboMojHrQXr chr5-6:mRz31q0lq7KMcuI chr7-9:89RXxPN2BlOqxLs \
            chr10-12:3dU1L2Hap43xuCs chr13-16:DQqJ2Sqr49RP4xe chr17-23:U8eg5XfTr8qPzPp; do
  get "raw/lava_ref/ukb_ref_${pair%%:*}.zip" "$S/${pair##*:}/download" -
done

[ $fail -eq 0 ] && echo BİTTİ || echo "BİTTİ (HATALI DOSYA VAR)"

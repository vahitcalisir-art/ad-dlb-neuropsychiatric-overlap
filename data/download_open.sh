#!/usr/bin/env bash
# Faz 1: koşulsuz açık (CC0 / EBI terms / LAVA açık indirme) dosyaların indirilmesi.
# Her dosya için boyut ve SHA-256 data/raw/CHECKSUMS.tsv'ye yazılır.
set -uo pipefail
cd "$(dirname "$0")"
mkdir -p raw/bellenguez2022 raw/chia2021 raw/lava_ref raw/clump_ref
log=raw/CHECKSUMS.tsv
[ -f "$log" ] || printf "file\tbytes\tsha256\turl\tdownloaded\n" > "$log"

get() {  # get <dest> <url>
  local dest=$1 url=$2
  if [ -s "$dest" ] && grep -q "^$dest	" "$log"; then echo "zaten var: $dest"; return 0; fi
  echo "indiriliyor: $url"
  if curl -fL --retry 5 --retry-delay 10 -C - -o "$dest" "$url"; then
    printf "%s\t%s\t%s\t%s\t%s\n" "$dest" "$(stat -c %s "$dest")" "$(sha256sum "$dest" | cut -d' ' -f1)" \
      "$url" "$(date -Iseconds)" >> "$log"
  else
    echo "HATA: $url" >&2
  fi
}

EBI=https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics
B=$EBI/GCST90027001-GCST90028000/GCST90027158
get raw/bellenguez2022/README.txt                                   $B/README.txt
get raw/bellenguez2022/md5sum.txt                                   $B/md5sum.txt
get raw/bellenguez2022/GCST90027158_buildGRCh38.tsv.gz-meta.yaml    $B/GCST90027158_buildGRCh38.tsv.gz-meta.yaml
get raw/bellenguez2022/35379992-GCST90027158-MONDO_0004975.h.tsv.gz $B/harmonised/35379992-GCST90027158-MONDO_0004975.h.tsv.gz
get raw/bellenguez2022/harmonised_md5sum.txt                        $B/harmonised/md5sum.txt

C=$EBI/GCST90001001-GCST90002000/GCST90001390
get raw/chia2021/README.txt                                         $C/README.txt
get raw/chia2021/GCST90001390_buildGRCh38.tsv.gz-meta.yaml          $C/GCST90001390_buildGRCh38.tsv.gz-meta.yaml
get raw/chia2021/33589841-GCST90001390-EFO_0006792.h.tsv.gz         $C/harmonised/33589841-GCST90001390-EFO_0006792.h.tsv.gz
get raw/chia2021/harmonised_md5sum.txt                              $C/harmonised/md5sum.txt

get raw/lava_ref/blocks_s2500_m25_f1_w200.GRCh37_hg19.locfile \
    https://raw.githubusercontent.com/josefin-werme/LAVA/main/support_data/blocks_s2500_m25_f1_w200.GRCh37_hg19.locfile
get raw/lava_ref/g1000_eur.zip https://vu.data.surfsara.nl/index.php/s/VZNByNwpD8qqINe/download

get raw/clump_ref/1kg.v3.tgz http://fileserve.mrcieu.ac.uk/ld/1kg.v3.tgz
echo BİTTİ

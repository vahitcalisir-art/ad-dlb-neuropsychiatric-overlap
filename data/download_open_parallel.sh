#!/usr/bin/env bash
# download_open.sh'te Bellenguez'in arkasında sırada bekleyen dosyaları paralel indirir.
# Aynı hedef yollar ve aynı CHECKSUMS.tsv kullanılır; download_open.sh bunlara sıra geldiğinde
# dosya CHECKSUMS.tsv'de kayıtlıysa atlar.
set -uo pipefail
cd "$(dirname "$0")"
log=raw/CHECKSUMS.tsv
dl() {  # dl <dest> <url>
  local dest=$1 url=$2
  mkdir -p "$(dirname "$dest")"
  if curl -fL --retry 5 --retry-delay 10 -C - -o "$dest" "$url"; then
    printf "%s\t%s\t%s\t%s\t%s\n" "$dest" "$(stat -c %s "$dest")" "$(sha256sum "$dest" | cut -d' ' -f1)" \
      "$url" "$(date -Iseconds)" >> "$log"; echo "OK $dest"
  else echo "HATA: $url" >&2; fi
}
EBI=https://ftp.ebi.ac.uk/pub/databases/gwas/summary_statistics
C=$EBI/GCST90001001-GCST90002000/GCST90001390
dl raw/chia2021/README.txt $C/README.txt
dl raw/chia2021/GCST90001390_buildGRCh38.tsv.gz-meta.yaml $C/GCST90001390_buildGRCh38.tsv.gz-meta.yaml
dl raw/chia2021/harmonised_md5sum.txt $C/harmonised/md5sum.txt
dl raw/chia2021/33589841-GCST90001390-EFO_0006792.h.tsv.gz $C/harmonised/33589841-GCST90001390-EFO_0006792.h.tsv.gz &
dl raw/lava_ref/blocks_s2500_m25_f1_w200.GRCh37_hg19.locfile \
   https://raw.githubusercontent.com/josefin-werme/LAVA/main/support_data/blocks_s2500_m25_f1_w200.GRCh37_hg19.locfile
dl raw/lava_ref/g1000_eur.zip https://vu.data.surfsara.nl/index.php/s/VZNByNwpD8qqINe/download &
dl raw/clump_ref/1kg.v3.tgz http://fileserve.mrcieu.ac.uk/ld/1kg.v3.tgz &
wait
echo BİTTİ

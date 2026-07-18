#!/bin/bash
# Watcher Tethering native untuk deflisten qs_tethering — baca state NetworkManager
# Output: off | on | frame animasi (● | ● ● | ● ● ●) selama transisi
# Lock dari toggle-tethering.sh = tampilkan animasi dari klik sampai nmcli selesai
HOTSPOT_CONN="Hotspot"
LOCK="/tmp/qs_tethering_loading.lock"

last=""
dots=0

emit() {
  # emit hanya saat nilai berubah biar eww gak re-render sia-sia
  if [ "$1" != "$last" ]; then
    echo "$1"
    last="$1"
  fi
}

loading() {
  # lock menutup celah antara klik dan nmcli selesai (dihapus toggle script);
  # valid hanya <15 detik — guard dari stale lock kalau toggle mati di tengah
  [ -f "$LOCK" ] || return 1
  age=$(( $(date +%s) - $(stat -c %Y "$LOCK" 2>/dev/null || echo 0) ))
  [ "$age" -lt 15 ]
}

state() {
  # activated → on | activating → wait (NM masih proses) | selain itu → off
  s=$(nmcli -t -f NAME,STATE connection show --active 2>/dev/null |
    awk -F: -v c="$HOTSPOT_CONN" '$1==c{print $2; exit}')
  case "$s" in
    activated)  echo "on" ;;
    activating) echo "wait" ;;
    *)          echo "off" ;;
  esac
}

while true; do
  if loading || [ "$(state)" = "wait" ]; then
    # frame animasi loading berganti tiap 0.4s
    dots=$(( dots % 3 + 1 ))
    case $dots in
      1) emit "●" ;;
      2) emit "● ●" ;;
      3) emit "● ● ●" ;;
    esac
    sleep 0.4
    continue
  fi
  dots=0

  # Kondisi asli hotspot — sumber kebenaran NetworkManager, bukan klik user,
  # jadi perubahan dari luar (nmcli manual, airplane mode) ikut tersinkron
  case "$(state)" in
    on) emit "on" ;;
    *)  emit "off" ;;
  esac

  # tidur pendek 3x sambil pantau lock biar animasi mulai cepat (<0.4s)
  for _ in 1 2 3; do
    loading && break
    sleep 0.4
  done
done

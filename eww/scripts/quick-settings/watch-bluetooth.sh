#!/bin/bash
# Watcher Bluetooth native untuk deflisten qs_bluetooth
# Output: off | on | <device> | animasi ● saat blueman dibuka/ditutup
# Lock dari toggle-blueman.sh = tampilkan animasi loading selama transisi
LOCK="/tmp/qs_bt_loading.lock"

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
  # animasi jalan selama blueman-manager hidup — dari klik buka sampai
  # klik tutup (atau blueman ditutup dari window-nya langsung)
  pgrep -f 'blueman-manager$' >/dev/null && return 0
  # lock menutup celah antara klik dan proses ter-spawn/teardown;
  # valid hanya <10 detik — guard dari stale lock kalau toggle mati di tengah
  [ -f "$LOCK" ] || return 1
  age=$(( $(date +%s) - $(stat -c %Y "$LOCK" 2>/dev/null || echo 0) ))
  [ "$age" -lt 10 ]
}

while true; do
  if loading; then
    # frame animasi loading berganti tiap 0.4s
    dots=$(( dots % 3 + 1 ))
    case $dots in
      1) emit "●" ;;
      2) emit "●●●" ;;
      3) emit "●●●●●●" ;;
    esac
    sleep 0.4
    continue
  fi
  dots=0

  # Kondisi asli bluetooth: off | on | nama device terhubung
  if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    device=$(bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-)
    if [ -z "$device" ]; then
      device=$(bluetoothctl info 2>/dev/null | grep "Connected: yes" -B5 | grep "Name:" | head -1 | cut -d: -f2 | xargs)
    fi
    emit "${device:-on}"
  else
    emit "off"
  fi

  # tidur pendek 3x sambil pantau lock biar animasi mulai cepat (<0.4s)
  for _ in 1 2 3; do
    loading && break
    sleep 0.4
  done
done

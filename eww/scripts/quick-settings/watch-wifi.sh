#!/bin/bash
# Watcher WiFi native untuk deflisten qs_wifi — baca state device NetworkManager
# Output: off | on | <SSID> | animasi titik (. .. ...) selama proses koneksi
# Poll adaptif: 0.4s saat connecting (frame animasi), 1s saat idle

last=""
dots=0

emit() {
  # emit hanya saat nilai berubah biar eww gak re-render sia-sia
  if [ "$1" != "$last" ]; then
    echo "$1"
    last="$1"
  fi
}

while true; do
  if ! nmcli radio wifi 2>/dev/null | grep -qi "enabled"; then
    emit "off"
    dots=0
    sleep 1
    continue
  fi

  state=$(nmcli -t -f TYPE,STATE device 2>/dev/null | awk -F: '$1=="wifi"{print $2; exit}')
  case "$state" in
    connected)
      ssid=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | awk -F: '$1=="yes"{print $2; exit}')
      emit "${ssid:-on}"
      dots=0
      sleep 1
      ;;
    *connecting*)
      # NetworkManager sedang memproses koneksi (prepare/configuring/ip-config)
      # → frame animasi titik berganti tiap 0.4s
      dots=$(( dots % 3 + 1 ))
      case $dots in
        1) emit "●" ;;
        2) emit "●●●" ;;
        3) emit "●●●●●●" ;;
      esac
      sleep 0.4
      ;;
    *)
      # disconnected / unavailable — radio nyala tapi belum terhubung
      emit "on"
      dots=0
      sleep 1
      ;;
  esac
done

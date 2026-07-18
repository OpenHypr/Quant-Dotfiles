#!/bin/bash
# Toggle Airplane Mode via nmcli networking + bluetooth
# Airplane ON  → WiFi & Bluetooth auto mati (perilaku airplane sesungguhnya)
# Airplane OFF → WiFi & BT tetap mati (nyalakan manual)
# Status card BT sinkron otomatis via watch-bluetooth.sh (baca state asli)
# PENTING: onclick EWW punya timeout 200ms — bluetooth-off.sh punya retry
# loop sampai 5 detik, kerja berat wajib jalan di background
SCRIPTS="/home/xuanz/.config/collab-scripts"

state=$(nmcli networking 2>/dev/null)
if [ "$state" = "enabled" ]; then
  /usr/bin/eww update qs_airplane="on" 2>/dev/null
  (
    nmcli networking off 2>/dev/null
    # bluetooth ikut mati + rfkill block — biar gak bisa dinyalain
    # selama airplane aktif (konsisten dengan WiFi/hotspot)
    "$SCRIPTS/bluetooth-off.sh" --block >/dev/null 2>&1
  ) &
else
  /usr/bin/eww update qs_airplane="off" 2>/dev/null
  (
    # buka block BT duluan — independen dari NM, jangan ikut antre di
    # belakang networking on yang bisa blocking 10+ detik
    rfkill unblock bluetooth 2>/dev/null
    nmcli networking on 2>/dev/null
  ) &
fi

#!/bin/bash
# Toggle power Bluetooth untuk card QS — delegasi ke collab-scripts
# State UI diurus watch-bluetooth.sh (deflisten); lock = animasi loading
# PENTING: onclick EWW punya timeout 200ms — bluetooth-on/off.sh punya
# retry loop sampai 5 detik, wajib jalan di background
LOCK="/tmp/qs_bt_loading.lock"
SCRIPTS="/home/xuanz/.config/collab-scripts"

touch "$LOCK"

if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
  (
    # delay 2 detik — animasi loading jalan dulu sebelum power berubah
    sleep 2
    "$SCRIPTS/bluetooth-off.sh" >/dev/null 2>&1
    rm -f "$LOCK"
  ) &
else
  (
    # delay 2 detik — animasi loading jalan dulu sebelum power berubah
    sleep 2
    "$SCRIPTS/bluetooth-on.sh" >/dev/null 2>&1
    rm -f "$LOCK"
  ) &
fi

#!/bin/bash
# Pantau Bluetooth — dipanggil defpoll tiap 5 detik
# (WiFi ditangani watch-wifi.sh via deflisten)

# --- Bluetooth ---
# Lock check dihapus: toggle-bluetooth.sh sudah tidak ada (toggle via blueman),
# watcher ini satu-satunya penulis qs_bluetooth
if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
  device=$(bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-)
  if [ -z "$device" ]; then
    device=$(bluetoothctl info 2>/dev/null | grep "Connected: yes" -B5 | grep "Name:" | head -1 | cut -d: -f2 | xargs)
  fi
  if [ -n "$device" ]; then
    eww update qs_bluetooth="$device"
  else
    eww update qs_bluetooth="on"
  fi
else
  eww update qs_bluetooth="off"
fi

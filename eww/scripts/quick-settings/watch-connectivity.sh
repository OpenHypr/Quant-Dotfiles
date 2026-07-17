#!/bin/bash
# Pantau konektivitas WiFi & Bluetooth — dipanggil defpoll tiap 5 detik
# Skip kalau ada toggle yg sedang transisi (lock file)

# --- WiFi (skip kalau lock aktif) ---
if [ ! -f /tmp/qs_toggle_wifi.lock ]; then
  wifi_radio=$(nmcli radio wifi 2>/dev/null)
  if echo "$wifi_radio" | grep -qi "enabled"; then
    ssid=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | grep "^yes:" | cut -d: -f2)
    if [ -n "$ssid" ]; then
      eww update qs_wifi="$ssid"
    else
      eww update qs_wifi="on"
    fi
  else
    eww update qs_wifi="off"
  fi
fi

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

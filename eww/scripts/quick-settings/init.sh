#!/bin/bash
# Inisialisasi state quick settings — dipanggil saat EWW start
# Cek state sistem aktual dan update variabel EWW

# WiFi — 3 state: off | on | <SSID>
if nmcli radio wifi 2>/dev/null | grep -q "enabled"; then
  ssid=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | grep "^yes:" | cut -d: -f2)
  if [ -n "$ssid" ]; then
    eww update qs_wifi="$ssid"
  else
    eww update qs_wifi="on"
  fi
else
  eww update qs_wifi="off"
fi

# Bluetooth — 3 state: off | on | <device>
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

# Airplane Mode
if nmcli networking 2>/dev/null | grep -q "enabled"; then
  eww update qs_airplane="off"
else
  eww update qs_airplane="on"
fi

# Tethering
if nmcli connection show --active 2>/dev/null | grep -q "Hotspot"; then
  eww update qs_tethering="on"
else
  eww update qs_tethering="off"
fi

# Night Light
if pgrep -x "hyprsunset\|wlsunset\|gammastep" >/dev/null 2>&1; then
  eww update qs_nightlight="on"
else
  eww update qs_nightlight="off"
fi

# DND
if command -v swaync-client &>/dev/null; then
  if swaync-client --get-dnd 2>/dev/null | grep -q "true"; then
    eww update qs_dnd="on"
  else
    eww update qs_dnd="off"
  fi
elif command -v makoctl &>/dev/null; then
  if makoctl mode 2>/dev/null | grep -q "dnd"; then
    eww update qs_dnd="on"
  else
    eww update qs_dnd="off"
  fi
else
  eww update qs_dnd="off"
fi

# Power Mode
if command -v powerprofilesctl &>/dev/null; then
  profile=$(powerprofilesctl get 2>/dev/null)
  case "$profile" in
    *power-saver*)  eww update qs_powermode="safe" ;;
    *performance*)  eww update qs_powermode="performance" ;;
    *)              eww update qs_powermode="balanced" ;;
  esac
fi

# Theme
eww update qs_theme="dark"

#!/bin/bash
# Inisialisasi state quick settings — dipanggil saat EWW start
# Cek state sistem aktual dan update variabel EWW

# WiFi — ditangani watch-wifi.sh via deflisten, tidak perlu init di sini

# Bluetooth — ditangani watch-bluetooth.sh via deflisten, tidak perlu init di sini

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

# Power Mode — ditangani collab-scripts/power-mode.sh, tidak perlu init di sini

# Theme
eww update qs_theme="dark"

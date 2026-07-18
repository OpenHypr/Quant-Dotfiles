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

# Tethering — ditangani watch-tethering.sh via deflisten, tidak perlu init di sini

# Night Light — level cycle (off|25%|50%|75%|100%) tersimpan di state file
if pgrep -x "hyprsunset" >/dev/null 2>&1; then
  eww update qs_nightlight="$(cat /tmp/qs_nightlight.state 2>/dev/null || echo '50%')"
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

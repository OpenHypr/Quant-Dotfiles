#!/bin/bash
# Toggle Night Light (hyprsunset / wlsunset / gammastep)
# Cek proses yg sedang jalan
if pgrep -x "hyprsunset" >/dev/null 2>&1; then
  pkill hyprsunset 2>/dev/null
  /usr/bin/eww update qs_nightlight="off"
elif pgrep -x "wlsunset" >/dev/null 2>&1; then
  pkill wlsunset 2>/dev/null
  /usr/bin/eww update qs_nightlight="off"
elif pgrep -x "gammastep" >/dev/null 2>&1; then
  pkill gammastep 2>/dev/null
  /usr/bin/eww update qs_nightlight="off"
else
  # Default: coba hyprsunset dulu, fallback ke wlsunset
  if command -v hyprsunset &>/dev/null; then
    hyprsunset -t 4500 &
    /usr/bin/eww update qs_nightlight="on"
  elif command -v wlsunset &>/dev/null; then
    wlsunset -t 4500 &
    /usr/bin/eww update qs_nightlight="on"
  elif command -v gammastep &>/dev/null; then
    gammastep -O 4500 &
    /usr/bin/eww update qs_nightlight="on"
  fi
fi

#!/bin/bash
# Cycle Power Mode: safe → balanced → performance → safe
# Update EWW langsung biar UI responsif tanpa nunggu watcher (deflisten)
# Watcher tetap jalan buat sinkronisasi perubahan dari luar (waybar, CLI)

current=$(powerprofilesctl get 2>/dev/null || echo "balanced")
case "$current" in
  power-saver)
    powerprofilesctl set balanced 2>/dev/null
    eww update qs_powermode="balanced" 2>/dev/null
    ;;
  balanced)
    powerprofilesctl set performance 2>/dev/null
    eww update qs_powermode="performance" 2>/dev/null
    ;;
  *)
    powerprofilesctl set power-saver 2>/dev/null
    eww update qs_powermode="safe" 2>/dev/null
    ;;
esac

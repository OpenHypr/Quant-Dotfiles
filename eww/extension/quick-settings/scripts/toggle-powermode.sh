#!/bin/bash
# Cycle Power Mode: safe → balanced → performance → safe
# Frontend: update variabel EWW (instant)
# Backend:  powerprofilesctl set <profile> (system + DBus)
# Watcher watch-powermode.sh via deflisten akan sinkronkan ulang via DBus
current=$(eww get qs_powermode 2>/dev/null || echo "balanced")

case "$current" in
  safe)
    eww update qs_powermode="balanced"
    powerprofilesctl set balanced &
    ;;
  balanced)
    eww update qs_powermode="performance"
    powerprofilesctl set performance &
    ;;
  performance)
    eww update qs_powermode="safe"
    powerprofilesctl set power-saver &
    ;;
  *)
    eww update qs_powermode="balanced"
    powerprofilesctl set balanced &
    ;;
esac

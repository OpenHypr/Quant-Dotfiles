#!/bin/bash
# Cycle Power Mode: safe → balanced → performance → safe
# Frontend: update variabel EWW (instant)
# Backend:  jalankan power-mode.sh <mode> (sync system + waybar)
COLLAB="$HOME/.config/collab-scripts/power-mode.sh"
current=$(eww get qs_powermode 2>/dev/null || echo "balanced")

case "$current" in
  safe)
    eww update qs_powermode="balanced"
    "$COLLAB" balanced &
    ;;
  balanced)
    eww update qs_powermode="performance"
    "$COLLAB" performance &
    ;;
  performance)
    eww update qs_powermode="safe"
    "$COLLAB" safe &
    ;;
  *)
    eww update qs_powermode="balanced"
    "$COLLAB" balanced &
    ;;
esac

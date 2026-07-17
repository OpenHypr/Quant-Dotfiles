#!/bin/bash
# Cycle Power Mode: safe → balanced → performance → safe
current=$(eww get qs_powermode 2>/dev/null || echo "balanced")
case "$current" in
  "safe")
    powerprofilesctl set balanced 2>/dev/null || true
    eww update qs_powermode="balanced"
    ;;
  "balanced")
    powerprofilesctl set performance 2>/dev/null || true
    eww update qs_powermode="performance"
    ;;
  "performance")
    powerprofilesctl set power-saver 2>/dev/null || true
    eww update qs_powermode="safe"
    ;;
  *)
    powerprofilesctl set balanced 2>/dev/null || true
    eww update qs_powermode="balanced"
    ;;
esac

#!/bin/bash
# Cycle Power Mode: power-saver → balanced → performance → power-saver
# Baca state asli dari ppd (bukan eww) — UI diurus watch-powermode.sh (deflisten)

current=$(powerprofilesctl get 2>/dev/null || echo "balanced")
case "$current" in
  power-saver) powerprofilesctl set balanced 2>/dev/null ;;
  balanced)    powerprofilesctl set performance 2>/dev/null ;;
  *)           powerprofilesctl set power-saver 2>/dev/null ;;
esac

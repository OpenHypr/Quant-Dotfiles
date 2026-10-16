#!/bin/bash
# ============================================================
# adjust-volume.sh <sink-input-index> <scroll-dy>
# Naik/turun volume sink-input via scroll event
# scroll up (dy < 0) = volume +5, scroll down (dy > 0) = volume -5
# ============================================================
[ -z "$1" ] || [ -z "$2" ] && exit 1

index="$1"
dy="$2"
step=5

# Tentukan arah: scroll up (dy negatif) => naikkan volume
if [[ "$dy" == -* ]]; then
    delta=$step
else
    delta=$((-step))
fi

# Dapetin volume saat ini
current=$(pactl -f json list sink-inputs 2>/dev/null | jq -r "
  .[] | select(.index == $index) | .volume |
  [.[].value_percent | rtrimstr(\"%\") | tonumber] | add / length
")

[ -z "$current" ] && exit 0

new=$((current + delta))

# Clamp 0–150
[ "$new" -gt 150 ] && new=150
[ "$new" -lt 0 ] && new=0

pactl set-sink-input-volume "$index" "${new}%"

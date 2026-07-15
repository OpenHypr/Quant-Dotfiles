#!/bin/bash
# ============================================================
# set-volume-exact.sh <sink-input-index> <volume%>
# Set volume exact ke persentase tertentu (dari scale widget)
# ============================================================
[ -z "$1" ] || [ -z "$2" ] && exit 1

index="$1"
vol="$2"

# Clamp
[ "$vol" -gt 150 ] && vol=150
[ "$vol" -lt 0 ] && vol=0

pactl set-sink-input-volume "$index" "${vol}%"

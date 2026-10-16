#!/bin/bash
# set-volume-exact.sh <index> <volume%> — "master" = default sink
[ -z "$1" ] || [ -z "$2" ] && exit 1
index="$1"; vol="$2"
[ "$vol" -gt 150 ] && vol=150
[ "$vol" -lt 0 ] && vol=0
if [ "$index" = "master" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ "${vol}%"
else
    pactl set-sink-input-volume "$index" "${vol}%"
fi

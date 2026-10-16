#!/bin/bash
# set volume untuk mic: index 0 = default source, selain itu = source-output
[ -z "$1" ] || [ -z "$2" ] && exit 1
index="$1"; vol="$2"
[ "$vol" -gt 150 ] && vol=150
[ "$vol" -lt 0 ] && vol=0
if [ "$index" = "0" ]; then
    pactl set-source-volume @DEFAULT_SOURCE@ "${vol}%"
else
    pactl set-source-output-volume "$index" "${vol}%"
fi

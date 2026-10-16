#!/bin/bash
# toggle-mute.sh <index> — "master" = default sink
[ -z "$1" ] && exit 1
if [ "$1" = "master" ]; then
    pactl set-sink-mute @DEFAULT_SINK@ toggle
else
    pactl set-sink-input-mute "$1" toggle
fi

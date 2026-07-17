#!/bin/bash
# toggle mute untuk mic: index 0 = default source, selain itu = source-output
[ -z "$1" ] && exit 1
if [ "$1" = "0" ]; then
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
else
    pactl set-source-output-mute "$1" toggle
fi

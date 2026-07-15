#!/bin/bash
# ============================================================
# toggle-mute.sh <sink-input-index>
# Toggle mute untuk sink-input tertentu
# ============================================================
[ -z "$1" ] && exit 1
pactl set-sink-input-mute "$1" toggle

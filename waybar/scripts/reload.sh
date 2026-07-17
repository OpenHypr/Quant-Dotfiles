#!/bin/bash
# Toggle/reload waybar
if pgrep -x waybar >/dev/null; then
    killall -SIGUSR2 waybar
else
    waybar >/dev/null 2>&1 &
fi

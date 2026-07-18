#!/bin/bash
# Toggle blueman-manager — tanpa sinyal loading ke watcher;
# animasi card cuma milik transisi power (toggle-bluetooth.sh),
# buka/tutup blueman gak perlu mengubah tampilan status BT
if pgrep -f 'blueman-manager$' >/dev/null; then
  pkill -f 'blueman-manager$'
else
  blueman-manager >/dev/null 2>&1 &
fi

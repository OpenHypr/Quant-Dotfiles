#!/bin/bash
# Toggle blueman-manager — buka kalau belum jalan, tutup kalau sudah
# Match pakai cmdline penuh: proses jalan sebagai "python /usr/bin/blueman-manager"

if pgrep -f 'blueman-manager$' >/dev/null; then
  pkill -f 'blueman-manager$'
else
  blueman-manager &
fi

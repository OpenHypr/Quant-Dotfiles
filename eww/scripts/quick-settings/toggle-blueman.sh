#!/bin/bash
# Toggle blueman-manager + sinyal loading untuk watch-bluetooth.sh
# Selama lock ada, watcher menampilkan animasi loading di status card
LOCK="/tmp/qs_bt_loading.lock"

if pgrep -f 'blueman-manager$' >/dev/null; then
  # Tutup — animasi sampai proses benar-benar mati (max 2s)
  touch "$LOCK"
  pkill -f 'blueman-manager$'
  for _ in $(seq 1 20); do
    pgrep -f 'blueman-manager$' >/dev/null || break
    sleep 0.1
  done
  rm -f "$LOCK"
else
  # Buka — animasi sampai window blueman muncul (max 6s)
  touch "$LOCK"
  blueman-manager &
  bpid=$!
  for _ in $(seq 1 30); do
    # match class persis — grep longgar bisa false-positive dari judul
    # window lain (mis. editor yang buka file toggle-blueman.sh)
    hyprctl clients -j 2>/dev/null | grep -q '"class": "blueman-manager"' && break
    # proses mati = gagal launch, jangan tahan lock 6 detik
    kill -0 "$bpid" 2>/dev/null || break
    sleep 0.2
  done
  rm -f "$LOCK"
fi

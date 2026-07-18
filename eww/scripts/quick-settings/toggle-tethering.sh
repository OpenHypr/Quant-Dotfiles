#!/bin/bash
# Toggle WiFi Hotspot — state UI diurus watch-tethering.sh (deflisten qs_tethering),
# jadi tidak perlu eww update lagi. Lock file = sinyal animasi ke watcher.
# PENTING: onclick EWW punya timeout 200ms — kerja nmcli jalan di background
# biar script exit instan.
HOTSPOT_CONN="Hotspot"
LOCK="/tmp/qs_tethering_loading.lock"

touch "$LOCK"

if nmcli connection show --active 2>/dev/null | grep -q "$HOTSPOT_CONN"; then
  # OFF — matikan hotspot
  (
    nmcli connection down "$HOTSPOT_CONN" 2>/dev/null
    rm -f "$LOCK"
  ) &
else
  # ON — lepas WiFi dulu, pastikan radio nyala, lalu aktifkan hotspot
  (
    nmcli device disconnect wlan0 2>/dev/null
    nmcli radio wifi on 2>/dev/null
    nmcli connection up "$HOTSPOT_CONN" 2>/dev/null
    rm -f "$LOCK"
  ) &
fi

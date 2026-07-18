#!/bin/bash
# Toggle WiFi Hotspot — animasi ● ●● ●●● saat transisi
# PENTING: onclick EWW punya timeout 200ms — script yang lebih lama dibunuh.
# Semua kerja (nmcli + animasi) wajib jalan di background biar script exit instan.
HOTSPOT_CONN="Hotspot"

if nmcli connection show --active 2>/dev/null | grep -q "$HOTSPOT_CONN"; then
  # OFF — animasi dulu, lalu matikan
  (
    /usr/bin/eww update qs_tethering="●" 2>/dev/null;   sleep 0.2
    /usr/bin/eww update qs_tethering="● ●" 2>/dev/null;  sleep 0.2
    /usr/bin/eww update qs_tethering="● ● ●" 2>/dev/null; sleep 0.2
    nmcli connection down "$HOTSPOT_CONN" 2>/dev/null
    /usr/bin/eww update qs_tethering="off" 2>/dev/null
  ) &
else
  # ON — disconnect WiFi dulu, wifi nyala, animasi, lalu hotspot
  (
    nmcli device disconnect wlan0 2>/dev/null
    nmcli radio wifi on 2>/dev/null
    /usr/bin/eww update qs_tethering="●" 2>/dev/null;   sleep 0.2
    /usr/bin/eww update qs_tethering="● ●" 2>/dev/null;  sleep 0.2
    /usr/bin/eww update qs_tethering="● ● ●" 2>/dev/null; sleep 0.2
    if nmcli connection up "$HOTSPOT_CONN" 2>/dev/null; then
      /usr/bin/eww update qs_tethering="on" 2>/dev/null
    else
      # gagal nyalakan hotspot — jangan bohong di UI
      /usr/bin/eww update qs_tethering="off" 2>/dev/null
    fi
  ) &
fi

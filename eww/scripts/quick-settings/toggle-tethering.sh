#!/bin/bash
# Toggle WiFi Hotspot
HOTSPOT_CONN="Hotspot"
if nmcli connection show --active 2>/dev/null | grep -q "$HOTSPOT_CONN"; then
  nmcli connection down "$HOTSPOT_CONN" 2>/dev/null
  eww update qs_tethering="off"
else
  nmcli connection up "$HOTSPOT_CONN" 2>/dev/null
  eww update qs_tethering="on"
fi

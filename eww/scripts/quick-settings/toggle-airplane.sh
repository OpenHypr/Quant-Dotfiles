#!/bin/bash
# Toggle Airplane Mode via nmcli networking
# Airplane ON  → WiFi auto mati
# Airplane OFF → WiFi tetap mati (nyalakan manual)

state=$(nmcli networking 2>/dev/null)
if [ "$state" = "enabled" ]; then
  /usr/bin/eww update qs_airplane="on" 2>/dev/null
  nmcli networking off 2>/dev/null
else
  /usr/bin/eww update qs_airplane="off" 2>/dev/null
  nmcli networking on 2>/dev/null
fi

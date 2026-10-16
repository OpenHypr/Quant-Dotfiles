#!/bin/bash
# Toggle radio WiFi — state UI diurus watch-wifi.sh (deflisten qs_wifi),
# jadi tidak perlu eww update / lock file lagi

if nmcli radio wifi 2>/dev/null | grep -qi "enabled"; then
  nmcli radio wifi off 2>/dev/null
else
  nmcli radio wifi on 2>/dev/null
fi

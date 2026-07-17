#!/bin/bash
# Toggle WiFi — 3 state: off | on | <SSID connected>
# Pakai counter cegah background process overwrite saat toggle cepat
LOCK="/tmp/qs_toggle_wifi.lock"
COUNTER="/tmp/qs_toggle_wifi.cnt"

counter=$(cat "$COUNTER" 2>/dev/null || echo 0)
counter=$((counter + 1))
echo "$counter" > "$COUNTER"

state=$(nmcli radio wifi 2>/dev/null)
if echo "$state" | grep -qi "enabled"; then
  # Matikan WiFi
  touch "$LOCK"
  nmcli radio wifi off 2>/dev/null
  eww update qs_wifi="off"
  (sleep 2; rm -f "$LOCK") &
else
  # Nyalakan WiFi — update langsung "on", SSID dicek nanti
  touch "$LOCK"
  nmcli radio wifi on 2>/dev/null
  eww update qs_wifi="on"
  (
    my_cnt=$counter
    sleep 3
    # Hanya update kalau gak ada toggle baru setelah ini
    current=$(cat "$COUNTER" 2>/dev/null || echo 0)
    if [ "$current" = "$my_cnt" ]; then
      ssid=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | grep "^yes:" | cut -d: -f2)
      if [ -n "$ssid" ]; then
        eww update qs_wifi="$ssid"
      fi
    fi
    rm -f "$LOCK"
  ) &
fi

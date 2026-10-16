#!/bin/bash
# Toggle quick-settings — auto-close swaync saat QS dibuka (mutual exclusion)
if eww active-windows | grep -q "^quick-settings:"; then
  eww close quick-settings
else
  eww close mixer
  eww close mic-mixer
  swaync-client --close-panel
  eww open quick-settings
fi

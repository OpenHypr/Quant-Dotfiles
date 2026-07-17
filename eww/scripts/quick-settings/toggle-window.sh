#!/bin/bash
# Toggle quick-settings popup — mutually exclusive dengan mixer & mic-mixer
if eww active-windows | grep -q "^quick-settings:"; then
  eww close quick-settings
else
  eww close mixer
  eww close mic-mixer
  eww open quick-settings
fi

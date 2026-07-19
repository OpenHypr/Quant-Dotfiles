#!/bin/bash
# Toggle power-menu popup — mutually exclusive dengan popup lain
if eww active-windows | grep -q "^power-menu:"; then
  eww close power-menu
else
  eww close mixer
  eww close mic-mixer
  eww close quick-settings
  eww open power-menu
fi

#!/bin/bash
# Toggle volume mixer — auto-close mic-mixer
if /usr/bin/eww active-windows | grep -q '^mixer:'; then
    /usr/bin/eww close mixer
else
    /usr/bin/eww close mic-mixer 2>/dev/null
    /usr/bin/eww open mixer
fi

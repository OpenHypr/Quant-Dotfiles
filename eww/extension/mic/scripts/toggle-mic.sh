#!/bin/bash
# Toggle mic mixer — auto-close volume mixer
if /usr/bin/eww active-windows | grep -q '^mic-mixer:'; then
    /usr/bin/eww close mic-mixer
else
    /usr/bin/eww close mixer 2>/dev/null
    /usr/bin/eww open mic-mixer
fi

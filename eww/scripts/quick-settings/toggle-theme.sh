#!/bin/bash
# Toggle Theme dark/light
current=$(eww get qs_theme 2>/dev/null || echo "dark")
if [ "$current" = "dark" ]; then
  /usr/bin/eww update qs_theme="light"
else
  /usr/bin/eww update qs_theme="dark"
fi

#!/bin/bash
# Cycle DND mode: Off → Priority → Alarms → Silent → Off ...
STATE_FILE="/tmp/swaync-dnd-mode"

# Baca mode saat ini, default "Off"
CURRENT=$(cat "$STATE_FILE" 2>/dev/null || echo "Off")

case "$CURRENT" in
  "Off")
    NEXT="Priority"
    swaync-client --dnd-off
    ;;
  "Priority")
    NEXT="Alarms"
    swaync-client --dnd-off
    ;;
  "Alarms")
    NEXT="Silent"
    swaync-client --dnd-on
    ;;
  "Silent")
    NEXT="Off"
    swaync-client --dnd-off
    ;;
  *)
    NEXT="Off"
    swaync-client --dnd-off
    ;;
esac

echo "$NEXT" > "$STATE_FILE"

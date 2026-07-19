#!/bin/bash
# Power menu actions — dipanggil dari widget onclick
# Usage: actions.sh <sleep|logout|reboot|poweroff>
action="$1"

case "$action" in
  sleep)
    systemctl suspend
    ;;
  logout)
    hyprctl dispatch exit
    ;;
  reboot)
    systemctl reboot
    ;;
  poweroff)
    systemctl poweroff
    ;;
  *)
    echo "Usage: $0 <sleep|logout|reboot|poweroff>"
    exit 1
    ;;
esac

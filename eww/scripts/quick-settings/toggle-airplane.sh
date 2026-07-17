#!/bin/bash
# Toggle Airplane Mode via nmcli networking
state=$(nmcli networking 2>/dev/null)
if [ "$state" = "enabled" ]; then
  nmcli networking off 2>/dev/null
  eww update qs_airplane="on"
else
  nmcli networking on 2>/dev/null
  eww update qs_airplane="off"
fi

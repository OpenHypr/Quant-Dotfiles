#!/bin/bash
# Toggle power Bluetooth untuk card QS — state UI diurus watch-bluetooth.sh
# Lock file = sinyal animasi loading ke watcher.
# PENTING: onclick EWW punya timeout 200ms — bluetoothctl bisa lambat,
# kerja berat wajib jalan di background.
LOCK="/tmp/qs_bt_loading.lock"

touch "$LOCK"

if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
  # --- OFF: matikan controller ---
  (
    sleep 2
    for _ in $(seq 1 10); do
      bluetoothctl power off >/dev/null 2>&1
      if bluetoothctl show 2>/dev/null | grep -q "Powered: no"; then
        break
      fi
      sleep 0.5
    done
    rm -f "$LOCK"
  ) &
else
  # --- ON: nyalakan controller ---
  (
    sleep 2

    # Hormati airplane mode — kalau networking mati, jangan nyalakan BT
    if ! nmcli networking 2>/dev/null | grep -qi "enabled"; then
      rm -f "$LOCK"
      exit 1
    fi

    # Lepas soft-block rfkill
    rfkill unblock bluetooth 2>/dev/null

    # Pastikan bluetooth.service hidup
    if ! systemctl is-active --quiet bluetooth; then
      systemctl start bluetooth 2>/dev/null || sudo systemctl start bluetooth 2>/dev/null || true
    fi

    # Power on + retry
    for _ in $(seq 1 10); do
      bluetoothctl power on >/dev/null 2>&1
      if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
        break
      fi
      sleep 0.5
    done

    rm -f "$LOCK"
  ) &
fi

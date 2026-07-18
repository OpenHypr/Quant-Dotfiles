#!/bin/bash
# Matikan Bluetooth dari terminal — pasangan bluetooth-on.sh
# Pakai: bluetooth-off.sh [--block]
#   --block  sekalian soft-block via rfkill (controller hilang total,
#            gak bisa dinyalain lagi kecuali rfkill unblock)

# Service mati / controller gak ada = sudah off, tidak perlu apa-apa
if ! systemctl is-active --quiet bluetooth ||
   ! bluetoothctl show 2>/dev/null | grep -q "Powered:"; then
  echo "Bluetooth sudah OFF (service mati / controller tidak ada)"
  # --block tetap dihormati meski sudah off — penting buat airplane mode
  if [ "$1" = "--block" ]; then
    rfkill block bluetooth 2>/dev/null
    echo "rfkill: blocked"
  fi
  exit 0
fi

# Power off controller — retry + verifikasi state asli (Powered: no),
# konsisten dengan pola di bluetooth-on.sh
for _ in $(seq 1 10); do
  bluetoothctl power off >/dev/null 2>&1
  if bluetoothctl show 2>/dev/null | grep -q "Powered: no"; then
    echo "Bluetooth OFF ✓"
    # opsional: blokir radio sekalian biar gak bisa nyala tanpa unblock
    if [ "$1" = "--block" ]; then
      rfkill block bluetooth 2>/dev/null
      echo "rfkill: blocked"
    fi
    exit 0
  fi
  sleep 0.5
done

echo "GAGAL: controller masih Powered setelah 5 detik" >&2
echo "Cek: bluetoothctl show" >&2
exit 1

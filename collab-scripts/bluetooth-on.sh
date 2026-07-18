#!/bin/bash
# Nyalakan Bluetooth dari terminal — urutan lengkap biar gak ada yang kelewat:
# rfkill unblock → pastikan service jalan → power on controller
# Pakai: bluetooth-on.sh

# 0. Hormati airplane mode — konsisten dengan WiFi/hotspot yang juga
#    terkunci selama networking off; tanpa guard ini rfkill unblock di
#    bawah bakal nge-bypass block dari toggle-airplane.sh
if ! nmcli networking 2>/dev/null | grep -qi "enabled"; then
  echo "GAGAL: airplane mode aktif — matikan dulu sebelum nyalakan Bluetooth" >&2
  exit 1
fi

# 1. Lepas soft-block rfkill (sering jadi penyebab "controller not available")
rfkill unblock bluetooth 2>/dev/null

# 2. Pastikan bluetooth.service hidup — kalau mati, coba start (butuh polkit/sudo)
if ! systemctl is-active --quiet bluetooth; then
  echo "bluetooth.service mati — mencoba start..."
  systemctl start bluetooth 2>/dev/null || sudo systemctl start bluetooth || {
    echo "GAGAL: tidak bisa start bluetooth.service" >&2
    exit 1
  }
fi

# 3. Power on controller — retry max 5 detik: setelah rfkill unblock atau
#    service baru start, controller butuh waktu sebentar buat siap.
#    Verifikasi dari state asli (Powered: yes), bukan parsing output command
#    yang bisa gagal sesaat padahal ujungnya nyala (AutoEnable bluetoothd).
for _ in $(seq 1 10); do
  bluetoothctl power on >/dev/null 2>&1
  if bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; then
    echo "Bluetooth ON ✓"
    bluetoothctl show 2>/dev/null | grep -E "Name|Powered|Discoverable|Pairable"
    exit 0
  fi
  sleep 0.5
done

echo "GAGAL: controller tidak Powered setelah 5 detik" >&2
echo "Cek: bluetoothctl show && rfkill list bluetooth" >&2
exit 1

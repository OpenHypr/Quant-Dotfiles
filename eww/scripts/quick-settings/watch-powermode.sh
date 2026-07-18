#!/bin/bash
# Watcher Power Mode native untuk deflisten qs_powermode — event-driven DBus,
# dengar sinyal daemon yang sama dengan module power-profiles-daemon waybar
# jadi keduanya selalu sinkron dari mana pun profile diubah
# Mapping: power-saver -> safe | balanced -> balanced | performance -> performance

last=""

emit_current() {
  case "$(powerprofilesctl get 2>/dev/null)" in
    power-saver) val="safe" ;;
    performance) val="performance" ;;
    *)           val="balanced" ;;
  esac
  # emit hanya saat berubah biar eww gak re-render sia-sia
  if [ "$val" != "$last" ]; then
    echo "$val"
    last="$val"
  fi
}

while true; do
  emit_current
  # dengarkan sinyal PropertiesChanged dari daemon; pakai process substitution
  # biar loop jalan di main shell dan dedup $last tetap kepakai;
  # stdbuf -oL cegah output gdbus nyangkut di block buffer
  while read -r line; do
    case "$line" in
      *ActiveProfile*) emit_current ;;
    esac
  done < <(stdbuf -oL gdbus monitor --system --dest org.freedesktop.UPower.PowerProfiles 2>/dev/null)
  # gdbus mati (daemon restart?) — jeda sebentar lalu sambung lagi
  sleep 2
done

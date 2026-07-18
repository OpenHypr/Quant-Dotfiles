#!/bin/bash
# ============================================================
# Backend Power Mode — single source of truth untuk EWW & Waybar
# Hanya script ini yg akses DBus power-profiles-daemon
#
# Subcommand:
#   watch  — deflisten daemon: monitor DBus → emit safe|balanced|performance
#   cycle  — cycle profile + update EWW + signal waybar
#   get    — output current state: safe|balanced|performance
#   icon   — output Nerd Font icon sesuai current state
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WAYBAR_SIGNAL=5  # SIGRTMIN+5 buat refresh custom/power-mode waybar

# Mapping: power-profiles-daemon → nilai internal
map_state() {
  case "$1" in
    power-saver) echo "safe" ;;
    performance) echo "performance" ;;
    *)           echo "balanced" ;;
  esac
}

# Mapping: nilai internal → Nerd Font icon
map_icon() {
  case "$1" in
    safe)        echo "" ;;  # power-saver
    balanced)    echo "" ;;  # balanced
    performance) echo "" ;;  # performance
  esac
}

# Dapatkan state dari daemon langsung
get_state() {
  local raw
  raw=$(powerprofilesctl get 2>/dev/null || echo "balanced")
  map_state "$raw"
}

# Signal waybar buat refresh custom/power-mode
signal_waybar() {
  pkill -SIGRTMIN+"$WAYBAR_SIGNAL" waybar 2>/dev/null || true
}

# ============================================================
# Subcommand: watch
# deflisten daemon — emit state ke stdout + signal waybar
# ============================================================
cmd_watch() {
  local last=""

  emit() {
    local state
    state=$(get_state)
    if [ "$state" != "$last" ]; then
      echo "$state"
      last="$state"
      # signal waybar setiap kali state berubah
      signal_waybar
    fi
  }

  # emit initial state
  emit

  # monitor DBus buat perubahan
  while read -r line; do
    case "$line" in
      *ActiveProfile*) emit ;;
    esac
  done < <(stdbuf -oL gdbus monitor --system --dest org.freedesktop.UPower.PowerProfiles 2>/dev/null)
}

# ============================================================
# Subcommand: cycle
# Cycle profile + update EWW langsung + signal waybar
# ============================================================
cmd_cycle() {
  local current next
  current=$(get_state)

  case "$current" in
    safe)
      powerprofilesctl set balanced 2>/dev/null
      next="balanced"
      ;;
    balanced)
      powerprofilesctl set performance 2>/dev/null
      next="performance"
      ;;
    *)
      powerprofilesctl set power-saver 2>/dev/null
      next="safe"
      ;;
  esac

  # update EWW langsung (instant, tanpa nunggu watcher)
  eww update qs_powermode="$next" 2>/dev/null

  # signal waybar
  signal_waybar
}

# ============================================================
# Subcommand: get
# Output current state (buat debugging / external use)
# ============================================================
cmd_get() {
  get_state
}

# ============================================================
# Subcommand: icon
# Output Nerd Font icon (buat waybar custom module display)
# ============================================================
cmd_icon() {
  map_icon "$(get_state)"
}

# ============================================================
# Dispatch
# ============================================================
case "${1:-}" in
  watch)  cmd_watch ;;
  cycle)  cmd_cycle ;;
  get)    cmd_get ;;
  icon)   cmd_icon ;;
  *)
    echo "Usage: $0 {watch|cycle|get|icon}" >&2
    exit 1
    ;;
esac

#!/bin/bash
# ============================================================
# Backend Power Mode — akses DBus power-profiles-daemon + signal waybar
# Tidak menyentuh EWW qs_powermode (card power mode sekarang frontend-only)
#
# Subcommand:
#   watch       — daemon: monitor DBus → signal waybar
#   cycle       — cycle profile + signal waybar
#   safe|balanced|performance — set profile langsung + signal waybar
#   get         — output current state: safe|balanced|performance
#   icon        — output Nerd Font icon sesuai current state
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
# Daemon background — monitor DBus + signal waybar
# Dipanggil init.sh pas eww start, jalan persistent
# NOTE: tidak update EWW qs_powermode (card sekarang frontend-only)
# ============================================================
cmd_watch() {
  local last=""

  emit() {
    local state
    state=$(get_state)
    if [ "$state" != "$last" ]; then
      last="$state"
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
# Subcommand: safe | balanced | performance
# Set profile langsung + signal waybar
# NOTE: tidak update EWW (frontend-only)
# ============================================================
cmd_safe() {
  powerprofilesctl set power-saver 2>/dev/null
  signal_waybar
}

cmd_balanced() {
  powerprofilesctl set balanced 2>/dev/null
  signal_waybar
}

cmd_performance() {
  powerprofilesctl set performance 2>/dev/null
  signal_waybar
}

# ============================================================
# Subcommand: cycle
# Cycle profile + signal waybar
# NOTE: tidak update EWW (frontend-only)
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
  watch)       cmd_watch ;;
  cycle)       cmd_cycle ;;
  safe)        cmd_safe ;;
  balanced)    cmd_balanced ;;
  performance) cmd_performance ;;
  get)         cmd_get ;;
  icon)        cmd_icon ;;
  *)
    echo "Usage: $0 {watch|cycle|safe|balanced|performance|get|icon}" >&2
    exit 1
    ;;
esac

#!/bin/bash
# ============================================================
# EWW OSD — Brightness
# Layout: [icon persentase] [======bar======]
# ============================================================

TIMER_LOCK="/tmp/eww-osd-timer.lock"
OSD_FLAG="/tmp/eww-osd-open.flag"

# ── Baca level brightness ───────────────────────────
BRIGHT=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
ICON=""
VALUE=$BRIGHT
PROGRESS=$BRIGHT

# ── Update EWW (progress = persentase, bukan pixel) ──
eww update osd_icon="$ICON" osd_value="$VALUE" osd_progress="$PROGRESS" 2>/dev/null

# ── Buka window hanya jika belum terbuka ────────────
if [ ! -f "$OSD_FLAG" ]; then
    eww open osd 2>/dev/null
fi
touch "$OSD_FLAG"

# ── Auto-close timer ────────────────────────────────
if [ -f "$TIMER_LOCK" ]; then
    kill "$(cat "$TIMER_LOCK")" 2>/dev/null
fi

(
    sleep 2
    eww close osd 2>/dev/null
    rm -f "$TIMER_LOCK" "$OSD_FLAG"
) &
echo $! > "$TIMER_LOCK"

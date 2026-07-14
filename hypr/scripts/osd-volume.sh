#!/bin/bash
# ============================================================
# EWW OSD — Volume
# Layout: [icon persentase] [======bar======]
# ============================================================

TIMER_LOCK="/tmp/eww-osd-timer.lock"
OSD_FLAG="/tmp/eww-osd-open.flag"

# ── Baca status volume ──────────────────────────────
OUTPUT=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
VOL=$(echo "$OUTPUT" | awk '{print $2}')

if echo "$OUTPUT" | grep -q 'MUTED'; then
    ICON=""
    VALUE=0
    PROGRESS=0
else
    VALUE=$(awk -v v="$VOL" 'BEGIN { printf "%.0f", v * 100 }')
    PROGRESS=$(awk -v v="$VOL" 'BEGIN { printf "%.0f", (v > 1.0 ? 100 : v * 100) }')
    ICON=$(awk -v v="$VOL" 'BEGIN {
        if (v <= 0.01) print ""
        else if (v < 0.33) print ""
        else if (v < 0.66) print ""
        else print ""
    }')
fi

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

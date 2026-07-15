#!/bin/bash
# ============================================================
# watch.sh — Pantau PipeWire sink-inputs & output JSON ke stdout
# Dipanggil oleh EWW deflisten, setiap baris = update variabel
# ============================================================

output_state() {
    pactl -f json list sink-inputs 2>/dev/null | jq -c '
[.[] | {
    index: .index,
    app_name: (.properties."application.name" // "Unknown"),
    app_binary: (.properties."application.process.binary" // "unknown"),
    mute: .mute,
    volume: (.volume | [.[].value_percent | rtrimstr("%") | tonumber] | add / length | floor),
    icon: (if .properties."application.process.binary" == "firefox" or .properties."application.process.binary" == "firefox-nightly" then "󰈹"
           elif .properties."application.process.binary" == "spotify" then ""
           elif .properties."application.process.binary" == "chromium" or .properties."application.process.binary" == "chrome" or .properties."application.process.binary" == "google-chrome" then ""
           elif .properties."application.process.binary" == "mpv" then ""
           elif .properties."application.process.binary" == "vlc" then "󰕼"
           elif .properties."application.process.binary" == "discord" then ""
           elif .properties."application.process.binary" == "slack" then ""
           elif .properties."application.process.binary" == "obs" then "󰑋"
           elif (.properties."application.name" // "") | test("speech"; "i") then "󰂞"
           else "" end)
}]
'
}

# Output initial state
output_state

# Pantau event PipeWire, re-query tiap ada perubahan sink-input
stdbuf -oL pactl subscribe 2>/dev/null | while read -r event; do
    case "$event" in
        *"sink-input"*)
            sleep 0.05
            output_state
            ;;
    esac
done

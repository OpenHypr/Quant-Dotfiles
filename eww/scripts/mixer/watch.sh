#!/bin/bash
# ============================================================
# watch.sh — Pantau PipeWire default sink & sink-inputs
# ============================================================

output_state() {
    local default_sink master apps

    # --- Master / system volume dari default sink ---
    default_sink=$(pactl get-default-sink 2>/dev/null)
    master=$(pactl -f json list sinks 2>/dev/null | jq -c --arg name "$default_sink" '
[.[] | select(.name == $name)] | first // {} | {
    index: "master",
    app_name: "System",
    app_binary: "system",
    mute: (.mute // false),
    volume: (if .volume then (.volume | [.[].value_percent | rtrimstr("%") | tonumber] | add / length | floor) else 0 end),
    icon: (if .mute then "󰝟" else "󰕾" end)
}')
    [ -z "$master" ] && master='{"index":"master","app_name":"System","app_binary":"system","mute":false,"volume":0,"icon":"󰕾"}'

    # --- Per-aplikasi sink-inputs ---
    apps=$(pactl -f json list sink-inputs 2>/dev/null | jq -c '
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
')
    [ -z "$apps" ] && apps='[]'

    jq -cn --argjson master "$master" --argjson apps "$apps" '{master: $master, apps: $apps}'
}

output_state
stdbuf -oL pactl subscribe 2>/dev/null | while read -r event; do
    case "$event" in
        *"sink"* | *"server"*) sleep 0.05; output_state ;;
    esac
done

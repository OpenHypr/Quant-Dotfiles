#!/bin/bash
# ============================================================
# watch-mic.sh — Pantau PipeWire default source & source-outputs
# Output JSON {master: {...}, apps: [...]}
# ============================================================

output_state() {
    local default_source master apps

    # --- Master mic dari default source ---
    default_source=$(pactl get-default-source 2>/dev/null)
    master=$(pactl -f json list sources 2>/dev/null | jq -c --arg name "$default_source" '
[.[] | select(.name == $name)] | first // {} | {
    index: 0,
    app_name: (.description // "Microphone"),
    app_binary: "mic",
    mute: (.mute // false),
    volume: (if .volume then (.volume | [.[].value_percent | rtrimstr("%") | tonumber] | add / length | floor) else 0 end),
    icon: (if .mute then "󰍭" else "󰍬" end)
}')
    [ -z "$master" ] && master='{"index":0,"app_name":"Microphone","app_binary":"mic","mute":false,"volume":0,"icon":"󰍬"}'

    # --- Source-outputs (aplikasi yg capture mic) ---
    apps=$(pactl -f json list source-outputs 2>/dev/null | jq -c '
[.[] | {
    index: .index,
    app_name: (.properties."application.name" // "Unknown"),
    app_binary: (.properties."application.process.binary" // "unknown"),
    mute: .mute,
    volume: (.volume | [.[].value_percent | rtrimstr("%") | tonumber] | add / length | floor),
    icon: (if .properties."application.process.binary" == "firefox" or .properties."application.process.binary" == "firefox-nightly" then "󰈹"
           elif .properties."application.process.binary" == "discord" then ""
           elif .properties."application.process.binary" == "obs" then "󰑋"
           elif .properties."application.process.binary" == "slack" then ""
           else "" end)
}]
')
    [ -z "$apps" ] && apps='[]'

    jq -cn --argjson master "$master" --argjson apps "$apps" '{master: $master, apps: $apps}'
}

output_state
stdbuf -oL pactl subscribe 2>/dev/null | while read -r event; do
    case "$event" in
        *"source"* | *"server"*) sleep 0.05; output_state ;;
    esac
done

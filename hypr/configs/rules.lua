-- WINDOW RULES
hl.window_rule({
    match = { class = "^(pavucontrol)$" },
    float = true,
    center = true,
})

hl.window_rule({
    match = { class = "^(nm-connection-editor)$" },
    float = true,
    center = true,
})

hl.window_rule({
    match = { class = "^(blueman-manager)$" },
    float = true,
    center = true,
})

hl.window_rule({
    match = { class = "^(org.gnome.Calculator)$" },
    float = true,
    center = true,
})

hl.window_rule({ match = { class = "^(code|code-oss)$" }, opacity = "0.90", rounding = 5 })

hl.window_rule({
    match = { class = "^(Spotify)$" },
    opacity = "0.80",
    rounding = 5,
    float = false,
    center = true,
    size = { 800, 600 },
})

hl.window_rule({
    match = { class = "^(kitty)$" },
    center = true,
    size = { 850, 500 },
})
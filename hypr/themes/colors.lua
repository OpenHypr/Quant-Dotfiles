local palette = require("./themes.palette")

hl.config({
    general = {
        col = {
            active_border = "rgba(d5c89a44)",
            inactive_border = "rgba(d5c89a4b)",
        },
    },
})

return {
    background = palette.bg_solid,
    foreground = palette.fg,
    transparent = "rgba(00000000)",
    accent2 = "rgba(f5c2e7ff)",
    black = "rgba(11111bff)",
    white = "rgba(ffffffff)",
    red = "rgba(f38ba8ff)",
    green = "rgba(a6e3a1ff)",
    yellow = "rgba(f9e2afff)",
    blue = "rgba(89b4faff)",
    purple = "rgba(cba6f7ff)",
    cyan = "rgba(94e2d5ff)",
}
-- GAPS, BORDERS, BLUR, AND SHADOW
hl.config({
    general = {
        gaps_in = 3,
        gaps_out = { top = 5, right = 5, bottom = 5, left = 5 },
        border_size = 1,
        resize_on_border = true,
        layout = "dwindle",
    },

    decoration = {
        rounding = 5,
        active_opacity = 1.0,
        inactive_opacity = 0.99,
        fullscreen_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 5,
            render_power = 9,
        },

        blur = {
            enabled = true,
            size = 10,
            passes = 3,
            vibrancy = 0.2,
        },
    },
})
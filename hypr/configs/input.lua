-- INPUT CONFIG
hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0.5,

        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            tap_to_click = true,
            scroll_factor = 1.0,
        },
    },
})

hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.3,
})
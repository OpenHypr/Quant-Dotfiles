# Hyprland Lua migration

This is an isolated migration of `~/.config/hypr/` to the Lua configuration
API used by Hyprland 0.56.2. The active `.conf` configuration remains
unchanged.

The folder structure and section organization follow the existing config:

```text
hypr-lua/
├── hyprland.lua
├── hyprpaper.conf
├── configs/
└── themes/
```

Hyprpaper has its own configuration format, so `hyprpaper.conf` intentionally
remains a `.conf` file. Supporting shell scripts and integrations are reused
from their existing locations under `~/.config/hypr/scripts/`, `eww/`,
`rofi/`, and `waybar/`.

To test this config, start a separate Hyprland session with:

```sh
start-hyprland -- --config ~/.config/hypr-lua/hyprland.lua
```

Do not use `hyprctl reload` to switch between configs; reload uses the config
path selected when the running Hyprland session started.
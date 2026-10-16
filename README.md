# Quant-Dotfiles

Hyprland-based Wayland desktop environment configuration, themed with a custom dark color scheme (Catppuccin Mocha-inspired: `#16161D` background, `#d5c89a` foreground, `#89b4fa` accent).

## Screenshots

<!-- TODO: Add screenshots -->
<!-- - Full desktop -->
<!-- - EWW control center -->
<!-- - EWW calendar popup -->
<!-- - EWW media popup -->
<!-- - Rofi launcher -->
<!-- - Spotify (Spicetify) -->

## Features

- **Window Manager**: Hyprland with dwindle layout, blur, shadows, and animations
- **Status Bar**: Waybar with workspaces, taskbar, MPRIS, clock, system tray, network, audio, CPU/memory/disk, battery, and power profiles
- **Widget System**: EWW control center (quick toggles, brightness/volume sliders, media player), calendar popup, media popup with album art, disk shortcuts popup
- **Clipboard Manager**: cliphist-based history with image preview and thumbnails via Rofi
- **Screenshot Workflow**: Full screen, window picker (with thumbnails), and area selection using grim + slurp, with notification actions
- **Wallpaper**: hyprpaper with Rofi-based selector/gallery
- **Terminal**: Kitty with transparency, blur, and powerline tab bar
- **Shell**: Fish with Starship prompt, eza, bat, ripgrep, zoxide
- **Launcher**: Rofi with drun mode and icon support
- **Spotify**: Spicetify with Turntable theme (blur, rotating cover art, custom FAD)
- **System Monitor**: btop with matcha-dark-sea theme
- **Audio Visualizer**: cava with GLSL shader support
- **Notifications**: SwayNC
- **Lock Screen**: hyprlock
- **Idle Management**: hypridle
- **Color Scheme**: Catppuccin Mocha palette — consistent across Hyprland, Waybar, EWW, Kitty, Rofi, Starship, Spicetify

## Components

| Component | Purpose | Config Location |
|-----------|---------|----------------|
| [Hyprland](./docs/components.md#hyprland) | Wayland compositor | `hypr/` |
| [Waybar](./docs/components.md#waybar) | Status bar | `waybar/` |
| [EWW](./docs/components.md#eww) | Widget system | `eww/` |
| [Fish](./docs/components.md#fish) | Shell | `fish/` |
| [Kitty](./docs/components.md#kitty) | Terminal emulator | `kitty/` |
| [Rofi](./docs/components.md#rofi) | Application launcher | `rofi/` |
| [Fastfetch](./docs/components.md#fastfetch) | System info | `fastfetch/` |
| [Starship](./docs/components.md#starship) | Shell prompt | `starship.toml` |
| [Spicetify](./docs/components.md#spicetify) | Spotify theming | `spicetify/` |
| [Cava](./docs/components.md#cava) | Audio visualizer | `cava/` |
| [Btop](./docs/components.md#btop) | System monitor | `btop/` |

Full component details: [docs/components.md](./docs/components.md)

## Shared Scripts

Semua script quick-settings self-contained di `eww/extension/quick-settings/scripts/` — tidak ada lagi folder `collab-scripts/` terpisah.

Arsitektur: EWW card ↔ `toggle-powermode.sh` (frontend cycle) → `power-mode.sh` (backend DBus) → `powerprofilesctl` → waybar signal.

## Installation

### Prerequisites

Arch Linux (or Arch-based distro) with an AUR helper (`yay` or `paru`).

### Core Packages

```bash
# Window manager and utilities
sudo pacman -S hyprland hyprpaper hypridle hyprlock hyprpicker hyprshade

# Status bar and widget system
sudo pacman -S waybar eww

# Notification daemon and logout
sudo pacman -S swaync wlogout

# Terminal and shell
sudo pacman -S kitty fish

# Launcher
sudo pacman -S rofi

# Clipboard
sudo pacman -S cliphist wl-clipboard

# Screenshot
sudo pacman -S grim slurp imagemagick

# Audio
sudo pacman -S wireplumber pamixer playerctl

# Hardware control
sudo pacman -S brightnessctl power-profiles-daemon

# Network and Bluetooth
sudo pacman -S networkmanager nm-connection-editor blueman

# Polkit
sudo pacman -S polkit-kde-agent

# Shell tools
sudo pacman -S fastfetch starship eza bat ripgrep zoxide neovim

# System monitor
sudo pacman -S btop

# Audio visualizer
sudo pacman -S cava

# Utilities
sudo pacman -S jq curl

# Fonts
sudo pacman -S ttf-jetbrains-mono-nerd ttf-cascadia-mono

# Desktop apps (optional keybind targets)
sudo pacman -S nautilus firefox code

# Spotify + theming
yay -S spotify spicetify-cli
```

### Deploy Config

```bash
# Clone
git clone <repo-url> ~/dotfiles

# Symlink all configs
for d in hypr waybar eww fish kitty rofi fastfetch cava btop spicetify; do
  ln -sf ~/dotfiles/$d ~/.config/$d
done
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml

# Apply Spicetify
spicetify backup apply
```

## Dependencies

Full dependency map: [docs/dependencies.md](./docs/dependencies.md)

### Quick Reference — Required

| Category | Packages |
|----------|----------|
| Compositor | hyprland, hyprpaper, hypridle, hyprlock, hyprpicker, hyprshade |
| UI | waybar, eww, rofi, swaync, wlogout |
| Shell | fish, kitty, starship, fastfetch |
| Media | wireplumber, pamixer, playerctl |
| Hardware | brightnessctl, networkmanager, blueman, power-profiles-daemon |
| Clipboard | cliphist, wl-clipboard |
| Screenshot | grim, slurp, imagemagick |
| Tools | jq, curl, polkit-kde-agent |
| Fonts | ttf-jetbrains-mono-nerd, ttf-cascadia-mono |
| CLI tools | eza, bat, ripgrep, zoxide, neovim |

### Optional

| Package | Used By | Notes |
|---------|---------|-------|
| hyprpanel | Hyprland | Panel (AUR). Launched alongside waybar — may conflict |
| nautilus | Hyprland | File manager keybind (`SUPER + X`) |
| code | Hyprland | VSCode keybind (`SUPER + C`) |
| firefox | Hyprland | Browser keybind (`SUPER + B`) |
| spotify | Hyprland | Spotify keybind (`SUPER + M`) |
| spicetify | Spotify | Theme injection |
| cava | Standalone | Audio visualizer |
| btop | Standalone | System monitor |
| discord | Hyprland | Commented out |
| nvidia drivers | Hyprland | Commented out env vars |

## Known Issues

1. **EWW daemon startup**: EWW is pre-launched as a daemon to prevent popup lag on first open. If popups lag, restart with `eww daemon`.
2. **hyprpanel + waybar dual launch**: `autostart.conf` launches both `waybar` and `hyprpanel`. This may cause visual conflicts or redundant panels. **Needs Manual Verification.**
3. **hyprpanel toggle keybind**: `SUPER + Q` runs `pkill hyprpanel || hyprpanel`. If waybar is the intended primary bar, this keybind will not toggle it — it only targets hyprpanel.
4. **Clipboard image thumbnails**: Require `imagemagick`. Without it, a generic icon displays instead.
5. **media-info.sh album art**: Requires network access. YouTube thumbnail fallback uses `i.ytimg.com` — may break if URLs change.
6. **Hardcoded wallpaper path**: `hyprpaper.conf` references `/home/xuanz/Pictures/wallpapers/605945.jpg`. Users must update or remove this file.
7. **Hardcoded monitor names**: `monitor.conf` uses `eDP-1` and `DP-1`. Users with different monitor names must update.
8. **Font dependency**: Multiple components require `JetBrainsMono Nerd Font`. Calendar clock requires `Terminess Nerd Font Mono`.
9. **polkit-kde-agent path**: Hardcoded to `/usr/lib/polkit-kde-authentication-agent-1`. Path may vary per distro.
10. **cava config**: All settings are commented out (effectively defaults). If cava doesn't work, uncomment the `method` setting for your audio system (pipewire/pulseaudio).

## Roadmap

- [ ] Add screenshots
- [ ] Add `install.sh` script
- [ ] Auto-detect monitor names at startup (replace hardcoded `eDP-1`/`DP-1`)
- [ ] Add GPU-specific config detection (NVIDIA vs Intel/AMD)
- [ ] Include wallpapers in repo
- [ ] Resolve hyprpanel/waybar dual-launch
- [ ] Add EWW battery widget
- [ ] Add hypridle config file (currently using defaults)
- [ ] Add hyprlock config file (currently using defaults)
- [ ] Generate keybind cheatsheet
- [ ] Add GTK theme setup instructions

#!/bin/bash
# Toggle swaync — auto-close QS saat swaync dibuka (mutual exclusion)
eww close quick-settings
swaync-client --toggle-panel

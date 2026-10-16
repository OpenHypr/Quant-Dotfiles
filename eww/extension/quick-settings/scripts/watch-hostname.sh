#!/bin/bash
# Emit username@hostname — dipakai deflisten power_menu
echo "$(whoami)@$(cat /etc/hostname)"

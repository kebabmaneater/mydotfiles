#!/bin/bash

set -e

DISPLAY_NAMES=(Lock Logout 'Power Off' Reboot Suspend)
COMMANDS=('loginctl lock-session' 'hyprctl dispatch exit' 'systemctl poweroff' 'systemctl reboot' 'systemctl suspend')
ICONS=(
        
        󰍃
        
        
        
)

MENU_ITEMS=()
for i in "${!DISPLAY_NAMES[@]}"; do
        MENU_ITEMS+=("${ICONS[i]} :text:${DISPLAY_NAMES[i]}")
done

CHOICE=$(printf '%s\n' "${MENU_ITEMS[@]}" | wofi --show dmenu -n --conf ~/.config/wofi/power_menu)

# Extract label from `text:...`
SELECTED_NAME="${CHOICE#*:text:}"

# Match selection and run command
for i in "${!DISPLAY_NAMES[@]}"; do
        if [[ "${DISPLAY_NAMES[i]}" == "$SELECTED_NAME" ]]; then
                eval "${COMMANDS[i]}"
                break
        fi
done

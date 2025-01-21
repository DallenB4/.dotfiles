#!/run/current-system/sw/bin/bash
playerctl -a pause
pkill -9 -f hyprlock
touch ~/hyprlock.log
hyprlock --verbose &> ~/hyprlock.log

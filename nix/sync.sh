#!/run/current-system/sw/bin/bash
# pkill -9 -f .ags-wrapped; pwait ags &> /dev/null; echo "Restarting ags" && ags &> ~/ags.log &
pkill -9 -f waybar; nohup waybar &> /dev/null &

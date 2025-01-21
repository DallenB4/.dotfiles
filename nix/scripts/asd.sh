#!/bin/sh
hyprctl dispatch exec -- "[group;silent;monitor DP-2]" alacritty -e 'sh -c "sleep 0.4; cmatrix -ab; zsh"'
sleep 0.3
hyprctl dispatch exec -- "[group barred;silent;monitor DP-2]" alacritty -e 'sh -c "cava;zsh"'
sleep 0.2
hyprctl dispatch resizewindowpixel "0 400,title:^(cava)$"
sleep 0.2
hyprctl dispatch focusmonitor DVI-I-1
hyprctl dispatch exec -- "[group barred;silent;monitor DVI-I-1]" alacritty -e 'sh -c "
neofetch
tput civis
read -n1 -s -r
tput cnorm
zsh"'
sleep 0.2
hyprctl dispatch exec -- "[group;monitor DVI-I-1]" alacritty -e 'sh -c "
echo -ne \"\e[32m\"
figlet \"Hello, Dallen!\" -f smslant
figlet \"Hello, Dallen!\" -f smscript
figlet \"Hello, Dallen!\" -f small
echo
figlet \"Hello, Dallen!\" -f shadow
figlet \"Hello, Dallen!\" -f standard
tput civis
read -n1 -s -r
tput cnorm
zsh"'
sleep 0.2
hyprctl dispatch resizeactive "0 -300"
hyprctl dispatch focusmonitor DP-1

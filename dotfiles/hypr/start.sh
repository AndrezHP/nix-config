#!/usr/bin/env bash

swww init &
swww img ~/nix-config/dotfiles/wallpaper/garden.png &

nm-applet --indicator &

#eww &
waybar &

noisetorch -i &

#mako
dunst

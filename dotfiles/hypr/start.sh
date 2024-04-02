#!/usr/bin/env bash

swww init &
swww img ~/nix-config/home-manager/wallpapers/garden.png &

nm-applet --indicator &

#eww &
waybar &

noisetorch -i &

#mako
dunst

#!/usr/bin/env sh

theme="$HOME/nix-config/dotfiles/rofi/capture.rasi"

CHOICE=$(printf "active window\nactive monitor\nselect window\nselect region" | rofi -dmenu -p "Screenshot:" -theme ${theme})
case ''${CHOICE} in
    "active window")
    hyprshot -m window -m active
    ;;
    "active monitor")
    hyprshot -m output -m active
    ;;
    "select window")
    hyprshot -m window
    ;;
    "select region")
    hyprshot -m region
    ;;
esac

#!/usr/bin/env sh

theme="$HOME/nix-config/dotfiles/rofi/capture.rasi"

choice=$(printf "active window\nactive monitor\nselect window\nselect region" | rofi -dmenu -p "Screenshot:" -theme ${theme})

case ''$1 in
    "-s") flag="-o ~/Media/Screenshots" ;;
    "-c") flag="--clipboard-only" ;;
esac

case ''${choice} in
    "active window") hyprshot -m window $flag -m active ;;
    "active monitor") hyprshot -m output $flag -m active ;;
    "select window") hyprshot -m window $flag ;;
    "select region") hyprshot -m region $flag ;;
esac

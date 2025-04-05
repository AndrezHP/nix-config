#!/usr/bin/env sh
dir="$HOME/.config/rofi/"
theme='launcher-1'
rofi -show drun -matching fuzzy -theme ${dir}/${theme}.rasi

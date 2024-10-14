#!/usr/bin/fish

set wallpapers "$HOME/.local/share/wallpapers/wallpapers-ultrawide"
set wallpaper (eza $wallpapers | shuf -n 1)

set image $wallpapers/$wallpaper

echo $image

convert $image -resize 3440x1440 /tmp/wallpaper.png
i3lock --nofork -i /tmp/wallpaper.png


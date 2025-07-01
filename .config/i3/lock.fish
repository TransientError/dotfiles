#!/usr/bin/fish

set wallpapers "$HOME/.local/share/wallpapers/wallpapers-ultrawide"
set wallpaper (eza $wallpapers | shuf -n 1)

set wpsv "$HOME/.local/share/wallpapers/wp-vert-d"
set wpv (eza $wpsv | shuf -n 1)

set image $wallpapers/$wallpaper
set imagev $wpsv/$wpv

echo $image

convert $image -resize 3440x1440 /tmp/wallpaper.png
convert $imagev -resize 1440x2560 /tmp/wallpaper-vert.png

magick /tmp/wallpaper.png /tmp/wallpaper-vert.png -gravity east +append /tmp/lock.png

i3lock --nofork -i /tmp/lock.png


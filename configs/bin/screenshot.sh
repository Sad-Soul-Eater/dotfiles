#!/usr/bin/env bash

SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP="$(date +%Y.%m.%d-%H.%M.%S)"
FILENAME="${SCREENSHOTS_DIR}/${TIMESTAMP}.screenshot.png"
ICON_PATH="gnome-screenshot"
IMG_V="xdg-open"

full() {
	maim --hidecursor --quality 9 "$FILENAME"
	xclip -selection clipboard -t image/png "$FILENAME"
	notify-send "Screenshot taken." -t 500 --urgency low -i $ICON_PATH
}

full_cl() {
	maim --hidecursor --quality 3 "/tmp/maim_clipboard.png"
	xclip -selection clipboard -t image/png "/tmp/maim_clipboard.png"
	notify-send "Copied to clipboard." -t 500 --urgency low -i $ICON_PATH
	rm "/tmp/maim_clipboard.png"
}

area() {
	notify-send 'Select area to capture.' --urgency low -i $ICON_PATH
	maim --hidecursor --quality 9 -s "$FILENAME"
	xclip -selection clipboard -t image/png "$FILENAME"
	notify-send "Screenshot taken." -t 500 --urgency low -i $ICON_PATH
}

area_cl() {
	notify-send 'Select area to copy to clipboard.' -t 500 --urgency low -i $ICON_PATH
	maim --hidecursor --quality 3 -s "/tmp/maim_clipboard.png"
	xclip -selection clipboard -t image/png "/tmp/maim_clipboard.png"
	notify-send "Copied selection to clipboard." -t 500 --urgency low -i $ICON_PATH
	rm "/tmp/maim_clipboard.png"
}

open() {
	cd "$SCREENSHOTS_DIR" || exit 1
	$IMG_V "$(find . -maxdepth 1 -type f -printf '%T@ %f\n' | sort -r | cut -d' ' -f2- | head -1)" &
}

edit() {
	cd "$SCREENSHOTS_DIR" || exit 1
	gimp "$(find . -maxdepth 1 -type f -printf '%T@ %f\n' | sort -r | cut -d' ' -f2- | head -1)" &
	notify-send 'Opening last screenshot with GIMP' -t 500 --urgency low -i $ICON_PATH
}

usage() {
	echo "Usage: ./screenshot.sh [options]
Options:
-h  open this page
-f  full screenshot
-g  full screenshot to clipboard
-a  area screenshot
-c  area screenshot to clipboard
-o  open last screenshot
-e  edit last screenshot"
}

if [[ "$1" == "" ]]; then
	usage
	exit 0
fi

while getopts "fgacoeh" OPTION; do
	case "$OPTION" in
	f)
		full
		;;
	g)
		full_cl
		;;
	a)
		area
		;;
	c)
		area_cl
		;;
	o)
		open
		;;
	e)
		edit
		;;
	h)
		usage
		;;
	*)
		usage
		exit 1
		;;
	esac
done

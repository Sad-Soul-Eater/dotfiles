#!/usr/bin/env bash

SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP="$(date +%Y.%m.%d-%H.%M.%S)"
FILENAME="${SCREENSHOTS_DIR}/${TIMESTAMP}.screenshot.jpg"
ICON_PATH="gnome-screenshot"
IMG_V="xdg-open"

full() {
	flameshot gui --region all --path "$FILENAME"
}

full_cl() {
	flameshot gui --region all --clipboard
}

area() {
	flameshot gui --path "$FILENAME"
}

area_cl() {
	flameshot gui --clipboard
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

check_dir() {
	if [ ! -d "$SCREENSHOTS_DIR" ]; then
		mkdir -p "$SCREENSHOTS_DIR"
	fi
}

if [[ "$1" == "" ]]; then
	usage
	exit 0
fi

while getopts "fgacoeh" OPTION; do
	case "$OPTION" in
	f)
		check_dir
		full
		;;
	g)
		check_dir
		full_cl
		;;
	a)
		check_dir
		area
		;;
	c)
		check_dir
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

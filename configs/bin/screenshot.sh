#!/usr/bin/env bash
# Screenshot wrapper
# Uses maim (which uses slop)
# "Friendship ended with scrot. Now maim is my best friend."

SCREENSHOTS_DIR=~/Pictures/Screenshots
TIMESTAMP="$(date +%Y.%m.%d-%H.%M.%S)"
FILENAME=${SCREENSHOTS_DIR}/${TIMESTAMP}.screenshot.png
ICON_PATH=/usr/share/icons/Flat-Remix-Blue-Dark/devices/scalable/cs-screen.svg
IMG_V=xdg-open

# -u option hides cursor
# -m option changes the compression level
# -m 3 takes the shot faster but the file size is slightly bigger

if [[ "$1" == "-s" ]]; then
	# Area/window selection.
	notify-send 'Select area to capture.' --urgency low -i $ICON_PATH
	maim -u -m 3 -s "$FILENAME"
	notify-send "Screenshot taken." --urgency low -i $ICON_PATH
elif [[ "$1" == "-c" ]]; then
	notify-send 'Select area to copy to clipboard.' --urgency low -i $ICON_PATH
	# Copy selection to clipboard
	maim -u -m 9 -s /tmp/maim_clipboard
	xclip -selection clipboard -t image/png /tmp/maim_clipboard
	notify-send "Copied selection to clipboard." --urgency low -i $ICON_PATH
	rm /tmp/maim_clipboard
elif [[ "$1" == "-b" ]]; then
	# Browse with feh
	cd $SCREENSHOTS_DIR || return
	$IMG_V "$(find . -maxdepth 1 -type f -printf '%T@ %f\n' | sort -r | cut -d' ' -f2- | head -1)" &
elif [[ "$1" == "-e" ]]; then
	# Edit last screenshot with GIMP
	cd $SCREENSHOTS_DIR || return
	gimp "$(find . -maxdepth 1 -type f -printf '%T@ %f\n' | sort -r | cut -d' ' -f2- | head -1)" &
	notify-send 'Opening last screenshot with GIMP' --urgency low -i $ICON_PATH
else
	# Full screenshot
	maim -u -m 3 "$FILENAME"
	xclip -selection clipboard -t image/png "$FILENAME"
	notify-send "Screenshot taken." --urgency low -i $ICON_PATH
fi

#!/usr/bin/env bash

calc() {
	rofi -show calc -modi calc -no-show-match -no-sort -calc-command "echo '{result}' | xclip" -lines 12 -width 768
}

drun() {
	rofi -show drun -modi drun,window,run -lines 12 -width 1152 -columns 3 -sidebar-mode -show-icons true
}

clip() {
	CM_HISTLENGTH=20 CM_LAUNCHER=rofi CM_DIR=~/.cache/clipmenu clipmenu -i -p "clipmenu" -width 768
}

nm() {
	networkmanager_dmenu -width 300
}

power() {
	ACTION_LIST="lock\nsuspend\nlogout\nreboot\nshutdown"

	_rofi() {
		rofi -dmenu -i -sync -p "sys" -width 115 -lines 5
	}

	SELECTED_STRING=$(echo -e "$ACTION_LIST" | _rofi)
	if [ "$SELECTED_STRING" == "lock" ]; then
		betterlockscreen -l dim -t "Don't touch my machine!"
	elif [ "$SELECTED_STRING" == "suspend" ]; then
		betterlockscreen -s dim -t "Don't touch my machine!"
	elif [ "$SELECTED_STRING" == "logout" ]; then
		i3-msg exit
	elif [ "$SELECTED_STRING" == "reboot" ]; then
		systemctl reboot
	elif [ "$SELECTED_STRING" == "shutdown" ]; then
		systemctl poweroff
	fi
}

screenshot() {
	ACTION_LIST="area to clipboard\narea\nopen last\nedit last\nfull\nfull to clipboard"
	SCRIPT="$(dirname "$(readlink -f "$0")")"/screenshot.sh

	_rofi() {
		rofi -dmenu -i -sync -p "screen" -width 175 -lines 6
	}

	SELECTED_STRING=$(echo -e "$ACTION_LIST" | _rofi)
	if [ "$SELECTED_STRING" == "full" ]; then
		$SCRIPT -f
	elif [ "$SELECTED_STRING" == "full to clipboard" ]; then
		$SCRIPT -g
	elif [ "$SELECTED_STRING" == "area" ]; then
		$SCRIPT -a
	elif [ "$SELECTED_STRING" == "area to clipboard" ]; then
		$SCRIPT -c
	elif [ "$SELECTED_STRING" == "open last" ]; then
		$SCRIPT -o
	elif [ "$SELECTED_STRING" == "edit last" ]; then
		$SCRIPT -e
	fi
}

emoji() {
	rofimoji --rofi-args "-lines 20 -width 1344 -columns 2"
}

usage() {
	echo "Usage: ./rofi.sh [options]
Options:
-h  open this page
-c  calc
-d  drun, run, window
-l  clipmenu
-n  NetworkManager
-p  power menu
-s  screenshot menu
-e  emoji picker"
}

if [[ "$1" == "" ]]; then
	usage
	exit 0
fi

while getopts "cdlnpseh" OPTION; do
	case "$OPTION" in
	c)
		calc
		;;
	d)
		drun
		;;
	l)
		clip
		;;
	n)
		nm
		;;
	p)
		power
		;;
	s)
		screenshot
		;;
	e)
		emoji
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

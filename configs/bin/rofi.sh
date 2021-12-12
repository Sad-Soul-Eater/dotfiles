#!/usr/bin/env bash

calc() {
	rofi -show calc -modi calc -no-show-match -no-sort -theme-str 'window {width: 30%;}' -calc-command "printf '{result}' | xclip -selection clipboard"
}

drun() {
	rofi -show drun -modi drun,window,run -sidebar-mode -show-icons true -theme-str 'window {width: 60%;} listview {columns: 5;}'
}

clip() {
	CM_HISTLENGTH=20 CM_LAUNCHER=rofi CM_DIR=~/.cache/clipmenu clipmenu -i -p "clipmenu" -theme-str 'window {width: 60%;} listview {columns: 2;}'
}

nm() {
	networkmanager_dmenu -theme-str 'window {width: 20%;}'
}

power() {
	ACTION_LIST="lock\nsuspend\nlogout\nreboot\nshutdown"

	_rofi() {
		rofi -dmenu -i -sync -p "sys" -theme-str 'window {width: 5%;} listview {lines: 5;}'
	}

	SELECTED_STRING=$(echo -e "$ACTION_LIST" | _rofi)
	if [ "$SELECTED_STRING" == "lock" ]; then
		betterlockscreen -l dim
	elif [ "$SELECTED_STRING" == "suspend" ]; then
		betterlockscreen -s dim
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
		rofi -dmenu -i -sync -p "shot" -theme-str 'window {width: 10%;} listview {lines: 6;}'
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
	rofimoji --rofi-args "-theme-str 'window {width: 60%;} listview {columns: 3;}'"
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

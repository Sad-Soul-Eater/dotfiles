#!/bin/bash

calc () {
	rofi -show calc -modi calc -bw 2 -lines 12 -width 60 -columns 3
}

drun () {
	rofi -show drun -modi drun,window,run -bw 2 -lines 12 -width 60 -columns 3 -sidebar-mode -show-icons true
}

clip () {
	CM_HISTLENGTH=20 CM_LAUNCHER=rofi CM_DIR=~/.cache/clipmenu clipmenu -p "clipmenu" -width 40
}

nm () {
	networkmanager_dmenu -width 15
}

power () {
	ACTION_LIST="lock\nsuspend\nlogout\nreboot\nshutdown"

	_rofi () {
		rofi -dmenu -i -sync -p "sys" -width 6 -lines 5
	}

	SELECTED_STRING=$(echo -e "$ACTION_LIST" | _rofi "$@")
	if [ "$SELECTED_STRING" == "lock" ]; then
		betterlockscreen -l dimblur -t "Don't touch my machine!"
	elif [ "$SELECTED_STRING" == "suspend" ]; then
		systemctl suspend
	elif [ "$SELECTED_STRING" == "logout" ]; then
		i3-msg exit
	elif [ "$SELECTED_STRING" == "reboot" ]; then
		systemctl reboot
	elif [ "$SELECTED_STRING" == "shutdown" ]; then
		systemctl poweroff
	fi
}

screenshot (){
	ACTION_LIST="full\narea\nopen last\narea to clip"
	SCRIPT=$(dirname $(readlink -f $0))/screenshot.sh

	_rofi () {
		rofi -dmenu -i -sync -p "screen" -width 8 -lines 4
	}

	SELECTED_STRING=$(echo -e "$ACTION_LIST" | _rofi "$@")
	if [ "$SELECTED_STRING" == "full" ]; then
		$SCRIPT
	elif [ "$SELECTED_STRING" == "area" ]; then
		$SCRIPT -s
	elif [ "$SELECTED_STRING" == "open last" ]; then
		$SCRIPT -b
	elif [ "$SELECTED_STRING" == "area to clip" ]; then
		$SCRIPT -c
  fi
}

usage () {
	echo "-h	open this page
-c	open calc in rofi
-d	open drun, run, window in rofi
-l	open clipmenu in rofi
-n	open NetworkManager in rofi
-p	power menu
-s	screenshot menu"
}

while getopts "cdlnhps" OPTION; do
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
		h)
			usage
			exit 1
			;;
	esac
done

shift "$(($OPTIND -1))"

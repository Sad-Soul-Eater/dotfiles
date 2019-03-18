#!/bin/bash

calc() {
    rofi -show calc -modi calc -lines 12 -width 768 -columns 3
}

drun() {
    rofi -show drun -modi drun,window,run -lines 12 -width 1152 -columns 3 -sidebar-mode -show-icons true
}

clip() {
    CM_HISTLENGTH=20 CM_LAUNCHER=rofi CM_DIR=~/.cache/clipmenu clipmenu -p "clipmenu" -width 768
}

nm() {
    networkmanager_dmenu -width 250
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
        systemctl suspend
    elif [ "$SELECTED_STRING" == "logout" ]; then
        i3-msg exit
    elif [ "$SELECTED_STRING" == "reboot" ]; then
        systemctl reboot
    elif [ "$SELECTED_STRING" == "shutdown" ]; then
        systemctl poweroff
    fi
}

screenshot() {
    ACTION_LIST="full\narea\nopen last\narea to clip"
    SCRIPT="$(dirname "$(readlink -f "$0")")"/screenshot.sh

    _rofi() {
        rofi -dmenu -i -sync -p "screen" -width 150 -lines 4
    }

    SELECTED_STRING=$(echo -e "$ACTION_LIST" | _rofi)
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

emoji() {
    rofi -show emoji -modi emoji -lines 20 -width 1344 -columns 3
}

usage() {
    echo "-h  open this page
-c  calc
-d  drun, run, window
-l  clipmenu
-n  NetworkManager
-p  power menu
-s  screenshot menu
-e  emoji picker"
}

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

shift "$((OPTIND - 1))"

#!/usr/bin/env bash

(
	flock 200

	killall -q polybar

	while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

	outputs=$(xrandr --query | grep " connected" | cut -d" " -f1)
	tray_output='eDP-1-0'

	for m in $outputs; do
		if [[ $m == "eDP" ]]; then
			tray_output=$m
		fi
	done

	for m in $outputs; do
		export MONITOR=$m
		export TRAY_POSITION=none
		if [[ $m == "$tray_output" ]]; then
			TRAY_POSITION=right
		fi

		polybar base </dev/null >/var/tmp/polybar-"$m".log 2>&1 200>&- &
		disown
	done
) 200>/var/tmp/polybar-launch.lock

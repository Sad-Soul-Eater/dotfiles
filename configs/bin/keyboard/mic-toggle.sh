#!/usr/bin/env bash

DEFAULT_SOURCE="$(pactl get-default-source)"

pactl set-source-mute "$DEFAULT_SOURCE" toggle

NOTIFICATION_ICON=''
NOTIFICATION_BODY=''

if [[ "$(pactl get-source-mute "$DEFAULT_SOURCE" | grep --only-matching --perl-regexp '(?<=Mute: ).+')" == "yes" ]]; then
	NOTIFICATION_ICON='microphone-sensitivity-muted'
	NOTIFICATION_BODY='Muted'
else
	NOTIFICATION_ICON='microphone-sensitivity-high'
	NOTIFICATION_BODY='Unmuted'
fi

notify-send --icon "$NOTIFICATION_ICON" --expire-time 1000 'Microphone' "$NOTIFICATION_BODY"

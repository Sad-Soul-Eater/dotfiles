#!/usr/bin/env bash

DEVICE_ID="$(xinput list | grep Touchpad | head | grep --only-matching --perl-regexp '(?<=id=)\d+')"

NOTIFICATION_ICON=''
NOTIFICATION_BODY=''

if [[ "$(xinput list-props "$DEVICE_ID" | grep --only-matching 'Device Enabled.*' | grep --only-matching --perl-regexp '\d$')" == '1' ]]; then
	xinput disable "$DEVICE_ID"

	NOTIFICATION_ICON='touchpad-disabled'
	NOTIFICATION_BODY='Disabled'
else
	xinput enable "$DEVICE_ID"

	NOTIFICATION_ICON='touchpad'
	NOTIFICATION_BODY='Enabled'
fi

notify-send --icon "$NOTIFICATION_ICON" --expire-time 1000 'Touchpad' "$NOTIFICATION_BODY"

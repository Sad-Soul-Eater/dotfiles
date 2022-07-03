#!/usr/bin/env bash

NOTIFICATION_ICON=''
NOTIFICATION_BODY=''

if [[ "$(asusctl profile --profile-get | grep --only-matching --perl-regexp '(?<=Active profile is ).+')" == 'Balanced' ]]; then
	asusctl profile --profile-set Performance

	NOTIFICATION_ICON='power-profile-performance-symbolic'
	NOTIFICATION_BODY='Perfomance'
else
	asusctl profile --profile-set Balanced

	NOTIFICATION_ICON='power-profile-balanced-symbolic'
	NOTIFICATION_BODY='Balanced'
fi

notify-send --icon "$NOTIFICATION_ICON" --expire-time 1000 'Power Profile' "$NOTIFICATION_BODY"

#!/usr/bin/env bash

if [[ "$(pactl get-source-mute "$(pactl get-default-source)" | grep --only-matching --perl-regexp '(?<=Mute: ).+')" == 'yes' ]]; then
	echo ''
else
	echo ''
fi

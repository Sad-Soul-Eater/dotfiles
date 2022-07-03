#!/usr/bin/env bash

coproc acpi_listen
trap 'kill $COPROC_PID' EXIT

while read -u "${COPROC[0]}" -a event; do
	if [[ "$(grep '^button/micmute' --only-matching <<< "${event[@]}")" == 'button/micmute' ]]; then
		"$HOME/bin/keyboard/mic-toggle.sh"
	fi
done

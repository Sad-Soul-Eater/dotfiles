#!/usr/bin/env bash

ICON=''

targets=($(upower -e | grep 'headset'))


result=''
for target in "${targets[@]}"; do
	if [[ -n "${result}" ]]; then
		result+=' '
	fi

	result+="$ICON $(upower -i "${target}" | grep --perl-regexp --only-matching '\d+(?=%)')%"
done

echo "$result"

#!/usr/bin/env bash

declare -A files
for file in "$@"; do
	files+=(["$file"]=$(stat --printf="%s" -- "$file"))
done

max=0
maxName=""
for file in "${!files[@]}"; do
	if [[ "${files[$file]}" > $max ]]; then
		max=${files[$file]}
		maxName="$file"
	fi
done

for file in "$@"; do
	if [[ ! "$file" == "$maxName" ]]; then
		rm -- "$file"
	fi
done

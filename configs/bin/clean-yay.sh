#!/bin/env bash

cd "$HOME/.cache/yay" || exit
CACHE_LIST=$(mktemp)
INSTALLED_LIST=$(mktemp)
DIRS_TO_RM=$(mktemp)

cd "$HOME/.cache/yay" || exit
fd --type=directory --max-depth=1 >"$CACHE_LIST"
yay -Qq >"$INSTALLED_LIST"
diff -u "$INSTALLED_LIST" "$CACHE_LIST" | grep -oP "(?<=^\+).*" | grep -vP "(?<=^\+).*" >"$DIRS_TO_RM"

if [ -s "$DIRS_TO_RM" ]; then
	echo "Founded unneeded folders:"
	cat "$DIRS_TO_RM"
	echo ""
	read -rp "Delete them? <Y/n> " prompt
	if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" || $prompt == "" ]]; then
		cd "$HOME/.cache/yay" || exit
		xargs -a "$DIRS_TO_RM" rm -rfv
	fi
else
	echo "No unneeded folders found!"
fi

rm "$CACHE_LIST" "$INSTALLED_LIST" "$DIRS_TO_RM"

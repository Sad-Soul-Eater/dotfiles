#!/usr/bin/env bash

echo -e "Update starting!"

TT_RSS_FOLDER="/var/www/tt-rss"
PLUGINS_FOLDER="$TT_RSS_FOLDER/plugins.local"
THEMES_FOLDER="$TT_RSS_FOLDER/themes.local"

REPOS=()
REPOS+=("$TT_RSS_FOLDER")
# Get themes and plugins git repos with remote
mapfile -t -O "${#REPOS[@]}" REPOS < <(find $PLUGINS_FOLDER/*/.git/refs/remotes -maxdepth 0 -type d 2>/dev/null | sed 's/\(.*\)\/\.git\/refs\/remotes$/\1/')
mapfile -t -O "${#REPOS[@]}" REPOS < <(find $THEMES_FOLDER/*/.git/refs/remotes -maxdepth 0 -type d 2>/dev/null | sed 's/\(.*\)\/\.git\/refs\/remotes$/\1/')

printf "Stopping tt-rss serevice... "
systemctl stop tt-rss.service
printf "ok\n\n"

for REPO in "${REPOS[@]}"; do
	echo "Getting latest for *** $REPO  ***"
	git -C "$REPO" pull --rebase
	echo ""
done

printf "Fixing permissions..."
chown -R www-data:www-data "$TT_RSS_FOLDER"
printf "ok\n\n"

printf "Starting tt-rss serevice... "
systemctl start tt-rss.service
printf "ok\n"

echo "Update completed!"

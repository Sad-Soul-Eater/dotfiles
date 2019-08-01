#!/usr/bin/env bash

fail() {
	echo "Update failed"
	exit 1
}

echo "Update starting!"

DOWNLOAD_SCRIPT="$(dirname "$(readlink -f "$0")")/downloaders/download-latest-release-from-github.sh"

DIR="/home/git/gitea"
FILE="gitea"
REGEX="browser_download_url.*gitea-.*-linux-amd64\"$"
OPTS="--dir=$DIR --out=$FILE.new"

if [ -f "$DOWNLOAD_SCRIPT" ]; then
	# shellcheck disable=SC1090
	if ! . "$DOWNLOAD_SCRIPT" "go-gitea/gitea" "$REGEX" "$OPTS"; then
		fail
	fi
else
	echo "Error: Download script not found"
	fail
fi

printf "Stopping Gitea serevice..."
if ! systemctl stop gitea.service; then
	fail
fi
printf " ok\n"

printf "Moving Gitea bin..."
rm "$DIR/$FILE"
if ! mv "$DIR/$FILE.new" "$DIR/$FILE"; then
	fail
fi
printf " ok\n"

printf "Fixing permissions..."
if ! chmod +x "$DIR/$FILE"; then
	fail
fi
if ! chown -R git:git "$DIR/$FILE"; then
	fail
fi
printf " ok\n"

printf "Starting Gitea serevice..."
if ! systemctl start gitea.service; then
	fail
fi
printf " ok\n"

echo "Update completed!"

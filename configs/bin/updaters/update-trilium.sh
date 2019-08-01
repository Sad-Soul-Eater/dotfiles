#!/usr/bin/env bash

fail() {
	echo "Update failed"
	exit 1
}

echo "Update starting!"

DOWNLOAD_SCRIPT="$(dirname "$(readlink -f "$0")")/downloaders/download-latest-release-from-github.sh"

DIR="/home/trilium"
FILE="trilium.tar.xz"
REGEX="browser_download_url.*trilium-linux-x64-server-.*\.tar\.xz"
OPTS="--dir=$DIR --out=$FILE"

if [ -f "$DOWNLOAD_SCRIPT" ]; then
	# shellcheck disable=SC1090
	if ! . "$DOWNLOAD_SCRIPT" "zadam/trilium" "$REGEX" "$OPTS"; then
		fail
	fi
else
	echo "Error: Download script not found"
	fail
fi

printf "Stopping Trilium serevice..."
if ! systemctl stop trilium.service; then
	fail
fi
printf " ok\n"

printf "Extracting archive..."
if ! tar -xJf "$DIR/$FILE"; then
	fail
fi
rm "$DIR/$FILE"
printf " ok\n"

printf "Fixing permissions..."
if ! chown -R trilium:trilium "$DIR/trilium-linux-x64-server"; then
	fail
fi
printf " ok\n"

printf "Starting Trilium serevice..."
if ! systemctl start trilium.service; then
	fail
fi
printf " ok\n"

echo "Update completed!"

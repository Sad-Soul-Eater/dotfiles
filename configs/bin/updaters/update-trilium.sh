#!/usr/bin/env bash

fail() {
	echo "Update failed"
	exit 1
}

echo "Update starting!"

TRILIUM_HOME="/home/trilium"
DOWNLOAD_SCRIPT="$(dirname "$(readlink -f "$0")")/downloaders/download-latest-release-from-github.sh"

cd "$TRILIUM_HOME" || fail

if [ -f "$DOWNLOAD_SCRIPT" ]; then
	# shellcheck disable=SC1090
	if ! . "$DOWNLOAD_SCRIPT" "zadam/trilium" "browser_download_url.*trilium-linux-x64-server-.*\.tar\.xz"; then
		fail
	fi
else
	echo "Error: Download script not found"
	fail
fi

printf "Stopping Trilium serevice... "
if ! systemctl stop trilium.service; then
	fail
fi

printf "Extracting archive... "
if ! tar -xJf trilium-linux-x64-server-*.tar.xz; then
	fail
fi

rm trilium-linux-x64-server-*.tar.xz

printf "Fixing permissions..."
if ! chown -R trilium:trilium "./trilium-linux-x64-server"; then
	fail
fi

printf "Starting Trilium serevice... "
if ! systemctl start trilium.service; then
	fail
fi

echo "Update completed!"

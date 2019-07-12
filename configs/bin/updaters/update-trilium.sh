#!/usr/bin/env bash

DOWNLOAD_SCRIPT="$(dirname "$(readlink -f "$0")")/downloaders/download-latest-release-from-github.sh"

cd /home/trilium || exit 1

if [ -f "$DOWNLOAD_SCRIPT" ]; then
	# shellcheck disable=SC1090
	. "$DOWNLOAD_SCRIPT" "zadam/trilium" "browser_download_url.*trilium-linux-x64-server-.*\.tar\.xz"
else
	exit 1
fi

systemctl stop trilium.service

tar -xJf trilium-linux-x64-server-*.tar.xz
rm trilium-linux-x64-server-*.tar.xz

chown -R trilium:trilium ./trilium-linux-x64-server

systemctl start trilium.service

#!/usr/bin/env bash

usage() {
	echo "Usage: ./download-latest-release-from-github.sh \"github_repo\" \"grep_regex\""
}

if [ -z "$1" ]; then
	usage
	exit 0
fi
REPO="$1"

if [ -z "$2" ]; then
	usage
	exit 1
fi
REGEX="$2"

URL=$(curl -s https://api.github.com/repos/"$REPO"/releases/latest | grep "$REGEX")
if [ "$URL" = "" ]; then
	exit 1
fi
echo "$URL" | cut -d '"' -f 4 | wget -qi -

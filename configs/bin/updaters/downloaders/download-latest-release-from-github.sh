#!/usr/bin/env bash

usage() {
	echo "Usage: ./download-latest-release-from-github.sh \"github_repo\" \"grep_regex\" \"aria2c_options\""
}

if [ -z "$1" ]; then
	echo "Error: missing github repository"
	usage
	exit 0
fi
REPOSITORY="$1"

if [ -z "$2" ]; then
	echo "Error: missing regex for grep"
	usage
	exit 1
fi
REGEX="$2"

OPTS="$3"

URL_REGEX="(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]"

URL=$(curl -s https://api.github.com/repos/"$REPOSITORY"/releases/latest | grep "$REGEX" | cut -d '"' -f 4)

if [ -z "$URL" ]; then
	echo "Error: wrong regex: grep result is empty"
	exit 1
fi

if ! [[ "$URL" =~ $URL_REGEX ]]; then
	echo "Error: wrong regex: grep result is not url:"
	echo "$URL"

	exit 1
fi

echo "Download starting..."
if ! aria2c --console-log-level=error $OPTS "$URL"; then
	echo "Downloading failed"
	exit 1
fi
echo "Download completed"

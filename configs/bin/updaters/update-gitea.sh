#!/usr/bin/env bash

# ~ Config section begin ~

DIR="/home/git/gitea"
FILE="gitea"

# ~ Config section end ~

fail() {
	echo "Update failed"
	exit 1
}

echo "Starting..."

RELEASES_FILE=$(mktemp)

curl --silent --output "$RELEASES_FILE" https://api.github.com/repos/go-gitea/gitea/releases

LAST_REPO_VERSION=$(grep -oP '(?<="tag_name": "v)(.*)(?<!-rc\d)(?<!-dev)(?=")' "$RELEASES_FILE" | sort -Vr | head -n1)
LAST_VERSION_URL=$(grep -oP "(?<=\s\"browser_download_url\": \")https:\/\/github\.com\/go-gitea\/gitea\/releases\/download\/v$LAST_REPO_VERSION\/gitea-$LAST_REPO_VERSION-linux-amd64(?=\")" "$RELEASES_FILE")

rm "$RELEASES_FILE"

URL_REGEX="(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]"
if ! [[ "$LAST_VERSION_URL" =~ $URL_REGEX ]]; then
	echo "Error: wrong regex: grep result is not url:"
	echo "$LAST_VERSION_URL"

	exit 1
fi

LOCAL_GITEA_VERSION=$("$DIR"/"$FILE" -v | grep -oP "(?<=Gitea version )(.*)(?= built)")
COMPARED_VERSION=$(printf "%s\n" "$LOCAL_GITEA_VERSION" "$LAST_REPO_VERSION" | sort -Vr | head -n1)

echo "Local gitea version: $LOCAL_GITEA_VERSION"
echo "Latest gitea version: $LAST_REPO_VERSION"

if [ "$LOCAL_GITEA_VERSION" != "$COMPARED_VERSION" ]; then
	echo "Starting update!"
else
	echo "Update unneded!"
	exit 0
fi

echo "Downloading..."
if ! aria2c --console-log-level=error --dir="$DIR" --out="$FILE.new" "$LAST_VERSION_URL"; then
	echo "Downloading failed"
	exit 1
fi

printf "Stopping Gitea serevice..."
if ! systemctl stop gitea.service; then
	fail
fi
printf " ✔\n"

printf "Backing up old Gitea bin..."
rm "$DIR/$FILE.bak" 2>/dev/null
if ! cp "$DIR/$FILE" "$DIR/$FILE.bak"; then
	fail
fi
printf " ✔\n"

printf "Moving Gitea bin..."
rm "$DIR/$FILE"
if ! mv "$DIR/$FILE.new" "$DIR/$FILE"; then
	fail
fi
printf " ✔\n"

printf "Fixing permissions..."
if ! chmod +x "$DIR/$FILE"; then
	fail
fi
if ! chown -R git:git "$DIR/$FILE"; then
	fail
fi
if ! chmod +x "$DIR/$FILE.bak"; then
	fail
fi
if ! chown -R git:git "$DIR/$FILE.bak"; then
	fail
fi
printf " ✔\n"

printf "Starting Gitea serevice..."
if ! systemctl start gitea.service; then
	fail
fi
printf " ✔\n"

echo "Update completed!"

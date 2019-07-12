#!/usr/bin/env sh
# Convert yaml files to json files in specified folder
# Usage - ./yaml-to-json.sh /dir/to/yaml

WORKING_DIR="$1"

for YAML_FILE in "$WORKING_DIR"/*.yaml; do
	[ -e "$YAML_FILE" ] || continue

	FILE_NAME=$(basename "${YAML_FILE%.*}")
	JSON_FILE=$WORKING_DIR/$FILE_NAME.json

	python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin), sys.stdout, indent=4)' <"$YAML_FILE" >"$JSON_FILE"

	echo "$FILE_NAME - Converted!"
done

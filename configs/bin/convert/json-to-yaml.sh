#!/usr/bin/env sh
# Convert yaml files to json files in specified folder
# Usage - ./yaml-to-json.sh /dir/to/yaml

WORKING_DIR="$1"

for JSON_FILE in "$WORKING_DIR"/*.json; do
	[ -e "$JSON_FILE" ] || continue

	FILE_NAME=$(basename "${JSON_FILE%.*}")
	YAML_FILE=$WORKING_DIR/$FILE_NAME.yaml

	python -c 'import sys, yaml, json; yaml.safe_dump(json.load(sys.stdin), sys.stdout, default_flow_style=False)' <"$JSON_FILE" >"$YAML_FILE"

	echo "$FILE_NAME - Converted!"
done

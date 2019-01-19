#!/usr/bin/env bash

set -e

BASE_CONFIG="base"
CONFIG_SUFFIX=".yaml"

META_DIR="meta"
CONFIG_DIR="configs"
PROFILES_DIR="profiles"

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASE_DIR}"
git submodule update --init --recursive --remote

while IFS= read -r config; do
	CONFIGS+=" ${config}"
done < "${META_DIR}/${PROFILES_DIR}/$1"

shift

echo ${CONFIGS}

for config in ${CONFIGS} ${@}; do
	echo -e "\nConfigure $config"
	configFile="$(mktemp)" ; echo -e "$(<"${BASE_DIR}/${META_DIR}/${BASE_CONFIG}${CONFIG_SUFFIX}")\n$(<"${BASE_DIR}/${META_DIR}/${CONFIG_DIR}/${config}${CONFIG_SUFFIX}")" > "$configFile"
	"${BASE_DIR}/${META_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASE_DIR}" -c "$configFile" ; rm -f "$configFile"
done

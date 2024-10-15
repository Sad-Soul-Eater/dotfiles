#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"

pushd "$SCRIPT_DIR" || exit 1
    ./stow.sh --adopt
    git restore .
popd


#!/usr/bin/env sh

set -e

if ! command -v stow >/dev/null; then
  echo 'Error: command not found "stow"'
  exit 1
fi

cd "$(dirname "$0")"
stow $@ --verbose=2 --target="$HOME" .

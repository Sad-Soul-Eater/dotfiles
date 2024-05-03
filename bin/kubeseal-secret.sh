#!/usr/bin/env bash

TARGET_SECRET=$(realpath "$*")

kubeseal -o yaml -f "$TARGET_SECRET" -w "$TARGET_SECRET"

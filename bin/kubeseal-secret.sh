#!/usr/bin/env bash

TARGET_SECRET=$(realpath "$*")

kubeseal --controller-namespace sealed-secrets -o yaml -f "$TARGET_SECRET" -w "$TARGET_SECRET"

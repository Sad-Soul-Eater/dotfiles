#!/bin/bash

echo "---------------------"
echo "    Optimizing png"
echo "---------------------"
echo ""

if [[ "$1" == "" || "$2" -lt 0 ]]; then
	echo "optiPng.sh [path] [parallel jobs count]"
	exit 1
fi

find "$1" -type f -iname '*.png' | parallel -j "$2" optipng -strip all -fix -clobber

echo ""
echo "---------------------"
echo "   Optimizing done"
echo "---------------------"

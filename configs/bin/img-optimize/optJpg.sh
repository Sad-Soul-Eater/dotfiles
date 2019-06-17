#!/bin/bash

echo "---------------------"
echo "    Optimizing jpg"
echo "---------------------"
echo ""

if [[ "$1" == "" ]]; then
	echo "optiJpg.sh [path] [parallel jobs count]"
	exit 1
fi

find "$1" -type f -iname '*.jpg' | parallel -j "$2" jpegoptim -s -o

echo ""
echo "---------------------"
echo "   Optimizing done"
echo "---------------------"

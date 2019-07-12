#!/usr/bin/env bash

optimize() {
	echo "---------------------"
	echo "    Optimizing png"
	echo "---------------------"
	echo ""

	find "$1" -type f -iname '*.png' | parallel -j "$2" optipng "$3"

	echo ""
	echo "---------------------"
	echo "   Optimizing done"
	echo "---------------------"
}

usage() {
	echo "Usage: ./optiPng.sh -p \"path_to_imgs\" [options]
Options:
-h  open this page
-p  path to images
-j  parallel jobs count
    if not set, used physical CPU count
-o  options for optipng
    if not set, used -strip all -fix -clobber"
}

if [ "$1" = "" ]; then
	usage
	exit 0
fi

IMGS_PATH=""
JOBS=""
OPTS=""

while getopts p:j:o:h OPTION; do
	case "${OPTION}" in
	p)
		IMGS_PATH=${OPTARG}
		;;
	j)
		JOBS=${OPTARG}
		;;
	h)
		usage
		exit 0
		;;
	o)
		OPTS=${OPTARG}
		;;
	*)
		usage
		exit 1
		;;
	esac
done

if [ "$IMGS_PATH" = "" ]; then
	usage
	exit 1
fi

if [ "$JOBS" = "" ]; then
	JOBS="$(grep '^core id' /proc/cpuinfo | sort -u | wc -l)"
fi

if [ "$OPTS" = "" ]; then
	OPTS="-strip all -fix -clobber"
fi

optimize "$IMGS_PATH" "$JOBS" "$OPTS"

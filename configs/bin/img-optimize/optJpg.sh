#!/usr/bin/env bash

optimize() {
	echo "---------------------"
	echo "    Optimizing jpg"
	echo "---------------------"
	echo ""

	find "$1" -type f -iname '*.jpg' | parallel -j "$2" jpegoptim "$3"

	echo ""
	echo "---------------------"
	echo "   Optimizing done"
	echo "---------------------"
}

usage() {
	echo "Usage: ./optiJpg.sh -p \"path_to_imgs\" [options]
Options:
-h  open this page
-p  path to images
-j  parallel jobs count
    if not set, used physical CPU count
-o  options for jpegopti
    if not set, used -s -o"
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
	echo "The path is empty"
	usage
	exit 1
fi

if [ "$JOBS" = "" ]; then
	JOBS="$(grep '^core id' /proc/cpuinfo | sort -u | wc -l)"
fi

if [ "$OPTS" = "" ]; then
	OPTS="-s -o"
fi

optimize "$IMGS_PATH" "$JOBS" "$OPTS"

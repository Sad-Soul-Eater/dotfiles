#!/usr/bin/env bash

optimize() {
	echo "---------------------"
	echo "    Optimizing png"
	echo "---------------------"
	echo ""

	# shellcheck disable=SC2086
	find "$1" $2 -type f -iname '*.png' | parallel -j "$3" optipng "$4"

	echo ""
	echo "---------------------"
	echo "   Optimizing done"
	echo "---------------------"
}

usage() {
	echo "Usage: ./optiPng.sh -p \"path_to_imgs\" [options]
Options:
-h  Open this page
-d  Limit the directory traversal to a given depth,
    by default, there is no limit on the search depth
-p  Path to images
-j  Parallel jobs count,
    if not set, used physical CPU count
-o  Options for optipng,
    if not set, used -preserve -strip all -fix -clobber"
}

if [ "$1" = "" ]; then
	usage
	exit 0
fi

IMGS_PATH=""
JOBS=""
OPTS=""
DEPTH="-maxdepth "

while getopts d:p:j:o:h OPTION; do
	case "${OPTION}" in
	d)
		DEPTH+="${OPTARG}"
		;;
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
	OPTS="-preserve -strip all -fix -clobber"
fi

if [ "$DEPTH" = "-maxdepth " ]; then
	DEPTH=""
fi

optimize "$IMGS_PATH" "$DEPTH" "$JOBS" "$OPTS"

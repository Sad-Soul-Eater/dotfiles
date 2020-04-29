#!/usr/bin/env bash

optimize() {
	echo "---------------------"
	echo "    Optimizing jpg"
	echo "---------------------"
	echo ""

	# shellcheck disable=SC2086
	find "$1" $2 -type f -iname '*.jpg' | parallel -j "$3" jpegoptim "$4"

	echo ""
	echo "---------------------"
	echo "   Optimizing done"
	echo "---------------------"
}

usage() {
	echo "Usage: ./optiJpg.sh -p \"path_to_imgs\" [options]
Options:
-h  Open this page
-d  Limit the directory traversal to a given depth,
    by default, there is no limit on the search depth
-p  Path to images
-j  Parallel jobs count,
    if not set, used physical CPU count
-o  Options for jpegopti,
    if not set, used --preserve --preserve-perms --strip-all"
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
	echo "The path is empty"
	usage
	exit 1
fi

if [ "$JOBS" = "" ]; then
	JOBS="$(grep '^core id' /proc/cpuinfo | sort -u | wc -l)"
fi

if [ "$OPTS" = "" ]; then
	OPTS="--preserve --preserve-perms --strip-all"
fi

if [ "$DEPTH" = "-maxdepth " ]; then
	DEPTH=""
fi

optimize "$IMGS_PATH" "$DEPTH" "$JOBS" "$OPTS"

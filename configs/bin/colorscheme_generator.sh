#!/bin/bash
# Update various configs to apply Xresources color scheme

PATTERNS_DIR=$(dirname $(readlink -f $0))/coloring_patterns
TEMP_PATTERS_DIR=/tmp/colored_patterns

if [ -e "$TEMP_PATTERS_DIR" ]; then
	rm -rf $TEMP_PATTERS_DIR/*
else
	mkdir -p $TEMP_PATTERS_DIR
fi

for PATTERN in $PATTERNS_DIR/*.pt; do
	[ -e "$PATTERN" ] || continue

	PATTERN_NAME=$(basename ${PATTERN%.*})
	TMP_PATTERN=$TEMP_PATTERS_DIR/$PATTERN_NAME.tmp

	cp $PATTERN $TMP_PATTERN

	# Numbered colors
	for i in {0..15}; do

	v=`xrdb -query | awk '/*.color'"$i":'/ { print substr($2,2) }'`
	eval "sed -i 's/%cl${i}%/${v}/g' $TMP_PATTERN";

	done

	# Named colors
	foreground=`xrdb -query | awk '/*.foreground/ { print substr($2,2) }'`
	background=`xrdb -query | awk '/*.background/ { print substr($2,2) }'`
	sed -i "s/%clfg%/${foreground}/g" $TMP_PATTERN
	sed -i "s/%clbg%/${background}/g" $TMP_PATTERN

	echo "$PATTERN_NAME - Done!"

	readarray TEMP_ARR < $TMP_PATTERN
done

#!/usr/bin/env sh

BAR_HEIGHT=22  # polybar height
BORDER_SIZE=1  # border size from your wm settings

YAD_WIDTH=228
YAD_HEIGHT=186

DATE="%{T9}%{T-} $(date +"%e %B")"

case "$1" in
--popup)
	if [ "$(xdotool getwindowfocus getwindowname)" = "yad-calendar" ]; then
		exit 0
	fi

	eval "$(xdotool getmouselocation --shell)"
	eval "$(xdotool getdisplaygeometry --shell)"

	# X
	if [ "$((X + YAD_WIDTH / 2 + BORDER_SIZE))" -gt "$WIDTH" ]; then #Right side
		: $((pos_x = WIDTH - YAD_WIDTH - BORDER_SIZE * 2))
	elif [ "$((X - YAD_WIDTH / 2 - BORDER_SIZE))" -lt 0 ]; then #Left side
		: $((pos_x = 0))
	else #Center
		: $((pos_x = X - YAD_WIDTH / 2))
	fi

	# Y
	if [ "$Y" -gt "$((HEIGHT / 2))" ]; then #Bottom
		: $((pos_y = HEIGHT - YAD_HEIGHT - BORDER_SIZE * 2))
	else #Top
		: $((pos_y = BAR_HEIGHT))
	fi

	yad --calendar --undecorated --close-on-unfocus --no-buttons \
		--geometry="${YAD_WIDTH}x${YAD_HEIGHT}+${pos_x}+${pos_y}" \
		--title="yad-calendar" --borders=0 >/dev/null &
	;;
*)
	echo "$DATE"
	;;
esac

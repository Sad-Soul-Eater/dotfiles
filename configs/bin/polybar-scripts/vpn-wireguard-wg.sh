#!/usr/bin/env sh

connection_status() {
	if [ -f "$config" ]; then
		connection=$(sudo wg show "$config_name" 2>/dev/null | head -n 1 | awk '{print $NF }')

		if [ "$connection" = "$config_name" ]; then
			echo "1"
		else
			echo "2"
		fi
	else
		echo "3"
	fi
}

config="$HOME/wg/hiso-tun.conf"
config_name=$(basename "${config%.*}")

case "$1" in
--toggle)
	if [ "$(connection_status)" = "1" ]; then
		sudo wg-quick down "$config" 2>/dev/null
	else
		sudo wg-quick up "$config" 2>/dev/null
	fi
	;;
*)
	if [ "$(connection_status)" = "1" ]; then
		echo "%{T5}󰯄%{T-} $config_name"
	elif [ "$(connection_status)" = "3" ]; then
		echo "%{T5}󰒙%{T-} Config not found!"
	else
		echo "%{T5}󰒙%{T-}"
	fi
	;;
esac

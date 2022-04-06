#!/usr/bin/env sh

connection_name='hiso-tun'

connection_status() {
	nmcli connection show "$connection_name" | rg -o '(GENERAL\.STATE:\s+)(\w*)' -r '$2'
}

case "$1" in
--toggle)
	if [ "$(connection_status)" = 'activated' ]; then
		nmcli connection down "$connection_name" 2>/dev/null
	else
		nmcli connection up "$connection_name" 2>/dev/null
	fi
	;;
*)
	if [ "$(connection_status)" = 'activated' ]; then
		echo "%{T5}󰯄%{T-} $connection_name"
	else
		echo "%{T5}󰒙%{T-}"
	fi
	;;
esac

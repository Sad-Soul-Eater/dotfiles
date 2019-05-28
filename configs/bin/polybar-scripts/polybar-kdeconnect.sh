#!/usr/bin/env bash

# CONFIGURATION
LOCATION=0
YOFFSET=0
XOFFSET=0
WIDTH=200
WIDTH_WIDE=400

# Icons shown in Polybar
ICON=''
SEPERATOR='|'

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

show_devices() {
	IFS=$','
	devices=""
	for device in $(qdbus --literal org.kde.kdeconnect /modules/kdeconnect org.kde.kdeconnect.daemon.devices); do
		deviceid=$(echo "$device" | awk -F'["|"]' '{print $2}')
		devicename=$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.name)
		isreach="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.isReachable)"
		istrust="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.isTrusted)"
		if [ "$isreach" = "true" ] && [ "$istrust" = "true" ]; then
			if "$(qdbus --literal org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.battery.isCharging)" == "true"; then
				battery=" "
			else
				battery=""
			fi
			battery+="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.battery.charge)%"
			devices+="%{A1:$DIR/polybar-kdeconnect.sh -n '$devicename' -i $deviceid -b '$battery' -m:}$ICON $battery%{A}$SEPERATOR"
		elif [ "$isreach" = "false" ] && [ "$istrust" = "true" ]; then
			devices+="$ICON$SEPERATOR"
		else
			haspairing="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.hasPairingRequests)"
			if [ "$haspairing" = "true" ]; then
				show_pmenu2 "$devicename" "$deviceid"
			fi
			devices+="%{A1:$DIR/polybar-kdeconnect.sh -n $devicename -i $deviceid -p:}$ICON%{A}$SEPERATOR"

		fi
	done
	echo "${devices::-1}"
}

show_menu() {
	menu="$(rofi -sep "|" -dmenu -i -p "$DEV_NAME - $DEV_BATTERY" -location $LOCATION -yoffset $YOFFSET -xoffset $XOFFSET -width $WIDTH -hide-scrollbar -line-padding 4 -padding 20 -lines 5 <<<"Send File|Browse Files|Ping|Find Device|Unpair")"
	case "$menu" in
	*'Send File') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/share" org.kde.kdeconnect.device.share.shareUrl "file://$(zenity --file-selection)" ;;
	*'Browse Files')
		if "$(qdbus --literal org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/sftp" org.kde.kdeconnect.device.sftp.isMounted)" == "false"; then
			qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/sftp" org.kde.kdeconnect.device.sftp.mount
		fi
		qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/sftp" org.kde.kdeconnect.device.sftp.startBrowsing
		;;
	*'Ping') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/ping" org.kde.kdeconnect.device.ping.sendPing ;;
	*'Find Device') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/findmyphone" org.kde.kdeconnect.device.findmyphone.ring ;;
	*'Unpair') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID" org.kde.kdeconnect.device.unpair ;;
	esac
}

show_pmenu() {
	menu="$(rofi -sep "|" -dmenu -i -p "$DEV_NAME" -location $LOCATION -yoffset $YOFFSET -xoffset $XOFFSET -width $WIDTH -hide-scrollbar -line-padding 1 -padding 20 -lines 1<<<"Pair Device")"
	case "$menu" in
	*'Pair Device') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID" org.kde.kdeconnect.device.requestPair ;;
	esac
}

show_pmenu2() {
	menu="$(rofi -sep "|" -dmenu -i -p "$1 has sent a pairing request" -location $LOCATION -yoffset $YOFFSET -xoffset $XOFFSET -width $WIDTH_WIDE -hide-scrollbar -line-padding 4 -padding 20 -lines 2 <<<"Accept|Reject")"
	case "$menu" in
	*'Accept') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$2" org.kde.kdeconnect.device.acceptPairing ;;
	*) qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$2" org.kde.kdeconnect.device.rejectPairing ;;
	esac
}

unset DEV_ID DEV_NAME DEV_BATTERY
while getopts 'di:n:b:mp' c; do
	# shellcheck disable=SC2220
	case $c in
	d) show_devices ;;
	i) DEV_ID=$OPTARG ;;
	n) DEV_NAME=$OPTARG ;;
	b) DEV_BATTERY=$OPTARG ;;
	m) show_menu ;;
	p) show_pmenu ;;
	esac
done

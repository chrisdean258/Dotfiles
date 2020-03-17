#!/bin/bash

while true; do
	rm -f ~/.xresetroot
	xsetroot -name "$(printf %1000s "")"
	counter=0
	while ! [ -f ~/.xresetroot ]; do
		battery_num="$(acpi | grep -oP "[0-9]*(?=%)")"
		battery_msg="$(acpi | grep -E -m1 -o "[0-9][0-9]:[0-9][0-9]:[0-9][0-9]|Full")"
		nettype=$(nmcli device | awk '/connected/ {print $2}')
		network=$(nmcli device wifi | awk '/^\*/ {print $2}')
		[ "$nettype" = "ethernet" ] && network="Connected via ethernet"
		time=$(date +"%F %I:%M %p")
		ping -c 1 -w 1 google.com &>/dev/null && netspeed="Connected" || netspeed="No Access"

		width=$(echo $battery_num | awk '{ print 3*int(($1+5)/10) }')
		other=$(echo $battery_num | awk '{ print 10-int(($1+5)/10) }')
		battery="$(printf "%.*s%*s" $width ░░░░░░░░░░ $other "")"

		[ $battery_num -le 15 ] && battery="$(echo -e "\x05$battery\x01")"
		acpi | grep -E -q "\<[cC]harging\>|Full" && battery_msg="$(echo -e "\x06$battery_msg\x01")"

		if [ "$counter" -eq 1 ] && [ "$netspeed" = "Connected" ]; then
			netspeed="$(speedtest-cli --simple | awk 'BEGIN{RS="~"} {printf("%d/%d/%d", $5, $8, $2) }')"
		fi
		[ -n "$network" ] && network="$network (${netspeed})"

		name="$(printf %100s "") [$battery] $battery_num% ($battery_msg) | $network | $time "

		xsetroot -name "$name"
		[ "$counter" -ne 0 ] && sleep 10
		counter=$(echo "$counter" | awk '{ print ($1 + 1) % 30 }')
	done
	exec bash ~/.xsession --
done &

if [ $# -eq 0 ]; then
	export PATH=$PATH:$HOME/.bin
	hostname | grep -q XPS && export GDK_SCALE=2
	[ -x /usr/bin/xfce4-power-manager ] && xfce4-power-manager &
	/usr/lib/notification-daemon/notification-daemon &
	monitor
	xset r rate 500 300 #Repeat rate
	xsetroot -solid black
	exec dwm &>> ~/.xsession-errors
	echo "DWM failed to start" > ~/dwm.error
fi

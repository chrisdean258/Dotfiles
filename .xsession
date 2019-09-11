#!/bin/bash

while true; do
	rm -f ~/.xresetroot
	xsetroot -name "$(python -c 'print " " * 1000')"
	counter=0
	while ! [ -f ~/.xresetroot ]; do
		battery_num="$(upower --dump | awk '/percentage/ {print int($NF)}' | sort -n | tail -n 1)"
		width=$(echo $battery_num | awk '{ print 3*int(($1+5)/10) }')
		other=$(echo $battery_num | awk '{ print 10-int(($1+5)/10) }')
		battery="$(printf "%.*s%*s" $width ░░░░░░░░░░ $other "")"
		network=
		nettype=$(nmcli --terse device | cut -d : -f 2 | head -n 1)
		[ "$nettype" = "wifi" ] && network=$(nmcli --terse device wifi | grep "^\*" | cut -d : -f 2)
		[ "$nettype" = "ethernet" ] && network="Connected via ethernet"

		[ -z "${netspeed#No Access}" ] && netspeed="Connected"
		timeout 1 ping -c 1 google.com >/dev/null 2>/dev/null || netspeed="No Access"
		if [ "$netspeed" = "No Access" ]; then
			con=$(nmcli --terse con show --active | cut -d : -f 1)
			[ -n "$con" ] && nmcli con up "$con"
			counter="0"
		elif [ "$counter" -eq 1 ]; then
			netspeed="$(speedtest-cli --simple | awk 'BEGIN{RS="~"} {printf("%d/%d/%d", $5, $8, $2) }')"
		fi
		[ -n "$network" ] && network="$network (${netspeed})"
		time=$(date +"%F %I:%M %p")

		name="$(printf %100s "") [$battery] ${battery_num}% | ${network:-No Network} | $time "

		xsetroot -name "$name"
		[ "$counter" -ne 0 ] && sleep 10
		counter=$(echo "$counter" | awk '{ print ($1 + 1) % 30 }')
	done
	exec bash ~/.xsession --
done &

if [ $# -eq 0 ]; then
	# xrdb -merge .Xresources
	export PATH=$PATH:$HOME/.bin
	if [ -x /usr/bin/xfce4-power-manager ] ; then
		xfce4-power-manager &
	fi
	# monitor detect
	feh --bg-scale ~/Documents/background-black.png
	exec dwm
	echo "DWM failed to start" > ~/dwm.error
fi

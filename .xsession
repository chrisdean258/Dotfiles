#!/bin/bash

while true; do
	rm -f ~/.xresetroot
	xsetroot -name "$(python -c 'print " " * 1000')"
	counter=0
	while ! [ -f ~/.xresetroot ]; do
		longest=0
		battery_num="$(upower --dump | awk '/percentage/ {print int($NF)}' | sort -n | tail -n 1)"
		width=$(echo $battery_num | awk '{ print 3*int(($1+5)/10) }')
		other=$(echo $battery_num | awk '{ print 10-int(($1+5)/10) }')
		battery="$(printf "%.*s%*s" $width ░░░░░░░░░░ $other "")"
		old_network="$network"
		nettype=$(nmcli device | awk '/connected/ { print $2 }' | head -n 1)
		network=
		[ "$nettype" = "wifi" ] && network=$(nmcli device wifi | awk '/\*/ { print $2 }')
		[ "$nettype" = "ethernet" ] && network="Connected via ethernet"
		if [ "$old_network" != "$network" ]; then
			counter="0"
		fi
		[ "$counter" -eq 0 ] && netspeed="$(speedtest-cli --simple | awk 'BEGIN{RS="~"} {printf("(%d/%d Mb/s, %d ms)", $5, $8, $2) }')"
		time=$(date +"%F %I:%M %p")

		name="$(printf %100s "") [$battery] ${battery_num}% | ${network:-No Network} ${netspeed+$netspeed }| $time "

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
	exec dwm #&> ~/dwm.error
	echo "DWM failed to start" > ~/dwm.error
fi

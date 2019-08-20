#!/bin/bash

while true; do
	rm -f ~/.xresetroot
	xsetroot -name "$(python -c 'print " " * 1000')"
	while ! [ -f ~/.xresetroot ]; do
		longest=0
		batteryp=$(upower --dump | grep -E "percentage" | sort | uniq | sed "s/^.\{25\}//" | tail -n 1)
		battery_num=$(echo $batteryp | sed "s/.%//")
		extra=$(echo $battery_num | awk '{ print $1 * 2 + 10 }')
		battery=$(printf "%-${extra}s" $(yes ░ | head -n ${battery_num} | tr -d "\n"))

		nettype=$(nmcli device | grep connected | head -n 1 | awk '{ print $2 }')
		network="No Network"
		[ "$nettype" = "wifi" ] && network=$(nmcli device wifi | awk '/\*/ { print $2 " (" $5 " " $6 ")" }' 2>/dev/null )
		[ "$nettype" = "ethernet" ] && network="Connected via ethernet"
		time=$(date +"%F %I:%M %p")

		name="$(printf %100s "") [$battery] $batteryp | $network | $time "
		xsetroot -name "$name"
		sleep 10
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
	exec dwm &> ~/dwm.error
	echo "DWM failed to start" > ~/dwm.error
fi

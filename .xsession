#!/bin/bash

root()
{
	rm -f ~/.xresetroot
	xsetroot -name "$(printf %1000s "")"
	while ! [ -f ~/.xresetroot ]; do
		battery_num="$(acpi | grep -oP "[0-9]*(?=%)")"
		battery_msg="$(acpi | grep -E -m1 -o "[0-9][0-9]:[0-9][0-9]:[0-9][0-9]")"
		nettype=$(nmcli device | awk '/connected/ {print $2}')
		network=$(nmcli device wifi | awk '/^\*/ {print $2}')
		[ "$nettype" = "ethernet" ] && network="Connected via ethernet"
		time=$(date +"%F %H:%M")
		ping -c 1 -w 1 google.com &>/dev/null && netspeed="" || netspeed=" (No Access)"

		width=$(echo $battery_num | awk '{ print 3*int(($1+5)/10) }')
		other=$(echo $battery_num | awk '{ print 10-int(($1+5)/10) }')
		battery="$(printf "%.*s%*s" $width ░░░░░░░░░░ $other "")"

		[ -n "$network" ] && network="${network}${netspeed}"

		name="$(printf %100s "") [$battery] $battery_num% ${battery_msg:+($battery_msg) }| $network | $time"

		xsetroot -name "$name"
		sleep 10
	done
	exec bash ~/.xsession --
}

root &

if [ $# -eq 0 ]; then
	export PATH=$PATH:$HOME/.bin
	[ -x "$(which xfce4-power-manager)" ] && xfce4-power-manager &
	/usr/lib/notification-daemon/notification-daemon &
	monitor --no4k
	xset r rate 500 300 # Repeat rate
	xsetroot -solid black
	xclock -digital -brief -bg black -fg white -update 1 &
	exec dwm &>> ~/.xsession-errors
	echo "DWM failed to start" > ~/dwm.error
fi

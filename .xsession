#!/bin/bash

while true; do
	rm -f ~/.xresetroot
	xsetroot -name "$(printf %1000s "")"
	counter=0
	while ! [ -f ~/.xresetroot ]; do
		battery_num="$(acpi | sed "s/.* \([0-9]*\)\%.*/\1/g")"
		width=$(echo $battery_num | awk '{ print 3*int(($1+5)/10) }')
		other=$(echo $battery_num | awk '{ print 10-int(($1+5)/10) }')
		battery="$(printf "%.*s%*s" $width ░░░░░░░░░░ $other "")"
		battery_msg="$(acpi | grep -o "[0-9][0-9]:[0-9][0-9]:[0-9][0-9]")"
		temperature="$(acpi -t | sed "s/.* \([0-9][0-9]*\).[0-9]* degrees.*/\1/g")"

		[ $temperature -ge 40 ] && temperature=$(echo -e "\x05$temperature\x01")
		[ $battery_num -ge 90 ] && battery="$(echo -e "\x06$battery\x01")"
		[ $battery_num -le 15 ] && battery="$(echo -e "\x05$battery\x01")"
		if acpi | grep -q "\<[cC]harging\>"; then
			battery_msg="$(echo -e "\x06$battery_msg\x01")"
		elif [ $battery_num -le 15 ]; then
			battery_msg="$(echo -e "\x05$battery_msg\x01")"
		fi
		network=
		nettype=$(nmcli --terse device | cut -d : -f 2 | head -n 1)
		[ "$nettype" = "wifi" ] && network=$(nmcli --terse device wifi | grep "^\*" | cut -d : -f 2)
		[ "$nettype" = "ethernet" ] && network="Connected via ethernet"

		[ -z "${netspeed#No Access}" ] && netspeed="Connected"
		timeout 1 ping -c 1 google.com >/dev/null 2>/dev/null || netspeed="No Access"
		if [ "$netspeed" = "No Access" ] && [ "$counter" -gt 15 ]; then
			con=$(nmcli --terse con show --active | cut -d : -f 1)
			[ -n "$con" ] && nmcli con up "$con"
			counter="0"
		elif [ "$counter" -eq 1 ]; then
			netspeed="$(speedtest-cli --simple | awk 'BEGIN{RS="~"} {printf("%d/%d/%d", $5, $8, $2) }')"
		fi
		[ -n "$network" ] && network="$network (${netspeed:-No Access})"
		time=$(date +"%F %I:%M %p")

		name="$(printf %100s "") [$battery] ${battery_num}% ${battery_msg:+($battery_msg) }| $temperature °C | ${network:-No Network} | $time "

		xsetroot -name "$name"
		[ "$counter" -ne 0 ] && sleep 10
		counter=$(echo "$counter" | awk '{ print ($1 + 1) % 30 }')
	done
	exec bash ~/.xsession --
done &

if [ $# -eq 0 ]; then
	# xrdb -merge .Xresources
	export PATH=$PATH:$HOME/.bin
	hostname | grep -q XPS && export GDK_SCALE=2
	[ -x /usr/bin/xfce4-power-manager ] && xfce4-power-manager &
	/usr/lib/notification-daemon/notification-daemon &
	monitor
	xset r rate 500 300 #Repeat rate
	xsetroot -solid black
	exec dwm bash $0 &> ~/.xsession-errors
	echo "DWM failed to start" > ~/dwm.error
fi

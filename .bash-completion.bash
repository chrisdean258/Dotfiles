#!/bin/bash

complete -d cd
complete -o bashdefault -f -X "!*.pdf" print-paper
complete -o bashdefault -f -X "@(*.pdf|*.aux|*.nav|*.snm|*.toc|*.jpg|*.pyc|*.png|*.mp3|*.wav|*.o|*.bin)" vim
# complete -o bashdefault -f -X "!@(*.pdf|*.jpg|*.png|*.mp3|*.wav|*.ppm|*.pgm|*.html|*.webm|*.mp4|*.mkv|*.flv|*.gif|*.svg|*.xlsx)" open
complete -o bashdefault -f -X "!@(*.h5)" h5dump
complete -o bashdefault -f -X "!*.ovnp" openvpn

for exe in ~/.bin/pdf*; do
	complete -o bashdefault -f -X '!*.pdf' "$(basename "$exe")"
done


__complete_make()
{
	local cur
	local words

	cur=${COMP_WORDS[COMP_CWORD]}	

	words="$(grep -o "^[a-zA-Z0-9_\-]*:" ./*akefile 2>/dev/null | sed "s/:$//g")"
	COMPREPLY=( $(compgen -W "$words" -- "$cur" ) )

	return 0
}

complete -o bashdefault -o default -o nospace -F __complete_make make

__complete_xdotool()
{
	cur=${comp_words[comp_cword]}	
	words="$(xdotool --help | awk '/^ / {print $1}')"
	compreply=( $(compgen -w "$words" -- "$cur" ) )

	return 0
}

complete -o bashdefault -o default -o nospace -F __complete_xdotool xdotool

__complete_j()
{
	cur=${comp_words[comp_cword]}	
	words="$(cat ~/.cache/jmpp/jmp_complete)"
	compreply=( $(compgen -w "$words" -- "$cur" ) )

	return 0
}

#!/bin/bash

complete -d cd
complete -o bashdefault -G "*.pdf" print-paper
complete -o bashdefault -f -X "@(*.pdf|*.log|*.aux|*.nav|*.out|*.snm|*.toc|*.jpg|*.pyc|*.png|*.mp3|*.wav)" vim
complete -o bashdefault -G "@(*.pdf|*.jpg|*.png|*.mp3|*.wav)" open

for exe in ~/.bin/pdf*; do
	complete -o bashdefault -G "*.pdf" "$(basename $exe)"
done


__complete_ssh() 
{
	local cur opts prog
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prog="${COMP_WORDS[0]}"
	opts=$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2-)
	[ "$prog" = "scp" ] && opts=$(echo "$opts" | sed "s/$/:/g")

	COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
	return 0
}
complete -o bashdefault -o default -o nospace -F __complete_ssh ssh
complete -o bashdefault -o default -o nospace -F __complete_ssh scp

__complete_make()
{
	local cur
	local words

	cur=${COMP_WORDS[COMP_CWORD]}	

	words="$(cat *akefile 2>/dev/null | grep -o "^[a-zA-Z0-9_\-]*:" | sed "s/:$//g")"
	COMPREPLY=( $(compgen -W "$words" -- "$cur" ) )

	return 0
}

complete -o bashdefault -o default -o nospace -F __complete_make make

#!/bin/bash

complete -d cd
complete -o bashdefault -f -X "!*.pdf" pdf-title
complete -o bashdefault -f -X "!*.pdf" pdfhead
complete -o bashdefault -f -X "!*.pdf" print-paper

__complete_vim()
{
	local cur
	local prev
	local words

	cur=${COMP_WORDS[COMP_CWORD]}

	if [ ${COMP_WORDS[$COMP_CWORD-1]} = "-t" ]; then
		words="$(cat tags .tags 2>/dev/null | awk '{print $1}')"
	else
		words="$(file -L * | grep -v -E "\.log$|\.aux$|\.nav$|\.out$|\.snm$|\.toc$" | grep -E "ASCII|text|empty|directory" | cut -d: -f1 | sed "s:^\.\/::g")"
	fi
	old="$IFS"
	IFS=$'\n'
	COMPREPLY=( $(compgen -W "$words" -- "$cur" ) )
	IFS="$old"

	return 0
}

complete -o bashdefault -o default -o nospace -F __complete_vim vim

__complete_open()
{
	local cur
	local old
	local words

	cur=${COMP_WORDS[COMP_CWORD]}	
	words="$(file -L *| grep -v -E "ASCII|text|empty|directory|data" | grep -o "^[^:]*")"
	old="$IFS"
	IFS=$'\n'
	COMPREPLY=( $(compgen -W "$words" -- "$cur" | sed "s/.*/'&'/g") )
	IFS="$old"

	return 0
}

complete -o bashdefault -o default -o nospace -F __complete_open open

__complete_j()
{
	local cur
	local expanded
	local files

	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}	
	words="$(cat ~/.cache/jmp/jmp_complete 2>/dev/null)" 

	COMPREPLY=( $(compgen -W "$words" -- "$cur") )

	[ ${#COMPREPLY[@]} -eq 0 ] && COMPREPLY=( $(cat ~/.jmp_complete 2>/dev/null | grep "$cur") )

	return 0
}

complete -o bashdefault -o default -o nospace -F __complete_j j

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

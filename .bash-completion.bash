#!/bin/bash


complete -d cd
complete -G "*.pdf" pdf-title
complete -G "*.pdf" pdfhead

__complete_vim()
{
	local cur
	local words

	cur=${COMP_WORDS[COMP_CWORD]}	

	words="$(file -L * | grep -v -E "\.log|\.aux|\.nav|\.out|\.snm|\.toc|directory" | grep -E "ASCII|text|empty" | cut -d: -f1 | sed "s:^\.\/::g")"
	COMPREPLY=( $(compgen -W "$words" -- "$cur" ) )

	return 0
}

complete -o bashdefault -o default -o nospace -F __complete_vim vim

__complete_open()
{
	local cur
	local old
	local words

	cur=${COMP_WORDS[COMP_CWORD]}	

	words="$(file -L *| grep -v -E "ASCII|text|empty|directory|data" | cut -d: -f1 | sed "s:^\.\/::g")"
	COMPREPLY=( $(compgen -W "$words" -- "$cur" ) )

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
	words="$(cat ~/.jmp_complete)" 

	COMPREPLY=( $(compgen -W "$(cat ~/.jmp_complete)" -- "$cur") )

	[ ${#COMPREPLY[@]} -eq 0 ] && COMPREPLY=( $(cat ~/.jmp_complete | grep "$cur") )

	return 0
}

complete -o bashdefault -o default -o nospace -F __complete_j j

__complete_redo()
{
	local words 
	words="$(fc -l -50 | sed 's/\t//')"
	COMPREPLY=($(compgen -W "$words" -- "${COMP_WORDS[COMP_CWORD]}"))
}

complete -o bashdefault -o default -o nospace -F __complete_redo redo

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

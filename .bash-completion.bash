#!/bin/bash

__complete_cd()
{
	local cur dir
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	COMPREPLY=( $(compgen -d -- "${cur}") )

	return 0
}

complete -o bashdefault -o default -o nospace -F __complete_cd cd

__complete_vim()
{
	local cur
	local expanded
	local files

	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}	

	cur=`echo $cur | sed 's:^~:$HOME:'`

	files=$(compgen -G "$cur*")

	if [ -n "$files" ]; then
		COMPREPLY=( $(echo "$files" | xargs file | grep -E "ASCII|text|empty" | cut -d: -f1 ) )
	fi

	return 0
}

complete -o bashdefault -o default -o nospace -F __complete_vim vim

__complete_j()
{
	local cur
	local expanded
	local files

	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}	

	COMPREPLY=( $(cat ~/.jmp_complete | grep "^$cur") )

	[ ${#COMPREPLY[@]} -eq 0 ] && COMPREPLY=( $(cat ~/.jmp_complete | grep "$cur") )

	return 0
}

complete -o bashdefault -o default -o nospace -F __complete_j j

__complete_redo()
{
  COMPREPLY=($(compgen -W "$(fc -l -50 | sed 's/\t//')" -- "${COMP_WORDS[COMP_CWORD]}"))
}

complete -o bashdefault -o default -o nospace -F __complete_redo redo


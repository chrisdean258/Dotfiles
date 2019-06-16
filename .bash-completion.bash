#!/bin/bash

__complete_cd()
{
	local cur dir
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	dir=`dirname "$cur"`
	COMPREPLY=( $(find . -prune -type d -ipath "./${cur}*" | sed "s/^..//" ) )

	return 0
}


# complete -o default -F __complete_cd cd


__complete_vim()
{
	local cur
	local expanded
	local files

	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}	

	cur=`echo $cur | sed 's:^~:$HOME:'`

	files=$(compgen -G "$cur*")

	if [ "$files" ]; then
		COMPREPLY=( $(echo "$files" | xargs file | grep -E "ASCII|text|empty" | cut -d: -f1 ) )
	fi

	return 0
}

complete -o nosort -o default -F __complete_vim vim

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


# complete  -F __complete_cd cd


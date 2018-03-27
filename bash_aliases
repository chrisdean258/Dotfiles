alias c="clear"

alias rls="ls"

alias cd="cdls"

alias bashrc=". ~/.bashrc"

cdls()
{
	builtin cd $@ && ls
}

alias cat="catdir"

catdir()
{
	if [ $# -eq 1 ] && [ -d $1 ]; then
		ls $1
	else
		/bin/cat $*
	fi

}

alias cd..="cd .."
alias ..="cd .."

-()
{
	builtin cd -
}

export -f -

j()
{
	if [ $# -eq 0 ]; then
		builtin cd ~ && ls
		return
	fi

	OLD_JUMP=$JUMP
	JUMP=$1

	if [ "$JUMP"="$OLD_JUMP" ] && [[ $PWD == *$JUMP ]] 
	then
		cd `find ~ -type d -name *$1 2> /dev/null | tee /dev/stdout | grep -A 1 -m 1 "$PWD" | tail -1` && pwd | sed "s|$HOME|~|g" && ls
	else
		builtin cd `find ~ -type d -name *$1 2> /dev/null | grep "$1$" | grep -v "^$PWD$" | head -1` && pwd | sed "s|$HOME|~|g" && ls
	fi
}

export -f j

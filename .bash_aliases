#!/bin/bash
alias bashrc=". ~/.bashrc"

alias cd..="cd .."
alias ..="cd .."

command -v colordiff &>/dev/null && alias diff="colordiff"
command -v neomutt &>/dev/null   && alias mutt="neomutt"

-()
{
	builtin cd -
}

alias cd="cdls"

cdls()
{
	builtin cd "$@" 
	success=$?
	if [ "$success" -eq 0 ]; then
		[ `ls | wc -l` -lt 100 ] && ls 
		echo `realpath .` >> ~/.jmp && 
		sed -i 1d ~/.jmp
	fi
}

md()
{
	mkdir "$@" && cd "$@"
}

pip3()
{
	pip3=`which pip3`
	if [ -z "$pip3" ]; then
		echo "pip3 not installed"
		return 1
	fi
	for arg in "$@"; do
		if [ "$arg" = "--user" ]; then
			$pip3 "$@"
			return $?
		fi
	done

	if groups | grep -q sudo; then
		sudo $pip3 "$@"
	else
		$pip3 "$@"
	fi
}

j()
{
	jmps="$HOME/.jmp"
	if [ $# -ne 0 ]
	then
		pattern=".*$(echo "$@" | sed "s/\s\+/.*\/.*/g")[^\/]*$"
	else
		builtin cd "$(tail -n 1 $jmps)"
		return 0
	fi


	if [ "$1" = "--setup" ]; then
		rm -rf "$jmps"
		time=$(date +%D --date="-2 month" 2>/dev/null)
		[ -z "$time" ] && time=$(date -v-2m "+%D")
		cat <(find "$HOME" -type d -not -path "*/\.*" -newermt "$time") > "$jmps"
		size="$(cat "$jmps" | wc -l)"
		[ "$size" -lt 1000 ] && yes "" | head -n "$(echo $size | awk '{print 1000 - $1}')" >> "$jmps"
		return 0
	fi

	if echo $PWD | grep -qi "$pattern"
	then
		new_dir=$(
		tac $jmps |
		grep -i "$pattern" |
		awk '{ if (!a[$0]++) print $0; if(!b) b = $0 }; END { print b }' |
		grep -m 1 -A 1 "^$PWD$" |
		\tail -1
		)
	else
		new_dir=$(grep -i "$pattern" $jmps | \tail -n 1)
	fi

	if [ "$new_dir" ]
	then 
		if [ -d "$new_dir" ]
		then
			builtin cd $new_dir 
		else
			sed -i "/^$new_dir$/d" $jmps
			j "$@"
		fi
	fi
}

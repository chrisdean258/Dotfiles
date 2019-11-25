#!/bin/bash
alias bashrc=". ~/.bashrc"

alias cd..="cd .."
alias ..="cd .."

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias car="cat"

exe() { [ -x "$(command -v "$1")" ]; }

if exe dircolors; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto --group-directories-first'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
elif [ -n "$MAC" ]; then
	alias ls='ls -G'
	alias grep='grep --color'
	alias fgrep='fgrep --color'
	alias egrep='egrep --color'
fi

exe colordiff && alias diff="colordiff"
exe neomutt && alias mutt="neomutt"
exe vimpager && alias less="vimpager"

cat()
{
	CAT="$(which cat)"
	if ! [ -t 1 ] || [ $# -eq 0 ]; then
		$CAT "$@"
		exit "$?"
	fi
	for f in "$@"; do
		[ -d "$f" ] && ls "$f" && continue
		exe vimcat && file -b --mime-type "$f" | grep -q "text" && vimcat "$f" && continue
		exe pdftotext && file -b --mime-type "$f" | grep -q "pdf" && pdftotext "$f" - && continue
		$CAT "$f"
	done
}

-() { builtin cd -; }

alias cd="cdls"

cdls()
{
	if builtin cd "$@"; then
		[ `ls | wc -l` -lt 100 ] && ls "$([ -z "$MAC" ] && echo "-G")"
		echo `realpath .` >> ~/.jmp && [ -z "$MAC" ] && sed -i 1d ~/.jmp
		return 0
	fi
	return 1
}

md() { mkdir "$@" && cd "$@"; }

pip3()
{
	pip3=`which pip3`
	[ -z "$pip3" ] && echo "pip3 not installed" && return 1
	echo "$*" | grep -q -e "[-]-user" && $pip3 "$@" && return $?
	sudo="$(groups | grep -q "sudo" && echo "sudo")"
	$sudo -H $pip3 "$@"
}

j()
{
	jmps="$HOME/.jmp"
	[ $# -ne 0 ] && pattern=".*$(echo "$@" | sed "s/\s\+/.*\/.*/g")[^\/]*$"

	if [ "$1" = "--setup" ]; then
		time=$(date +%D --date="-2 month" 2>/dev/null) || time=$(date -v-2m "+%D")
		(find "$HOME" -type d -not -path "*/\.*" -newermt "$time" && yes "") | head -n 1000 > "$jmps"
		return 0
	fi

	new_dir=$(tac "$jmps" | grep -m 1 -i "$pattern")
	if echo "$PWD" | grep -qi "$pattern"; then
		new_dir=$(tac "$jmps" | grep -i "$pattern" | awk '!a[$0]++' | sed -e '1h;$G' | grep -m 1 -A 1 "^$PWD$" | tail -n 1)
	fi

	[ -d "$new_dir" ] && builtin cd "$new_dir" && echo "$@" >> ${jmps}_complete 
	return $?
}

retry()
{
	if [ $# -eq 0 ]; then
		while ! "$BASH" -c "$(history -p !!)"; do :; done
	else
		while ! "$@"; do :; done
	fi
}

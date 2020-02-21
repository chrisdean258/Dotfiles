#!/bin/bash

jmp_dir="$HOME/.cache/jmp"

alias cd..="cd .."
alias ..="cd .."

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias car="cat"
alias matlab="matlab -nodesktop -nosplash"

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
		echo `realpath .` >> ~/.jmp && [ -z "$MAC" ] && sed -i 1d "$jmp"
		return 0
	fi
	return 1
}

j()
{
	local new_dir
	[ $# -ne 0 ] && pattern=".*$(echo "$@" | sed "s/\s\+/.*\/.*/g")[^\/]*$"

	if [ "$1" = "--setup" ]; then
		time=$(date +%D --date="-2 month" 2>/dev/null) || time=$(date -v-2m "+%D")
		(find "$HOME" -type d -not -path "*/\.*" -newermt "$time" && yes "") | head -n 1000 > "$jmp"
		return 0
	fi

	new_dir=$(tac "$jmp" | grep -m 1 -i "$pattern")
	if echo "$PWD" | grep -qi "$pattern"; then
		new_dir=$(tac "$jmp" | grep -i "$pattern" | awk '!a[$0]++' | sed -e '1h;$G' | grep -m 1 -A 1 "^$PWD$" | tail -n 1)
	fi

	if [ -d "$new_dir" ]; then 
		builtin cd "$new_dir" && echo "$@" >> ${jmp}_complete
	else
		grep -v "^$new_dir$" "$jmp" > "$jmp_dir/tmp" 
		mv "$jmp_dir/tmp" "$jmp"
		return 1
	fi
	return $?
}

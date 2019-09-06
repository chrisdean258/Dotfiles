#!/bin/bash
alias bashrc=". ~/.bashrc"

alias cd..="cd .."
alias ..="cd .."

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias car="cat"

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
		echo $CAT "$@"
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
		[ `ls | wc -l` -lt 100 ] && ([ -z "$MAC" ] && ls) || ls -G
		echo `realpath .` >> ~/.jmp && 
			[ -z "$MAC" ] &&
			sed -i 1d ~/.jmp || true
	fi
}

md() { mkdir "$@" && cd "$@"; }

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

	if echo "$PWD" | grep -qi "$pattern"
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

	if [ -n "$new_dir" ]
	then 
		if [ -d "$new_dir" ]
		then
			echo "$@" >> ${jmps}_complete
			builtin cd "$new_dir" 
		else
			sed -i "/^$new_dir$/d" "$jmps"
			j "$@"
		fi
	fi
}

retry()
{
	if [ $# -eq 0 ]; then
		while ! "$BASH" -c "$(history -p !!)"; do :; done
	else
		while ! "$@"; do :; done
	fi
}

redo()
{
	if [ $# -eq 0 ]; then
		"$BASH" -c "$(history -p !!)"
	else
		"$BASH" -c "$(history 1000 | grep "^ $1\>" | sed "s/^ [0-9]*//")"
	fi
	
}

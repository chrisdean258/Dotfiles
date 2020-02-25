# If not running interactively, don't do anything
echo $- | grep -q "i" || return

if [ -z "$TMUX" ] && [ -x "$(which tmux 2>/dev/null)" ]; then
	ID="$( tmux ls 2>/dev/null | grep -vm1 attached | cut -d: -f1 )"
	[ -n "$ID" ] && a="attach"
	[ -z "$SSH_TTY" ] && exec tmux $a || export SSH_TTY
fi

[ -z "$BASH_SOURCED" ] || return
BASH_SOURCED="yes"

exe() { [ -x "$(command -v "$1")" ]; }

[ -r ~/.bash_profile ] && . ~/.bash_profile
[ -r ~/.bash_aliases ] && . ~/.bash_aliases
[ -r ~/.git-completion.bash ] && source ~/.git-completion.bash
[ -r ~/.bash-completion.bash ] && source ~/.bash-completion.bash
exe lesspipe && eval "$(SHELL=/bin/sh lesspipe)"

HISTCONTROL=ignoreboth
HISTSIZE=
HISTFILESIZE=
P_RED="\[`tput setaf 1`\]" 
P_GREEN="\[`tput setaf 2`\]" 
#P_YELLOW="\[`tput setaf 3`\]" 
#P_BLUE="\[`tput setaf 4`\]" 
#P_PURPLE="\[`tput setaf 5`\]"
#P_AQUA="\[`tput setaf 6`\]"
#P_WHITE="\[`tput setaf 7`\]"
#P_BLACK="\[`tput setaf 8`\]"
P_CLEAR="\[`tput sgr0`\]"

export PATH=$HOME/bin:$HOME/.bin:$PATH
export EDITOR=vim
export VISUAL=vim
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export HISTIGNORE="ls:cd"
export TERM=st-256color

shopt -s histappend   2>/dev/null
shopt -s cdspell      2>/dev/null
shopt -s autocd       2>/dev/null
shopt -s checkwinsize 2>/dev/null
shopt -s globstar     2>/dev/null
shopt -s checkhash    2>/dev/null

set -o vi

if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

PS1='\u@\h:\w\$ '
if exe tput && tput setaf 1 >&/dev/null; then
	if [ -z "$SSH_TTY" ]; then
		PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	else
		PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	fi
fi

PROMPT_COMMAND=prompt_command
PROMPT_SAVE=`echo $PS1 | sed 's/..$//g'`
prompt_command()
{
	rv_save=$?
	rv="$([ $rv_save -ne 0 ] && echo -n "$P_RED[$rv_save]$P_CLEAR ")"
	bat="$(low-battery 2>/dev/null && echo -en "$P_RED[Low Battery] $P_CLEAR")"
	gb="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
	gd="$(timeout 0.5s git status 2>/dev/null | grep -q "clean" || echo "*")"
	git="${gb:+$P_GREEN ($gb$gd)$P_CLEAR}"
	PS1="${rv}${battery}$PROMPT_SAVE${git}\$ "
}

jmp_dir="$HOME/.cache/jmp"
jmp="$jmp_dir/jmp"

alias cd..="cd .."
alias ..="cd .."

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias car="cat"
alias matlab="matlab -nodesktop -nosplash"
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'

if exe dircolors; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

exe colordiff && alias diff="colordiff"
exe neomutt && alias mutt="neomutt"
exe vimpager && alias less="vimpager"

-() { builtin cd -; }

alias cd="cdls"

cdls()
{
	if builtin cd "$@"; then
		[ `ls | wc -l` -lt 100 ] && ls
		echo `realpath .` >> "$jmp" && sed -i 1d "$jmp"
		return 0
	fi
	return 1
}

j()
{
	[ $# -ne 0 ] && pattern=".*$(echo "$@" | sed "s/\s\+/.*\/.*/g")[^\/]*$"

	if [ "$1" = "--setup" ]; then
		time=$(date +%D --date="-2 month" 2>/dev/null)
		(find "$HOME" -type d -not -path "*/\.*" -newermt "$time" && yes "") | head -n 1000 > "$jmp"
		return 0
	fi

	new_dir=$(tac "$jmp" | grep -m 1 -i "$pattern")
	if echo "$PWD" | grep -qi "$pattern"; then
		new_dir=$(tac "$jmp" | grep -i "$pattern" | awk '!a[$0]++' | sed -e '1h;$G' | grep -m 1 -A 1 "^$PWD$" | tail -n 1)
	fi

	[ -z "$new_dir" ] && return 1
	if [ -d "$new_dir" ]; then 
		builtin cd "$new_dir" && echo "$@" >> ${jmp}_complete
	else
		grep -vF "$new_dir" "$jmp" > "$jmp_dir/tmp" 
		mv "$jmp_dir/tmp" "$jmp"
		j
	fi
	return $?
}

update_file="$HOME/.cache/bash_update"
! [ -f "$update_file" ] && touch "$update_file"
if ! diff "$update_file" <(date +%j) &>/dev/null; then
	[ -z "$NO_UPDATE" ] && dots pull
	date +%j > "$update_file"
fi

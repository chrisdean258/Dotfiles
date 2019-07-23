# If not running interactively, don't do anything
echo $- | grep -q "i" || return

if [ -z "$TMUX" ] && [ -x "$(which tmux 2>/dev/null)" ]; then
	ID="$( tmux ls | grep -vm1 attached | cut -d: -f1 )"
	[ -n "$ID" ] && a="attach"
	[ -z "$SSH_TTY" ] && exec tmux $a
fi

[ -z "$BASH_SOURCED" ] || return
BASH_SOURCED="yes"

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -x "$(command -v python3)" ] || source /opt/rh/python33/enable
[ -r ~/.bash_profile ] && . ~/.bash_profile
[ -r ~/.bash_aliases ] && . ~/.bash_aliases
[ -r ~/.git-completion.bash ] && source ~/.git-completion.bash
[ -r ~/.bash-completion.bash ] && source ~/.bash-completion.bash
[ -x "$(command -v dircolors)" ] && eval "$(dircolors -b)"

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
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

export PATH=$HOME/bin:$HOME/.bin:$PATH
export EDITOR=vim
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export HISTIGNORE="ls:cd"

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

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	if hostname | grep -qE "$(whoami)|localhost"; then
		PS1='\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	else
		PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	fi
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

PROMPT_COMMAND=prompt_command
PROMPT_SAVE=`echo $PS1 | sed 's/..$//g'`
prompt_command()
{
	rv_save=$?
	return_val=$([ $rv_save -ne 0 ] && echo -n "$P_RED[$rv_save]$P_CLEAR ")
	battery=$(command -v low_battery &> /dev/null && low_battery && echo -en "$P_RED[Low Battery] $P_CLEAR")
	git_branch=""
	if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
		git_branch=$(echo -en " $P_GREEN($(git rev-parse --abbrev-ref HEAD | tr -d "\n\f")$(timeout 0.5s git status 2>/dev/null | grep -q clean || echo "*"))$P_CLEAR")
	fi  
	nc=$(awk "BEGIN { print $(whoami | wc -c) \
		+ $(pwd | sed "s:$HOME:~:" | wc -c) \
		+ $(echo $battery | wc -c) \
		+ $(echo $git_branch | wc -c | awk '{print $1 ? int($1 - 20) : 0}')\
	}")
	sum=$(awk "BEGIN{print int($nc * 1.5) } ")
	maybe_newline=""
	if [ $sum -gt $COLUMNS ] && [ $nc -lt $COLUMNS ]; then
		maybe_newline=$(echo "\n")
	fi  
	PS1="${return_val}${battery}$PROMPT_SAVE${git_branch}${maybe_newline}\$ "
}

! [ -f ~/.bash_update ] && touch ~/.bash_update
if ! diff ~/.bash_update <(date +%j) &>/dev/null; then
	[ -z "$NO_UPDATE" ] && dots deploy
	date +%j > ~/.bash_update
fi

# If not running interactively, don't do anything
echo $- | grep -q "i" || return
set +e

if [ -z "$TMUX" ] && [ -x "$(which tmux 2>/dev/null)" ]; then
	ID="$( tmux ls 2>/dev/null | grep -Evm1 'attached|^[A-Z_]*:' | cut -d: -f1 )"
	[ -n "$ID" ] && a="attach"
	[ -z "$SSH_TTY" ] && exec tmux $a || export SSH_TTY
fi

exe() { [ -x "$(command -v "$1")" ]; }
ssource() { [ -r "$1" ] && source "$1"; }

ssource "$HOME/.bashrc.local"
ssource "$HOME/.bash_aliases"
ssource "$HOME/.git-completion.bash"
ssource "$HOME/.bash-completion.bash"
ssource "$HOME/.cargo/env"

HISTCONTROL=ignoreboth HISTSIZE= HISTFILESIZE=
P_RED="\[`tput setaf 1`\]" 
P_GREEN="\[`tput setaf 2`\]" 
P_CYAN="\[`tput setaf 6`\]"
P_CLEAR="\[`tput sgr0`\]"

export PATH=$HOME/bin:$HOME/.bin:$PATH:$HOME/.local/bin/:
export EDITOR=vim
export VISUAL=vim
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export HISTIGNORE="ls:cd"

export TERM=xterm-256color
[ -f "$HOME/.config/pyrc" ] && export PYTHONSTARTUP="$HOME/.config/pyrc"

export XDG_CONFIG_HOME="$HOME/.config"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export GRIPHOME="$XDG_CONFIG_HOME/grip"
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"

shopt -s histappend 2>/dev/null
shopt -s checkhash  2>/dev/null
# shopt -s nullglob   2>/dev/null

set -o vi

if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

if exe dircolors; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

PS1='\u@\h:\w\$ '
if exe tput && tput setaf 1 >&/dev/null; then
	PS1="\[\033[01;32m\]\u${SSH_TTY:+@\h}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
fi

PROMPT_COMMAND=prompt_command
PROMPT_SAVE="$(echo "$PS1" | sed 's/..$//g')"
prompt_command()
{
	rv_save=$?
	rv="$( ([ $rv_save -ne 0 ] || history -p !! | head -n 1 | grep -qE "^\[|^test") && echo -n "${P_RED}[$rv_save]$P_CLEAR ")"
	bat="$(low-battery 2>/dev/null && echo -en "${P_RED}[Low Battery] $P_CLEAR")"
	gb="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
	gd="$(timeout 0.5s git status 2>/dev/null | grep -q "clean" || echo "*")"
	git="${gb:+$P_GREEN ($gb$gd)$P_CLEAR}"
	venv="$( [ -n "$VIRTUAL_ENV" ] && echo "$P_CYAN($(basename "$VIRTUAL_ENV")) $P_CLEAR")"
	PS1="${venv}${rv}${bat}$PROMPT_SAVE${git}\$ "
	stty -echo; echo -n $'\e[6n'; read -d R x; stty echo
	[ "${x#*;}" -eq 1 ] || echo -en "\n"
}

jmp_dir="$HOME/.cache/jmp"
jmp="$jmp_dir/jmp"

alias cd..="cd .."
alias ..="cd .."

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias car="ccat"
alias cat="ccat"
alias matlab="matlab -nodesktop -nosplash"
alias jn="swallow jupyter notebook"
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias hgrep='history | grep --color=auto'
alias ping="ping -c1 -w 1"

exe colordiff && alias diff="colordiff"
exe neomutt   && alias mutt="neomutt"
exe vimpager  && alias less="vimpager"
exe swallow   && alias gimp="swallow gimp"
exe swallow   && alias audacity="swallow audacity"
exe swallow   && alias sxiv="swallow sxiv"


-() { builtin cd -; }

alias cd="cdls"

cdls()
{
	builtin cd "$@" && ls && realpath . >> "$jmp" && sed -i 1d "$jmp" 
}

pd()
{
	if [ $# -eq 0 ]; then
		popd
	else
		pushd "$@"
	fi
}

j()
{
	[ $# -ne 0 ] && pattern=".*$(echo "$@" | sed "s/\s\+/.*\/.*/g")[^\/]*$"

	if [ "$1" = "--setup" ]; then
		mkdir -p "$jmp_dir"
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


if test "$(find ~/.bashrc -mmin +1000)"; then
	touch ~/.bashrc && (ping -c 1 -w 1 8.8.8.8) &>/dev/null && dots stash-pull
fi

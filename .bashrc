# If not running interactively, don't do anything
echo $- | grep -q "i" || return
set +e

TMUX_DEFUALT_SESSION="default"
if [ -n "$SSH_TTY" ]; then
	export SSH_TTY
elif [ -z "$TMUX" ] && [ -x "$(which tmux 2>/dev/null)" ]; then
	if tmux "ls" | grep "$TMUX_DEFUALT_SESSION"; then
		i="$(tmux ls | grep -o '^default[0-9][0-9]*' | sort -rn | sed "s/default//g" | awk '{ print $1 + 1 } END { print 1 }' | head -n 1)"
		exec tmux new-session -t "$TMUX_DEFUALT_SESSION" -s "${TMUX_DEFUALT_SESSION}${i}" \; new-window
	else
		exec tmux new-session -s "$TMUX_DEFUALT_SESSION"
	fi
fi

exe() { [ -x "$(command -v "$1")" ]; }
ssource() { [ -r "$1" ] && source "$1"; }

ssource "$HOME/.bashrc.local"
ssource "$HOME/.bash_aliases"
ssource "$HOME/.git-completion.bash"
ssource "$HOME/.bash-completion.bash"
ssource "$HOME/.cargo/env"

HISTCONTROL=ignoreboth
HISTSIZE=
HISTFILESIZE=
P_RED="\[$(tput setaf 1)\]"
P_GREEN="\[$(tput setaf 2)\]"
P_CYAN="\[$(tput setaf 6)\]"
P_CLEAR="\[$(tput sgr0)\]"

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
	ssource /usr/share/bash-completion/bash_completion || ssource /etc/bash_completion
fi

if exe dircolors; then
	if test -r ~/.dircolors; then
		eval "$(dircolors -b ~/.dircolors)"
	else
		eval "$(dircolors -b)"
	fi
fi

PS1='\u@\h:\w'
if exe tput && tput setaf 1 >&/dev/null; then
	PS1="\[\033[01;32m\]\u${SSH_TTY:+@\h}\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]"
fi

PROMPT_COMMAND="save_rv;do_cwd;prompt_command"
PROMPT_SAVE="$PS1"
RV=0
save_rv() {
	RV=$?
}

prompt_command()
{
	rv="$( ([ $RV -ne 0 ] || history -p !! | head -n 1 | grep -qE "^\[|^test") && echo -n "${P_RED}[$RV]$P_CLEAR ")"
	bat="$(low-battery 2>/dev/null && echo -en "${P_RED}[Low Battery] $P_CLEAR")"
	gb="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
	gd="$(git status 2>/dev/null | grep -q "clean" || echo "*")"
	git="${gb:+$P_GREEN ($gb$gd)$P_CLEAR}"
	venv="$( [ -n "$VIRTUAL_ENV" ] && echo "$P_CYAN($(basename "$VIRTUAL_ENV")) $P_CLEAR")"
	[ -z "$NLPROMPT" ] && PS1="${venv}${rv}${bat}$PROMPT_SAVE${git}\$ " || PS1="${venv}${rv}${bat}$PROMPT_SAVE${git}\n\$ "
	stty -echo; echo -n $'\e[6n'; read -d R x; stty echo
	[ "${x#*;}" -eq 1 ] || echo -en "\n"
}

jmp_dir="$HOME/.cache/jmp"
jmp="$jmp_dir/jmp"

norealias() {
	arg="${1%=*}"
	if ! alias "$arg" 2>/dev/null | grep -q "."; then
		alias "$@"
	fi
}

norealias cd..="cd .."
norealias ..="cd .."

norealias ll='ls -alF'
norealias la='ls -A'
norealias l='ls -CF'
norealias namp="nmap"
norealias car="ccat"
norealias cat="ccat"
norealias matlab="matlab -nodesktop -nosplash"
norealias jn="swallow jupyter notebook"
norealias ls='ls --color=auto --group-directories-first'
norealias grep='grep --color=auto'
norealias hgrep='history | grep --color=auto'
norealias ping="ping -c1 -w 1"
norealias vim="vvim"
norealias ssj=ssh

alias vf='vim -O $($(fc -nl -1))'

exe colordiff && alias diff="colordiff"
exe neomutt   && alias mutt="neomutt"
exe vimpager  && alias less="vimpager"
exe swallow   && alias gimp="swallow gimp"
exe swallow   && alias audacity="swallow audacity"
exe swallow   && alias sxiv="swallow sxiv"
exe rg || norealias rg="grep -rn"


-() { builtin cd - || return; }

pd()
{
	if [ $# -eq 0 ]; then
		popd || return;
	else
		pushd "$@" || return;
	fi
}

__OLD_PWD="$PWD"
do_cwd() {
	if [ "$__OLD_PWD" != "$PWD" ]; then __OLD_PWD="$PWD"
		ls 
		! [ -f "$jmp" ] && j --setup
		realpath . >> "$jmp" && [ "$(wc -l < "$jmp")" -lt 10000 ] && sed -i 1d "$jmp"
		venv
	fi
}


venv() {
	if [ -n "$VIRTUAL_ENV" ]; then
		if ! realpath "$PWD/" | grep -q -F "$(dirname "$VIRTUAL_ENV")"; then
			deactivate
		fi
	else
		ssource "env/bin/activate"
		ssource "../env/bin/activate"
		ssource "../../env/bin/activate"
	fi
}

j()
{
	[ $# -ne 0 ] && pattern=".*$(echo "$@" | sed "s/\s\+/.*\/.*/g")[^\/]*$"

	if ! [ -r "$jmp" ]; then
		mkdir -p "$jmp_dir"
		time=$(date +%D --date="-2 month" 2>/dev/null)
		(find "$HOME" -type d -not -path "*/\.*" -newermt "$time" && yes "") | head -n 1000 > "$jmp"
	fi

	new_dir=$(tac "$jmp" | grep -m 1 -i "$pattern")
	if echo "$PWD" | grep -qi "$pattern"; then
		new_dir=$(tac "$jmp" | grep -i "$pattern" | awk '!a[$0]++' | sed -e '1h;$G' | grep -m 1 -A 1 "^$PWD$" | tail -n 1)
	fi

	[ -z "$new_dir" ] && return 1
	if ! builtin cd "$new_dir" 2>/dev/null; then
		grep -vF "$new_dir" "$jmp" > "$jmp_dir/tmp"
		mv "$jmp_dir/tmp" "$jmp"
		j
	fi
	return $?
}

bind -m vi-command '"ciw": "lbcw"'
bind -m vi-command '"diw": "lbdw"'
bind -m vi-command '"yiw": "lbyw"'
bind -m vi-command '"ciW": "lBcW"'
bind -m vi-command '"diW": "lBdW"'
bind -m vi-command '"yiW": "lByW"'

SSH_AGENT_CACHE="$HOME/.cache/.ssh-agent"

ssh-add -l &>/dev/null
if [ "$?" == 2 ]; then
	ssource "$SSH_AGENT_CACHE" >/dev/null
	ssh-add -l &>/dev/null
	if [ "$?" == 2 ]; then
		(umask 066; ssh-agent -t 3600 > "$SSH_AGENT_CACHE")
		ssource "$SSH_AGENT_CACHE" >/dev/null
	fi
fi


if test "$(find ~/.bashrc -mmin +1000)"; then
	touch ~/.bashrc && (ping -c 1 -w 1 8.8.8.8) &>/dev/null && dots pull --autostash
fi

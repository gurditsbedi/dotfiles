# If not running interactively, don't do anything {{{
case $- in
    *i*) ;;
      *) return;;
esac
# }}}
# Bash Settings {{{
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=5000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
#}}}
# Not used Yet {{{
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# }}}
# Prompt Settings {{{
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color|alacritty) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;38;5;166m\]\u \[\033[00m\]at \[\033[01;38;5;136m\]\h\[\033[00m\] in \[\033[01;38;5;33m\]\w\[\033[01;38;5;64m\] $(__git_ps1 "\[[%s\]]" ) \[\033[00m\]\n₹ '
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w₹'
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#}}}
# Originally Present {{{
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# }}}
# aliases {{{
alias ls='ls -lh --color=auto'
alias c='clear'
alias q='exit'

alias r='reset'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cdd='cd ~/Desktop'
alias cdt='cd /tmp/'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias xcp='xclip -sel clip'

alias mkdir='mkdir -p'

alias dbc='xdg-open'            # emulate double click
alias e='nvim'                  # edit file neovim
alias m='cmus'

alias cp="cp -i"                # confirm before overwriting something
# }}}
# custom funtions {{{
# ex - archive extractor
# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Change Desktop Background
# Selects a random picture from a given directory and sets it as the wallpaper
# usage: changeDesktopBackground <location>
#                                default-value "$HOME/Pictures/Wallpapers/"
# example: changeDesktopBackground $HOME/Pictures/Wallpapers/

changeDesktopBackground ()
{
    loc=${1:-"$HOME/Pictures/Wallpapers/"}
    file="$(ls --format=single-column $loc | sort --random-sort | head -n1)"
    gsettings set org.gnome.desktop.background picture-uri "$loc$file"
}

# }}}
# History Ignores {{{
    HISTIGNORE="$HISTIGNORE:e:q:r:f:z *"
# }}}
# PATH additions, exports  {{{
export PATH="$HOME/.local/bin:$PATH"
# /sbin/
export PATH="/sbin:$PATH"
export EDITOR="nvim"

# git
. ~/.git-prompt.sh
. ~/.git-completion.bash
export GIT_PS1_SHOWDIRTYSTATE=1

# for fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export TERM=alacritty
# }}}
# programs initilizations {{{
# z tool
. ~/.z.sh
# direnv
eval "$(direnv hook bash)"
# }}}

# vim:foldmethod=marker:foldlevel=0

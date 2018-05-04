
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
HISTSIZE=1000
HISTFILESIZE=2000

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
    xterm-color|*-256color) color_prompt=yes;;
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
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias cdd='cd ~/Desktop'
alias cdt='cd /tmp/'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias erc="nvim ~/.bashrc"
alias src="source ~/.bashrc"

alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'

alias xcp='xclip -sel clip'

alias mkdir='mkdir -p'

alias py=/usr/bin/python3
alias py3=/usr/bin/python3
alias python=/usr/bin/python3
alias py2=/usr/bin/python2
alias python2=/usr/bin/python2
alias ipy=/usr/bin/ipython3
alias ipy2=/usr/bin/ipython
alias ipy3=/usr/bin/ipython3

alias dbc='xdg-open'            # emulate double click
alias e='nvim'                  # edit file neovim
alias v='nvim -M'               # view file in neovim(syntax higlighted view)
alias m='cmus'

# git
alias g='git'


alias cp="cp -i"                # confirm before overwriting something
alias df='df -h'                # human-readable sizes
alias free='free -m'            # show sizes in MB
alias more='less'


# }}}
# transfer.sh {{{
transfer() { if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
    tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; echo;}

# Examples:
#     ix hello.txt              # paste file (name/ext will be set).
#     echo Hello world. | ix    # read from STDIN (won't set name/ext).
#     ix -n 1 self_destruct.txt # paste will be deleted after one read.
#     ix -i ID hello.txt        # replace ID, if you have permission.
#     ix -d ID

ix() {
    local opts
    local OPTIND
    [ -f "$HOME/.netrc" ] && opts='-n'
    while getopts ":hd:i:n:" x; do
        case $x in
            h) echo "ix [-d ID] [-i ID] [-n N] [opts]"; return;;
            d) $echo curl $opts -X DELETE ix.io/$OPTARG; return;;
            i) opts="$opts -X PUT"; local id="$OPTARG";;
            n) opts="$opts -F read:1=$OPTARG";;
        esac
    done
    shift $(($OPTIND - 1))
    [ -t 0 ] && {
        local filename="$1"
        shift
        [ "$filename" ] && {
            curl $opts -F f:1=@"$filename" $* ix.io/$id
            return
        }
        echo "^C to cancel, ^D to send."
    }
    curl $opts -F f:1='<-' $* ix.io/$id
}

# }}}
# ix.io {{{
ix() {
            local opts
            local OPTIND
            [ -f "$HOME/.netrc" ] && opts='-n'
            while getopts ":hd:i:n:" x; do
                case $x in
                    h) echo "ix [-d ID] [-i ID] [-n N] [opts]"; return;;
                    d) $echo curl $opts -X DELETE ix.io/$OPTARG; return;;
                    i) opts="$opts -X PUT"; local id="$OPTARG";;
                    n) opts="$opts -F read:1=$OPTARG";;
                esac
            done
            shift $(($OPTIND - 1))
            [ -t 0 ] && {
                local filename="$1"
                shift
                [ "$filename" ] && {
                    curl $opts -F f:1=@"$filename" $* ix.io/$id
                    return
                }
                echo "^C to cancel, ^D to send."
            }
            curl $opts -F f:1='<-' $* ix.io/$id
        }


# }}}
# custom funtions {{{

# reddit expander
rd() {
    code="arr = document.getElementsByClassName('expando-button');  for (var i = 0, len = arr.length; i < len; i++) arr[i].click();"
    echo $code | xclip -sel clip
    echo "copied: $code"
}

# mardown viewer in terminal (hack)
mdv() {
    file=${1:-"README.md"}
    pandoc $file | lynx -stdin
}

# Tree - if the original tree command does not exists
if [ ! -x "$(which tree 2>/dev/null)" ]
then
    alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi

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
#changeDesktopBackground


# }}}
# fzf-awesomeness {{{
fzfDmenu() {
	# note: xdg-open has a bug with .desktop files, so we cant use that shit
	selected="$(\ls /usr/share/applications | fzf)"
	nohup `grep '^Exec' "/usr/share/applications/$selected" | head -1 | sed 's/^Exec=//' | sed 's/%.//'` >/dev/null 2>&1&
}
# hotkey to run the function (Ctrl+O)
bind '"\C-O":"fzfDmenu\n"'

cdk() {
    selected="$(\ls $HOME/Desktop/ | fzf)"
    cd "$HOME/Desktop/$selected"
}
# }}}
# History Ignores {{{
    HISTIGNORE="$HISTIGNORE:rd"
    HISTIGNORE="$HISTIGNORE:e"
    HISTIGNORE="$HISTIGNORE:q"
    HISTIGNORE="$HISTIGNORE:r"
# }}}
# PATH additions, exports  {{{
export PATH="$HOME/.local/bin:$PATH"
# /sbin/
export PATH="/sbin:$PATH"
# git
. ~/.git-prompt.sh
. ~/.git-completion.bash
export GIT_PS1_SHOWDIRTYSTATE=1
# added by Anaconda3 installer
#export PATH="$HOME/anaconda3/bin:$PATH"
export PATH="$HOME/anaconda3/envs/imgseg/bin:$PATH"
. /home/gurditsbedi/anaconda3/etc/profile.d/conda.sh
# android
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
# for fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# apex cli tab completion
_apex()  {
  COMPREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local opts="$(apex autocomplete -- ${COMP_WORDS[@]:1})"
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  return 0
}
complete -F _apex apex
# }}}

# vim:foldmethod=marker:foldlevel=0

##############################################################
# DEBUGGING
##############################################################

function printHookFunctions () {
    print -C 1 ":::pwd_functions:" $chpwd_functions
    print -C 1 ":::periodic_functions:" $periodic_functions
    print -C 1 ":::precmd_functions:" $precmd_functions
    print -C 1 ":::preexec_functions:" $preexec_functions
    print -C 1 ":::zshaddhistory_functions:" $zshaddhistory_functions
    print -C 1 ":::zshexit_functions:" $zshexit_functions
}

# reloads all functions
# http://www.zsh.org/mla/users/2002/msg00232.html
r() {
    local f=($ZSH_CONFIG_HOME/functions/*(.))
    unfunction $f:t 2> /dev/null
    autoload -Uz $f:t
}

# web feed alternative to rss
# atomtitles () { curl --silent $1 | xmlstarlet sel -N atom="http://www.w3.org/2005/Atom" -t -m /atom:feed/atom:entry -v atom:title -n}

##############################################################
# TODO TMUX - to be revised
##############################################################

tmux-hglog() {
    tmux kill-pane -t 1
    tmux split-window -h -l 40 "while true; do clear; date; echo; hg xlog-small -l 5 || exit; sleep 600; done;"
    tmux select-pane -t 0
}

# tmux-neww-in-cwd - open a new shell with same cwd as calling pane
# http://chneukirchen.org/dotfiles/bin/tmux-neww-in-cwd
tmux-neww-in-cwd() {
    SIP=$(tmux display-message -p "#S:#I:#P")

    PTY=$(tmux server-info |
    egrep flags=\|bytes |
    awk '/windows/ { s = $2 }
    /references/ { i = $1 }
    /bytes/ { print s i $1 $2 } ' |
    grep "$SIP" |
    cut -d: -f4)

    PTS=${PTY#/dev/}

    PID=$(ps -eao pid,tty,command --forest | awk '$2 == "'$PTS'" {print $1; exit}')

    DIR=$(readlink /proc/$PID/cwd)

    tmux neww "cd '$DIR'; $SHELL"
}


##############################################################
# AUTOLOAD
##############################################################

# -U disables alias expansion while the function is being loaded.
# -z forces zsh-style autoloading even if KSH_AUTOLOAD is set for whatever reason.

autoload -Uz zmv
# noglob so you don't need to quote the arguments of zmv
# mmv *.JPG *.jpg
alias mmv='noglob zmv -W'

autoload -Uz colors


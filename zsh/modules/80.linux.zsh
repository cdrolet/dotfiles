
if [[ $TERM == "xterm" ]]; then
    export TERM="xterm-256color"
fi

# activate ls colors


which dircolors > /dev/null

if [[ $? -eq 0 && -a $ZSH_DIRCOLORS && $TERM == *256* ]]; then
    eval `dircolors -b $ZSH_DIRCOLORS`
else
    eval `dircolors -b`
fi

# At this point, $LS_COLORS should have beeen initialized from dircolors and possibly .dircolors


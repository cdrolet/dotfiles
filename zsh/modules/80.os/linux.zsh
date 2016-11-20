
if [[ "$OSTYPE" != linux* ]]; then
  return 1
fi

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




# Load command-not-found
# Debian-based
if [[ -s '/etc/zsh_command_not_found' ]]; then
    source '/etc/zsh_command_not_found'
# Arch Linux-based
elif [[ -s '/usr/share/doc/pkgfile/command-not-found.zsh' ]]; then
    source '/usr/share/doc/pkgfile/command-not-found.zsh'
fi    

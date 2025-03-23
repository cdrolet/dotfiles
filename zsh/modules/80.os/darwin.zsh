if [[ "$OSTYPE" != darwin* ]]; then
  return 1
fi

##############################################################
# ENVIRONMENT
##############################################################

# Homebrew paths
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"

# Set up PATH with both Homebrew and GNU utils
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:$PATH"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

# The OSX way for ls colors.
export CLICOLOR=1
export LSCOLORS="gxfxcxdxbxegedabagacad"

# Activate gls colors
if [[ -a $ZSH_DIRCOLORS ]]; then
    if [[ "$TERM" == *256* ]]; then
        which gdircolors > /dev/null && eval "`gdircolors -b $ZSH_DIRCOLORS`"
    else
        # standard colors for non-256-color terms
        which gdircolors > /dev/null && eval "`gdircolors -b`"
    fi
else
    which gdircolors > /dev/null && eval "`gdircolors -b`"
fi

#iterm2 integration to zsh
test -e "$HOME/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

##############################################################
# FUNCTIONS
##############################################################

# Start a webcam for screencast
function webcam () {
    mplayer -cache 128 -tv driver=v4l2:width=350:height=350 -vo xv tv:// -noborder -geometry "+1340+445" -ontop -quiet 2>/dev/null >/dev/null
}

##############################################################
# ALIAS
##############################################################

# Flush the DNS on Mac
alias dnsflush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# Darwin ls command does not support --color option.
alias l="gls -oAhtr --group-directories-first --color=always"
alias ls="gls --color=always"

# Copy and paste and prune the useless newline
alias pbcopynn='tr -d "\n" | pbcopy'


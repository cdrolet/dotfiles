##############################################################
# CACHE 
##############################################################

export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"
mkdir -p $ZSH_CACHE

##############################################################
# SEARCH PATH
##############################################################

export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$ZSH_CONFIG_HOME/bin:$PATH

##############################################################
# OTHERS
##############################################################

export DOTFILE_HOME=${PWD}
export TERM="xterm-256color"
export ZSH_DIRCOLORS="$HOME/.dircolors/dircolors.256dark"
export EDITOR="vi"
# Treat these characters as part of a word.
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
export PATH="/opt/homebrew/bin/kubectl:$PATH"

##############################################################
# LOCALE
##############################################################

# only define LC_CTYPE if undefined
if [[ -z "$LC_CTYPE" && -z "$LC_ALL" ]]; then
    # pick the first entry from LANG
	export LC_CTYPE=${LANG%%:*}
fi

# Reset to default key bindings.
bindkey -d



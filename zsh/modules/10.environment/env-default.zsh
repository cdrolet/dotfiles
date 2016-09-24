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
export PATH=$HOME/.local/sbin:$PATH
export PATH=$ZSH_CONFIG_HOME/bin:$PATH

##############################################################
# OTHERS
##############################################################

export ZSH_DIRCOLORS="$HOME/.dircolors/dircolors.256dark"
#export EDITOR="vim"

##############################################################
# LOCALE
##############################################################

# only define LC_CTYPE if undefined
if [[ -z "$LC_CTYPE" && -z "$LC_ALL" ]]; then
    # pick the first entry from LANG
	export LC_CTYPE=${LANG%%:*}
fi

##############################################################
# OPTIONS
##############################################################

# treat  the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation, etc.  (An initial unquoted ‘~’ always produces named directory expansion.)
setopt EXTENDED_GLOB



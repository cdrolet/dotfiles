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
export EDITOR="vim"


##############################################################
# LOCALE
##############################################################

# only define LC_CTYPE if undefined
if [[ -z "$LC_CTYPE" && -z "$LC_ALL" ]]; then
	export LC_CTYPE=${LANG%%:*} # pick the first entry from LANG
fi

##############################################################
# OPTIONS
##############################################################

# treat  the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation, etc.  (An initial unquoted ‘~’ always produces named directory expansion.)
setopt EXTENDED_GLOB

# do not allows > redirection to truncate existing files, and >> to create files. >! must be used to truncate a file, and >>! to create a file.
setopt NO_CLOBBER

# if unset, output flow control via start/stop characters (usually assigned to ^S/^Q) is disabled in the shell’s editor,
# so I can reuse these keys for more useful feature
setopt NO_FLOW_CONTROL

# no Beep on error in ZLE.
setopt NO_BEEP

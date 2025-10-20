##############################################################
# CACHE
##############################################################

export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"
mkdir -p $ZSH_CACHE

##############################################################
# SEARCH PATH
##############################################################

# Homebrew paths (must be set early for tool initialization)
if [[ "$OSTYPE" == darwin* ]]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
fi

export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$ZSH_CONFIG_HOME/bin:$PATH

##############################################################
# OTHERS
##############################################################

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
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

##############################################################
# DIRENV - AUTO-LOAD ENVIRONMENT PER DIRECTORY
##############################################################

# Initialize direnv (loads .envrc files per directory)
eval "$(direnv hook zsh)"

# direnv automatically loads/unloads environment variables
# based on .envrc files in directories
# Example .envrc:
#   export DATABASE_URL=postgres://localhost/mydb
#   export NODE_ENV=development

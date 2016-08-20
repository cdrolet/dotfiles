##############################################################
# CACHE 
##############################################################

export XDG_CACHE_HOME="$HOME/.cache"
export ZSH_CACHE="$XDG_CACHE_HOME/zsh"
mkdir -p $ZSH_CACHE

##############################################################
# COLORS 
##############################################################

export ZSH_DIRCOLORS="$HOME/.dircolors/dircolors.256dark"

##############################################################
# SEARCH PATH
##############################################################

export PATH=/usr/local/sbin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/sbin:$PATH
export PATH=$ZSH_CONFIG_HOME/bin:$PATH

##############################################################
# FUNCTION PATH
##############################################################

local function_path="$ZSH_CONFIG_HOME/functions"

# Autoload function path
# adds all directories below function_path to `$fpath', while ignoring "CVS" directories
# http://unix.stackexchange.com/questions/33255/how-to-define-and-load-your-own-shell-function-in-zsh
fpath=(
    $function_path
    $function_path/**/*~*/(CVS)#(/N)
    "${fpath[@]}"
)

# -U disables alias expansion while the function is being loaded.
# -z forces zsh-style autoloading even if KSH_AUTOLOAD is set for whatever reason.
autoload -Uz $function_path/*(:t)

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

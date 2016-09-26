
# -U disables alias expansion while the function is being loaded.
# -z forces zsh-style autoloading even if KSH_AUTOLOAD is set for whatever reason.

autoload -Uz zmv
# noglob so you don't need to quote the arguments of zmv: mmv *.JPG *.jpg
alias mmv='noglob zmv -W'

autoload -Uz colors

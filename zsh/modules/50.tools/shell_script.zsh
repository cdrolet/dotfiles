# create a new script, automatically populating the shebang line, editing the
# script, and making it executable.
# http://www.commandlinefu.com/commands/view/8050/
shebang() {
    name=${1:?filename required}
    shell=${2:-bash}

    if i=$(command -v $shell); then
        printf '#!/usr/bin/env %s\n\n' $shell > $name && chmod 755 $name && hx $name && chmod 755 $name;
    else
        echo "Could not find $shell, is it in your \$PATH?";
    fi;
    # in case the new script is in path, this throw out the command hash table and
    # start over  (man zshbuiltins)
    rehash
}

##############################################################
# COLOR
##############################################################

colortest () {
    for code ({000..255}) print -P -- "$code: %F{$code}This is how your text would look like%f"
}

# Colors
COL_RED="001"
COL_GREEN="002"
COL_YELLOW="003"
COL_BLUE="004"
COL_MAGENTA="005"
COL_CYAN="006"

##############################################################
# ECHOES
##############################################################

echoAndRun() {
    echo -e "$@"
    "$@"
}

##############################################################
# DEBUGGING
##############################################################

printHookFunctions () {
    print -C 1 ":::pwd_functions:" $chpwd_functions
    print -C 1 ":::periodic_functions:" $periodic_functions
    print -C 1 ":::precmd_functions:" $precmd_functions
    print -C 1 ":::preexec_functions:" $preexec_functions
    print -C 1 ":::zshaddhistory_functions:" $zshaddhistory_functions
    print -C 1 ":::zshexit_functions:" $zshexit_functions
}

# reloads all functions
# http://www.zsh.org/mla/users/2002/msg00232.html
reloadFunctions() {
    local f=($ZSH_CONFIG_HOME/functions/*(.))
    unfunction $f:t 2> /dev/null
    autoload -Uz $f:t
}

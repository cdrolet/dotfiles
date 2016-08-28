
initHome() {
    local source=~/.zshrc
    # resolve $source until the file is no longer a symlink
    while [ -h "$source" ]; do
        ZSH_CONFIG_HOME="$( cd -P "$( dirname "$source" )" && pwd )"
        source="$(readlink "$source")"
        # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
        [[ $source != /* ]] && source="$ZSH_CONFIG_HOME/$source"
    done

    export ZSH_CONFIG_HOME="$( cd -P "$( dirname "$source" )" && pwd )"
    
    ZSH_MODULES=$ZSH_CONFIG_HOME/modules
    ZSH_ALIASES=$ZSH_CONFIG_HOME/aliases
    ZSH_OS=$ZSH_CONFIG_HOME/os
    ZSH_FUNCTIONS=$ZSH_CONFIG_HOME/functions
    setopt EXTENDED_GLOB
}

initModules() {
    for file in $(ls $ZSH_MODULES/*.zsh | sort); do
        echo " ===> $file " 
        source $file
    done
}

initFunctions() {
    # http://unix.stackexchange.com/questions/33255/how-to-define-and-load-your-own-shell-function-in-zsh
    fpath=(
        $ZSH_FUNCTIONS
        "${fpath[@]}"
    )
    autoload -Uz $ZSH_FUNCTIONS/*(.)
}

initAliases() {
    for file in $(ls ZSH_ALIASES/**/*.zsh); do
        echo " ---> $file " 
        source $file
    done
}

initHome

initModules

initFunctions

initAliases

# Need to install the command-not-found hook
# Pacman: pkgfile
# TODO to be moved, in os?
source /usr/share/doc/pkgfile/command-not-found.zsh

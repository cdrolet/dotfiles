
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
    ZSH_FUNCTIONS="functions"
    
    export PROMPT_HIDDEN_USER=(root c cdrolet)
}

scanModules() {

    for module in $(ls -d $ZSH_MODULES/<0-100>.* | sort -t'.' -k1n); do
        scanFunctions $module
        scanSource $module
    done
}

scanFunctions() {

    functionsPath=$1/$ZSH_FUNCTIONS
    if [ ! -d $functionsPath ]; then
        return 1;
    fi

    fpath=($functionsPath $fpath)
    
    for function in $(echo $functionsPath/*(.N)); do
        autoload -Uz $function
    done
}

scanSource() {

    setopt extended_glob
    for file in $(echo $1/**/*.zsh(.N)); do
        name=$( dirname "$file" )

        #skip external directory
        if [[ ${name#*external} != $name ]]; then
            continue;
        fi

        source $file
    done
}


initHome

scanModules

# INSTALL
# Need to install the command-not-found hook
# Pacman: pkgfile

#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="/usr/local/opt/python@3.7/bin:$PATH"

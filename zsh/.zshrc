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

 #stopwatch2=`date +%s`;
# echo -ne "scan source in $(date -u --date @$((`date +%s` - $stopwatch1)) +%H:%M:%S)\r";

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

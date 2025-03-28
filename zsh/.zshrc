typeset -i record_metrics=2 # 0 to disable metrics, 1 for only > 0 seconds, 2 for all
# to output execution
# set -x
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
        track "scanFunctions $module"
        track "scanSource $module"
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
        filename=$( basename "$file" )

        #skip external directory and files starting with #
        if [[ ${name#*external} != $name ]] || [[ $filename == \#* ]]; then
            continue;
        fi

        source $file
    done
}

sdkMan() {
    # SDKMAN initialization
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
}

 # 0 to disable metrics, 1 for only > 0 seconds, 2 for all
track() {
    local step_stopwatch=0
    if [ $record_metrics -gt 0 ]; then
        step_stopwatch=$(/opt/homebrew/bin/gdate +%s%3N)
    fi

    # Execute the function passed as parameters
    local function_call="$@"
    local function_name="$1"
    eval "$function_call"

    if [ $record_metrics -gt 0 ]; then
        local end_time=$(/opt/homebrew/bin/gdate +%s%3N) 
        local total_time=$((end_time - step_stopwatch))
        if [ $record_metrics -eq 2 ] || ([ $record_metrics -eq 1 ] && [ $total_time -gt 0 ]); then
            if [ $total_time -ge 1000 ]; then
                printf "- %s loaded in %.2f seconds\n" "$function_call" "$(( total_time / 1000.0 ))"
            else
                echo "- $function_call loaded in ${total_time}ms"
            fi
        fi
    fi
}

full_stopwatch=$(/opt/homebrew/bin/gdate +%s%3N)

track "initHome"
track "scanModules"
track "sdkMan"

if [ $record_metrics -gt 0 ]; then
    
    end_time=$(/opt/homebrew/bin/gdate +%s%3N)
    total_time=$((end_time - full_stopwatch))
    
    if [ $total_time -ge 1000 ]; then
        printf "Total startup time: %.2f seconds\n" "$(( total_time / 1000.0 ))"
    else
        echo "Total startup time: ${total_time}ms"
    fi
fi
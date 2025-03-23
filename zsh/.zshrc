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

        #skip external directory
        if [[ ${name#*external} != $name ]]; then
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

track() {
    local step_stopwatch=0
    if [ $record_metrics -gt 0 ]; then
        if command -v gdate >/dev/null 2>&1; then
            step_stopwatch=$(gdate +%s%N)
        else
            step_stopwatch=$(($(date +%s) * 1000)) # Fallback to milliseconds using regular date
        fi
    fi

    # Execute the function passed as parameters
    local function_call="$@"
    local function_name="$1"
    eval "$function_call"

    if [ $record_metrics -gt 0 ]; then
        if command -v gdate >/dev/null 2>&1; then
            end_time=$(gdate +%s%N)
            local totalTime=$(( (end_time - step_stopwatch) / 1000000 )) # Convert to milliseconds
        else
            end_time=$(($(date +%s) * 1000))
            local totalTime=$((end_time - step_stopwatch))
        fi
        if [ $record_metrics -eq 2 ] || ([ $record_metrics -eq 1 ] && [ $totalTime -gt 0 ]); then
            if [ $totalTime -ge 1000 ]; then
                printf "- %s loaded in %.2f seconds\n" "$function_call" "$(( totalTime / 1000.0 ))"
            else
                echo "- $function_call loaded in ${totalTime}ms"
            fi
        fi
    fi
}

# to output execution
# set -x
record_metrics=1 # 0 to disable metrics, 1 for only > 0 seconds, 2 for all
if command -v gdate >/dev/null 2>&1; then
    full_stopwatch=$(gdate +%s%N)
else
    full_stopwatch=$(($(date +%s) * 1000))
fi

track "initHome"
track "scanModules"
track "sdkMan"

if [ $record_metrics -gt 0 ]; then
    if command -v gdate >/dev/null 2>&1; then
        end_time=$(gdate +%s%N)
        total_ms=$(( (end_time - full_stopwatch) / 1000000 ))
    else
        end_time=$(($(date +%s) * 1000))
        total_ms=$((end_time - full_stopwatch))
    fi
    if [ $total_ms -ge 1000 ]; then
        printf "Total startup time: %.2f seconds\n" "$(( total_ms / 1000.0 ))"
    else
        echo "Total startup time: ${total_ms}ms"
    fi
fi
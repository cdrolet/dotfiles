#!/usr/bin/env bash

out() {
    printf "\n"
    for text in "$@";do
        printf "$text\n"
    done
}

indent() {
    printf "    "
    $@
}

initGlobalVariables() {
    shopt -s dotglob

    SOURCE_DIR="$1"
    BACKUP_DIR="$SOURCE_DIR"/backup
    REVERT_FILE="$SOURCE_DIR"/revert_dotfiles.sh
    TEMP_FILE="$SOURCE_DIR"/files.tmp
    SELECTED_FILES=()
    OVERWRITTEN_FILES=()
    readarray -t IGNORED_FILES < "$SOURCE_DIR"/.dotignore
    IGNORED_FILES+=("$(basename "$BACKUP_DIR")")
    MAX_SCAN_LEVEL=1
    FORCE=1
    
}

readCommandArgs() {
}

arrayContains () { 
    local array="$1[@]"
    local seeking=$2
    local in=1
    for element in "${!array}"; do
        if [[ $element == $seeking ]]; then
            in=0
            break
        fi
    done
    return $in
}


cleanupGlobalVariables() {

    unset SELECTED_FILES
    unset SOURCE_DIR
    unset BACKUP_DIR
    unset REVERT_FILE
    unset TEMP_FILE
    unset IGNORED_FILES
    unset MAX_SCAN_LEVEL
}


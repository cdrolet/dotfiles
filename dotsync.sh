#!/usr/bin/env bash

#   Author: Charles Drolet
#
#   This script do the following:
#
#   1. Update your current local dotfiles repo with latest remote changes.
#
#   2. Scan this repo and subfolders for every file and folder starting with a dot
#      Only the root and the first level of subfolder are scanned.
#
#   3. Propose to the user the following list of changes:
#       - Create symlinks from your home directory to the files from step 2.
#       - Backup any file in your home repository that may be overwritten by the symlink creation.
#       - Remove old symlinks from your home directory to missing file from this repo.
#
#   This preview include the name of every files involved and the action that will be taken.
#   It will also report:
#       - Rejected file from potential conflict when two files having the same name from different directory.
#       - Ignored file when a file name is listed in the .dotignore file
#       - Skipped file when a file is already symlinked to this repo.
#
#   4. If user confirm to proceed with the changes proposal:
#       - apply them all at once.
#       - create a symlink to the dotrevert.sh
#
#
#   usage:
#
#   sh dotsync.sh [-f] [-t filename]
#
#   -f: don't ask for user confirmation before applying changes.
#   -t: only apply to the specified filename.

out() {
    printf "\n"
    for text in "$@";do
        printf "$text\n"
    done
}

ind() {
    printf "    "
}

readCommandArgs() {
    FORCE=1

    while getopts 'ft:v' flag; do
        case "${flag}" in
            f) FORCE=0 ;;
            t) TARGET="${OPTARG}" ;;
            *) error "Unexpected option ${flag}" ;;
        esac
    done
}

initSourceDir() {
    local source="${BASH_SOURCE[0]}"
    # resolve $source until the file is no longer a symlink
    while [ -h "$source" ]; do
        SOURCE_DIR="$( cd -P "$( dirname "$source" )" && pwd )"
        source="$(readlink "$source")"
        # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
        [[ $source != /* ]] && source="$SOURCE_DIR/$source"
    done
    SOURCE_DIR="$( cd -P "$( dirname "$source" )" && pwd )"
}


initSynchVariables() {
    shopt -s dotglob

    initSourceDir
    
    BACKUP_DIR="$SOURCE_DIR"/backup
    REVERT_FILE="$SOURCE_DIR"/dotrevert.sh
    SELECTED_FILES=()
    SKIPPED_FILES=()
    OVERWRITTEN_FILES=()
    REJECTED_FILES=()
    BROKEN_FILES=()
    IGNORED_FILES=($(awk -F= '{print $1}' $SOURCE_DIR/.dotignore))
    IGNORED_FILES+=("$(basename "$BACKUP_DIR")")
    MAX_SCAN_LEVEL=2

}

updateFromRepo() {

    out "Updating $SOURCE_DIR to master." ""

    cd "$SOURCE_DIR"
    git pull origin master
    git submodule foreach git pull origin master
    cd
    out
}

selectFiles() {

    if [ -z $TARGET ]; then
        out "Scanning dot files:"
    else
        out "targeting dot files: "$TARGET""
    fi

    selectFileTree "$SOURCE_DIR"
}

selectFileTree() {

    if isIllegible "$1"; then
        selectFile $1
        return
    fi

    local level=${2:-0}

    # look for dotfiles in subfolders
    if [ -d "$1" ] && [ "$level" -lt $MAX_SCAN_LEVEL ]; then
        if ! isIgnored $(basename "$1"); then
            scanDir "$1" $((level+1))
        fi
    fi
}

scanDir() {
    for file in $1/*;do
      selectFileTree "$file" $2
    done
}

isIllegible() {

    [[ "$SOURCE_DIR" == "$1" ]] && return 1

    local filename=$(basename "$1")

    [[ "$filename" != .* ]] && return 1

    [[ ! -z $TARGET ]] && [[ "$filename" != $TARGET ]] && return 1
    
    # check if the file is not in the ignored list
    if isIgnored "$filename";then
        ind; echo "- Ignoring "$1""
        return 1
    fi

    # check if the file is not in conflict with another selected file
    if isFileInConflictWith "$1" SELECTED_FILES; then
        return 1
    fi
    
    # check if the file is not in conflict with a skipped file    
    if isFileInConflictWith "$1" SKIPPED_FILES; then
        return 1
    fi

    # check if the file is not already a symlink to our dotfiles
    if areFileLinkPointToward $HOME/"$filename" "$SOURCE_DIR";then
        SKIPPED_FILES+=($1)
        ind; echo "- Skipping "$1" (already symlinked)"
        return 1
    fi

    return 0
}

isFileInConflictWith() {
    local filename=$(basename "$1")
    local arrayname=$2[@]
    
    files=("${!arrayname}")
    
    for element in "${files[@]}"; do
        if [[ $(basename "$element") == "$filename" ]]; then
            ind; echo "! Rejecting "$1" (in conflict with "$element")"   
            REJECTED_FILES+=($1)
            return 0
        fi
    done
    
    return 1
}

areFileLinkPointToward() {
    if [[ -L "$1" ]] && [[ "$(readlink $1)" == "$2"* ]];then
        return 0;
    fi
    return 1;
}

isIgnored() {

    for element in "${IGNORED_FILES[@]}";do
        if [[ "$1" == "$element" ]];then
            return 0;
        fi
    done;
    return 1;
}

selectFile() {

    SELECTED_FILES+=("$1")

    local homefile=$HOME/$(basename "$1")
    # check if file exist in home
    if [ -e "$homefile" ];then
        OVERWRITTEN_FILES+=($(basename "$1"))
        ind; echo "* Selecting "$1" (exist in home)"
        return
    fi

    ind; echo "+ Selecting "$1" (new dotfile)"
}

removeBrokenSymLinks() {

    out "Looking for broken symbolic links:"

    lookForBrokenLinks

    if [ "${#BROKEN_FILES[@]}" -eq 0 ];then
        out "No broken symbolic links detected."
        return
    else
        confirmBrokenLinkRemoval
    fi

}

lookForBrokenLinks() {
    for file in "$HOME"/*; do

        if [ ! -e "$file" ]; then
            if areFileLinkPointToward "$file" "$SOURCE_DIR"; then
                BROKEN_FILES+=($file)
                ind; echo "- $file"
           fi
        fi

    done
}

confirmBrokenLinkRemoval() {

    echo "${#BROKEN_FILES[@]} broken symbolic links pointing to $SOURCE_DIR"

    read -p "Do you want to remove them? (y/n) " -n 1;
    out
    if [[ $REPLY =~ ^[Yy]$ ]];then
        removeBrokenLinkFiles
    fi

}

removeBrokenLinkFiles() {
    for file in "${BROKEN_FILES[@]}"; do
        rm -fv "$file"
    done
}


createSymLinks() {

    selectFiles
    
    if [ "${#SELECTED_FILES[@]}" -eq 0 ];then
        out "No new symbolic links required."
    else
        confirmLinkCreation
    fi

}

confirmLinkCreation() {

    echo "+ ${#SELECTED_FILES[@]} symbolic links to be added in home."

    if [ "${#OVERWRITTEN_FILES[@]}" -gt 0 ];then
        echo "* ${#OVERWRITTEN_FILES[@]} files in home will be saved in $BACKUP_DIR."
    fi

    if [ "${#REJECTED_FILES[@]}" -gt 0 ];then
        echo "! Warning, ${#REJECTED_FILES[@]} dot files in conflict."
    fi

    if [ "$FORCE" -eq 0 ];then
        backupAndLinkFiles
    else
        out "To revert changes, execute 'sh ~/$(basename "$REVERT_FILE")'."
        read -p "Do you want to proceed? (y/n) " -n 1;
        out
        if [[ $REPLY =~ ^[Yy]$ ]];then
            backupAndLinkFiles
        fi
    fi
}

backupAndLinkFiles() {
    backupHome
    symlinkFiles
    ind; ln -sf ${REVERT_FILE} $HOME
}

backupHome() {

    if [ "${#OVERWRITTEN_FILES[@]}" -eq 0 ];then
        return
    fi
    
    [ ! -d ${BACKUP_DIR} ] && mkdir "$BACKUP_DIR"

    out "Transfering existing files to ${BACKUP_DIR}:"

    for file in "${OVERWRITTEN_FILES[@]}";do
        mv -fv "$file" "$BACKUP_DIR"
    done

}

symlinkFiles() {
    out "Creating symbolic links in home:"
    for file in "${SELECTED_FILES[@]}";do
        ind; ln -sfnv ${file} $HOME
    done
}

cleanup() {

    unset -f isIgnored
    unset -f isIllegible
    unset -f areFilesLinked
    unset -f symlinkFiles
    unset -f backupAndLinkFiles
    unset -f updateFromRepo
    unset -f confirmLinkCreation
    unset -f initSynchVariables
    unset -f isIllegible
    unset -f scanDir
    unset -f selectFiles
    unset -f createSymLinks
    unset -f copyFiles
    unset -f getSourceDir
    unset -f cleanup

    unset SELECTED_FILES
    unset SOURCE_DIR
    unset BACKUP_DIR
    unset REVERT_FILE
    unset BROKEN_FILES
    unset IGNORED_FILES
    unset MAX_SCAN_LEVEL

    out "Finished." ""
}

initSynchVariables

updateFromRepo

readCommandArgs "$@"

removeBrokenSymLinks

createSymLinks

cleanup

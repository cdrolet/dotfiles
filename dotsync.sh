#!/usr/bin/env bash

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
    while getopts 'frt:v' flag; do
        case "${flag}" in
            f) FORCE=0 ;;
            r) REVERT=0 ;;
            t) TARGET="${OPTARG}" ;;
            *) error "Unexpected option ${flag}" ;;
        esac
    done
}

initSynchVariables() {
    shopt -s dotglob

    SOURCE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    BACKUP_DIR="$SOURCE_DIR"/backup
    REVERT_FILE="$SOURCE_DIR"/dotrevert.sh
    TEMP_FILE="$SOURCE_DIR"/files.tmp
    SELECTED_FILES=()
    SKIPPED_FILES=()
    OVERWRITTEN_FILES=()
    REJECTED_FILES=()
    TO_REMOVE_FILES=()
    TO_RESTORE_FILES=()
    readarray -t IGNORED_FILES < "$SOURCE_DIR"/.dotignore
    IGNORED_FILES+=("$(basename "$BACKUP_DIR")")
    MAX_SCAN_LEVEL=2
    FORCE=1 #false
    REVERT=1 #false

}

updateFromRepo() {

    out "Updating $SOURCE_DIR to master." ""

    cd "$SOURCE_DIR"
    git pull origin master
#    git submodule foreach git pull origin master
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

  local level=0
  [ ! -z "$2" ] && level=$2

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

areFilesLinked() {

    if [ -L "$1" ] && [ "$(readlink $1)" = "$2" ];then
        return 0
    fi
    return 1
}

areFileLinkPointToward() {
    if [[ -L "$1" ]] && [[ "$(readlink $1)" == "$2"* ]];then
        return 0
    fi
    return 1
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

performAction() {

    if [ "$REVERT" -eq 0 ];then
        revertSymLinks
        return
    fi
        
    createSymLinks
}

revertSymLinks() {
    
    selectFileToRevert
    
    if [ "${#TO_REMOVE_FILES[@]}" -eq 0 ] && [ "${#TO_RESTORE_FILES[@]}" -eq 0 ];then
        out "No files to revert."
    else
        confirmRevert
    fi

}

selectFileToRevert() {
    selectFilesToRemove
    selectFilesToRestore
}


selectFilesToRemove() {
    [[ ! -z $TARGET ]] && return
    out "Scanning home files to remove:"
    
    for file in $HOME/*;do
        # check if the file is not a symlink to our dotdir
        if areFileLinkPointToward "$file" "$SOURCE_DIR";then
            TO_REMOVE_FILES+=($file)
            ind; echo "- Selecting "$file""
        fi
    done
    if [ ${#TO_REMOVE_FILES[@]} -eq 0 ]; then
        ind; echo "No file to be removed in home." 
    fi
}

selectFilesToRestore() {
    if [[ ! -z $TARGET ]]; then
        out "Looking for backup file: "$TARGET""
    else
        out "Scanning backup files to restore:"
    fi
    for file in $BACKUP_DIR/*;do
    
        local filename="$(basename $file)"
        [[ ! -z $TARGET ]] && [[ "$filename" != $TARGET ]] && continue
        
        local homefile="$HOME/$filename"
        if [ -e "$homefile" ] && [ ! -L "$homefile" ] && [ ! $file -nt "$homefile" ]; then
            ind; echo "- Skipping "$file" (already in home)"
            continue
        fi
    
        TO_RESTORE_FILES+=($file)
        ind; echo "+ Selecting "$file""
    done
    if [ ${#TO_RESTORE_FILES[@]} -eq 0 ]; then
        ind; echo "No file to be restored from backup." 
    fi

}

confirmRevert() {

    echo
    [ ${#TO_REMOVE_FILES[@]} -gt 0 ] && echo "- "${#TO_REMOVE_FILES[@]}" files to be removed in home." 
    [ ${#TO_RESTORE_FILES[@]} -gt 0 ] && echo "+ "${#TO_RESTORE_FILES[@]}" files to be restored from backup."

    if [ "$FORCE" -eq 0 ];then
        removeAndRestoreFiles
    else
        read -p "Do you want to proceed? (y/n) " -n 1;
        echo
        if [[ $REPLY =~ ^[Yy]$ ]];then
            removeAndRestoreFiles
        fi
    fi
}

removeAndRestoreFiles() {
    removeFiles
    restoreFiles
}

removeFiles() {
    for file in "${TO_REMOVE_FILES[@]}";do
        ind; rm -vf "$file"
    done
}

restoreFiles() {
    echo
    rsync -ahH --out-format='    %f' "$BACKUP_DIR"/* "$HOME"
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
}

backupHome() {

    if [ "${#OVERWRITTEN_FILES[@]}" -eq 0 ];then
        return
    fi
    
    rm -rfd "$BACKUP_DIR"
    mkdir "$BACKUP_DIR"

    out "Transfering existing files to "$BACKUP_DIR":"
    printf "%s\r" ${OVERWRITTEN_FILES[@]} > "$TEMP_FILE"
    rsync -ahH --files-from="$TEMP_FILE" --out-format='    %f' "$HOME" "$BACKUP_DIR"
    rm "$TEMP_FILE"
}

symlinkFiles() {
    out "Creating symbolic links in home:"
    for file in "${SELECTED_FILES[@]}";do
        ind; ln -svf $file $HOME
    done
}

cleanup() {

unset -f isIgnored
    unset -f isIllegible
    unset -f areFilesLinked
    unset -f symlinkFiles
    unset -f backupAndLinkFiles
    unset -f updateFromRepo
    unset -f areFilesLinked
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
    unset TEMP_FILE
    unset IGNORED_FILES
    unset MAX_SCAN_LEVEL

    out "Finished." ""
}

initSynchVariables

updateFromRepo

readCommandArgs "$@"

performAction

cleanup

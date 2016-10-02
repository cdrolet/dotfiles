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

areFileLinkPointToward() {
    if [[ -L "$1" ]] && [[ "$(readlink $1)" == "$2"* ]];then
        return 0
    fi
    return 1
}

readCommandArgs() {
    FORCE=1 
    REVERT=1    

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

initRevert() {
    shopt -s dotglob

    initSourceDir
    
    
    BACKUP_DIR="$SOURCE_DIR"/backup
    TO_REMOVE_FILES=()
    TO_RESTORE_FILES=()
}

revert() {
    
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
    for file in "${$BACKUP_DIR}"/*; do
        mv -fvt "$HOME" "$file"
    done

#    rsync -ahH --out-format='    %f' "$BACKUP_DIR"/* "$HOME"
}

cleanup() {
    echo
}

initRevert

readCommandArgs "$@"

revert

cleanup

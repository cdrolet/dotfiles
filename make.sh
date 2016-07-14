#!/usr/bin/env bash

loadCommons() {

    local sourcedir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source "$sourcedir"/script/commons.sh
    initGlobalVariables "$sourcedir"
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
        scanDir "$SOURCE_DIR"
    else
        # Not good, should target dir as well
        if isIllegible "$TARGET"; then
            selectFile "$TARGET"
        fi
    fi
}

scanDir() {

    local level=0 
    if [ ! -z "$2" ];then
        level=$2
    fi  

    for file in $1/*;do
        if isIllegible "$file"; then
            selectFile $file
        else
            # look for dotfiles in subfolders
            if [ -d "$file" ] && [ "$level" -lt $MAX_SCAN_LEVEL ]; then
                if ! isIgnored $(basename "$file"); then
                    scanDir "$file" $((level+1))
                fi
            fi
        fi
    done
}

selectFile() {

    SELECTED_FILES+=("$1")

    local homefile=~/$(basename "$1")
    # check if file exist in home
    if [ -e "$homefile" ];then
        local detail="(* exist in home)"
        OVERWRITTEN_FILES+=($(basename "$1"))
    else
        local detail="(new dotfile)"
    fi
    
    indent echo "+ Selecting "$1" "$detail""
}

isIllegible() {

    local filename=$(basename "$1")
    if [[ "$filename" != .* ]] ;then
        return 1
    fi

    # check if the file is not already a symlink to our dotfiles
    if areFilesLinked ~/"$filename" "$1";then
        indent echo "- Skipping "$1" (already symlinked)"
        return 1
    fi

    # check if the file is in the ignored list
    if isIgnored "$filename";then
        indent echo "- Ignoring "$1""
        return 1
    fi
}

areFilesLinked() {

    if [ -L "$1" ] && [ "$(readlink $1)" = "$2" ];then
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

createSymLinks() {

    if [ "${#SELECTED_FILES[@]}" -eq 0 ];then
        out "No new symbolic links required."
    else
        confirmLinkCreation "$1"
    fi
}


confirmLinkCreation() {

    out "Symbolic links creation required in home."
    
    if [ "${#OVERWRITTEN_FILES[@]}" -gt 0 ];then
        out "* Overwritten files in home will be saved in $BACKUP_DIR." \
        "To revert dot files to the backup files, execute 'sh ~/$(basename "$REVERT_FILE")'."
    fi

    if [ "$FORCE" -eq 0 ];then
        backupAndLinkFiles
    else
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

    [ -d "$BACKUP_DIR" ] || mkdir "$BACKUP_DIR"
    
    out "Transfering existing files to "$BACKUP_DIR":" 
    printf "%s\r" ${OVERWRITTEN_FILES[@]} > "$TEMP_FILE"
    rsync -ahH --files-from="$TEMP_FILE" --out-format='    %n%L' ~ "$BACKUP_DIR"
    rm "$TEMP_FILE"
}

symlinkFiles() {
    out "Creating symbolic links in home:" 

    for file in "${SELECTED_FILES[@]}";do
        indent
        ln -svf "$file" ~
    done
}

cleanup() {

    cleanupGlobalVariables

    unset -f isIgnored 
    unset -f isIllegible
    unset -f areFilesLinked
    unset -f symlinkFiles
    unset -f backupAndLinkFiles
    unset -f updateFromRepo
    unset -f areFilesLinked
    unset -f confirmLinkCreation
    unset -f initGlobalVariables
    unset -f isIllegible
    unset -f scanDir
    unset -f selectFiles
    unset -f createSymLinks
    unset -f copyFiles
    unset -f getSourceDir
    unset -f cleanup

    out "Finished." ""
}

loadCommons

while getopts 'ft:v' flag; do
    case "${flag}" in
        f) FORCE=0 ;;
        r) REVERT=0 ;;
        t) TARGET="${OPTARG}" ;;
        *) error "Unexpected option ${flag}" ;;
    esac
done

# Missing conflicting files check

# 

readCommandArgs

updateFromRepo

selectFiles

createSymLinks "$1"

cleanup

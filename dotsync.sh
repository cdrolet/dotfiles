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
    while getopts 'ft:v' flag; do
        case "${flag}" in
            f) FORCE=0 ;;
            r) REVERT=0 ;;
            t) TARGET="${OPTARG}" ;;
            *) error "Unexpected option ${flag}" ;;
        esac
    done
}

initGlobalVariables() {
    shopt -s dotglob

    SOURCE_DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    BACKUP_DIR="$SOURCE_DIR"/backup
    REVERT_FILE="$SOURCE_DIR"/revert_dotfiles.sh
    TEMP_FILE="$SOURCE_DIR"/files.tmp
    SELECTED_FILES=()
    OVERWRITTEN_FILES=()
    REJECTED_FILES=()
    readarray -t IGNORED_FILES < "$SOURCE_DIR"/.dotignore
    IGNORED_FILES+=("$(basename "$BACKUP_DIR")")
    MAX_SCAN_LEVEL=2
    FORCE=1

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
        selectFileTree "$SOURCE_DIR"
        return
    fi

    out "targeting dot files: "$TARGET""
    selectFileTree "$TARGET" 1
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
	ind; echo "> scanning dir $1"
    for file in $1/*;do
      selectFileTree "$file" $2
    done
}

isIllegible() {

    [[ "$SOURCE_DIR" == $filename ]] && return 1

    local filename=$(basename "$1")

    [[ "$filename" != .* ]] && return 1

    # check if the file is not already a symlink to our dotfiles
    if areFilesLinked ~/"$filename" "$1";then
        ind; echo "- Skipping "$1" (already symlinked)"
        return 1
    fi

    # check if the file is not in the ignored list
    if isIgnored "$filename";then
        ind; echo "- Ignoring "$1""
        return 1
    fi

    # check if the file is not in conflict with another selected file
    for element in "${SELECTED_FILES[@]}"; do
        if [[ $(basename "$element") == "$filename" ]]; then
            ind; echo "! Rejecting "$1" (in conflict with "$element")"
            REJECTED_FILES+=($1)
            return 1
        fi
    done

    return 0
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

selectFile() {

    SELECTED_FILES+=("$1")

    local homefile=~/$(basename "$1")
    # check if file exist in home
    if [ -e "$homefile" ];then
        OVERWRITTEN_FILES+=($(basename "$1"))
        ind; echo "* Selecting "$1" (exist in home)"
        return
    fi

    ind; echo "+ Selecting "$1" (new dotfile)"
}

createSymLinks() {

    if [ "${#SELECTED_FILES[@]}" -eq 0 ];then
        out "No new symbolic links required."
    else
        confirmLinkCreation
    fi
}


confirmLinkCreation() {

    out "Symbolic links creation required in home."

    if [ "${#OVERWRITTEN_FILES[@]}" -gt 0 ];then
        out "* Overwritten files in home will be saved in $BACKUP_DIR." \
        "To revert dot files to the backup files, execute 'sh ~/$(basename "$REVERT_FILE")'."
    fi

    if [ "${#REJECTED_FILES[@]}" -gt 0 ];then
        out "! Warning, conflict detected."
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
    rsync -ahH --files-from="$TEMP_FILE" --out-format='    %f -> $BACKUP_DIR' ~ "$BACKUP_DIR"
    rm "$TEMP_FILE"
}

symlinkFiles() {
    out "Creating symbolic links in home:"

    for file in "${SELECTED_FILES[@]}";do
        ind; ln -svf "$file" ~
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
    unset -f initGlobalVariables
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

initGlobalVariables

updateFromRepo

readCommandArgs "$@"

selectFiles

createSymLinks

cleanup

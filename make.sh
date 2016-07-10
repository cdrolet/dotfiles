#!/usr/bin/env bash

out() {
  printf "\n"
  for text in "$@"
  do
    printf "$text\n"
  done
}

indent() {
  printf "    "
  $@
}

initGlobalVariables() {
  shopt -s dotglob
  
  SOURCE_DIR=$(getSourceDir)
  BACKUP_DIR="$SOURCE_DIR"/backup
  REVERT_FILE="$SOURCE_DIR"/revert_dotfiles.sh
  TEMP_FILE="$SOURCE_DIR"/files.tmp
  SELECTED_FILES=()
  readarray -t IGNORED_FILES < "$SOURCE_DIR"/.dotignore
  IGNORED_FILES+=("$(basename "$BACKUP_DIR")")
  MAX_SCAN_LEVEL=1
}

getSourceDir() {
  local source="${BASH_SOURCE[0]}"
  local current
  # resolve $source until the file is no longer a symlink
  while [ -h "$source" ]; do
    current="$( cd -P "$( dirname "$source" )" && pwd )"
    source="$(readlink "$source")"
    # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    [[ $source != /* ]] && source="$current/$source"
  done
  echo "$( cd -P "$( dirname "$source" )" && pwd )"
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
  out "Scanning dot files:" ""
  selectDirFiles "$SOURCE_DIR"
}

selectDirFiles() {
  local level=0 
  if [ ! -z "$2" ] 
  then
    level=$2
  fi  
  
  for file in $1/*
  do
    if isIllegible "$file"
	then
      SELECTED_FILES+=("$file")
      indent echo "+ Selecting "$file""
	else
	  # look for dotfiles in subfolders
      if [ -d "$file" ] && [ $level -lt $MAX_SCAN_LEVEL ]
      then
        if ! isIgnored $(basename "$file") 
        then
            selectDirFiles "$file" $((level+1))
        fi
	  fi
	fi
  done
}

isIllegible() {
  local filename=$(basename "$1")
  if [[ "$filename" != .* ]] 
  then
    return 1
  fi

  # check if the file is not already a symlink to our dotfiles
  if areFilesLinked ~/"$filename" "$1" 
  then
    indent echo "- Skipping "$1" (already symlinked)"
	return 1
  fi

  # check if the file is in the ignored list
  if isIgnored "$filename"
  then
    indent echo "- Ignoring "$1""
    return 1
  fi
}

areFilesLinked() {
  if [ -L "$1" ] && [ "$(readlink $1)" = "$2" ]
  then
    return 0
  fi
  return 1
}

isIgnored() {
  for element in "${IGNORED_FILES[@]}"
  do
    if [[ "$1" == "$element" ]]; then
      return 0;
    fi
  done;
  return 1;
}

createSymLinks() {
  if [ "${#SELECTED_FILES[@]}" -eq 0 ]
  then
    out "No new symbolic links required."
  else
    confirmLinkCreation "$1"
  fi
}


confirmLinkCreation() {
  out "Symbolic links creation required in home." "" \
      "Overwritten files in home will be saved in backup directory." \
      "To revert to the backup files, execute 'sh ~/$(basename "$REVERT_FILE")'."

  if [ "$1" == "--force" -o "$1" == "-f" ]
  then
    out
    backupAndLinkFiles
  else
    read -p "Do you want to continue? (y/n) " -n 1;
    out
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      backupAndLinkFiles
    fi
  fi
  out
}

backupAndLinkFiles() {
  backupHome
  symlinkFiles
}

backupHome() {
  [ -d "$BACKUP_DIR" ] || mkdir "$BACKUP_DIR"

  out "Saving overwritten files in "$BACKUP_DIR"."

  local files=()
  for file in "${SELECTED_FILES[@]}"
  do
    local homefile=~/$(basename "$file")
    # check if file exist
    if [ ! -e "$homefile" ]
    then
      continue
    fi

    indent echo "+ Adding $homefile to backup"
    files+=($(basename "$file"))
  done

  if [ "${#files[@]}" -eq 0 ]
  then
    indent echo "- No backup required"
    return
  fi
  
  copyFiles "${files[@]}"
}

copyFiles() {
  printf "%s\n" $1 > "$TEMP_FILE"
  rsync -av --files-from="$TEMP_FILE" --out-format='    %n%L' ~ "$BACKUP_DIR"
  rm "$TEMP_FILE"
}

symlinkFiles() {
  out "Creating symbolic links in home."

  for file in "${SELECTED_FILES[@]}"
  do
	indent
	ln -svf "$file" ~
  done
}

cleanup() {

  unset SELECTED_FILES
  unset SOURCE_DIR
  unset BACKUP_DIR
  unset REVERT_FILE
  unset TEMP_FILE
  unset IGNORED_FILES
  unset MAX_SCAN_LEVEL
  
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
  unset -f selectDirFiles
  unset -f selectFiles
  unset -f createSymLinks
  unset -f copyFiles
  unset -f getSourceDir
  unset -f cleanup
  unset -f indent
  
  out "Finished." ""
  unset -f out
}

initGlobalVariables

updateFromRepo

selectFiles

createSymLinks

cleanup

#!/usr/bin/env bash

initGlobalVariables() {
  shopt -s dotglob
  
  local source="${BASH_SOURCE[0]}"
  # resolve $source until the file is no longer a symlink
  while [ -h "$source" ]; do
    SOURCE_DIR="$( cd -P "$( dirname "$source" )" && pwd )"
    source="$(readlink "$source")"
    # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    [[ $source != /* ]] && source="$SOURCE_DIR/$source"
  done

  SOURCE_DIR="$( cd -P "$( dirname "$source" )" && pwd )"
  BACKUP_DIR="$SOURCE_DIR"/backup
  REVERT_FILE="$SOURCE_DIR"/revert_dotfiles.sh
  TEMP_FILE="$SOURCE_DIR"/files.tmp
  SELECTED_FILES=()
  readarray -t IGNORED_FILES < "$SOURCE_DIR"/.dotignore
  IGNORED_FILES+=("$(basename "$BACKUP_DIR")")
}

selectDirFiles() {
  for file in $1/*
  do
    
echo ">>> "$1""
    
	if isFileIllegible "$file"
	then
      SELECTED_FILES+=("$file")
      indent "echo "+ Adding $(basename "$file")""
	else
	  # look for dotfiles in subfolders
      if [ -d "$file" ] 
      then
		if ! isIgnored $(basename "$file") 
		then
   	      indent "echo "looking into $file""
	      selectDirFiles "$file"
		fi
	  fi	
	fi
  done
}

isFileIllegible() {
  local filename=$(basename "$1")
  if [[ "$filename" != .* ]] 
  then
    return 1
  fi

  # check if the file is not already a symlink to our dotfiles
  if areFilesLinked ~/"$filename" "$1" 
  then
    indent "echo - Skipping "$1" (already symlinked)"
	return 1
  fi

  # check if the file is in the ignored list
  if isIgnored "$filename"
  then
    indent "echo - Ignoring "$1""
    return 1
  fi
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

    indent "echo "+ Adding $homefile to backup""
    files+=($(basename "$file"))
  done

  if [ "${#files[@]}" -eq 0 ]
  then
    indent "echo "- No file overwritten""
    return
  fi
  
  rsyncFiles "${files[@]}"
}

rsyncFiles() {
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

areFilesLinked() {
    
     echo "are files linked $1 "$SOURCE_DIR/$(basename "$2")""""
      
	 
	if [ -L "$1" ] && [ "$(readlink $1)" = "$SOURCE_DIR/$(basename "$2")" ]
	then
	  return 0
	fi
	return 1
}

updateFromRepo() {
  out "Updating $SOURCE_DIR to master." ""

  cd "$SOURCE_DIR"
  git pull origin master
  git submodule foreach git pull origin master
  cd
  out
}

cleanup() {
  unset -f isIgnored 
  unset -f symlinkFiles
  unset -f makeAllLinks
  unset -f updateFromRepo
  unset -f areFilesLinked
  unset -f confirmLinkCreation
  unset -f initGlobalVariables

  unset SELECTED_FILES
  unset SOURCE_DIR
  unset BACKUP_DIR
  unset REVERT_FILE
  unset TEMP_FILE
  unset IGNORED_FILES

}

confirmLinkCreation() {
  out "Symbolic links required." "" \
      "Overwritten files in home will be saved in backup directory." \
      "To revert to the backup files, execute 'sh ~/$(basename "$REVERT_FILE")'."

  if [ "$1" == "--force" -o "$1" == "-f" ]
  then
    out
    makeAllLinks
  else
    read -p "Do you want to continue? (y/n) " -n 1;
    out
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      makeAllLinks
    fi
  fi
  out
}

selectFiles() {
  out "Scanning dot files:" ""
  selectDirFiles "$SOURCE_DIR"
}

makeAllLinks() {
  backupHome
  symlinkFiles
}

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

initGlobalVariables

updateFromRepo

selectFiles

if [ "${#SELECTED_FILES[@]}" -eq 0 ]
then
  out "No new symbolic links required."
else
  confirmLinkCreation "$1"
fi

cleanup

out "Finished." ""


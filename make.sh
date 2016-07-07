#!/usr/bin/env bash

initGlobals() {
  local source="${BASH_SOURCE[0]}"
  # resolve $source until the file is no longer a symlink
  while [ -h "$source" ]; do
    DOTFILES_DIR="$( cd -P "$( dirname "$source" )" && pwd )"
    source="$(readlink "$source")"
    # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    [[ $source != /* ]] && source="$DOTFILES_DIR/$source"
  done
  DOTFILES_DIR="$( cd -P "$( dirname "$source" )" && pwd )"
  BACKUP_HOME_DIR="$DOTFILES_DIR"/backup
  REVERT_FILE="$DOTFILES_DIR"/revert.sh
}

out() {
  printf("\n")
  for text in "$@"
  do
    printf("$text\n")
  done
}

addSymbolicLinks() {
  out "Linking dot files to home directory." "" \
      "Overwritten files will be saved in backup directory." \
      "To revert to the backup files, execute 'sh ~/revert.sh'."

  if [ "$1" == "--force" -o "$1" == "-f" ]
  then
    out
    makeAllLinks
  else
    read -p "Do you want to continue? (y/n) " -n 1;
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      makeAllLinks
    fi
  fi
  cr
}

makeAllLinks() {
  loadIgnoredFiles
  selectFiles
  backupHome
  symlinkFiles
}

loadIgnoredFiles() {
  readarray -t IGNORED_FILES < "$DOTFILES_DIR"/.dotignore
  out "Files to ignore: ${IGNORED_FILES[@]}"
}

selectFiles() {
  out "Selecting dot files:"
 
  DOTFILES=()
  shopt -s dotglob

  for file in $DOTFILES_DIR/*
  do
    addFile "$file"
    if [ -d "$file" ] && [ "$ignored" -eq 1 ]
    then
      for file in $file/*
      do
        addFile "$file"
      done;
    fi
  done
}

addFile() {
  local filename=$(basename "$1")
  isIgnored "$filename"
  ignored=$?
  if [[ "$filename" == .* ]] && [[ "$ignored" -eq 1 ]]
  then
    DOTFILES+=("$1")
    echo "+ $1"
  fi
}

isIgnored() {
  local ignoredList=( "${IGNORED_FILES[@]}" )
  ignoredList+=("$(basename "$BACKUP_HOME_DIR")")
  for element in "${ignoredList[@]}"
  do
    if [[ "$1" == "$element" ]]; then
      echo "- Ignoring $1"
      return 0;
    fi
  done;
  return 1;
}

backupHome() {
  [ -d "$BACKUP_HOME_DIR" ] || mkdir "$BACKUP_HOME_DIR"

  out "Saving previous home files in $BACKUP_HOME_DIR."

  for file in "${DOTFILES[@]}"
  do
    [ -a "$file" ] && mv -fv ~/$(basename "$file") "$BACKUP_HOME_DIR"
  done
}

symlinkFiles() {
  out "Creating symbolic links in home."

  for file in "${DOTFILES[@]}"
  do
    ln -svf "$file" ~
  done
  ln -svf "$REVERT_FILE" ~
}

updateFromRepo() {
  out "Updating $DOTFILES_DIR to master."
  
  cd "$DOTFILES_DIR"
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
  unset -f addSymbolicLinks
  unset -f initGlobals
  unset excluded_names
  unset excluded_names
}

initGlobals

updateFromRepo

addSymbolicLinks "$1"

cleanup

#echo ""
#echo "CAVEATS"
#echo "Vim:  If remote server, rm .vimrc.bundles"
#echo "Bash: If local server, rm .bashrc.local"
out "Finished."



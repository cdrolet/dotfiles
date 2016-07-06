#!/bin/bash

initVar() {
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

addSymbolicLinks() {
  echo ""
  echo "Linking dot files to home directory."
  echo ""
  echo "Overwritten files will be saved in backup directory" 
  echo "To revert to the backup files, execute 'sh ~/revert.sh'."
  echo ""
  if [ "$1" == "--force" -o "$1" == "-f" ]
  then
    echo ""
    makeAllLinks
  else
    read -p "Do you want to continue? (y/n) " -n 1;
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      makeAllLinks
    fi
  fi
  echo ""
}

makeAllLinks() {
  loadIgnoredFiles
  selectFiles
  backupHome
  symlinkFiles
}

loadIgnoredFiles() {
  readarray -t IGNORED_FILES < "$DOTFILES_DIR"/.dotignore
  echo ""
  echo "Files to ignore: "${IGNORED_FILES[@]}""
}

selectFiles() {
  echo ""
  echo "Selecting dot files:"
  echo ""
 
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

  echo ""
  echo "Saving previous home files in $BACKUP_HOME_DIR."
  echo ""

  for file in "${DOTFILES[@]}"
  do
    [ -a "$file" ] && mv -fv ~/$(basename "$file") "$BACKUP_HOME_DIR"
  done
}

symlinkFiles() {
  echo ""
  echo "Creating symbolic links in home."
  echo ""

  for file in "${DOTFILES[@]}"
  do
    ln -svf "$file" ~
  done
  ln -svf "$REVERT_FILE" ~
}

updateFromRepo() {
  echo ""
  echo "Updating $DOTFILES_DIR to master."
  echo ""
  cd "$DOTFILES_DIR"
  git pull origin master
  git submodule foreach git pull origin master
  cd
  echo ""
}

cleanup() {
  unset -f isIgnored 
  unset -f symlinkFiles
  unset -f makeAllLinks
  unset -f updateFromRepo
  unset -f addSymbolicLinks
  unset -f initVar
  unset excluded_names
  unset excluded_names
}

initVar

updateFromRepo

addSymbolicLinks "$1"

cleanup

#echo ""
#echo "CAVEATS"
#echo "Vim:  If remote server, rm .vimrc.bundles"
#echo "Bash: If local server, rm .bashrc.local"
echo ""
echo "Finished."
echo ""



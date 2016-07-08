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
  BACKUP_DIR="$DOTFILES_DIR"/backup
  REVERT_FILE="$DOTFILES_DIR"/revert.sh
  TEMP_FILE="$DOTFILES_DIR"/files.tmp
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
    out
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      makeAllLinks
    fi
  fi
  out
}

makeAllLinks() {
  loadIgnoredFiles
  selectFiles
  backupHome
  symlinkFiles
}

loadIgnoredFiles() {
  readarray -t IGNORED_FILES < "$DOTFILES_DIR"/.dotignore
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
    indent "echo "+ Adding $(basename "$1")""
  fi
}

isIgnored() {
  local ignoredList=( "${IGNORED_FILES[@]}" )
  ignoredList+=("$(basename "$BACKUP_DIR")")
  for element in "${ignoredList[@]}"
  do
    if [[ "$1" == "$element" ]]; then
      indent "echo - Ignoring "$1""
      return 0;
    fi
  done;
  return 1;
}

backupHome() {
  [ -d "$BACKUP_DIR" ] || mkdir "$BACKUP_DIR"

  out "Saving previous home files in "$BACKUP_DIR"."

  local files=()
  for file in "${DOTFILES[@]}"
  do
    if [ -a "$file" ]
    then
      files+=($(basename "$file"))
    fi
  done
  
  printf "%s\n" "${files[@]}" > "$TEMP_FILE"
  rsync -av --files-from="$TEMP_FILE" --out-format='    %n%L' ~ "$BACKUP_DIR"
  rm "$TEMP_FILE"
}

symlinkFiles() {
  out "Creating symbolic links in home."

  for file in "${DOTFILES[@]}"
  do
    linkFile "$file"
  done

  linkFile "$REVERT_FILE"
}

linkFile() {
  indent
  ln -svf "$1" ~
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


 

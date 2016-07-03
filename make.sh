#!/bin/bash

initDotFileDir() {
   local source="${BASH_SOURCE[0]}"
   # resolve $source until the file is no longer a symlink
   while [ -h "$source" ]; do
      DOTFILES_DIR="$( cd -P "$( dirname "$source" )" && pwd )"
      source="$(readlink "$source")"
      # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
      [[ $source != /* ]] && source="$DOTFILES_DIR/$source"
   done
   DOTFILES_DIR="$( cd -P "$( dirname "$source" )" && pwd )"
}

isIgnored() {
    local ignoredList=( "${ignored_names[@]}" )
    for element in "${ignoredList[@]}"
    do
       if [[ "$1" == "$element" ]]; then
           echo "Ignoring $1"
           return 0;
        fi
    done;
    return 1;
}

linkFile() {
    local filename=$(basename "$1")
    isIgnored "$filename"
    ignored=$?
    if [[ "$filename" == .* ]] && [[ "$ignored" -eq 1 ]]
    then
      ln -svf $1
    fi
}

makeAllLinks() {
  shopt -s dotglob

  for file in $DOTFILES_DIR/*
  do
    linkFile "$file"
    if [ -d "$file" ] && [ "$ignored" -eq 1 ]
    then
      for file in $file/*
      do
        linkFile "$file"
      done;
    fi
  done

}

updateFilesFromRepo() {
  echo ""
  echo "Updating $DOTFILES_DIR to master"
  echo ""
  cd "$DOTFILES_DIR"
  git pull origin master
  git submodule foreach git pull origin master
  cd
  echo ""
}

addSymbolicLinks() {
  echo ""
  echo "Adding symbolics links to home directory"
  echo ""
  if [ "$1" == "--force" -o "$1" == "-f" ]
  then
    makeAllLinks
  else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      makeAllLinks
    fi
  fi
}

cleanup() {
  unset -f isIgnored 
  unset -f linkFile
  unset -f makeAllLinks
  unset -f updateFilesFromRepo
  unset -f addSymbolicLinks
  unset -f initDotFileDir
  unset excluded_names
  unset excluded_names
}

# Variables

ignored_names=(".git" ".." ".")

initDotFileDir

updateFilesFromRepo

addSymbolicLinks "$1"

cleanup

echo ""
echo "CAVEATS"
echo "Vim:  If remote server, rm .vimrc.bundles"
echo "Bash: If local server, rm .bashrc.local"
echo ""
echo "Finished."


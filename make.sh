#!/bin/bash

dotfiles_dir=~/.dotfiles
ignored_names=(".git" ".." ".")

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

  for file in $dotfiles_dir/*
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
  echo "Updating $dotfiles_dir to master"
  echo ""
  cd $dotfiles_dir
  git pull origin master
  cd
}

addSymbolicLinks() {
  echo ""
  echo "Adding symbolics links to home"
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
  unset excluded_names
  unset excluded_names
}

updateFilesFromRepo

addSymbolicLinks "$1"

cleanup

echo ""
echo "CAVEATS"
echo "Vim:  If remote server, rm .vimrc.bundles"
echo "Bash: If local server, rm .bashrc.local"
echo ""
echo "Finished."


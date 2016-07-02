#!usr/bin/env bash

# Variables
dotfiles_dir=~/.dotfiles
dirs="git tmux zsh"

# Update dotfiles to master branch
echo "Updating $dotfiles_dir to master"
cd $dotfiles_dir;
git pull origin master;
cd;

echo ""

function echoSection() {
  echo 
  echo $1	
  echo
}

function makeLinks() {
  
  # For each directory in dirs, make a symlink for each file found that starts with a . (dot)
  for dir in */ do
    echoSection "Linking $dir files."
    cd $dotfiles_dir/$dir;
    for file in .*; do
      ln -svf $dotfiles_dir/$dir/$file ~/$file
    done
    echo ""
  done

  echoSection "CAVEATS"
  echo "Vim:  If remote server, rm .vimrc.bundles"
  echo "Bash: If local server, rm .bashrc.local"

  echo ""
  echo "Finished."
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  makeLinks;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    makeLinks;
  fi;
fi;

unset echoSections;
unset makeLinks;

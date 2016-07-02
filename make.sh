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

function hr() {
  local start=$'\e(0' end=$'\e(B' line='qqqqqqqqqqqqqqqq'
  local cols=${COLUMNS:-$(tput cols)}
  while ((${#line} < cols)); do line+="$line"; done
  printf '%s%s%s\n' "$start" "${line:0:cols}" "$end"
}

function echoSection() {
  hr 
  echo $1	
  hr)
}

function makeLinks() {
  # For each directory in dirs, make a symlink for each file found that starts with a . (dot)
  for dir in $dirs; do
    echoSection "Linking $dir files."
    cd $dotfiles_dir/$dir;
    dotFiles = 
    for file in [.]*; do
      ln -svf $dotfiles_dir/$dir/$file ~/$file
    done
    echo ""
  done

  # Handle odd-ball cases
  # Vim files
	  
  echoSection "Linking vim files."
  ln -svf $dotfiles_dir/vim ~/.vim;
  ln -svf $dotfiles_dir/vim/vimrc ~/.vimrc;
  ln -svf $dotfiles_dir/vim/vimrc.bundles ~/.vimrc.bundles;

  # ssh
  echoSection "Linking ssh configuration."
  ln -svf $dotfiles_dir/ssh/config ~/.ssh/config

  # i3
# echo ""
# echo "Linking i3 configuration."
# ln -svf $dotfiles_dir/.i3 ~/.i3

  echoSection "Linking fonts & dircolors"
  ln -svf $dotfiles_dir/fonts ~/.fonts;
  ln -svf $dotfiles_dir/dircolors ~/.dircolors;

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

unset makeLinks;

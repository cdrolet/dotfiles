#!/bin/bash -x

# Variables
dotfiles_dir=~/.dotfiles
excluded_names=(".zzz" ".git" ".." ".")

isExcluded () { 
 
    declare -a exlist=( "${excluded_names[@]}" )
    for element in "${exlist[@]}"; do
       echo "> $element";
        if [ "$1" = "$element" ]; then
            
            return 0;
        fi
    done;
    return 1;
}

makeLinks() {
  
  # make a symlink for each file or directory that starts with a . (dot)
  shopt -s dotglob

  for file in $dotfiles_dir/*; do
    echo "looking at $file"
    filename=$(basename "$file")
    isExcluded "$filename"
    excluded=$?
    echo "---> $filename, exclude: $excluded"
    if [[ "$filename" == .* ]] && [[ "$excluded" -eq 1 ]]; then
      ln -svf $file
      echo ""
    fi
  done

  echo ""
  echo "CAVEATS"
  echo "Vim:  If remote server, rm .vimrc.bundles"
  echo "Bash: If local server, rm .bashrc.local"
  echo ""
  echo "Finished."
}

# Update dotfiles to master branch
echo
echo "Updating $dotfiles_dir to master"
cd $dotfiles_dir;
git pull origin master;
cd;

echo ""

# Make symbolic links
if [ "$1" == "--force" -o "$1" == "-f" ]; then
  makeLinks;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    makeLinks;
  fi;
fi;

# Cleanup
unset -f makeLinks;
unset -f isExcluded;
unset excluded_names;


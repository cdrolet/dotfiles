#!/bin/bash

# Get the absolute path of the directory containing install.sh
INSTALL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$INSTALL_DIR/scripts/_common.sh"
# Source the dotsync script with the absolute path to the install directory
source "$INSTALL_DIR/scripts/dotsync.sh" "$INSTALL_DIR"

sub_header "Installing dotfiles"

cd "$INSTALL_DIR"

section "Updating git submodules"

spin "pulling origin master" "git pull origin master"
spin "pulling submodules" "git submodule foreach git pull origin master"

section "Syncing dotfiles"

# Check if project directory exists before creating it
if [ ! -d "$HOME/project" ]; then
    run "Create project directory" "mkdir -p $HOME/project"
fi
# Clone dotfiles if they don't already exist
if [ ! -d "$HOME/project/dotfiles" ]; then
    run "Clone dotfiles" "gh repo clone cdrolet/dotfiles $HOME/project/dotfiles"
    force_update_git_submodules
    run "Run dot sync" "./dotsync.sh"
else
    skipped "Dotfiles repository already cloned"
    force_update_git_submodules
fi


sync_dotfiles $INSTALL_DIR

unset INSTALL_DIR
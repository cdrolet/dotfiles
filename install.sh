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

sync_dotfiles $INSTALL_DIR

unset INSTALL_DIR
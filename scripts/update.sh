#!/bin/bash

# Get the absolute path of the directory containing install.sh
UPDATE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$UPDATE_DIR/scripts/common.sh"
# Source the dotsync script with the absolute path to the install directory
source "$UPDATE_DIR/scripts/dotsync.sh" "$UPDATE_DIR"

sub_header "Updating dotfiles"

cd "$UPDATE_DIR"

section "Updating git submodules"

with_spinner "pulling origin master" "git pull origin master"
with_spinner "pulling submodules" "git submodule foreach git pull origin master"

section "Syncing dotfiles"

sync_dotfiles $UPDATE_DIR

if [[ "$OSTYPE" == darwin* ]]; then
  source "$UPDATE_DIR/scripts/mac/defaults.sh"
fi

check_state

unset UPDATE_DIR
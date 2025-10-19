#!/usr/bin/env bash
########################################################################################
# File: dotsync.sh
########################################################################################

# Get the absolute path of the directory containing install.sh
INSTALL_SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
# Get the parent directory of INSTALL_SCRIPT_DIR
DOTFILES_ROOT="$(dirname "$(dirname "$INSTALL_SCRIPT_DIR")")"

source "$INSTALL_SCRIPT_DIR/lib/_bootstrap.sh"

LAST_STAGE=true

sync_dotfiles "$DOTFILES_ROOT"


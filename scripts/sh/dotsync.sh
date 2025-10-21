#!/usr/bin/env bash
########################################################################################
# File: dotsync.sh
########################################################################################

# Get the absolute path of the directory containing this script
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
# Get the parent directory (dotfiles root)
DOTFILES_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

source "$SCRIPT_DIR/lib/_bootstrap.sh"

LAST_STAGE=true

sync_dotfiles "$DOTFILES_ROOT"

##############################################################
# END
##############################################################

unset SCRIPT_DIR
unset DOTFILES_ROOT


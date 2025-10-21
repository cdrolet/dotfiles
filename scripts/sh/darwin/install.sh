#!/usr/bin/env bash

########################################################################################
# File: setup_mac.sh
# Description: Main script for Mac setup and configuration
########################################################################################

OS_SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

source "$OS_SCRIPT_DIR/apps.sh"
source "$OS_SCRIPT_DIR/system.sh"
source "$OS_SCRIPT_DIR/set-defaults.sh"

# Load environment-specific configuration files
if [ -n "$ENVIRONMENT" ]; then
  # Load env_$ENVIRONMENT.sh if it exists
  if [ -f "$OS_SCRIPT_DIR/env_$ENVIRONMENT.sh" ]; then
    source "$OS_SCRIPT_DIR/env_$ENVIRONMENT.sh"
  fi

  # Load any NOT_{env} files where {env} is not equal to $ENVIRONMENT
  for env_file in "$OS_SCRIPT_DIR"/env_NOT_*.sh; do
    if [ -f "$env_file" ]; then
      # Extract the environment name from the filename
      not_env=$(basename "$env_file" | sed 's/env_NOT_\(.*\)\.sh/\1/')

      # Check if it's not the current environment
      if [ "$not_env" != "$ENVIRONMENT" ]; then
        source "$env_file"
      fi
    fi
  done
fi

# Generate Brewfile with versions as final step
# This creates a snapshot of all installed packages
# Note: DOTFILES_ROOT is provided by the parent install.sh script

sub_header "Packages Version Backup"

spin "Generating Brewfile with package versions" "generate_brewfile '$DOTFILES_ROOT/backup'"

unset OS_SCRIPT_DIR

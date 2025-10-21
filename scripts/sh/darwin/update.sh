#!/usr/bin/env bash

########################################################################################
# File: darwin/update.sh
# Description: macOS-specific update operations
########################################################################################

OS_SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

# Source darwin utilities if not already loaded
if [ -f "$OS_SCRIPT_DIR/_install_utilities.sh" ]; then
    source "$OS_SCRIPT_DIR/_install_utilities.sh"
fi

##############################################################
# MACOS UPDATES
##############################################################

sub_header "Updating Homebrew"

run "Update Homebrew formulae database" "brew update"
spin "Upgrade Homebrew formulae" "brew upgrade"
spin "Upgrade Homebrew casks" "brew upgrade --cask --greedy"
spin "Cleanup Homebrew" "brew cleanup"
spin "Remove unused dependencies" "brew autoremove"

sub_header "Updating Xcode Command Line Tools"

install_xcode_cli_tools

sub_header "Updating SDKMAN"

update_sdkman

sub_header "Checking for macOS updates"

spin "Install recommended macOS updates" "softwareupdate --install --recommended"

##############################################################
# BREWFILE GENERATION
##############################################################

# Generate updated Brewfile with current package versions
# Note: DOTFILES_ROOT is provided by the parent update.sh script

sub_header "Packages Version Backup"

spin "Generating Brewfile with package versions" "generate_brewfile '$DOTFILES_ROOT/backup'"

unset OS_SCRIPT_DIR


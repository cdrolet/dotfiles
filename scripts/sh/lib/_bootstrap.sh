#!/usr/bin/env bash

########################################################################################
# File: _bootstrap.sh
# Author: Charles Drolet
# GitHub: @cdrolet
# 
# Description:
#   Bootstrap initialization script that loads all core libraries and sets up the
#   environment for installation and configuration scripts. This is the entry point
#   that orchestrates the loading of all utility modules.
#   
#   Responsibilities:
#   - Sudo validation and privilege elevation
#   - Library loading guard to prevent duplicate sourcing
#   - Sequential loading of all utility modules:
#     * Common: Configuration and constants
#     * Utils: General utility functions
#     * Time: Timestamp and execution tracking
#     * Errors: Error handling and reporting
#     * UI: Terminal formatting and visual feedback
#     * Commands: Command execution and validation
#     * Git: Repository and version control operations
#     * Fonts: Font installation utilities
#     * Dotsync: Dotfiles synchronization
#   - Initial UI setup (cursor management and header display)
#
# Usage:
#   source "$(dirname "$0")/lib/_bootstrap.sh"
#
# Dependencies:
#   - bash 3.2+ or zsh 5.0+
#   - Standard Unix utilities (date, printf, etc.)
#   - All library modules in scripts/sh/lib/
#
########################################################################################

sudo -v

# Check if the library is already loaded
if [ -n "${BOOTSTRAP_LIB_LOADED+x}" ]; then
    # Already loaded, return silently
    return 0
fi

# Mark the library as loaded
BOOTSTRAP_LIB_LOADED=true

# Increase the maximum nested function level to prevent "maximum nested function level reached" errors
FUNCNEST=100

LIBRARY_PATH=$(dirname "${BASH_SOURCE[0]}")

# Source all library files
source "$LIBRARY_PATH/_common.sh"
source "$LIBRARY_PATH/_utils.sh"
source "$LIBRARY_PATH/_time.sh"
source "$LIBRARY_PATH/_errors.sh"
source "$LIBRARY_PATH/_ui.sh"
source "$LIBRARY_PATH/_commands.sh"
source "$LIBRARY_PATH/_git.sh"
source "$LIBRARY_PATH/_fonts.sh"

source "$LIBRARY_PATH/_dotsync.sh"

unset LIBRARY_PATH

hide_cursor
header
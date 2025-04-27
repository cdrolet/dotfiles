#!/usr/bin/env bash

########################################################################################
# File: _common.sh
# Author: Charles Drolet
# GitHub: @cdrolet
# 
# Description:
#   A utility library providing error handling and UI formatting functionality.
#   This script serves as a foundation for other setup scripts by providing:
#   
#   - Error Handling:
#     * Error collection and reporting
#     * Interactive error resolution
#     * Signal handling and cleanup
#   
#   - UI Formatting:
#     * Consistent header and section formatting
#     * Status indicators (✓, ✗, ⚠)
#     * Progress feedback
#   
#   - Command Execution:
#     * Safe command execution with error capture
#
# Usage:
#   source "$(dirname "$0")/lib/_common.sh"
#
# Dependencies:
#   - bash 3.2+ or zsh 5.0+
#   - Standard Unix utilities (date, printf, etc.)
#
########################################################################################

# Check if the library is already loaded
if [ -n "${COMMON_LIB_LOADED+x}" ]; then
    # Already loaded, return silently
    return 0
fi

echo "LOADED!!!!!!!!"
# Mark the library as loaded
COMMON_LIB_LOADED=true

# Increase the maximum nested function level to prevent "maximum nested function level reached" errors
FUNCNEST=100

LIBRARY_PATH=$(dirname "${BASH_SOURCE[0]}")

# Source all library files
source "$LIBRARY_PATH/_core.sh"
source "$LIBRARY_PATH/_errors.sh"
source "$LIBRARY_PATH/_ui.sh"
source "$LIBRARY_PATH/_commands.sh"
source "$LIBRARY_PATH/_git.sh"
source "$LIBRARY_PATH/_utils.sh"

unset LIBRARY_PATH

hide_cursor
header
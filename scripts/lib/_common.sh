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

# Increase the maximum nested function level to prevent "maximum nested function level reached" errors
FUNCNEST=100

# Source all library files
source "$(dirname "${BASH_SOURCE[0]}")/_core.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_errors.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_ui.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_commands.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_git.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_utils.sh"

sudo -v
hide_cursor
header
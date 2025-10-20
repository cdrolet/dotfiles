#!/usr/bin/env bash

########################################################################################
# File: _common.sh
# Description: Common configuration, constants, and global variables
#
# Purpose:
#   Defines shared configuration defaults and global state variables used across
#   all scripts in the dotfiles installation system.
#
# Contents:
#   - Default configuration values (verbosity, simulation mode, confirmations)
#   - Global state tracking (execution stage, timing)
#   - Environment detection
#   - Variable initialization with fallback to defaults
#
# Variables:
#   DEFAULT_VERBOSE: Verbosity level (1=minimal, 2=normal, 3=detailed)
#   DEFAULT_SIMULATION: Dry-run mode flag
#   DEFAULT_SKIP_CONFIRMATION: Auto-confirm prompts flag
#   DEFAULT_ENVIRONMENT: Target environment (Home/Work)
#   LAST_STAGE: Indicates if this is the final execution stage
#   START_TIME: Script execution start timestamp
#
########################################################################################

# Default values for settings
DEFAULT_VERBOSE=2
DEFAULT_DRY_RUN=false
DEFAULT_SKIP_CONFIRMATION=false
DEFAULT_ENVIRONMENT=Home
# Global state variables
LAST_STAGE=true

if [ -z "${SKIP_CONFIRMATION+x}" ]; then
    SKIP_CONFIRMATION=$DEFAULT_SKIP_CONFIRMATION
fi
if [ -z "${IS_DRY_RUN+x}" ]; then
    IS_DRY_RUN=$DEFAULT_DRY_RUN
fi
if [ -z "${VERBOSE+x}" ]; then
    VERBOSE=$DEFAULT_VERBOSE
fi
if [ -z "${ENVIRONMENT+x}" ]; then
    ENVIRONMENT=$DEFAULT_ENVIRONMENT
fi
if [ -z "${START_TIME+x}" ]; then
    START_TIME=$(date +%s)
fi

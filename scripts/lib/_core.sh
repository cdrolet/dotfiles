#!/usr/bin/env bash

########################################################################################
# File: core.sh
# Description: Core functionality and global variables for the script library
########################################################################################

# Default values for settings
DEFAULT_VERBOSE=2
DEFAULT_SIMULATION=false
DEFAULT_SKIP_CONFIRMATION=false

# Global state variables
declare -g last_stage=false

if [ -z "${skip_confirmation+x}" ]; then
    declare -g skip_confirmation=$DEFAULT_SKIP_CONFIRMATION
fi
if [ -z "${is_simulation+x}" ]; then    
    declare -g is_simulation=$DEFAULT_SIMULATION
fi
if [ -z "${verbose+x}" ]; then
    declare -g verbose=$DEFAULT_VERBOSE
fi

# Start time for execution time tracking
if [ -z "${start_time+x}" ]; then
    declare -g start_time=$(date +%s)
fi 


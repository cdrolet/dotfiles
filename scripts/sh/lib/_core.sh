#!/usr/bin/env bash

########################################################################################
# File: core.sh
# Description: Core functionality and global variables for the script library
########################################################################################

# Default values for settings
DEFAULT_VERBOSE=2
DEFAULT_SIMULATION=false
DEFAULT_SKIP_CONFIRMATION=false
DEFAULT_ENVIRONMENT=Home
# Global state variables
LAST_STAGE=true

if [ -z "${SKIP_CONFIRMATION+x}" ]; then
    SKIP_CONFIRMATION=$DEFAULT_SKIP_CONFIRMATION
fi
if [ -z "${IS_SIMULATION+x}" ]; then    
    IS_SIMULATION=$DEFAULT_SIMULATION
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


#!/usr/bin/env bash

########################################################################################
# File: setup_mac.sh
# Description: Main script for Mac setup and configuration
########################################################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

clear
source "$SCRIPT_DIR/mac/apps.sh"
source "$SCRIPT_DIR/mac/defaults.sh"

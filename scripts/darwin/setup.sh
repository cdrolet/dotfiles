#!/usr/bin/env bash

########################################################################################
# File: setup_mac.sh
# Description: Main script for Mac setup and configuration
########################################################################################

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_DIR/mac/apps.sh"
last_stage=true
source "$SCRIPT_DIR/mac/defaults.sh"

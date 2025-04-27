#!/usr/bin/env bash

########################################################################################
# File: setup_mac.sh
# Description: Main script for Mac setup and configuration
########################################################################################

DARWIN_SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

source "$DARWIN_SCRIPT_DIR/apps.sh"
source "$DARWIN_SCRIPT_DIR/system.sh"

unset DARWIN_SCRIPT_DIR
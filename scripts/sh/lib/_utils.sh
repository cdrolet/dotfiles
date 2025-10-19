#!/usr/bin/env bash

########################################################################################
# File: utils.sh
# Description: Various utility functions
########################################################################################

source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"


pluralize() {
    local count="$1"
    local singular="$2"
    local plural="${3:-${singular}s}"  # Default to singular + 's' if plural not provided
    
    if [ "$count" -eq 1 ]; then
        echo "$singular"
    else
        echo "$plural"
    fi
}


# Detect OS type and extract OS name before any version
detect_os() {
    # Get the lowercase OS type
    local os_type=$(uname -s | tr '[:upper:]' '[:lower:]')
    
    # Extract OS name before any number (darwin20.6.0 -> darwin)
    os_name=$(echo "$os_type" | sed -E 's/([a-z]+)[0-9.].*/\1/')
    
    echo "$os_name"
}

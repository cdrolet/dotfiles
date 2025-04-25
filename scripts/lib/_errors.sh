#!/usr/bin/env bash

########################################################################################
# File: errors.sh
# Description: Error handling functionality
########################################################################################

source "$(dirname "${BASH_SOURCE[0]}")/_core.sh"

# Arrays to store messages
failures=()
errors=()

# Set up error handling
set -E  # ERR trap is inherited by shell functions
trap 'handle_error $? "$BASH_COMMAND"' ERR
trap 'check_state' EXIT

# Function to handle errors
handle_error() {
    local exit_code=$1
    local command=$2
    
    # Only treat it as an error if it's a syntax error or command not found
    if [[ $exit_code -eq 2 ]] || [[ $exit_code -eq 127 ]]; then
        local error_message="Command failed with exit code $exit_code: $command"
        errors+=("$error_message")
        local shell_error=$(bash -c "$command" 2>&1)
        if [[ -n "$shell_error" ]]; then
            errors+=("$shell_error")
        fi
        show_cursor
        unset COMMON_LIB_LOADED
        exit $exit_code
    fi
    return 0  # Return 0 to prevent script from exiting
}

# Function to output all errors and ask for confirmation to continue
check_state() {
    if [ ${#errors[@]} -gt 0 ]; then
        error_footer
        show_cursor
        unset COMMON_LIB_LOADED
        exit 1
    elif [ ${#failures[@]} -gt 0 ]; then
        failure_footer
        
        printf "\n"
        if [ "$last_stage" = false ]; then
            confirm "Do you want to continue despite these failures?"
            if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
                printf "Aborting...\n"
                show_cursor
                unset COMMON_LIB_LOADED
                exit 1
            fi
        fi
        
        # Clear failures after confirmation
        failures=()
    else
        success_footer
    fi
    
    # Only unset if this is the last stage
    if [ "$last_stage" = true ]; then
        unset COMMON_LIB_LOADED
    fi
    
    show_cursor
}

# Function to format and store error output
handle_error_output() {
    local message="$1"
    local output="$2"
    local max_length=75

    if [ -n "$output" ]; then
        printf "${red}%s${white}\n" "$output"
        # Add error to global array, taking only first line and limiting to max_length chars
        local first_line=$(echo "$output" | head -n 1)
        local truncated_error="${first_line:0:$max_length}"
        if [ ${#first_line} -gt $max_length ] || [ $(echo "$output" | wc -l) -gt 1 ]; then
            truncated_error="${truncated_error}..."
        fi
        failures+=("$message: $truncated_error")
    else
        failures+=("$message: {No output}")
    fi
} 
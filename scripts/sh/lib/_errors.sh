#!/usr/bin/env bash

########################################################################################
# File: errors.sh
# Description: Error handling functionality
########################################################################################

source "$(dirname "${BASH_SOURCE[0]}")/_core.sh"

FAILURES=()
ALL_FAILURES=()
ERRORS=()

# Set up error handling
set -E  # ERR trap is inherited by shell functions
trap 'handle_error $? "$BASH_COMMAND"' ERR
trap 'check_state' EXIT

handle_error() {
    local exit_code=$1
    local command=$2
    local error_message=""

    # Check specifically for source commands with "No such file or directory" errors
    # since this is a common error and we want to handle it gracefully
    if [[ "$command" == source* ]] || [[ "$command" == ". "* ]]; then
        # Extract the file path from the source command
        local file_path=$(echo "$command" | sed -E 's/^(source|\.) +([^ ]+).*/\2/')
        # Remove any quotes from the file path
        file_path="${file_path//\"/}"
        file_path="${file_path//\'/}"
        
        # Expand any variables in the file path
        eval "file_path=$file_path"
        
        # Check if the file exists
        if [[ ! -f "$file_path" ]]; then
            error_message="Error: File not found - $file_path"
            exit_code=2
        fi
    fi
    
    # Only treat it as an error if it's a syntax error or command not found
    if [[ $exit_code -eq 2 ]] || [[ $exit_code -eq 127 ]]; then
        local error_message="Command failed with exit code $exit_code: $command"
        ERRORS+=("$error_message")
        local shell_error=$(bash -c "$command" 2>&1)
        if [[ -n "$shell_error" ]]; then
            ERRORS+=("$shell_error")
        fi
        exit $exit_code
    fi
    
    return 0  # Return 0 to prevent script from exiting
}

# Function to output all errors and ask for confirmation to continue
check_state() {

    if [ "$LAST_STAGE" = true ]; then
        # Copy failures to ALL_FAILURES
        ALL_FAILURES+=("${FAILURES[@]}")
        
        # On last stage, set FAILURES to ALL_FAILURES to show complete summary
        FAILURES=("${ALL_FAILURES[@]}")
    fi

    if [ ${#ERRORS[@]} -gt 0 ]; then
        error_footer
        clear_state 
        exit 1
    elif [ ${#FAILURES[@]} -gt 0 ]; then
        
        printf "\n"
        if [ "$LAST_STAGE" = false ]; then
            confirm "Do you want to continue despite the $(pluralize ${#FAILURES[@]} "failure")?"
            if [[ ! "$confirm" =~ ^([Yy]|[Yy][Ee][Ss])$ ]]; then
                printf "Aborting...\n"
                failure_footer
                clear_state 
                exit 1
            fi
            # Copy failures to ALL_FAILURES before clearing
            ALL_FAILURES+=("${FAILURES[@]}")
            
            # Clear failures after confirmation
            FAILURES=()
        elif [ "$LAST_STAGE" = true ]; then
            failure_footer
        fi
    else
        if [ "$LAST_STAGE" = true ]; then
            success_footer
        fi
    fi
    
    # Only unset if this is the last stage
    if [ "$LAST_STAGE" = true ]; then
        clear_state 
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
        FAILURES+=("$message: $truncated_error")
    else
        FAILURES+=("$message: {No output}")
    fi
} 

clear_state() {
    unset COMMON_LIB_LOADED
    unset LAST_STAGE
    show_cursor
}
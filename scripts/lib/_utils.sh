#!/usr/bin/env bash

########################################################################################
# File: utils.sh
# Description: Time and string utility functions
########################################################################################

source "$(dirname "${BASH_SOURCE[0]}")/_core.sh"

# Function to print execution time if last_stage is true
print_execution_time() {
    if [ -n "${start_time+x}" ]; then
        local end_time=$(date +%s)
        local total_time=$((end_time - start_time))
        local formatted_time=$(format_time $total_time)
        printf "\n${blue}Total execution time: ${white}%s\n\n" "$formatted_time"
        
        # Unset start_time after printing to prevent multiple prints
        unset start_time
    fi
}

# Function to format time in a human-friendly way
format_time() {
    local seconds=$1
    local hours=$((seconds / 3600))
    local minutes=$(((seconds % 3600) / 60))
    local secs=$((seconds % 60))
    
    if [ $hours -gt 0 ]; then
        printf "%d %s %d %s %d %s" \
            $hours "$(pluralize $hours "hour")" \
            $minutes "$(pluralize $minutes "minute")" \
            $secs "$(pluralize $secs "second")"
    elif [ $minutes -gt 0 ]; then
        printf "%d %s %d %s" \
            $minutes "$(pluralize $minutes "minute")" \
            $secs "$(pluralize $secs "second")"
    else
        printf "%d %s" $secs "$(pluralize $secs "second")"
    fi
}

# Function to handle pluralization
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
#!/usr/bin/env bash

########################################################################################
# File: utils.sh
# Description: Time and string utility functions
########################################################################################

source "$(dirname "${BASH_SOURCE[0]}")/_core.sh"

# Function to print execution time if LAST_STAGE is true
print_execution_time() {
    if [ -n "${START_TIME+x}" ]; then
        local end_time=$(get_timestamp)
        local total_time=$((end_time - START_TIME))
        local formatted_time=$(format_time $total_time)
        printf "\n${BLUE}Total execution time: ${WHITE}%s\n\n" "$formatted_time"
        
        # Unset START_TIME after printing to prevent multiple prints
        unset START_TIME
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

# Cross-platform date function that works with millisecond precision
# Usage: get_timestamp [format]
# Default format: epoch seconds (like date +%s)
# Optional formats: 
#   ms - milliseconds since epoch using best available method
get_timestamp() {
    local format="${1:-s}"
    
    case "$format" in
        ms)
            # Attempt to get millisecond precision with standard date
            # First try using %N (nanoseconds) which works on GNU date (Linux)
            local nano=$(date +%N 2>/dev/null)
            
            if [ -n "$nano" ] && [ "$nano" != "%N" ]; then
                # If %N works, combine seconds with first 3 digits of nanoseconds
                local sec=$(date +%s)
                echo "${sec}${nano:0:3}"
            else
                # Fallback: just use seconds and pad with zeros for milliseconds
                # Less precise but works everywhere
                date +%s000
            fi
            ;;
        *)
            # Default to seconds precision (standard date works everywhere)
            date +%s
            ;;
    esac
} 
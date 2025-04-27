#!/usr/bin/env bash

########################################################################################
# File: _ui.sh
# Description: UI formatting and display functions for the script library
########################################################################################

source "$(dirname "${BASH_SOURCE[0]}")/_core.sh"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
DARK_GREEN='\033[38;5;22m'  # Deep forest green using 256-color mode
ORANGE='\033[38;5;208m'  # Bright orange using 256-color mode
DARK_ORANGE='\033[38;5;166m'  # Deeper, darker orange using 256-color mode
YELLOW='\033[0;33m'      # Standard yellow
BLUE='\033[0;34m'
GRAY='\033[0;90m'
BRIGHT_WHITE='\033[0;37m'
WHITE='\033[0;37m' # Dimmed bright white
OFF_WHITE='\033[38;5;252m' # A slightly duller white using 256-color mode

# Formatting options
BOLD='\033[1m'
REGULAR='\033[22m'

# Symbols for message types
SUCCESS_SYMBOL="✓"
FAILURE_SYMBOL="✗"
WARNING_SYMBOL="!"
INFO_SYMBOL="i"
SKIPPED_SYMBOL="↷"
ARROW_RIGHT="→"
ARROW_LEFT="←"
BAR_BLOCK="█" #▓ ⠿
HEADER_BLOCK="■"

# Spinner animation characters
SPINNER_CHARS=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

# Colored symbols for message outputs
PASSED="${GREEN}${SUCCESS_SYMBOL}${WHITE} "
FAILED="${RED}${FAILURE_SYMBOL}${WHITE} "
WARNED="${YELLOW}${WARNING_SYMBOL}${WHITE} "
INFO="${BLUE}${INFO_SYMBOL}${WHITE} "
SKIPPED="${BLUE}${SKIPPED_SYMBOL}${WHITE} "

# Footer definitions
START_HEADER="\n█▀ ▀█▀ ▄▀█ █▀█ ▀█▀\n▄█ ░█░ █▀█ █▀▄ ░█░"
SIM_HEADER="\n█▀ █ █▀▄▀█ █░█ █░░ ▄▀█ ▀█▀ █ █▀█ █▄░█\n▄█ █ █░▀░█ █▄█ █▄▄ █▀█ ░█░ █ █▄█ █░▀█"

SUCCESS_FOOTER="\n█▀█ █▄▀\n█▄█ █░█\n"
FAILURE_FOOTER="\n█▀▀ ▄▀█ █ █░░ █░█ █▀█ █▀▀\n█▀░ █▀█ █ █▄▄ █▄█ █▀▄ ██▄\n"
ERROR_FOOTER="\n█▀▀ █▀█ █▀█ █▀█ █▀█\n██▄ █▀▄ █▀▄ █▄█ █▀▄\n"

# UI Functions
ind() {
    printf "    "
}

header() {
    # Check if header_printed is defined and true
    if [ -n "${header_printed+x}" ] && [ "$header_printed" = true ]; then
        return
    fi
    # Determine which header to use based on simulation mode
    local header_text
    local color="$WHITE"
    
    if [ "$IS_SIMULATION" = true ]; then
        header_text="$SIM_HEADER"
        color="$BLUE"
    else
        header_text="$START_HEADER"
    fi
    
    # Print the header with appropriate color
    printf "\n${color}%b${WHITE}\n\n" "$header_text"
    
 #   # Print separator 
 #   separator 60
    
    # Reset color
 #   printf "${WHITE}\n"
    
    # Mark header as printed
    header_printed=true
    
    # Print each setting using the helper function
    print_setting "Verbose level" "$VERBOSE" "$DEFAULT_VERBOSE"
    print_setting "Simulation mode" "$IS_SIMULATION" "$DEFAULT_SIMULATION"
    print_setting "Skip confirmation" "$SKIP_CONFIRMATION" "$DEFAULT_SKIP_CONFIRMATION"
}

# Helper function to print a setting with appropriate color based on default
print_setting() {
    local name="$1"
    local value="$2"
    local default_value="$3"
    
    if [ "$value" = "$default_value" ]; then
        printf "• ${BLUE}%b: %b${WHITE}\n" "$name" "$value"
    else
        printf "• ${YELLOW}%b: %b${WHITE}\n" "$name" "$value"
    fi
}

sub_header() {

    check_state

    local title="$1"
    
    # Minimum length for the bar
    local min_length=10
    
    # Calculate the length of the title
    local title_length=$((6+${#title}))

    # The final bar length is whichever is larger: the title's length or the minimum length
    local bar_length=$(( title_length > min_length ? title_length : min_length ))
    
    printf "${WHITE}"

    # Print the top bar
    bar "$bar_length" 

    # Print the title itself, prefixed with "■ "
    printf "\n${BAR_BLOCK}${BAR_BLOCK} $title${WHITE} ${BAR_BLOCK}${BAR_BLOCK}"
    
    # Print the bottom bar
    bar "$bar_length" 

    printf "${WHITE}\n"
}

section() {
    local section="$1"
    printf "${WHITE}"
    separator 2 "$section"
    printf "${WHITE}"
}

separator() {
    local length="$1"
    local text="$2"
    local symbol="${3:-$HEADER_BLOCK}"

    bar "$length" "$symbol"
    printf " $text\n"
}

bar() {
    local length="$1"
    local symbol="${2:-$BAR_BLOCK}"
    
    printf "\n"
    local i=0
    while [ $i -lt "$length" ]; do
        printf "$symbol"
        i=$((i+1))
    done
}

info() {
    local message="$1"
    printf "\n$message\n"
}

confirm() {
    local message="$1"
    
    # Skip confirmation if skip_confirmation is true
    if [ "$skip_confirmation" = true ]; then
        return 0
    fi
    
    echo -e "${YELLOW}$message${WHITE}"
    show_cursor
    read -p "> " confirm
    printf "\n"
    hide_cursor
}

skipped() {
    local message="$1"
    local details="$2"
    print_message "$SKIPPED" "$message" "$details"
}

simulated() {
    local message="$1"
    local details="$2"
    print_message "$SKIPPED" "$message" "$details"
}

success() {
    local message="$1"
    local details="$2"
    print_message "$PASSED" "$message" "$details" 
}

failure() {
    local message="$1"
    local details="$2"
    print_message "$FAILED" "$message" "$details"
}

warning() {
    local message="$1"
    local details="$2"
    print_message "$WARNED" "$message" "$details"
}

# Helper function for printing messages with consistent formatting
print_message() {
    local symbol="$1"
    local message="$2"
    local details="$3"
    local color="${4:-$OFF_WHITE}"  # Default to white if no color specified
    
    if [ -n "$details" ]; then
        printf "%b${color}%b ${GRAY}%b${WHITE}\n" "$symbol" "$message" "$details"
    else
        printf "%b${color}%b${WHITE}\n" "$symbol" "$message"
    fi
}

simulation_header() {
    if [ "$IS_SIMULATION" = true ] && { [ ! -n "${header_printed+x}" ] || [ "$header_printed" = false ]; }; then
        header
    fi
}

# Helper function for printing footers
print_footer() {
    local footer_text="$1"
    local color="${2:-$WHITE}"
    local separator_length="${3:-30}"
    
    printf "\n${color}%b${WHITE}\n" "$footer_text"
    #separator "$separator_length"
    #printf "${WHITE}\n"
}

success_footer() {
    print_footer "$SUCCESS_FOOTER"
    success "No errors"
    
    # Print execution time if LAST_STAGE is true
    if [ "$LAST_STAGE" = true ];then
        print_execution_time
        show_cursor
    fi
}

failure_footer() {
    print_footer "$FAILURE_FOOTER" "$RED"
    
    # Correctly capture the pluralized word before using it in the string
    local failure_count=${#FAILURES[@]}
    local failure_text=$(pluralize $failure_count "failure")
    info "The following $failure_count $failure_text occurred:\n"
    
    for i in "${!FAILURES[@]}"; do
        if [ $i -lt 5 ]; then
            failure "${FAILURES[$i]}"
        elif [ $i -eq 5 ]; then
            local remaining=$(( ${#FAILURES[@]} - 5 ))
            printf "${RED}... and %d more failures${WHITE}\n" "$remaining"
            break
        fi
    done
    
    # Print execution time if LAST_STAGE is true
    if [ "$LAST_STAGE" = true ];then
        print_execution_time
        show_cursor
    fi
}

error_footer() {
    print_footer "$ERROR_FOOTER" "$RED"
    
    info "Execution aborted, error occurred:"
    failure "${ERRORS[0]}"
    show_cursor
} 
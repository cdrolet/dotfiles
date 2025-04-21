#!/usr/bin/env bash

########################################################################################
# File: _ui.sh
# Description: UI formatting and display functions for the script library
########################################################################################

source "$(dirname "${BASH_SOURCE[0]}")/_core.sh"

# Colors for different message types
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
gray='\033[0;90m'
bright_white='\033[0;37m'
white='\033[0;37m' # Dimmed bright white
off_white='\033[38;5;252m' # A slightly duller white using 256-color mode

# Bold and regular text formatting
bold='\033[1m'
regular='\033[22m'

# Symbols for different message types
success_symbol="✓"
failure_symbol="✗"
warning_symbol="!"
info_symbol="i"
skipped_symbol="↷"
upper_edge="◤"
lower_edge="◣"
arrow_right="→"
arrow_left="←"

# Spinner animation characters
spinner_chars=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

# Colored symbols
passed="${green}${success_symbol}${white} "
failed="${red}${failure_symbol}${white} "
warned="${yellow}${warning_symbol}${white} "
info="${blue}${info_symbol}${white} "
skipped="${blue}${skipped_symbol}${white} "

# Define header/footers using color variables
start_header="\n█▀ ▀█▀ ▄▀█ █▀█ ▀█▀\n▄█ ░█░ █▀█ █▀▄ ░█░"
sim_header="\n█▀ █ █▀▄▀█ █░█ █░░ ▄▀█ ▀█▀ █ █▀█ █▄░█\n▄█ █ █░▀░█ █▄█ █▄▄ █▀█ ░█░ █ █▄█ █░▀█"

success_footer="\n█▀█ █▄▀\n█▄█ █░█\n"
failure_footer="\n█▀▀ ▄▀█ █ █░░ █░█ █▀█ █▀▀\n█▀░ █▀█ █ █▄▄ █▄█ █▀▄ ██▄\n"
error_footer="\n█▀▀ █▀█ █▀█ █▀█ █▀█\n██▄ █▀▄ █▀▄ █▄█ █▀▄\n"

# UI Functions
ind() {
    printf "    "
}

header() {
    if [ "$header_printed" = true ]; then
        return
    fi
    # Determine which header to use based on simulation mode
    local header_text
    local color="$white"
    
    if [ "$is_simulation" = true ]; then
        header_text="$sim_header"
        color="$blue"
    else
        header_text="$start_header"
    fi
    
    # Print the header with appropriate color
    printf "\n${color}%b" "$header_text"
    
    # Print separator 
    separator 60
    
    # Reset color
    printf "${white}\n"
    
    # Mark header as printed
    header_printed=true
    
    # Print each setting using the helper function
    print_setting "Verbose level" "$verbose" "$DEFAULT_VERBOSE"
    print_setting "Simulation mode" "$is_simulation" "$DEFAULT_SIMULATION"
    print_setting "Skip confirmation" "$skip_confirmation" "$DEFAULT_SKIP_CONFIRMATION"
}

# Helper function to print a setting with appropriate color based on default
print_setting() {
    local name="$1"
    local value="$2"
    local default_value="$3"
    
    if [ "$value" = "$default_value" ]; then
        printf "• ${blue}%b: %b${white}\n" "$name" "$value"
    else
        printf "• ${yellow}%b: %b${white}\n" "$name" "$value"
    fi
}

sub_header() {
    local title="$1"
    
    # Minimum length for the bar
    local min_length=10
    
    # Calculate the length of the title
    local title_length=$((6+${#title}))

    # The final bar length is whichever is larger: the title's length or the minimum length
    local bar_length=$(( title_length > min_length ? title_length : min_length ))
    
    # Print the top bar
    bar "$bar_length" 

    # Print the title itself, prefixed with "■ "
    printf "\n■■ ${bright_white}$title${white} ■■"
    
    # Print the bottom bar
    bar "$bar_length" 

    printf "\n"
}

section() {
    local section="$1"
    printf "${bright_white}"
    separator 2 "$section"
    printf "${white}"
}

separator() {
    local length="$1"
    local text="$2"
    
    bar "$length"
    printf " $text\n"
}

bar() {
    local length="$1"
    local edge="$2"
    
    printf "\n"
    local i=0
    while [ $i -lt "$length" ]; do
        printf '■'
        i=$((i+1))
    done
    if [ "$edge" = "upper" ]; then
        printf "$upper_edge"
    elif [ "$edge" = "lower" ]; then
        printf "$lower_edge"
    fi
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
    
    echo -e "${yellow}$message${white}"
    show_cursor
    read -p "> " confirm
    printf "\n"
    hide_cursor
}

skipped() {
    local message="$1"
    local details="$2"
    print_message "$skipped" "$message" "$details"
}

simulated() {
    local message="$1"
    local details="$2"
    print_message "$skipped" "$message" "$details"
}

success() {
    local message="$1"
    local details="$2"
    print_message "$passed" "$message" "$details"
}

failure() {
    local message="$1"
    local details="$2"
    print_message "$failed" "$message" "$details" "$red"
}

warning() {
    local message="$1"
    local details="$2"
    print_message "$warned" "$message" "$details"
}

# Helper function for printing messages with consistent formatting
print_message() {
    local symbol="$1"
    local message="$2"
    local details="$3"
    local color="${4:-$off_white}"  # Default to white if no color specified
    
    if [ -n "$details" ]; then
        printf "%b${color}%b ${gray}%b${white}\n" "$symbol" "$message" "$details"
    else
        printf "%b${color}%b${white}\n" "$symbol" "$message"
    fi
}

simulation_header() {
    if [ "$is_simulation" = true ] && [ "$header_printed" = false ]; then
        header
    fi
}

# Helper function for printing footers
print_footer() {
    local footer_text="$1"
    local color="${2:-$white}"
    local separator_length="${3:-30}"
    
    printf "\n${color}%b${white}" "$footer_text"
    separator "$separator_length"
    printf "${white}\n"
}

success_footer() {
    print_footer "$success_footer"
    success "No errors"
    
    # Print execution time if last_stage is true
    if [ "$last_stage" = true ];then
        print_execution_time
        show_cursor
    fi
}

failure_footer() {
    print_footer "$failure_footer" "$red"
    
    info "The following failures occurred:\n"
    for i in "${!failures[@]}"; do
        if [ $i -lt 5 ]; then
            failure "${failures[$i]}"
        elif [ $i -eq 5 ]; then
            local remaining=$(( ${#failures[@]} - 5 ))
            printf "${red}... and %d more failures${white}\n" "$remaining"
            break
        fi
    done
    
    # Print execution time if last_stage is true
    if [ "$last_stage" = true ];then
        print_execution_time
        show_cursor
    fi
}

error_footer() {
    print_footer "$error_footer" "$red"
    
    info "Execution aborted, error occurred:"
    failure "${errors[0]}"
    show_cursor
} 
#!/usr/bin/env bash

########################################################################################
# File: _ui.sh
# Description: UI formatting and display functions for the script library
########################################################################################

source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
DARK_GREEN='\033[38;5;22m' 
ORANGE='\033[38;5;208m'  
DARK_ORANGE='\033[38;5;166m' 
YELLOW='\033[0;33m'      
BLUE='\033[0;34m'
GRAY='\033[0;90m'
BRIGHT_WHITE='\033[0;37m'
WHITE='\033[0;37m'
OFF_WHITE='\033[38;5;252m'

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
BAR_BLOCK="░"
HEADER_BLOCK="■"

# Spinner animation characters
SPINNER_CHARS=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

# Colored symbols for message outputs
PASSED="${GREEN}${SUCCESS_SYMBOL}${WHITE} "
FAILED="${RED}${FAILURE_SYMBOL}${WHITE} "
WARNED="${YELLOW}${WARNING_SYMBOL}${WHITE} "
INFO="${BLUE}${INFO_SYMBOL}${WHITE} "
SKIPPED="${BLUE}${SKIPPED_SYMBOL}${WHITE} "


START_HEADER="\n█▀ ▀█▀ ▄▀█ █▀█ ▀█▀\n▄█ ░█░ █▀█ █▀▄ ░█░"
SIM_HEADER="\n█▀ █ █▀▄▀█ █░█ █░░ ▄▀█ ▀█▀ █ █▀█ █▄░█\n▄█ █ █░▀░█ █▄█ █▄▄ █▀█ ░█░ █ █▄█ █░▀█"

SUCCESS_FOOTER="\n█▀█ █▄▀\n█▄█ █░█\n"
FAILURE_FOOTER="\n█▀▀ ▄▀█ █ █░░ █░█ █▀█ █▀▀\n█▀░ █▀█ █ █▄▄ █▄█ █▀▄ ██▄\n"
ERROR_FOOTER="\n█▀▀ █▀█ █▀█ █▀█ █▀█\n██▄ █▀▄ █▀▄ █▄█ █▀▄\n"


ind() {
    printf "    "
}

header() {

    if [ -n "${header_printed+x}" ] && [ "$header_printed" = true ]; then
        return
    fi

    local header_text
    local color="$WHITE"
    
    if [ "$IS_SIMULATION" = true ]; then
        header_text="$SIM_HEADER"
        color="$BLUE"
    else
        header_text="$START_HEADER"
    fi
    

    printf "\n${color}%b${WHITE}\n\n" "$header_text"
    
    header_printed=true
    
    local start_time_formatted=$(date "+%A, %B %d, %Y at %I:%M:%S %p")
    printf "• ${BLUE}Started: %s\n${WHITE}" "$start_time_formatted"
    
    print_setting "Verbose level" "$VERBOSE" "$DEFAULT_VERBOSE"
    print_setting "Simulation mode" "$IS_SIMULATION" "$DEFAULT_SIMULATION"
    print_setting "Skip confirmation" "$SKIP_CONFIRMATION" "$DEFAULT_SKIP_CONFIRMATION"
    print_setting "Environment" "$ENVIRONMENT" "$DEFAULT_ENVIRONMENT"
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
    
    local min_length=10
    
    local title_length=$((6+${#title}))

    local bar_length=$(( title_length > min_length ? title_length : min_length ))
    
    printf "\n${BLUE}"

    bar "$bar_length" 

    printf "\n${BAR_BLOCK}${BAR_BLOCK} $title ${BAR_BLOCK}${BAR_BLOCK}\n"

    bar "$bar_length" 

    printf "${WHITE}\n"
}

section() {
    local section="$1"
    printf "${BLUE}"
    separator 2 "$section"
    printf "${WHITE}"
}

separator() {
    local length="$1"
    local text="$2"
    local symbol="${3:-$HEADER_BLOCK}"

    printf "\n"
    bar "$length" "$symbol"
    printf " $text\n"
}

bar() {
    local length="$1"
    local symbol="${2:-$BAR_BLOCK}"
    
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
    
    if [ "$SKIP_CONFIRMATION" = true ]; then
        confirm="y"
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

print_message() {
    local symbol="$1"
    local message="$2"
    local details="$3"
    local color="${4:-$OFF_WHITE}" 
    
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

print_footer() {
    local footer_text="$1"
    local color="${2:-$WHITE}"
    local separator_length="${3:-30}"
    
    printf "\n${color}%b${WHITE}\n" "$footer_text"
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

# Get the terminal width
get_terminal_width() {
    # Try different methods to get the terminal width
    if [ -n "$COLUMNS" ]; then
        # Use COLUMNS environment variable if available
        echo "$COLUMNS"
    elif command -v tput >/dev/null 2>&1 && tput cols >/dev/null 2>&1; then
        # Use tput if available and working
        tput cols
    elif command -v stty >/dev/null 2>&1; then
        # Try stty if available
        stty size 2>/dev/null | awk '{print $2}' || echo 80
    else
        # Default fallback
        echo 80
    fi
}

# Draw a box around multiline text
draw_output_box() {
    local text="$1"
    local color="${2:-$GRAY}"
    
    # Auto-detect terminal width with boundaries
    local term_width=$(get_terminal_width)
    local min_width=80
    local max_width=110
    local desired_width=$max_width
    
    # Set box width based on terminal size
    # Subtract 5 characters for padding and margins
    if [ "$term_width" -lt $((min_width + 5)) ]; then
        # Terminal is too small, use minimum width
        local width=$min_width
    elif [ "$term_width" -lt $((max_width + 5)) ]; then
        # Terminal has space but not for max width
        local width=$((term_width - 5))
    else
        # Terminal has enough space for max width
        local width=$max_width
    fi
    
    local padding=1
    local content_width=$((width - 2))  # Width inside borders
    
    # If text is empty, return
    if [ -z "$text" ]; then
        return
    fi
    
    # Print the top border
    printf "$color"
    printf "┌"
    for ((i=0; i<width; i++)); do printf "─"; done
    printf "┐\n"
    
    # Print padding lines
    for ((i=0; i<padding; i++)); do
        printf "│"
        printf "%${width}s" " "
        printf "│\n"
    done
    
    # Print each line of text with proper padding
    echo "$text" | while IFS= read -r line; do
        # Trim line to content width
        local trimmed_line="${line:0:$content_width}"
        # Calculate padding needed on the right
        local right_padding=$((width - ${#trimmed_line} - 1))
        
        printf "│ %s%${right_padding}s│\n" "$trimmed_line" " "
    done
    
    # Print padding lines
    for ((i=0; i<padding; i++)); do
        printf "│"
        printf "%${width}s" " "
        printf "│\n"
    done
    
    # Print the bottom border
    printf "└"
    for ((i=0; i<width; i++)); do printf "─"; done
    printf "┘\n"
    printf "$WHITE"
}
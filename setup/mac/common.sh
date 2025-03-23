#!/bin/bash

#######################
# Global Variables
#######################

# Define color codes directly where used to avoid issues with variable expansion
gray='\033[90m'  
white='\033[0m'
red='\033[31m'
green='\033[32m'
yellow='\033[33m'
passed="\033[32m✓\033[0m "
failed="\033[31m✗\033[0m "
# Array to store error messages
errors=()

#######################
# Functions
#######################

print_separator() {
    printf "\n"
    for _ in $(seq 1 "$1"); do
        printf '■'
    done
    printf " $2\n"
}

print_header() {
    local title="$1"
    
    # Minimum length for the bar
    local min_length=10
    
    # Calculate the length of the title
    local title_length=$((2+${#title}))

    # The final bar length is whichever is larger: the title's length or the minimum length
    local bar_length=$(( title_length > min_length ? title_length : min_length ))
    
    # Print a newline before the bar
    printf "\n"
    
    # Print the top bar
    print_separator "$bar_length"

    # Print the title itself, prefixed with "■ "
    printf "■ $title"
    
    # Print the bottom bar
    print_separator "$bar_length"
}

print_section() {
    print_separator 2 "$1"
}

run_command() {
    local name="$1"
    shift # Remove name
    local command="$@"
         
    # Execute the command and capture its output
    if output=$($command 2>&1); then
        echo -e "$passed $name ${gray}$command${white}"
    else
        echo -e "$failed $name ${gray}$command${white}"
        echo -e "${red}Error: $output${white}"
        # Add error to global array
        errors+=("$name: $output")
        return 1
    fi
}


# Function to output all errors and ask for confirmation to continue
check_errors() {
    if [ ${#errors[@]} -gt 0 ]; then
        printf "\n"
        echo -e "${yellow}The following errors occurred:${white}"
        for error in "${errors[@]}"; do
            echo -e "${red}- $error${white}"
        done
        
        printf "\n"
        read -p "Do you want to continue despite these errors? (y/n): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            printf "Aborting...\n"
            exit 1
        fi
        
        # Clear errors after confirmation
        errors=()
    else
        printf "\n\n█▀ █░█ █▀▀ █▀▀ █▀ █▀\n▄█ █▄█ █▄▄ ██▄ ▄█ ▄█\n"
    fi
}

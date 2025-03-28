#!/bin/zsh

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
warned="\033[33m⚠\033[0m "
successFooter="\n█▀█ █▄▀\n█▄█ █░█\n"
failureFooter="\n█▀▀ ▄▀█ █ █░░ █░█ █▀█ █▀▀\n█▀░ █▀█ █ █▄▄ █▄█ █▀▄ ██▄\n"
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
    local description="$1"
    local command="$2"
    local warn_only="$3"
    # Execute the command and capture its output
    if output=$(eval "$command" 2>&1); then
        printf "$passed %s ${gray}%s${white}\n" "$description" "$command"
    else
        if [ "$warn_only" = "warning" ]; then
            printf "$warned %s ${gray}%s${white}\n" "$description" "$command"
        else
            printf "$failed %s ${gray}%s${white}\n" "$description" "$command"
            printf "${red}%s${white}\n" "$output"
            # Add error to global array, taking only first line and limiting to 50 chars
            local first_line=$(echo "$output" | head -n 1)
            local truncated_error="${first_line:0:75}"
            if [ ${#first_line} -gt 50 ] || [ $(echo "$output" | wc -l) -gt 1 ]; then
                truncated_error="${truncated_error}..."
            fi
            errors+=("$description: $truncated_error")
            return 1
        fi
    fi
}


# Function to output all errors and ask for confirmation to continue
check_errors() {
    if [ ${#errors[@]} -gt 0 ]; then
        printf "\n$failureFooter"
        print_separator 30
        printf "\n"
        printf "${yellow}The following errors occurred:${white}\n"
        # Show only first 5 errors
        for i in "${!errors[@]}"; do
            if [ $i -lt 5 ]; then
                printf "${red}- ${errors[$i]}${white}\n"
            elif [ $i -eq 5 ]; then
                local remaining=$(( ${#errors[@]} - 5 ))
                printf "${red}... and %d more errors${white}\n" "$remaining"
                break
            fi
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
        printf "\n$successFooter"
        print_separator 30
        printf "\n"
        printf "no errors\n"
    fi
}

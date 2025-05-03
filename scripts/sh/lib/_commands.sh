#!/usr/bin/env bash

########################################################################################
# File: commands.sh
# Description: Command execution functionality
########################################################################################

source "$(dirname "${BASH_SOURCE[0]}")/_core.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_ui.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_errors.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_utils.sh"

# Function to check if a command exists and install it if necessary
install() {
    local command_name="$1"   # Name of the command to check (e.g., "brew")
    local install_command="$2" # Command to run if the command doesn't exist
    local description="$3"     # Optional description
    local no_details="$4"     # Optional flag to not show details

    # Generate description if not provided
    if [ -z "$description" ]; then
        description="Installing $command_name"
    fi
    
    local output_command="$install_command"
    if [ "$no_details" = true ]; then
        output_command=""
    fi

    # Check if the command already exists
    if command -v "$command_name" &>/dev/null; then
        skipped "$command_name already installed" "$output_command"
        return 0
    fi
    
    # Command doesn't exist, so install it
    spin "$description" "$install_command" "$no_details"
}

# Function to show progress animation while running a command
spin() {
    local description="$1"
    local command="$2"
    local no_details="$3"
    local success_handler="${4:-default_success_handler}"  # Default to default_success_handler if not provided
    local failure_handler="${5:-default_failure_handler}"  # Default to default_failure_handler if not provided
 
    local delay=0.1
    local i=0
    local output=""
    local exit_status=0

    hide_cursor

    # Create a temporary file for output
    local tmp_file=$(mktemp)
    
    local output_command="$command"
    if [ "$no_details" = true ]; then
        output_command=""
    fi
    
    # Start the command in the background and redirect output to temp file
    eval "$output_command" > "$tmp_file" 2>&1 &
    local pid=$!

    # Show spinner while command is running
    while kill -0 $pid 2>/dev/null; do
        render_spinner_output "${SPINNER_CHARS[$i]}" "$description" "$output_command"
        i=$(( (i + 1) % ${#SPINNER_CHARS[@]} ))
        sleep $delay
    done

    # Get the exit status of the command
    wait $pid
    exit_status=$?
    
    # Extract only error-related lines from the output
    if [ $exit_status -ne 0 ]; then
        # Try to find error or fail messages, otherwise take the full output
        if grep -i "error\|fail\|already exists\|cannot\|denied" "$tmp_file" > /dev/null; then
            if [ "$VERBOSE" -lt 3 ]; then
                # For lower verbosity, only take the first line of errors
                output=$(grep -i "error\|fail\|already exists\|cannot\|denied" "$tmp_file" | head -n 1)
            else
                # For high verbosity, take all error lines
                output=$(grep -i "error\|fail\|already exists\|cannot\|denied" "$tmp_file")
            fi
        else
            if [ "$VERBOSE" -lt 3 ]; then
                # For lower verbosity, only take the first line
                output=$(head -n 1 "$tmp_file")
            else
                # For high verbosity, take all output
                output=$(cat "$tmp_file")
            fi
        fi
    else
        # On success, handle based on verbosity
        if [ "$VERBOSE" -lt 3 ]; then
            # For lower verbosity, only take the first line
            output=$(head -n 1 "$tmp_file")
        else
            # For high verbosity, take all output
            output=$(cat "$tmp_file")
        fi
    fi

    rm -f "$tmp_file"
    
    clear_line
    move_cursor_at_start

    # Handle command result
    if [ $exit_status -eq 0 ]; then
        $success_handler "$description" "$command" "$output"
    else
        $failure_handler "$description" "$command" "$output"
    fi
}

hide_cursor() {
    printf "\033[?25l"
}

show_cursor() {
    printf "\033[?25h"
}

clear_line() {
    printf "\r\033[K"
}

move_cursor_at_start() {
    printf "\033[0G"
}

render_spinner_output() {
    local spinner_char="$1"
    local description="$2"
    local command="$3"
    
    if [ "$VERBOSE" -eq 1 ]; then
        printf "\r${BLUE}${spinner_char}${WHITE} $description"
    elif [ "$VERBOSE" -ge 2 ]; then
        printf "\r${BLUE}${spinner_char}${WHITE} $description ${GRAY}$command${WHITE}"
    fi
}

# Function to execute commands from an associative array
run_command_map() {
    local section_name="$1"
    local array_name="$2"  # name of the associative array
    local success_handler="${3:-default_success_handler}"  # Default to default_success_handler if not provided
    local failure_handler="${4:-default_failure_handler}"  # Default to default_failure_handler if not provided

    section "$section_name"
    # Use eval with proper quoting to handle keys with spaces
    eval "for description in \"\${!$array_name[@]}\"; do
        command=\$(eval \"echo \\\"\${$array_name[\$description]}\\\"\")
        run \"\$description\" \"\$command\" \"\$success_handler\" \"\$failure_handler\"
    done"
}

# Function to execute commands from a regular array with a template
run_commands() {
    local section_name="$1"
    local -n params_array="$2"  # nameref to the regular array containing parameters
    local description_template="$3"  # template with placeholder for description
    local command_template="$4"  # template with placeholder for command
    local success_handler="${5:-default_success_handler}"  # Default to default_success_handler if not provided
    local failure_handler="${6:-default_failure_handler}"  # Default to default_failure_handler if not provided

    section "$section_name"
    for param in "${params_array[@]}"; do
        # Replace placeholder in command template with the parameter
        command=$(echo "$command_template" | sed "s/{param}/$param/g")
        
        # Replace placeholder in description template with the parameter
        description=$(echo "$description_template" | sed "s/{param}/$param/g")
        
        run "$description" "$command" "$success_handler" "$failure_handler"
    done
}

track_command() {
    step_stopwatch=$(get_timestamp_ms)

    # Execute the function passed as parameters
    local function_call="$@"
    local function_name="$1"

    eval "$function_call"

    local end_time=$(get_timestamp_ms) 
    
    # Ensure both values are integers for math
    step_stopwatch=${step_stopwatch%%[!0-9]*}

    end_time=${end_time%%[!0-9]*}
    
    local total_time=$((end_time - step_stopwatch))

    if [ $total_time -gt 0 ]; then
        if [ $total_time -ge 1000 ]; then
            # Calculate seconds with proper floating point in zsh
            local seconds=$((total_time / 1000.0))
            printf "• %s loaded in %.2f seconds\n" "$function_call" "$seconds"
        else
            printf "• $function_call loaded in ${total_time}ms\n"
        fi
    fi
}

rwarn() {
    local description="$1"
    local command="$2"
    run "$description" "$command" default_success_handler default_warning_handler
}

run() {
    local description="$1"
    local command="$2"
    local success_handler="${3:-default_success_handler}"  # Default to default_success_handler if not provided
    local failure_handler="${4:-default_failure_handler}"  # Default to default_failure_handler if not provided

    # Execute the command and capture its output
    if output=$(execute_command "$command"); then
        # Command succeeded
        $success_handler "$description" "$command" "$output"
    else
        # Command failed
        $failure_handler "$description" "$command" "$output"
    fi
}

# Function to execute a command and handle its output
execute_command() {
    local command="$1"
    if [ "$IS_SIMULATION" = true ]; then
        echo "Simulated: $command"
    else
        # Create a temporary file for output
        local tmp_file=$(mktemp)
        
        # Run the command and capture its exit status
        eval "$command" > "$tmp_file" 2>&1
        local exit_status=$?
        
        # Read the output from the temp file
        output=$(cat "$tmp_file")
        
        # Clean up
        rm -f "$tmp_file"
        
        # Return the output without color codes - we'll add colors during rendering
        echo "$output"
        
        # Return the original exit status
        return $exit_status
    fi
}

default_success_handler() {
    local description="$1"
    local command="$2"
    local output="$3"
    render_command_output "success" "$description" "$command" "$output"
}

default_failure_handler() {
    local description="$1"
    local command="$2"
    local output="$3"
    render_command_output "failure" "$description" "$command" "$output"
    return 1
}

default_warning_handler() {
    local description="$1"
    local command="$2"
    local output="$3"
    render_command_output "warning" "$description" "$command" "$output"
    # Don't return 1, so the script continues
    return 0
}



# Function to properly display colored output
render_command_output() {
    local status="$1"  # success, warning, or failure
    local description="$2"
    local command="$3"
    local output="$4"
    
    # Define the output function based on status
    local output_func=""
    case "$status" in
        "skipped") output_func="skipped" ;;
        "success") 
            if [ "$IS_SIMULATION" = true ]; then
                output_func="simulated"
            else
                output_func="success"
            fi
            ;;
        "warning") output_func="warning" ;;
        "failure") output_func="failure" ;;
    esac

    # Handle error output for failure status
    if [ "$status" = "failure" ] && [ "$VERBOSE" -ge 2 ]; then
        handle_error_output "$description" "$output"
    fi
    
    # Render output based on verbosity level
    case "$VERBOSE" in
        1) # Verbosity level 1: Only show description
            $output_func "$description"
            ;;
        2) # Verbosity level 2: Show description and command on same line (default)
            $output_func "$description" "$command"
            ;;
        3) # Verbosity level 3: Show command, output in a box, and description
            printf "${GRAY}${ARROW_LEFT} $command${WHITE}\n"
            if [ -n "$output" ]; then
                # Draw a box around the output with the appropriate color
                if [ "$status" = "failure" ]; then
                    draw_output_box "$output" "$RED"
                else
                    draw_output_box "$output" "$GRAY"
                fi
            fi
            $output_func "$description"
            ;;
    esac
}


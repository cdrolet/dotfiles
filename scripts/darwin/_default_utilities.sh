#!/usr/bin/env bash

# Function to read back the value of a defaults command after execution and set it as output
defaults_handler() {
    local description="$1"
    local command="$2"
    local output
    
    # Check if this is a defaults write command
    if [[ "$command" == *"defaults"*"write"* ]]; then
        # When a write command is executed, we need to read back the value since the default didn't output anything

        # Convert to read command
        local read_command=$(to_defaults_read_command "$command")
        
        # Execute the read command
        if [ "$is_simulation" = true ]; then
            output="Simulated: $(echo "$read_command")"
        else
            output="$read_command: $(eval "$read_command" 2>&1)"
        fi
        
        render_command_output "success" "$description" "$command" "$output"
    else
        default_success_handler "$description" "$command" "$output"
    fi
}

# Function to convert a defaults write command to a defaults read command
to_defaults_read_command() {
    local write_command="$1"
    
    # Replace 'write' with 'read'
    local read_command="${write_command/defaults write/defaults read}"
    
    # Replace 'write' with 'read'
    local read_command="${read_command/defaults -currentHost write/defaults -currentHost read}"

    # Remove everything after the last "-" character
    read_command=$(echo "$read_command" | sed 's/ -[^-]*$//')
    
    echo "$read_command"
}

# Export the validation handler for use in other scripts
export -f defaults_handler

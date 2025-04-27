#!/usr/bin/env bash

# Function to check for and install Xcode Command Line Tools
install_xcode_cli_tools() {
    local install_command="xcode-select --install"
    local description="Install Xcode Command Line Tools"
    
    # Check if Xcode CLI tools are already installed
    if xcode-select -p &>/dev/null; then
        skipped "Xcode Command Line Tools already installed" "$install_command"
        return 0
    fi
    
    # Install Xcode CLI tools
    spin "$description" "$install_command"
}

install_brew() {
    install "Homebrew" "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" "Installing Homebrew" true
}

load_brew() {
    # Check if brew is already in PATH
    if command -v brew &>/dev/null; then
        skipped "Homebrew already loaded" "$(which brew)"
        return 0
    fi
    
    # Load brew based on location
    if [[ -f /opt/homebrew/bin/brew ]]; then
        run "Loading Homebrew" "eval '$(/opt/homebrew/bin/brew shellenv)'" true     
    elif [[ -f /usr/local/bin/brew ]]; then
        run "Loading Homebrew" "eval '$(/usr/local/bin/brew shellenv)'" true
    else
        handle_error_output "Homebrew not found" "Cannot load Homebrew environment"
    fi
}

# Function to install multiple packages from an associative array
brew_install_from_map() {
    local section_name="$1"
    local array_name="$2"  # Name of the associative array
    
    # Print section header
    section "$section_name"
    
    # Iterate over the associative array
    eval "for package in \"\${!$array_name[@]}\"; do
        # Get the value (is_cask flag)
        is_cask=\$(eval \"echo \\\"\${$array_name[\$package]}\\\"\")
        
        # Handle special cases where we have tap:package format
        if [[ \$package == *:* ]]; then
            tap=\$(echo \$package | cut -d':' -f1)
            actual_package=\$(echo \$package | cut -d':' -f2)
            brew_install \"\$actual_package\" \"\$is_cask\" \"\$tap\"
        else
            brew_install \"\$package\" \"\$is_cask\"
        fi
    done"
}

# Function to install packages using Homebrew
brew_install() {
    local package="$1"
    local is_cask="${2:-false}"
    local tap="$3"
    local description="Installing $package"
    local command=""
    
    # Add tap if specified and not already added
    if [ -n "$tap" ]; then
        # Check if tap is already added
        if brew tap | grep -q "^$tap$"; then
            skipped "Tap $tap already added" "brew tap $tap"
        else
            spin "Adding tap $tap" "brew tap $tap"
        fi
    fi
    
    local cask_command=""
    # Build the install command
    if [ "$is_cask" = true ]; then
        cask_command=" --cask"
    fi
    command="brew install$cask_command $package"

    # Check if package is already installed
    if brew list "$package" &>/dev/null; then
        skipped "$package already installed" "$command"
        return 0
    fi
    
    # Install the package
    spin "$description" "$command"
}

# Function to install multiple VS Code extensions from an array
install_code_extensions_from_array() {
    local section_name="$1"
    local array_name="$2"  # Name of the array containing extension IDs
    local code_cmd="${3:-code}"  # Default to 'code', but allow custom command (like 'cursor')
    
    # Print section header
    section "$section_name"
    
    # Iterate over the array
    eval "for extension_id in \"\${$array_name[@]}\"; do
        install_code_extension \"\$extension_id\" \"$code_cmd\"
    done"
}

# Function to install VS Code extensions if they don't already exist
install_code_extension() {
    local extension_id="$1"
    local code_cmd="${2:-code}"  # Default to 'code', but allow custom command (like 'cursor')
    
    # Check if extension is already installed, ignore SIGPIPE errors
    if $code_cmd --list-extensions 2>/dev/null | grep -q "^$extension_id$"; then
        skipped "$extension_id already installed" "$code_cmd --install-extension $extension_id"
        return 0
    fi
    
    # Just silently ignore SIGPIPE errors and proceed with installation
    # The --list-extensions command is only used for checking if installed
    # We'll let the actual installation attempt handle any real errors
    
    # Install the extension
    run "Installing $extension_id extension" "$code_cmd --install-extension $extension_id"
}




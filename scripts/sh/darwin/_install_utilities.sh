#!/usr/bin/env bash


install_brew() {
    # Check if Homebrew is already installed
    if command -v brew &>/dev/null; then
        if [ "$UPGRADE_OUTDATED" = true ]; then
            spin "Upgrading Homebrew" "brew upgrade"
        else
            render_command_output "skipped" "Homebrew already installed" "$(brew --version)"
            return 0
        fi
    else
        install "Homebrew" "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" "Installing Homebrew" true    
    fi
}


load_brew() {
    # Check if brew is already in PATH
    if command -v brew &>/dev/null; then
        render_command_output "skipped" "Homebrew already loaded" "$(which brew)"
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
            render_command_output "skipped" "Tap $tap already added" "brew tap $tap"
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
        if [ "$UPGRADE_OUTDATED" = true ]; then
            spin "Upgrading $package" "brew upgrade$cask_command $package"
        else
            render_command_output "skipped" "$package already installed" "$command"
            return 0
        fi
    else
        # Install the package
        spin "$description" "$command"
    fi
}

# Function to install multiple VS Code extensions from an array
code_extensions_install_from_array() {
    local section_name="$1"
    local array_name="$2"  # Name of the array containing extension IDs
    local code_cmd="${3:-code}"  # Default to 'code', but allow custom command (like 'cursor')
    
    # Print section header
    section "$section_name"
    
    # Iterate over the array
    eval "for extension_id in \"\${$array_name[@]}\"; do
        code_extension_install \"\$extension_id\" \"$code_cmd\"
    done"
}

# Function to install multiple python packages using uv tool
uv_install_from_map() {
    local section_name="$1"
    local array_name="$2"  # Name of the associative array
    
    # Print section header
    section "$section_name"
    
    # Iterate over the associative array
    eval "for package in \"\${!$array_name[@]}\"; do
        # Get the gitrepository url
        url=\$(eval \"echo \\\"\${$array_name[\$package]}\\\"\")
        
        # Install the extension
        run "Installing python $package from ${url}" "uv tool install $package --from git+${url}"
    done"
}

# Function to install VS Code extensions if they don't already exist
code_extension_install() {
    local extension_id="$1"
    local code_cmd="${2:-code}"  # Default to 'code', but allow custom command (like 'cursor')
    
    # Check if extension is already installed, ignore SIGPIPE errors
    if $code_cmd --list-extensions 2>/dev/null | grep -q "^$extension_id$"; then
        render_command_output "skipped" "$extension_id already installed" "$code_cmd --install-extension $extension_id"
        return 0
    fi
    
    # Just silently ignore SIGPIPE errors and proceed with installation
    # The --list-extensions command is only used for checking if installed
    # We'll let the actual installation attempt handle any real errors
    
    # Install the extension
    run "Installing $extension_id extension" "$code_cmd --install-extension $extension_id"
}

# Function to install fonts from a directory
install_fonts_from_directory() {
    local source_dir="$1"
    local description="${2:-fonts}"
    
    # macOS fonts directory
    local fonts_dir="$HOME/Library/Fonts"
    
    # Count fonts to install
    local font_count=$(find "$source_dir" -type f \( -name "*.ttf" -o -name "*.otf" -o -name "*.TTF" -o -name "*.OTF" \) | wc -l | tr -d ' ')
    
    if [ "$font_count" -eq 0 ]; then
        skipped "No fonts found in $source_dir"
        return 0
    fi
    
    # Copy fonts to system fonts directory
    run "Installing $font_count $description" "find '$source_dir' -type f \( -name '*.ttf' -o -name '*.otf' -o -name '*.TTF' -o -name '*.OTF' \) -exec cp {} '$fonts_dir/' \;"
}


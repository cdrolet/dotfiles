#!/usr/bin/env bash

# Function to check for and install Xcode Command Line Tools
install_xcode_cli_tools() {
    local install_command="xcode-select --install"
    local description="Install Xcode Command Line Tools"

    # Check if Xcode CLI tools are already installed
    if xcode-select -p &>/dev/null; then
        # If upgrade flag is set, check for updates
        if [ "$UPGRADE_OUTDATED" = true ]; then
            # Check if there's an update available
            info "looking for updates"
            local update_check=$(check_xcode_cli_tools_update)

            if [ -n "$update_check" ]; then
                # Extract the full label (e.g., "Command Line Tools for Xcode 26.0-26.0")
                local update_label=$(echo "$update_check" | sed 's/^\* Label: //')
                spin "Updating Xcode Command Line Tools" "sudo softwareupdate --install '$update_label' --agree-to-license --no-scan"
            else
                skipped "Xcode Command Line Tools already up to date"
            fi
        else
            skipped "Xcode Command Line Tools already installed"
        fi
        return 0
    fi

    # Install Xcode CLI tools
    spin "$description" "$install_command"
}


# Check for available Xcode Command Line Tools updates
# Outputs the update label if available, nothing if up to date
check_xcode_cli_tools_update() {
    softwareupdate --list 2>/dev/null | grep "^\* Label: Command Line Tools"
}

update_sdkman() {
    # Check if SDKMAN is installed
    if [ ! -d "$HOME/.sdkman" ]; then
        skipped "SDKMAN not installed"
        return 0
    fi

    # Source SDKMAN and update
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    spin "Updating SDKMAN" "sdk update"
    echo ""
}

install_brew() {
    # Check if Homebrew is already installed
    if command -v brew &>/dev/null; then
        if [ "$UPGRADE_OUTDATED" = true ]; then
            spin "Upgrading Homebrew" "brew upgrade"
        else
            skipped "Homebrew already installed"
            return 0
        fi
    else
        install "Homebrew" "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" "Installing Homebrew" true
    fi
}


load_brew() {
    # Check if brew is already in PATH
    if command -v brew &>/dev/null; then
        skipped "Homebrew already loaded"
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
        # Get the value (package type: 'formula', 'cask', or legacy true/false)
        package_type=\$(eval \"echo \\\"\${$array_name[\$package]}\\\"\")

        # Convert to is_cask boolean for brew_install function
        # Support both new ('formula'/'cask') and legacy (true/false) formats
        if [[ \"\$package_type\" == \"cask\" || \"\$package_type\" == \"true\" ]]; then
            is_cask=true
        else
            is_cask=false
        fi

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


# Helper: Get cask artifacts from brew info
_get_cask_artifacts() {
    local package="$1"
    brew info --cask "$package" 2>/dev/null | sed -n '/^==> Artifacts$/,/^==> /p' | grep -v "^==>"
}

# Helper: Extract app name from artifacts
_extract_app_name() {
    local artifacts="$1"
    local app_line=$(echo "$artifacts" | grep "(App)" | head -1 | sed 's/ (App).*//')
    basename "$app_line" 2>/dev/null
}

# Helper: Extract binary path from artifacts
_extract_binary_path() {
    local artifacts="$1"
    local binary_line=$(echo "$artifacts" | grep "(Binary)" | head -1 | sed 's/ (Binary).*//')

    if [[ "$binary_line" == *"->"* ]]; then
        echo "$binary_line" | sed 's/.*-> //'
    elif [ -n "$binary_line" ]; then
        echo "/opt/homebrew/bin/$binary_line"
    fi
}

# Helper: Check if cask artifacts exist on disk
_cask_artifacts_exist() {
    local package="$1"
    local artifacts=$(_get_cask_artifacts "$package")

    # Check for app
    local app_name=$(_extract_app_name "$artifacts")
    if [ -n "$app_name" ] && [ -e "/Applications/$app_name" ]; then
        return 0
    fi

    # Check for binary
    local binary_path=$(_extract_binary_path "$artifacts")
    if [ -n "$binary_path" ] && [ -e "$binary_path" ]; then
        return 0
    fi

    # Check for font artifacts
    if echo "$artifacts" | grep -q "(Font)"; then
        # Extract font files from artifacts
        local font_files=$(echo "$artifacts" | grep "(Font)" | sed 's/ (Font).*//')
        while IFS= read -r font_file; do
            local font_name=$(basename "$font_file")
            # Check in both user and system font directories
            if [ -e "$HOME/Library/Fonts/$font_name" ] || [ -e "/Library/Fonts/$font_name" ]; then
                return 0
            fi
        done <<< "$font_files"
    fi

    return 1
}

# Helper: Remove conflicting cask artifacts
_remove_cask_artifacts() {
    local package="$1"
    local artifacts=$(_get_cask_artifacts "$package")

    # Remove app
    local app_name=$(_extract_app_name "$artifacts")
    if [ -n "$app_name" ] && [ -e "/Applications/$app_name" ]; then
        run "Removing existing $app_name" "rm -rf '/Applications/$app_name'"
    fi

    # Remove binary
    local binary_path=$(_extract_binary_path "$artifacts")
    if [ -n "$binary_path" ] && [ -e "$binary_path" ]; then
        run "Removing existing binary" "rm -f '$binary_path'"
    fi
}

# Function to install packages using Homebrew
brew_install() {
    local package="$1"
    local is_cask="${2:-false}"
    local tap="$3"

    # Add tap if needed
    if [ -n "$tap" ]; then
        if brew tap | grep -q "^$tap$"; then
            skipped "Tap $tap already added"
        else
            spin "Adding tap $tap" "brew tap $tap"
        fi
    fi

    # Build command
    local cask_flag=""
    [ "$is_cask" = true ] && cask_flag=" --cask"
    local install_cmd="brew install$cask_flag $package"

    # Check if package is registered in Homebrew
    if brew list "$package" &>/dev/null; then
        # Package is registered
        if [ "$is_cask" = true ] && ! _cask_artifacts_exist "$package"; then
            # Cask registered but artifacts missing - reinstall
            spin "Reinstalling $package (artifacts missing)" "brew reinstall$cask_flag $package"
        elif [ "$UPGRADE_OUTDATED" = true ]; then
            # Upgrade if requested
            spin "Upgrading $package" "brew upgrade$cask_flag $package"
        else
            # Already installed, skip
            skipped "$package already installed"
        fi
    else
        # Package not registered
        if [ "$is_cask" = true ] && _cask_artifacts_exist "$package"; then
            # Conflicting artifacts exist - remove and install
            _remove_cask_artifacts "$package"
        fi
        # Install package
        spin "Installing $package" "$install_cmd"
    fi
}


# Function to install multiple python packages using uv tool
uv_install_from_map() {
    local section_name="$1"
    local array_name="$2"  # Name of the associative array

    # Print section header
    section "$section_name"

    # Iterate over the associative array
    eval "for package in \"\${!$array_name[@]}\"; do
        # Get the git repository url
        url=\$(eval \"echo \\\"\${$array_name[\$package]}\\\"\")

        # Install the package
        run \"Installing python \$package from \$url\" \"uv tool install \$package --from git+\$url\"
    done"
}


##############################################################
# DEFAULT APPLICATION ASSOCIATION
##############################################################

# Set default application for a file type or protocol
# Usage: _set_default_app "bundle.id" "file.ext"
_set_default_app() {
    local bundle_id="$1"
    local file_ext="$2"
    
    run "Setting default for $file_ext" "duti -s $bundle_id $file_ext all"
}

# Set multiple default applications from associative array
# Usage: set_default_apps "App Name" "bundle.id" "array_name"
# Array format: ["Description"]="file.ext"
set_default_apps() {
    local app_name="$1"
    local bundle_id="$2"
    local array_name="$3"  # Name of the associative array
    
    # Print section header
    section "$app_name"
    
    # Iterate over the associative array
    eval "for description in \"\${!$array_name[@]}\"; do
        # Get the file extension
        file_ext=\$(eval \"echo \\\"\${$array_name[\$description]}\\\"\")
        
        # Set the default application
        _set_default_app \"\$bundle_id\" \"\$file_ext\"
    done"
}


##############################################################
# BREWFILE GENERATION
##############################################################

# Generate Brewfile with versions in comments
# This creates a snapshot of currently installed packages
generate_brewfile() {
    local output_dir="${1:-backup}"
    local output_file="$output_dir/Brewfile"
    
    section "Generating Brewfile"
    
    # Create output directory if it doesn't exist
    mkdir -p "$output_dir"
    
    # Generate header
    cat > "$output_file" << 'EOF'
# Brewfile
# Auto-generated on $(date +"%Y-%m-%d %H:%M:%S")
# 
# This file documents all Homebrew packages, casks, and taps installed on this system.
# Generated by: scripts/sh/darwin/_install_utilities.sh
#
# Usage:
#   brew bundle install --file=brew/Brewfile  # Install all packages
#   brew bundle check --file=brew/Brewfile    # Check what's missing
#   brew bundle cleanup --file=brew/Brewfile  # Remove packages not in file

EOF

    # Add actual date
    local current_date=$(date +"%Y-%m-%d %H:%M:%S")
    sed -i '' "s/\$(date +\"%Y-%m-%d %H:%M:%S\")/$current_date/" "$output_file"
    
    # Generate taps
    echo "" >> "$output_file"
    echo "##############################################################" >> "$output_file"
    echo "# TAPS" >> "$output_file"
    echo "##############################################################" >> "$output_file"
    echo "" >> "$output_file"
    brew tap | while read -r tap; do
        echo "tap \"$tap\"" >> "$output_file"
    done
    
    # Generate formulae with versions
    echo "" >> "$output_file"
    echo "##############################################################" >> "$output_file"
    echo "# FORMULAE" >> "$output_file"
    echo "##############################################################" >> "$output_file"
    echo "" >> "$output_file"
    
    brew list --formula | while read -r formula; do
        local version=$(brew list --versions "$formula" | awk '{print $2}')
        echo "brew \"$formula\"  # $version" >> "$output_file"
    done
    
    # Generate casks with versions
    echo "" >> "$output_file"
    echo "##############################################################" >> "$output_file"
    echo "# CASKS" >> "$output_file"
    echo "##############################################################" >> "$output_file"
    echo "" >> "$output_file"
    
    # Redirect stderr to suppress "not installed" errors for casks
    # that may appear in old Brewfiles but are no longer installed
    brew list --cask 2>/dev/null | while read -r cask; do
        local version=$(brew list --cask --versions "$cask" 2>/dev/null | awk '{print $2}')
        if [ -n "$version" ]; then
            echo "cask \"$cask\"  # $version" >> "$output_file"
        else
            # Fallback if version couldn't be determined
            echo "cask \"$cask\"" >> "$output_file"
        fi
    done
    
    # Generate VS Code extensions if code is installed
    if command -v code >/dev/null 2>&1; then
        echo "" >> "$output_file"
        echo "##############################################################" >> "$output_file"
        echo "# VSCODE EXTENSIONS" >> "$output_file"
        echo "##############################################################" >> "$output_file"
        echo "" >> "$output_file"
        code --list-extensions | while read -r ext; do
            local version=$(code --list-extensions --show-versions | grep "^$ext@" | cut -d@ -f2)
            echo "vscode \"$ext\"  # $version" >> "$output_file"
        done
    fi
    
    render_command_output "success" "Brewfile generated at $output_file" "generate_brewfile"
    info "Total: $(grep -c '^brew ' "$output_file") formulae, $(grep -c '^cask ' "$output_file") casks"
}

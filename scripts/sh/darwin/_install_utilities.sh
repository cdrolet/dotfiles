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
            local update_check=$(softwareupdate --list 2>/dev/null | grep "^\* Label: Command Line Tools")

            if [ -n "$update_check" ]; then
                # Extract the full label (e.g., "Command Line Tools for Xcode 26.0-26.0")
                local update_label=$(echo "$update_check" | sed 's/^\* Label: //')
                run "Updating Xcode Command Line Tools" "sudo softwareupdate --install '$update_label' --agree-to-license --no-scan"
            else
                render_command_output "skipped" "Xcode Command Line Tools already up to date" "$install_command"
            fi
        else
            render_command_output "skipped" "Xcode Command Line Tools already installed" "$install_command"
        fi
        return 0
    fi

    # Install Xcode CLI tools
    spin "$description" "$install_command"
}

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
            render_command_output "skipped" "Tap $tap already added" "brew tap $tap"
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
            render_command_output "skipped" "$package already installed" "$install_cmd"
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

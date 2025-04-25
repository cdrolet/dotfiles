#!/usr/bin/env bash


# Detect OS type and extract OS name before any number
detect_os() {
    # Get the lowercase OS type
    local os_type=$(uname -s | tr '[:upper:]' '[:lower:]')
    
    # Extract OS name before any number (darwin20.6.0 -> darwin)
    os_name=$(echo "$os_type" | sed -E 's/([a-z]+)[0-9.].*/\1/')
    
    echo "$os_name"
}

# Get the absolute path of the directory containing install.sh
SCRIPT_DIR="$( cd "$( dirname "$(dirname "${BASH_SOURCE[0]}")" )" && pwd )"

source "$SCRIPT_DIR/scripts/lib/_common.sh"

cd "$SCRIPT_DIR"

sub_header "Updating git repositories"

spin "pulling origin master" "git pull origin master"
spin "pulling submodules" "git submodule foreach git pull origin master"

# Check if project directory exists before creating it
if [ ! -d "$HOME/project" ]; then
    run "Create project directory" "mkdir -p $HOME/project"
else
    skipped "Project directory already exists"
fi

# Clone dotfiles if they don't already exist
if [ ! -d "$HOME/project/dotfiles" ]; then
    run "Clone dotfiles" "gh repo clone cdrolet/dotfiles $HOME/project/dotfiles"
else
    skipped "Dotfiles repository already cloned"
fi

force_update_git_submodules

sub_header "Syncing dotfiles"

# Source the dotsync script with the absolute path to the install directory
source "$SCRIPT_DIR/scripts/dotsync.sh"

sync_dotfiles $SCRIPT_DIR

# Get the OS name
OS_NAME=$(detect_os)
# Source OS-specific scripts if they exist
sub_header "OS-specific configuration for $OS_NAME"

# Check for OS-specific system script
if [ -f "$SCRIPT_DIR/$OS_NAME/setup.sh" ]; then
    info "Loading $OS_NAME setup"
    source "$SCRIPT_DIR/$OS_NAME/setup.sh"
else
    last_stage=true
    warning "No system configuration found for $OS_NAME"
fi


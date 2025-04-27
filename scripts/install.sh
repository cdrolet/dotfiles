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
INSTALL_SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
# Get the parent directory of INSTALL_SCRIPT_DIR
DOTFILES_ROOT="$(dirname "$INSTALL_SCRIPT_DIR")"

source "$INSTALL_SCRIPT_DIR/lib/_common.sh"

LAST_STAGE=false
# Get the OS name
OS_NAME=$(detect_os)

# Source OS-specific scripts if they exist
sub_header "OS-specific configuration for $OS_NAME"

# Check for OS-specific system script
if [ -f "$INSTALL_SCRIPT_DIR/$OS_NAME/install.sh" ]; then
    info "Loading $OS_NAME installer script"
    source "$INSTALL_SCRIPT_DIR/$OS_NAME/install.sh"
else
    last_stage=true
    warning "No system installer found for $OS_NAME"
fi

sub_header "Updating git repositories"

configure_git "cdrolet" "17693777+cdrolet@users.noreply.github.com" "nvim" "main"
# Only authenticate if not already authenticated
if ! check_github_auth; then
    run "Authenticate into github" "gh auth login"
fi

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

LAST_STAGE=true
# Source the dotsync script with the absolute path to the install directory
source "$INSTALL_SCRIPT_DIR/dotsync.sh"

sync_dotfiles "$DOTFILES_ROOT"


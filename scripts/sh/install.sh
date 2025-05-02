#!/usr/bin/env bash
########################################################################################
# File: install.sh
# Description: Main installation script for system, apps, and dotfiles
########################################################################################

###########################
# PREFLIGHT
###########################

# Function to parse command-line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --verbose=*)
                VERBOSE="${1#*=}"
                shift
                ;;
            --verbose|-v)
                VERBOSE=3  # Set to highest verbosity
                shift
                ;;
            --simulation|-s)
                IS_SIMULATION=true
                shift
                ;;
            --skip-confirmation|-y)
                SKIP_CONFIRMATION=true
                shift
                ;;
            --upgrade-outdated|-u)
                UPGRADE_OUTDATED=true
                shift
                ;;
            --environment=*)
                ENVIRONMENT="${1#*=}"
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [options]"
                echo ""
                echo "Options:"
                echo "  --verbose=LEVEL, -v       Set verbosity level (0-3, default: $DEFAULT_VERBOSE)"
                echo "  --simulation, -s          Run in simulation mode"
                echo "  --skip-confirmation, -y   Skip all confirmation prompts"
                echo "  --upgrade-outdated, -u    Upgrade outdated packages"
                echo "  --environment=ENV         Set environment (default: $DEFAULT_ENVIRONMENT)"
                echo "  --help, -h                Show this help message"
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                echo "Use --help for usage information."
                exit 1
                ;;
        esac
    done
}

# Get the absolute path of the directory containing install.sh
INSTALL_SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
# Get the parent directory of INSTALL_SCRIPT_DIR
DOTFILES_ROOT="$(dirname "$(dirname "$INSTALL_SCRIPT_DIR")")"

parse_arguments "$@"

source "$INSTALL_SCRIPT_DIR/lib/_common.sh"

DEFAULT_UPGRADE_OUTDATED=false
if [ -z "${UPGRADE_OUTDATED+x}" ]; then
    UPGRADE_OUTDATED=$DEFAULT_UPGRADE_OUTDATED
fi

LAST_STAGE=false

OS_NAME=$(detect_os)

full_os_name=$(uname -s)

print_setting "Upgrade outdated" "$UPGRADE_OUTDATED" "$DEFAULT_UPGRADE_OUTDATED"
print_setting "OS" "$OS_NAME" "$OS_NAME"

###########################
# INSTALLATION
###########################

# Check for OS-specific system script
if [ -f "$INSTALL_SCRIPT_DIR/$OS_NAME/install.sh" ]; then
    info "Loading ${YELLOW}$OS_NAME${WHITE} installer script..."
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

sync_dotfiles "$DOTFILES_ROOT"


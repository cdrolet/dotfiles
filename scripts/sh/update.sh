#!/usr/bin/env bash
########################################################################################
# File: update.sh
# Description: Update script for system, apps, dotfiles, and dependencies
########################################################################################

##############################################################
# PREFLIGHT
##############################################################

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
            --dry-run|-s)
                IS_DRY_RUN=true
                shift
                ;;
            --skip-confirmation|-y)
                SKIP_CONFIRMATION=true
                shift
                ;;
            --quiet|-q)
                VERBOSE=0
                shift
                ;;
            --environment=*)
                ENVIRONMENT="${1#*=}"
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [options]"
                echo ""
                echo "Update all system components, packages, and configurations"
                echo ""
                echo "Options:"
                echo "  --verbose=LEVEL, -v       Set verbosity level (0-3, default: $DEFAULT_VERBOSE)"
                echo "  --quiet, -q               Minimal output (verbosity level 0)"
                echo "  --dry-run, -s             Preview updates without applying them"
                echo "  --skip-confirmation, -y   Skip all confirmation prompts"
                echo "  --environment=ENV         Set environment (default: $DEFAULT_ENVIRONMENT)"
                echo "  --help, -h                Show this help message"
                echo ""
                echo "Examples:"
                echo "  $0                        # Interactive update with default verbosity"
                echo "  $0 -s                     # Dry-run to see what would be updated"
                echo "  $0 -y -q                  # Silent update without prompts"
                echo "  $0 -v                     # Verbose output"
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

# Get the absolute path of the directory containing update.sh
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
# Get the parent directory (dotfiles root)
DOTFILES_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

parse_arguments "$@"

source "$SCRIPT_DIR/lib/_bootstrap.sh"

LAST_STAGE=false

# Force upgrade mode for update script
UPGRADE_OUTDATED=true

OS_NAME=$(detect_os)

print_setting "Dry-run mode" "$IS_DRY_RUN" "$DEFAULT_DRY_RUN"
print_setting "Upgrade packages" "$UPGRADE_OUTDATED" "true"
print_setting "OS" "$OS_NAME" "$OS_NAME"

##############################################################
# UPDATE
##############################################################

# Check for OS-specific update script
if [ -f "$SCRIPT_DIR/$OS_NAME/update.sh" ]; then
    info "Loading ${YELLOW}$OS_NAME${WHITE} update script..."
    source "$SCRIPT_DIR/$OS_NAME/update.sh"
else
    warning "No OS-specific update script found for $OS_NAME"
    info "Performing generic updates only..."
fi

sub_header "Updating dotfiles repository"

spin "Pulling latest changes from origin/master" "git -C $DOTFILES_ROOT pull origin master"
spin "Updating git submodules" "git -C $DOTFILES_ROOT submodule update --remote --merge"

sub_header "Re-syncing dotfiles"

LAST_STAGE=true

sync_dotfiles "$DOTFILES_ROOT"

sub_header "Update Summary"

if [ "$IS_DRY_RUN" = true ]; then
    info "This was a dry-run. Run without ${YELLOW}--dry-run${WHITE} to apply updates."
else
    success "System update complete!"
fi

##############################################################
# END
##############################################################

unset SCRIPT_DIR
unset DOTFILES_ROOT

# Function to check if git is already configured and configure it if not
configure_git() {
    local name="$1"
    local email="$2"
    local editor="${3:-nvim}"
    local default_branch="${4:-main}"

    local config_needed=false

    # Check if git user name is configured
    if [ "$(git config --global user.name)" != "$name" ]; then
        config_needed=true
    fi

    # Check if git email is configured
    if [ "$(git config --global user.email)" != "$email" ]; then
        config_needed=true
    fi

    # Check if git editor is configured
    if [ "$(git config --global core.editor)" != "$editor" ]; then
        config_needed=true
    fi

    # Check if git default branch is configured
    if [ "$(git config --global init.defaultBranch)" != "$default_branch" ]; then
        config_needed=true
    fi

    # Configure git if needed
    if [ "$config_needed" = true ]; then
        run "Configuring git" "git config --global user.name '$name' && git config --global user.email '$email' && git config --global core.editor '$editor' && git config --global init.defaultBranch '$default_branch'"
    else
        skipped "Git already configured" "git config --global user.name '$name' && git config --global user.email '$email' && git config --global core.editor '$editor' && git config --global init.defaultBranch '$default_branch'"
    fi
}

force_update_git_submodules() {

    if [ "$(pwd)" != "$HOME/project/dotfiles" ]; then
        run "Change to dotfiles directory" "cd $HOME/project/dotfiles"
    else
        skipped "Already in dotfiles directory"
    fi

    run "Git pull" "git pull"
    # Force update by resetting local changes to submodules
    run "Resetting submodule changes" "git submodule foreach --recursive 'git reset --hard HEAD && git clean -fdx'"
    run "Force updating submodules" "git submodule update --init --recursive --force"

    return 0
}

# Function to check if already authenticated with GitHub
check_github_auth() {
    # Try to access GitHub API with current authentication or check if in dry-run mode
    if [ "$IS_DRY_RUN" = true ] || gh auth status &>/dev/null; then
        skipped "Already authenticated with GitHub" "gh auth status"
        return 0
    else
        return 1
    fi
}

# Function to authenticate with GitHub if not already authenticated
ensure_github_auth() {
    if check_github_auth; then
        return 0
    fi

    # Not authenticated, prompt user to login
    run "Authenticating with GitHub" "gh auth login --web"
}

# Function to clone or update a git repository
clone_or_update_repo() {
    local repo_url="$1"
    local target_dir="$2"
    local repo_name=$(basename "$repo_url" .git)

    if [ -d "$target_dir" ]; then
        # Repository exists, update it
        run "Updating $repo_name" "cd '$target_dir' && git pull"
    else
        # Repository doesn't exist, clone it
        local parent_dir=$(dirname "$target_dir")
        mkdir -p "$parent_dir"
        spin "Cloning $repo_name" "git clone '$repo_url' '$target_dir'"
    fi
}

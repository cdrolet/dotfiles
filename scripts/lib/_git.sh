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

# Function to update git submodules with option to force update
force_update_git_submodules() {
    run "Change to dotfiles directory" "cd $HOME/project/dotfiles"
    run "Git pull" "git pull"
    # Force update by resetting local changes to submodules
    run "Resetting submodule changes" "git submodule foreach --recursive 'git reset --hard HEAD && git clean -fdx'"
    run "Force updating submodules" "git submodule update --init --recursive --force"
    
    return 0
}
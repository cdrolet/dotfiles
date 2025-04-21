#!/usr/bin/env bash

########################################################################################
# File: apps.sh
# Description: Mac application installation and configuration
########################################################################################

SCRIPT_DIR="$( cd "$( dirname "$(dirname "${BASH_SOURCE[0]}")" )" && pwd )"
source "$SCRIPT_DIR/lib/_common.sh"
source "$SCRIPT_DIR/mac/_install_utilities.sh"

sub_header "Applications"

section "Brew"
install_xcode_cli_tools
install_brew
load_brew

declare -A fonts=(
    ["font-envy-code-r"]=true
    ["font-fira-code"]=true
    ["font-source-code-pro"]=true
)
brew_install_from_map "Fonts" "fonts"

#brew_install "iterm2" true

declare -A essential_tools=(
    ["coreutils"]=false
    ["wget"]=false
    ["curl"]=false
    ["btop"]=false
    ["neovim"]=false
    ["ripgrep"]=false
    ["fd"]=false
    ["fzf"]=false
    ["bat"]=false
    ["eza"]=false
    ["delta"]=false
    ["duti"]=false
    ["git"]=false
    ["gh"]=false
    ["gist"]=false
    ["kitty"]=true
)
brew_install_from_map "Essential Tools" "essential_tools"
run "Configuring git" " git config --global user.name 'cdrolet' && git config --global user.email '17693777+cdrolet@users.noreply.github.com' && git config --global core.editor 'nvim' && git config --global init.defaultBranch 'main'"

declare -A development_languages=(
    ["node"]=false
    ["python"]=false
    ["go"]=false
    ["rust"]=false
    ["ruby"]=false
)
brew_install_from_map "Development languages" "development_languages"

declare -A development_tools=(
    ["visual-studio-code"]=true
    ["cursor"]=true
    ["postman"]=true
)
brew_install_from_map "Development tools" "development_tools"

declare -a vscode_extensions=(
    "dbaeumer.vscode-eslint"
    "esbenp.prettier-vscode"
    "ms-python.python"
    "golang.go"
    "rust-lang.rust-analyzer"
    "redhat.vscode-yaml"
    "ms-azuretools.vscode-docker"
    "eamodio.gitlens"
)
install_code_extensions_from_array "VS Code Extensions" "vscode_extensions"

declare -A containers=(
    ["docker"]=true
    ["kubectl"]=false
    ["kubernetes-cli"]=false
    ["kubectx"]=false
)
brew_install_from_map "Containers" "containers"

declare -A browsers=(
    ["brave-browser"]=true
)
brew_install_from_map "Browsers" "browsers"

declare -A proton=(
    ["proton-drive"]=true
    ["protonmail-bridge"]=true
    ["protonvpn"]=true
    ["bitwarden"]=true
)
brew_install_from_map "Proton / Bitwarden" "proton"

declare -A music=(
    ["qobuz"]=true
)
brew_install_from_map "Music" "music"

declare -A productivity=(
    ["raycast"]=true
    ["boost-note"]=true
    ["obsidian"]=true
    ["rectangle"]=true
    ["koekeishiya/formulae:yabai"]=false
    ["felixkratz/formulae:sketchybar"]=false
)
brew_install_from_map "Productivity" "productivity"

section "Dotfiles"
# Check if project directory exists before creating it
if [ ! -d "$HOME/project" ]; then
    run "Create project directory" "mkdir -p $HOME/project"
fi

# Only authenticate if not already authenticated
if ! check_github_auth; then
    run "Authenticate into github" "gh auth login"
fi

# Clone dotfiles if they don't already exist
if [ ! -d "$HOME/project/dotfiles" ]; then
    run "Clone dotfiles" "gh repo clone cdrolet/dotfiles $HOME/project/dotfiles"
    run "Change to dotfiles directory" "cd $HOME/project/dotfiles"
    run "Update submodules" "git submodule update --init --recursive"
    run "Run dot sync" "./dotsync.sh"
else
    skipped "Dotfiles repository already cloned"
    run "Update dotfiles" "cd $HOME/project/dotfiles && git pull"
    run "Update submodules" "cd $HOME/project/dotfiles && git submodule update --init --recursive"
fi


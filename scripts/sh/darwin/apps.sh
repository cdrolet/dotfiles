#!/usr/bin/env bash

########################################################################################
# File: apps.sh
# Description: Mac application installation and configuration
########################################################################################

APP_SCRIPT_DIR="$( cd "$( dirname "$(dirname "${BASH_SOURCE[0]}")" )" && pwd )"
source "$APP_SCRIPT_DIR/lib/_common.sh"
source "$APP_SCRIPT_DIR/darwin/_install_utilities.sh"
source "$APP_SCRIPT_DIR/lib/_git.sh"

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
    ["kitty"]=true
)
brew_install_from_map "Essential Tools" "essential_tools"

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

declare -A mac_utilities=(
    ["appcleaner"]=true
)
brew_install_from_map "Various mac utilities" "mac_utilities"

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
    ["obsidian"]=true
    ["rectangle"]=true
    ["koekeishiya/formulae:yabai"]=false
    ["felixkratz/formulae:sketchybar"]=false
    ["felixkratz/formulae:borders"]=false
)
run "Start borders" "brew start borders"

brew_install_from_map "Productivity" "productivity"

declare -A git_tools=(  
    ["git"]=false
    ["gh"]=false
    ["gist"]=false
)
brew_install_from_map "Git tools" "git_tools"

unset APP_SCRIPT_DIR
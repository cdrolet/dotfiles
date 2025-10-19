#!/usr/bin/env bash

########################################################################################
# File: apps.sh
# Description: Mac application installation and configuration
########################################################################################

APP_SCRIPT_DIR="$( cd "$( dirname "$(dirname "${BASH_SOURCE[0]}")" )" && pwd )"
source "$APP_SCRIPT_DIR/lib/_bootstrap.sh"
source "$APP_SCRIPT_DIR/darwin/_install_utilities.sh"
source "$APP_SCRIPT_DIR/lib/_git.sh"

sub_header "Applications"

section "Core System Tools"
install_xcode_cli_tools
install_brew
load_brew
install "nix" "curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install"

declare -A git_tools=(  
    ["git"]=false
    ["gh"]=false
    ["gist"]=false
)
brew_install_from_map "Git tools" "git_tools"

section "GitHub Authentication"
ensure_github_auth

declare -A essential_tools=(
    ["coreutils"]=false
    ["wget"]=false
    ["curl"]=false
    ["btop"]=false
    ["helix"]=false
    ["ripgrep"]=false
    ["fd"]=false
    ["fzf"]=false
    ["bat"]=false
    ["eza"]=false
    ["delta"]=false
    ["duti"]=false
)
brew_install_from_map "Essential Tools" "essential_tools"

declare -A terminal_stuff=(
    ["ghostty"]=true
    ["starship"]=false
    ["neofetch"]=false

)
brew_install_from_map "Terminal stuff" "terminal_stuff"

declare -A development_languages=(
    ["node"]=false
    ["python"]=false
    ["go"]=false
    ["rust"]=false
    ["ruby"]=false
)
brew_install_from_map "Development languages" "development_languages"

declare -A development_IDEs=(
    ["visual-studio-code"]=true
    ["cursor"]=true
    ["zed"]=true
    ["postman"]=true
    ["obsidian"]=true
)
brew_install_from_map "Development IDEs" "development_IDEs"

declare -A development_tools=(
    ["utm"]=true
    ["uv"]=false
)
brew_install_from_map "Development tools" "development_tools"

declare -A python_packages=(
    ["specify-cli"]=https://github.com/github/spec-kit.git
)
uv_install_from_map "Python Packages" "python_packages"

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
code_extensions_install_from_array "VS Code Extensions" "vscode_extensions"

declare -A containers=(
    ["podman"]=false
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

declare -A graphic=(
    ["inkscape"]=true
)
brew_install_from_map "Graphic" "graphic"

declare -A teamwork=(
    ["slack"]=true
)
brew_install_from_map "Team work" "teamwork"

declare -A productivity=(
#  ["notion"]=true
    ["nikitabobko/tap:aerospace"]=true
    ["felixkratz/formulae:sketchybar"]=false
    ["felixkratz/formulae:borders"]=false
)
brew_install_from_map "Productivity" "productivity"

declare -A common_fonts=(
    ["font-envy-code-r"]=true
    ["font-fira-code"]=true
    ["font-source-code-pro"]=true
    ["font-noto-mono"]=true
    ["font-jetbrains-mono"]=true
)
brew_install_from_map "Common Fonts" "common_fonts"

declare -A professional_fonts=(
    ["d-fonts"]="install_fonts_from_repo git@github.com:cdrolet/d-fonts.git"
)
command_install_from_map "Professional Fonts" "professional_fonts"

unset APP_SCRIPT_DIR
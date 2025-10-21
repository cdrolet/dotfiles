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
    ["git"]="formula"
    ["gh"]="formula"
    ["gist"]="formula"
    ["lazygit"]="formula"
)
brew_install_from_map "Git tools" "git_tools"

section "GitHub Authentication"
ensure_github_auth

declare -A essential_tools=(
    ["coreutils"]="formula"
    ["curl"]="formula"
    ["btop"]="formula"
    ["procs"]="formula"
    ["helix"]="formula"
    ["ripgrep"]="formula"
    ["fd"]="formula"
    ["fzf"]="formula"
    ["bat"]="formula"
    ["eza"]="formula"
    ["delta"]="formula"
    ["duti"]="formula"
    ["xh"]="formula"
    ["zoxide"]="formula"
    ["atuin"]="formula"
    ["direnv"]="formula"
)
brew_install_from_map "Essential Tools" "essential_tools"

declare -A terminal_stuff=(
    ["ghostty"]="cask"
    ["starship"]="formula"
    ["macchina"]="formula"
)
brew_install_from_map "Terminal stuff" "terminal_stuff"

declare -A development_languages=(
    ["node"]="formula"
    ["python"]="formula"
    ["go"]="formula"
    ["rust"]="formula"
    ["ruby"]="formula"
)
brew_install_from_map "Development languages" "development_languages"

declare -A development_IDEs=(
    ["cursor"]="cask"
    ["zed"]="cask"
    ["bruno"]="cask"
    ["obsidian"]="cask"
)
brew_install_from_map "Development IDEs" "development_IDEs"

declare -A development_tools=(
    ["utm"]="cask"
    ["uv"]="formula"
    ["claude-code"]="cask"
    
)
brew_install_from_map "Development tools" "development_tools"

declare -A python_packages=(
    ["specify-cli"]=https://github.com/github/spec-kit.git
)
uv_install_from_map "Python Packages" "python_packages"

declare -A containers=(
    ["podman"]="formula"
    ["docker"]="formula"
    ["kubernetes-cli"]="formula"
    ["kubectx"]="formula"
)
brew_install_from_map "Containers" "containers"

declare -A browsers=(
    ["brave-browser"]="cask"
    ["zen"]="cask"
)
brew_install_from_map "Browsers" "browsers"

declare -A proton=(
    ["proton-drive"]="cask"
    ["protonmail-bridge"]="cask"
    ["protonvpn"]="cask"
    ["bitwarden"]="cask"
)
brew_install_from_map "Proton" "proton"

declare -A secrets=(
    ["bitwarden"]="cask"
    ["sops"]="formula"
    ["age"]="formula"\
)
brew_install_from_map "Secrets" "secrets"

declare -A music=(
    ["qobuz"]="cask"
)
brew_install_from_map "Music" "music"

declare -A torrent=(
    ["qbittorrent"]="cask"
)
brew_install_from_map "Torrent" "torrent"

declare -A design=(
    ["inkscape"]="cask"
    ["blender"]="cask"
    ["gimp"]="cask"
    ["figma"]="cask"
)
brew_install_from_map "Design" "graphic"

declare -A office=(
    ["slack"]="cask"
    ["zoom"]="cask"
)
brew_install_from_map "Office" "office"

declare -A social=(
    ["discord"]="cask"
    ["matrix"]="cask"
    ["signal"]="cask"
)
brew_install_from_map "Social" "social"

declare -A productivity=(
    ["nikitabobko/tap:aerospace"]="cask"
    ["felixkratz/formulae:sketchybar"]="formula"
    ["felixkratz/formulae:borders"]="formula"
)
brew_install_from_map "Productivity" "productivity"

declare -A common_fonts=(
    ["font-envy-code-r"]="cask"
    ["font-fira-code"]="cask"
    ["font-source-code-pro"]="cask"
    ["font-noto-mono"]="cask"
    ["font-jetbrains-mono"]="cask"
)
brew_install_from_map "Common Fonts" "common_fonts"

declare -A professional_fonts=(
    ["d-fonts"]="install_fonts_from_repo git@github.com:cdrolet/d-fonts.git"
)
command_install_from_map "Professional Fonts" "professional_fonts"

unset APP_SCRIPT_DIR

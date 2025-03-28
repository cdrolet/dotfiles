
#!/bin/bash

# Source common.sh from the same directory as this script
source "$(dirname "$0")/common.sh"

print_header "Install Apps"

print_section "Brew"
run_command "Install Xcode command line tools" "xcode-select --install"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
run_command "Load brew" "eval '$(/opt/homebrew/bin/brew shellenv)'"

print_section "Fonts"
 run_command "Installing font 'envy code r'" "brew install --cask font-envy-code-r"
 run_command "Installing font 'fira code'" "brew install --cask font-fira-code"
 run_command "Installing font 'source code pro'" "brew install --cask font-source-code-pro"

print_section "Dev tools"
run_command "Installing python" "brew install python"
run_command "Installing coreutils" "brew install coreutils"
run_command "Installing kubectl" "brew install kubectl"
run_command "Installing cursor" "brew install cursor"
run_command "Installing git" "brew install git"
run_command "Installing gh" "brew install gh"

print_section "Terminals"
run_command "Installing warp" "brew install warp"
run_command "Installing iterm2" "brew install iterm2"

print_section "Dotfiles"
run_command "Create project directory" "cd $HOME && mkdir project && cd project"
run_command "Authenticate into github" "gh auth login"
run_command "Clone dotfiles" "gh repo clone cdrolet/dotfiles"
run_command "Change to dotfiles directory" "cd dotfiles"
run_command "Update submodules" "git submodule update --init --recursive"
run_command "Run dot sync" "./dotsync.sh"

print_section "Browsing"
run_command "Install bitwarden" "brew install --cask bitwarden"
run_command "Install brave-browser" "brew install --cask brave-browser"

print_section "Proton"
run_command "Install proton" "brew install --cask proton-drive"
run_command "Install protonmail" "brew install --cask protonmail-bridge"
run_command "Install protonvpn" "brew install --cask protonvpn"

print_section "Others"
run_command "Install qobuz" "brew install --cask qobuz"


check_errors
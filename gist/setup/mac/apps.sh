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

print_section "Terminals"
run_command "Installing iterm2" "brew install iterm2"
run_command "Installing warp" "brew install warp"
run_command "Installing tmux" "brew install tmux"

print_section "Essential Tools"
run_command "Installing coreutils" "brew install coreutils"
run_command "Installing wget" "brew install wget"
run_command "Installing curl" "brew install curl"
run_command "Installing btop" "brew install btop"
run_command "Installing neovim" "brew install neovim"
run_command "Installing ripgrep" "brew install ripgrep"
run_command "Installing fd" "brew install fd"
run_command "Installing fzf" "brew install fzf"
run_command "Installing bat" "brew install bat"
run_command "Installing eza" "brew install eza"
run_command "Installing delta" "brew install delta"

print_section "Development languages"
run_command "Installing node" "brew install node"
run_command "Installing python" "brew install python"
run_command "Installing go" "brew install go"
run_command "Installing rust" "brew install rust"
run_command "Installing ruby" "brew install ruby"

print_section "Development tools"
run_command "Installing VS Code" "brew install --cask visual-studio-code"
run_command "Installing ESLint extension" "sudo code --install-extension dbaeumer.vscode-eslint"
run_command "Installing Prettier extension" "sudo code --install-extension esbenp.prettier-vscode"
run_command "Installing Python extension" "sudo code --install-extension ms-python.python"
run_command "Installing Go extension" "sudo code --install-extension golang.go"
run_command "Installing Rust Analyzer extension" "sudo code --install-extension rust-lang.rust-analyzer"
run_command "Installing YAML extension" "sudo code --install-extension redhat.vscode-yaml"
run_command "Installing Docker extension" "sudo code --install-extension ms-azuretools.vscode-docker"
run_command "Installing GitLens extension" "sudo code --install-extension eamodio.gitlens"

run_command "Installing cursor" "brew install --cask cursor"
run_command "Creating cursor CLI link" "sudo ln -sf '/Applications/Cursor.app/Contents/MacOS/Cursor' /usr/local/bin/cursor"
run_command "Installing postman" "brew install --cask postman"

print_section "Git"
run_command "Installing git" "brew install git"
run_command "Installing gh" "brew install gh"
run_command "Installing gist" "brew install gist"
git config --global user.name "cdrolet"
git config --global user.email "17693777+cdrolet@users.noreply.github.com"
git config --global core.editor "nvim"
#git config --global init.defaultBranch main

print_section "Containers"
run_command "Installing docker" "brew install --cask docker"
run_command "Installing kubectl" "brew install kubectl"
run_command "Installing kubernetes-cli" "brew install kubernetes-cli"
run_command "Installing kubectx" "brew install kubectx"

print_section "Browsing"
run_command "Installing brave-browser" "brew install --cask brave-browser"

print_section "Proton / Bitwarden"
run_command "Installing proton drive" "brew install --cask proton-drive"
run_command "Installing proton mailbridge" "brew install --cask protonmail-bridge"
run_command "Installing proton vpn" "brew install --cask protonvpn"
run_command "Installing bitwarden" "brew install --cask bitwarden"

print_section "Music"
run_command "Installing qobuz" "brew install --cask qobuz"

print_section "Productivity"
run_command "Installing alfred" "brew install --cask alfred"
run_command "Installing obsidian" "brew install --cask obsidian"
run_command "Installing rectangle" "brew install --cask rectangle"

print_section "Dotfiles"
run_command "Create project directory" "cd $HOME && mkdir project && cd project"
run_command "Authenticate into github" "gh auth login"
run_command "Clone dotfiles" "gh repo clone cdrolet/dotfiles"
run_command "Change to dotfiles directory" "cd dotfiles"
run_command "Update submodules" "git submodule update --init --recursive"
run_command "Run dot sync" "./dotsync.sh"

check_errors
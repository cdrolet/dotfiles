# Mac Setup Guide

## Initial Setup

### Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install Essential Tools
```bash
# Install basic tools
brew install git
brew install wget
brew install curl
brew install tree
brew install htop
brew install btop
brew install tmux
brew install vim
brew install neovim
brew install ripgrep
brew install fd
brew install fzf
brew install bat
brew install exa
brew install delta
```

### Install Development Tools
```bash
# Install development tools
brew install node
brew install python
brew install go
brew install rust
brew install ruby
```

### Install GUI Applications
```bash
# Install GUI apps
brew install --cask visual-studio-code
brew install --cask iterm2
brew install --cask alfred
brew install --cask rectangle
brew install --cask docker
brew install --cask postman
brew install --cask firefox
brew install --cask google-chrome
```

## Shell Configuration

### Install Oh My Zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install Powerlevel10k Theme
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### Install Zsh Plugins
```bash
# Install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

## Git Configuration
```bash
# Set up Git configuration
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global core.editor "vim"
git config --global init.defaultBranch main
```

## VSCode Extensions
```bash
# Install essential VSCode extensions
code --install-extension vscodevim.vim
code --install-extension dracula-theme.theme-dracula
code --install-extension esbenp.prettier-vscode
code --install-extension dbaeumer.vscode-eslint
code --install-extension ms-python.python
code --install-extension golang.go
code --install-extension rust-lang.rust
code --install-extension eamodio.gitlens
```

## System Preferences

### Dock Settings
```bash
# Set dock to auto-hide
defaults write com.apple.dock autohide -bool true

# Set dock animation speed
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Set dock magnification
defaults write com.apple.dock magnification -bool true
```

### Finder Settings
```bash
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true
```

### Keyboard Settings
```bash
# Enable key repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# Set key repeat rate
defaults write -g KeyRepeat -int 2

# Set initial key repeat delay
defaults write -g InitialKeyRepeat -int 15
```

## Backup and Restore

### Backup
```bash
# Backup dotfiles
cp -r ~/.zshrc ~/dotfiles/zsh/
cp -r ~/.vimrc ~/dotfiles/vim/
cp -r ~/.gitconfig ~/dotfiles/git/
cp -r ~/.tmux.conf ~/dotfiles/tmux/
```

### Restore
```bash
# Restore dotfiles
ln -s ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/dotfiles/vim/.vimrc ~/.vimrc
ln -s ~/dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
```

## Additional Tips

1. **Security**
   - Enable FileVault
   - Set up Time Machine backup
   - Enable Find My Mac

2. **Performance**
   - Disable Spotlight indexing for development directories
   - Clean up system storage regularly
   - Monitor system resources with Activity Monitor

3. **Development**
   - Set up SSH keys for GitHub
   - Configure GPG signing for Git commits
   - Set up development certificates

4. **Productivity**
   - Configure Alfred workflows
   - Set up Rectangle window management
   - Customize keyboard shortcuts

## Troubleshooting

### Common Issues
1. **Homebrew permissions**
   ```bash
   sudo chown -R $(whoami) /usr/local/bin /usr/local/lib
   ```

2. **Reset Dock**
   ```bash
   killall Dock
   ```

3. **Reset Finder**
   ```bash
   killall Finder
   ```

4. **Clear DNS Cache**
   ```bash
   sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
   ``` 
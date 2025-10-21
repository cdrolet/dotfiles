# Troubleshooting Guide

Common issues and solutions for your dotfiles setup.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Shell & Terminal Issues](#shell--terminal-issues)
- [Dotfile Sync Issues](#dotfile-sync-issues)
- [Tool-Specific Issues](#tool-specific-issues)
- [macOS-Specific Issues](#macos-specific-issues)
- [Performance Issues](#performance-issues)

## Installation Issues

### Command Line Tools Installation Fails

**Symptoms:**
- `xcode-select --install` hangs or fails
- "Can't install the software" error

**Solutions:**
```bash
# Remove existing installation
sudo rm -rf /Library/Developer/CommandLineTools

# Reinstall
xcode-select --install

# Or install full Xcode from App Store
```

### Homebrew Installation Fails

**Symptoms:**
- `brew` command not found
- Permission errors during installation

**Solutions:**
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Fix permissions (Apple Silicon)
sudo chown -R $(whoami) /opt/homebrew

# Fix permissions (Intel)
sudo chown -R $(whoami) /usr/local/Homebrew

# Add to PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

### Git Clone Fails

**Symptoms:**
- `Permission denied (publickey)`
- `Repository not found`

**Solutions:**
```bash
# Check SSH key
ssh -T git@github.com

# Generate new SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Add to GitHub
cat ~/.ssh/id_ed25519.pub
# Copy and add to GitHub → Settings → SSH Keys

# Or use HTTPS instead
git clone https://github.com/cdrolet/dotfiles.git
```

### Installation Hangs

**Symptoms:**
- Script stops responding
- No output for extended period

**Solutions:**
```bash
# Kill the process
Ctrl+C

# Run with verbose output
./scripts/sh/install.sh --verbose=3

# Check Homebrew
brew doctor

# Check internet connection
ping -c 3 github.com
```

## Shell & Terminal Issues

### "Command not found" After Installation

**Symptoms:**
- `zoxide: command not found`
- `atuin: command not found`
- Tools installed but not available

**Solutions:**
```bash
# Reload shell configuration
source ~/.zshrc

# Or restart terminal
exec zsh

# Check Homebrew PATH
echo $PATH | grep homebrew

# Manually add Homebrew to PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Verify installation
brew list | grep zoxide
which zoxide
```

### Zsh Not Loading Correctly

**Symptoms:**
- Plain prompt (no Starship)
- No syntax highlighting
- Missing aliases

**Solutions:**
```bash
# Check if .zshrc is symlinked
ls -la ~/.zshrc

# Re-sync dotfiles
cd ~/project/dotfiles
./scripts/sh/dotsync.sh

# Check for syntax errors
zsh -n ~/.zshrc

# Test in clean environment
zsh -f
source ~/.zshrc
```

### Shell Startup Errors

**Symptoms:**
- Error messages on terminal open
- Modules failing to load

**Solutions:**
```bash
# Check which module is failing
zsh -x 2>&1 | head -50

# Temporarily disable problematic module
mv ~/project/dotfiles/zsh/modules/XX.problem ~/project/dotfiles/zsh/modules/XX.problem.disabled

# Fix the module
hx ~/project/dotfiles/zsh/modules/XX.problem/file.zsh

# Re-enable
mv ~/project/dotfiles/zsh/modules/XX.problem.disabled ~/project/dotfiles/zsh/modules/XX.problem
```

### Slow Shell Startup

**Symptoms:**
- Terminal takes > 1 second to open
- Noticeable delay before prompt appears

**Solutions:**
```bash
# Profile startup time
time zsh -i -c exit

# Enable profiling
# In .zshrc, set: typeset -i record_metrics=1
# Restart shell to see timing

# Common culprits:
# 1. Slow completion initialization
# 2. Too many plugins
# 3. Heavy processes in startup

# Quick fix: Lazy load completions
# Edit zsh/modules/40.completion/completion.zsh
```

## Dotfile Sync Issues

### Symlink Creation Fails

**Symptoms:**
- `dotsync.sh` reports errors
- Files not symlinked
- "File exists" errors

**Solutions:**
```bash
# Backup existing files
mkdir -p ~/dotfiles-backup
cp ~/.zshrc ~/dotfiles-backup/
cp ~/.gitconfig ~/dotfiles-backup/

# Remove conflicting files
rm ~/.zshrc
rm ~/.gitconfig

# Re-run sync
./scripts/sh/dotsync.sh

# Check symlinks
ls -la ~ | grep '\->'
```

### Broken Symlinks

**Symptoms:**
- `ls -la ~` shows broken links (red)
- Files point to non-existent locations

**Solutions:**
```bash
# Find broken symlinks
find ~ -maxdepth 1 -type l ! -exec test -e {} \; -print

# Remove broken symlinks
find ~ -maxdepth 1 -type l ! -exec test -e {} \; -delete

# Re-sync
./scripts/sh/dotsync.sh
```

### Changes Not Applied

**Symptoms:**
- Edited dotfile but changes not visible
- Configuration not taking effect

**Solutions:**
```bash
# Check if file is symlinked
ls -la ~/.zshrc
# Should show: .zshrc -> /Users/you/project/dotfiles/.zshrc

# If not symlinked, sync again
./scripts/sh/dotsync.sh

# Reload configuration
source ~/.zshrc

# For other configs, restart the application
```

## Tool-Specific Issues

### Atuin Issues

**Problem**: `Error: could not load client settings`

**Solution:**
```bash
# Check config
bat ~/.config/atuin/config.toml

# Remove problematic lines
# Common issue: empty keys = []

# Reimport history
atuin import zsh

# Reset if needed
rm -rf ~/.local/share/atuin
atuin import zsh
```

**Problem**: Ctrl+R not working

**Solution:**
```bash
# Check Atuin is loaded
which atuin

# Re-initialize
atuin init zsh
source ~/.zshrc

# Check keybinding
bindkey | grep '\^R'
```

### Zoxide Issues

**Problem**: `z` command not working

**Solution:**
```bash
# Check zoxide is installed
which zoxide

# Re-initialize
eval "$(zoxide init zsh)"

# Add some directories manually
zoxide add ~/project/dotfiles
zoxide add ~/.config

# Test
z dot
```

**Problem**: Wrong directory suggested

**Solution:**
```bash
# Remove from database
zoxide remove /wrong/path

# Force jump to correct directory
cd /correct/path
# zoxide will learn over time
```

### Helix Issues

**Problem**: LSP not working

**Solution:**
```bash
# Check LSP is installed
# For TypeScript:
npm install -g typescript-language-server

# Check Helix config
hx --health typescript

# Install missing LSPs
# Helix will show which are missing
```

**Problem**: Theme not loading

**Solution:**
```bash
# Check theme exists
ls ~/.config/helix/themes/
hx -c 'theme nord'  # Test theme

# Reset config
rm ~/.config/helix/config.toml
hx  # Will create default
```

### Lazygit Issues

**Problem**: Lazygit not opening

**Solution:**
```bash
# Check installation
which lazygit
brew list | grep lazygit

# Reinstall if needed
brew reinstall lazygit

# Check git repository
cd ~/project/dotfiles
git status  # Should work
lazygit
```

**Problem**: Theme/colors wrong

**Solution:**
```bash
# Check config
bat ~/.config/lazygit/config.yml

# Reset to default
mv ~/.config/lazygit/config.yml ~/.config/lazygit/config.yml.bak
lazygit  # Will create default
```

## macOS-Specific Issues

### System Defaults Not Applied

**Symptoms:**
- Dock settings unchanged
- Finder preferences not set

**Solutions:**
```bash
# Re-run system configuration
./scripts/sh/darwin/system.sh

# Restart affected services
killall Dock
killall Finder
killall SystemUIServer

# Some changes require logout
# macOS Menu → Log Out

# Some require restart
sudo shutdown -r now
```

### AeroSpace Not Working

**Symptoms:**
- Windows not tiling
- Keybindings not responding

**Solutions:**
```bash
# Check if running
ps aux | grep AeroSpace

# Grant accessibility permissions
# System Settings → Privacy & Security → Accessibility
# Add AeroSpace

# Restart AeroSpace
killall AeroSpace
open -a AeroSpace
```

### SketchyBar Not Showing

**Symptoms:**
- Status bar not visible
- Default macOS menu bar showing

**Solutions:**
```bash
# Check if running
ps aux | grep sketchybar

# Restart
brew services restart sketchybar

# Check logs
tail -f /opt/homebrew/var/log/sketchybar.log

# Grant permissions
# System Settings → Privacy & Security → Accessibility
```

### Permission Errors

**Symptoms:**
- `Operation not permitted`
- Can't modify system files

**Solutions:**
```bash
# Grant Full Disk Access
# System Settings → Privacy & Security → Full Disk Access
# Add Terminal.app or Ghostty

# For Homebrew directories
sudo chown -R $(whoami) /opt/homebrew

# For local directories
sudo chown -R $(whoami) ~/.local
```

## Performance Issues

### Slow Shell Startup

**Diagnosis:**
```bash
# Time startup
time zsh -i -c exit

# Profile modules
zsh -x 2>&1 | ts -i "%.s"
```

**Solutions:**
```bash
# 1. Lazy load completions
# In completion.zsh:
autoload -Uz compinit
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null) ]; then
  compinit
else
  compinit -C
fi

# 2. Disable heavy plugins temporarily
mv zsh/modules/66.suggestions zsh/modules/66.suggestions.disabled

# 3. Use async loading
# (Advanced - requires zinit or similar)
```

### Slow Command Execution

**Symptoms:**
- Long delay before command runs
- Completion takes forever

**Solutions:**
```bash
# Clear completion cache
rm -f ~/.zcompdump*
compinit

# Check for slow functions
zsh -xv 2>&1 | grep -i slow

# Disable problematic modules
```

### High CPU Usage

**Symptoms:**
- Terminal using high CPU
- Fan spinning up

**Solutions:**
```bash
# Check what's using CPU
top -o cpu

# Check for runaway processes
ps aux | grep -v grep | sort -k3 -r | head -10

# Restart shell
exec zsh

# Check for infinite loops in configs
grep -r "while\|for" ~/project/dotfiles/zsh/modules/
```

## Getting Help

### Gather Debug Information

```bash
# System info
sw_vers
uname -a

# Shell info
echo $SHELL
zsh --version

# Homebrew info
brew --version
brew doctor

# Tool versions
zoxide --version
atuin --version
rg --version

# Check PATH
echo $PATH

# Check loaded modules
ls ~/project/dotfiles/zsh/modules/
```

### Enable Verbose Mode

```bash
# Run scripts with verbose output
./scripts/sh/install.sh --verbose=3
./scripts/sh/update.sh --verbose=3

# Shell debug mode
zsh -x
```

### Check Logs

```bash
# Homebrew logs
brew log <package>

# macOS system logs
log show --predicate 'process == "your-app"' --last 1h

# Shell startup log
zsh -x > /tmp/zsh-startup.log 2>&1
```

### Report Issues

If you can't resolve an issue:

1. **Gather information** (see above)
2. **Create minimal reproduction**
3. **Check existing issues** on GitHub
4. **Open new issue** with:
   - System info
   - Steps to reproduce
   - Error messages
   - What you've tried

## Quick Fixes

### Nuclear Option: Fresh Start

```bash
# Backup current setup
cp -r ~/project/dotfiles ~/project/dotfiles.backup

# Remove symlinks
rm ~/.zshrc ~/.gitconfig ~/.config/atuin ~/.config/helix

# Fresh clone
rm -rf ~/project/dotfiles
git clone https://github.com/cdrolet/dotfiles.git ~/project/dotfiles

# Reinstall
cd ~/project/dotfiles
./scripts/sh/install.sh
```

### Reset Single Component

```bash
# Reset Zsh
rm ~/.zshrc ~/.zcompdump*
./scripts/sh/dotsync.sh
source ~/.zshrc

# Reset Homebrew
brew doctor
brew update
brew upgrade

# Reset tool config
rm -rf ~/.config/atuin
rm -rf ~/.config/helix
./scripts/sh/dotsync.sh
```

## Still Having Issues?

- Check [Installation Guide](INSTALLATION.md) for setup steps
- Review [Usage Guide](USAGE.md) for correct usage
- See [Configuration Guide](CONFIGURATION.md) for customization
- Ask in [GitHub Discussions](https://github.com/cdrolet/dotfiles/discussions)
- Open [GitHub Issue](https://github.com/cdrolet/dotfiles/issues)

---

**Remember**: Most issues are solved by reloading the shell or re-syncing dotfiles!


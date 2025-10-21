# Installation Guide

Complete guide for installing and setting up your dotfiles.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Fresh macOS Installation](#fresh-macos-installation)
- [Standard Installation](#standard-installation)
- [Installation Options](#installation-options)
- [Post-Installation](#post-installation)
- [Verification](#verification)

## Prerequisites

### System Requirements
- **Operating System**: macOS 13 (Ventura) or later
- **Disk Space**: ~5GB free space
- **Memory**: 8GB RAM minimum (16GB recommended)
- **Internet**: Active connection required

### Before You Begin

1. **Backup Your Existing Dotfiles**
   ```bash
   mkdir -p ~/dotfiles-backup
   cp ~/.zshrc ~/.gitconfig ~/dotfiles-backup/
   ```

2. **Install Command Line Tools** (if not already installed)
   ```bash
   xcode-select --install
   ```

3. **Ensure You Have Git Access**
   ```bash
   git --version
   ```

## Fresh macOS Installation

If you're setting up a new Mac, you have two options:

### Option 1: One-Liner Install (Easiest)

```bash
# Single command installation
curl -fsSL https://raw.githubusercontent.com/cdrolet/dotfiles/main/install | bash
```

This will automatically:
- Check for and install Command Line Tools if needed
- Clone the repository to `~/project/dotfiles`
- Run the full installation script
- Pass any additional flags (e.g., `bash -s -- --verbose=2`)

**With options:**
```bash
# Verbose output
curl -fsSL https://raw.githubusercontent.com/cdrolet/dotfiles/main/install | bash -s -- --verbose=2

# Dry run
curl -fsSL https://raw.githubusercontent.com/cdrolet/dotfiles/main/install | bash -s -- --dry-run
```

### Option 2: Manual Install

If you prefer more control:

#### 1. Initial System Setup

```bash
# Update macOS first
sudo softwareupdate --install --all

# Install Command Line Tools
xcode-select --install
```

#### 2. Clone Repository

```bash
# Create project directory
mkdir -p ~/project

# Clone dotfiles
git clone https://github.com/cdrolet/dotfiles.git ~/project/dotfiles
cd ~/project/dotfiles
```

#### 3. Run Installation

```bash
# Preview what will be installed (recommended first time)
./scripts/sh/install.sh --dry-run --verbose=2

# If preview looks good, run actual installation
./scripts/sh/install.sh
```

The installer will:
1. ✅ Install Homebrew package manager
2. ✅ Install Command Line Tools (if needed)
3. ✅ Install development tools and applications
4. ✅ Configure macOS system defaults
5. ✅ Set up Git configuration
6. ✅ Create dotfile symlinks
7. ✅ Generate Brewfile backup

### 4. Restart Shell

```bash
# Close and reopen your terminal, or:
exec zsh
```

## Standard Installation

For an existing Mac with some tools already installed:

### 1. Clone Repository

```bash
cd ~/project
git clone https://github.com/cdrolet/dotfiles.git
cd dotfiles
```

### 2. Review What Will Be Installed

```bash
# Dry run to see changes
./scripts/sh/install.sh --dry-run

# Check for conflicts
ls -la ~ | grep -E '\.zshrc|\.gitconfig'
```

### 3. Run Installation

```bash
./scripts/sh/install.sh
```

### 4. Reload Configuration

```bash
source ~/.zshrc
```

## Installation Options

### Command-Line Flags

| Flag | Description |
|------|-------------|
| `--dry-run` | Preview changes without applying them |
| `--skip-confirmation` | Non-interactive mode (auto-confirm prompts) |
| `--verbose=N` | Verbosity level (0=quiet, 1=normal, 2=detailed, 3=debug) |
| `--quiet` | Minimal output (errors only) |
| `--upgrade-outdated` | Update existing packages (use `update.sh` instead) |

### Usage Examples

```bash
# Preview installation
./scripts/sh/install.sh --dry-run

# Verbose installation with detailed logs
./scripts/sh/install.sh --verbose=3

# Automated installation (CI/CD)
./scripts/sh/install.sh --skip-confirmation --quiet

# Update existing installation
./scripts/sh/update.sh
```

### Selective Installation

If you only want specific parts:

```bash
# Only sync dotfiles (no installation)
./scripts/sh/dotsync.sh

# Only install Homebrew packages
./scripts/sh/darwin/apps.sh

# Only configure macOS defaults
./scripts/sh/darwin/system.sh

# Only set default applications
./scripts/sh/darwin/set-defaults.sh
```

## Post-Installation

### 1. Verify Installation

```bash
# Check Homebrew
brew --version

# Check modern tools
zoxide --version
atuin --version
rg --version
fd --version
bat --version

# Check shell
echo $SHELL  # Should be /bin/zsh
```

### 2. Configure Personal Settings

```bash
# Edit Git user information
hx ~/project/dotfiles/git/.gitconfig
# Update user.name and user.email

# Re-sync dotfiles
./scripts/sh/dotsync.sh
```

### 3. Set Up Optional Tools

#### Atuin (Shell History Sync)
```bash
# Register for sync (optional)
atuin register -u <your-email> -e <your-email>
atuin login -u <your-email>
atuin sync
```

#### GitHub CLI
```bash
# Authenticate with GitHub
gh auth login
```

#### SDKMAN (Java/Kotlin/Scala)
```bash
# Install SDKMAN (if using Java)
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Install Java
sdk install java
```

### 4. macOS System Preferences

Some settings require manual configuration:

1. **System Settings → Desktop & Dock**
   - Set default web browser to Zen Browser

2. **System Settings → Privacy & Security → Accessibility**
   - Grant permissions to:
     - AeroSpace (window management)
     - SketchyBar (status bar)
     - Borders (window borders)

3. **Restart macOS** (recommended for all settings to take effect)

## Verification

### Check Symlinks

```bash
# Verify dotfiles are symlinked
ls -la ~ | grep '\->'

# Should see lines like:
# .zshrc -> /Users/you/project/dotfiles/.zshrc
# .gitconfig -> /Users/you/project/dotfiles/git/.gitconfig
```

### Test Commands

```bash
# Test zoxide
z dotfiles
pwd  # Should be in dotfiles directory

# Test atuin
atuin search git
history | head

# Test modern tools
rg "function" ~/project/dotfiles
fd ".zsh" ~/project/dotfiles
bat ~/.zshrc

# Test editor
hx --version
```

### Check Homebrew Installation

```bash
# List installed formulae
brew list --formula

# List installed casks
brew list --cask

# Verify specific tools
brew list | grep -E "ripgrep|fd|bat|eza|zoxide|atuin"
```

### Verify Brewfile Backup

```bash
# Check Brewfile was generated
cat ~/project/dotfiles/backup/Brewfile

# Should contain versioned packages
```

## Troubleshooting Installation

### Issue: "Command not found" after installation

**Solution:**
```bash
# Reload shell configuration
source ~/.zshrc

# Or restart terminal
exec zsh
```

### Issue: Homebrew not found

**Solution:**
```bash
# Check Homebrew installation
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

### Issue: Permission denied

**Solution:**
```bash
# Fix Homebrew permissions
sudo chown -R $(whoami) /opt/homebrew

# Or for Intel Macs:
sudo chown -R $(whoami) /usr/local/Homebrew
```

### Issue: Symlink conflicts

**Solution:**
```bash
# Backup existing files
mkdir -p ~/dotfiles-conflict-backup
mv ~/.zshrc ~/dotfiles-conflict-backup/
mv ~/.gitconfig ~/dotfiles-conflict-backup/

# Re-run sync
./scripts/sh/dotsync.sh
```

### Issue: Installation hangs

**Solution:**
```bash
# Kill the process (Ctrl+C)
# Re-run with verbose output to see where it hangs
./scripts/sh/install.sh --verbose=3

# Check Homebrew
brew doctor
```

## Uninstallation

If you need to remove the dotfiles:

### 1. Remove Symlinks

```bash
# Manually remove symlinks
rm ~/.zshrc
rm ~/.gitconfig
# ... remove other symlinks

# Or restore original files
cp ~/dotfiles-backup/.zshrc ~/.zshrc
```

### 2. Uninstall Homebrew (optional)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

### 3. Remove Repository

```bash
rm -rf ~/project/dotfiles
```

## Next Steps

After successful installation:

1. Read [Usage Guide](USAGE.md) for daily workflows
2. Explore [Tools Reference](TOOLS.md) to learn about installed tools
3. Customize your setup with [Configuration Guide](CONFIGURATION.md)
4. Set up regular updates with [Update Guide](USAGE.md#updating)

## Getting Help

- **Documentation**: Check [docs/](.) for detailed guides
- **Issues**: Report problems on [GitHub Issues](https://github.com/cdrolet/dotfiles/issues)
- **Troubleshooting**: See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

**Happy coding!** 🚀


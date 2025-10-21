# Configuration Guide

How to customize your dotfiles setup.

## Table of Contents

- [Adding Dotfiles](#adding-dotfiles)
- [Modifying Zsh Configuration](#modifying-zsh-configuration)
- [Adding Homebrew Packages](#adding-homebrew-packages)
- [Customizing macOS Defaults](#customizing-macos-defaults)
- [Git Configuration](#git-configuration)
- [Application Configurations](#application-configurations)

## Adding Dotfiles

### Add New Dotfile

```bash
# 1. Create file in dotfiles repository (must start with .)
cd ~/project/dotfiles
echo "export MY_VAR=value" > .myconfig

# 2. Sync to home directory
./scripts/sh/dotsync.sh

# 3. Verify symlink
ls -la ~/.myconfig  # Should show -> ~/project/dotfiles/.myconfig
```

### Exclude from Syncing

Add to `.dotignore`:

```bash
echo ".private" >> ~/project/dotfiles/.dotignore
echo ".work-config" >> ~/project/dotfiles/.dotignore
```

## Modifying Zsh Configuration

### Add New Zsh Module

```bash
# 1. Create numbered directory
mkdir -p ~/project/dotfiles/zsh/modules/75.custom

# 2. Add .zsh files
cat > ~/project/dotfiles/zsh/modules/75.custom/my-aliases.zsh << 'EOF'
# My custom aliases
alias myalias='echo "Hello!"'
EOF

# 3. Reload shell
source ~/.zshrc
```

### Module Loading Order

Modules load numerically:
- `10.environment/` - Environment variables, PATH
- `40.completion/` - Completion system
- `50.tools/` - Tool-specific configs
- `60.syntax/` - Syntax highlighting
- `62.history/` - History configuration
- `64.editor/` - Editor bindings
- `66.suggestions/` - Auto-suggestions
- `75.custom/` - Your custom modules
- `80.os/` - OS-specific settings

### Add Custom Aliases

Edit `zsh/modules/50.tools/` or create your own module:

```bash
# Option 1: Add to existing file
hx ~/project/dotfiles/zsh/modules/50.tools/git.zsh

# Option 2: Create custom file
mkdir -p ~/project/dotfiles/zsh/modules/75.custom
hx ~/project/dotfiles/zsh/modules/75.custom/aliases.zsh
```

### Add Custom Functions

```bash
cat > ~/project/dotfiles/zsh/modules/75.custom/functions.zsh << 'EOF'
# My custom functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}
EOF
```

### Modify Environment Variables

Edit `zsh/modules/10.environment/export.zsh`:

```bash
hx ~/project/dotfiles/zsh/modules/10.environment/export.zsh

# Add your variables:
export MY_CUSTOM_VAR="value"
export PATH="$HOME/my-bin:$PATH"
```

See [Environment Variables Reference](../.config/zsh/ENV.md) for full list.

### Customize Keybindings

Edit `zsh/modules/64.editor/bindings.zsh`:

```bash
hx ~/project/dotfiles/zsh/modules/64.editor/bindings.zsh

# Add custom keybinding:
bindkey '^X^C' my-custom-function
```

See [Keybindings Guide](../.config/zsh/KEYBINDINGS.md) for reference.

## Adding Homebrew Packages

### Add Formula (CLI Tool)

Edit `scripts/sh/darwin/apps.sh`:

```bash
hx ~/project/dotfiles/scripts/sh/darwin/apps.sh

# Add to existing map or create new one:
declare -A my_tools=(
    ["tool-name"]="formula"
    ["another-tool"]="formula"
)
brew_install_from_map my_tools "My Custom Tools"
```

### Add Cask (GUI Application)

```bash
declare -A my_apps=(
    ["app-name"]="cask"
    ["another-app"]="cask"
)
brew_install_from_map my_apps "My Custom Apps"
```

### Package Type Reference

- `"formula"` - CLI tools, libraries, servers (via `brew install`)
- `"cask"` - GUI applications (via `brew install --cask`)

### Install New Packages

```bash
# Re-run apps installation
./scripts/sh/darwin/apps.sh

# Or install manually
brew install tool-name
brew install --cask app-name
```

## Customizing macOS Defaults

### Modify System Settings

Edit `scripts/sh/darwin/system.sh`:

```bash
hx ~/project/dotfiles/scripts/sh/darwin/system.sh
```

### Example: Change Dock Position

```bash
# In system.sh, find Dock section and modify:
defaults write com.apple.dock orientation -string "left"  # or "bottom", "right"
```

### Apply Changes

```bash
./scripts/sh/darwin/system.sh
killall Dock  # Restart Dock to see changes
```

### Available Settings

The `system.sh` file includes settings for:
- **Dock**: Position, size, auto-hide, apps
- **Finder**: Sidebar, toolbar, view options
- **Safari**: Developer tools, search behavior
- **Keyboard & Trackpad**: Key repeat, tracking speed
- **Screenshots**: Location, format
- **Mission Control**: Hot corners, spaces

### Finding New Settings

```bash
# List all defaults for an app
defaults read com.apple.dock

# Set a new default
defaults write com.apple.app key -type value

# Types: -string, -int, -bool, -float, -array
```

## Git Configuration

### Modify Git Settings

Edit `git/.gitconfig`:

```bash
hx ~/project/dotfiles/git/.gitconfig
```

### Common Customizations

```toml
[user]
    name = Your Name
    email = your.email@example.com

[core]
    editor = hx  # or vim, nano, code, etc.

[alias]
    co = checkout
    br = branch
    ci = commit
    st = status
```

### Global Gitignore

Edit `git/.gitignore_global`:

```bash
hx ~/project/dotfiles/git/.gitignore_global

# Add patterns:
*.log
.DS_Store
node_modules/
```

### Re-sync Git Config

```bash
./scripts/sh/dotsync.sh
```

## Application Configurations

### Starship Prompt

```bash
hx ~/.config/starship/starship.toml

# Customize prompt
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"
```

### Ghostty Terminal

```bash
hx ~/.config/ghostty/config

# Change theme, font, etc.
theme = "nord"
font-family = "JetBrainsMono Nerd Font"
font-size = 14
```

### Helix Editor

```bash
hx ~/.config/helix/config.toml

# Customize editor
theme = "nord"
[editor]
line-number = "relative"
```

### Lazygit

```bash
hx ~/.config/lazygit/config.yml

# Customize lazygit
gui:
  theme:
    activeBorderColor:
      - '#88c0d0'
```

### Atuin History

```bash
hx ~/.config/atuin/config.toml

# Customize history
auto_sync = true
sync_frequency = "1h"
search_mode = "fuzzy"
```

### AeroSpace Window Manager

```bash
hx ~/.config/aerospace/aerospace.toml

# Customize keybindings, layouts
```

## Theme Configuration

All configurations use **Nord theme** for consistency:

- Terminal (Ghostty): Nord
- Git Delta: Nord
- Helix: Nord
- Lazygit: Nord colors
- Starship: Minimal with Nord-compatible colors

### Change Theme

To change to a different theme, update each config file:

1. Ghostty: `theme = "theme-name"`
2. Helix: `theme = "theme-name"`
3. Git Delta: `features = "theme-name"`
4. Lazygit: `gui.theme` section

## Advanced Configuration

### Add New Programming Language Support

#### 1. Install Language Tools

```bash
# Add to apps.sh
declare -A rust_tools=(
    ["rust"]="formula"
    ["rust-analyzer"]="formula"
)
```

#### 2. Configure Helix LSP

Helix has built-in LSP configs, but you can customize:

```bash
hx ~/.config/helix/languages.toml
```

#### 3. Add Language-Specific Aliases

```bash
# Create new module
mkdir -p ~/project/dotfiles/zsh/modules/50.tools
cat > ~/project/dotfiles/zsh/modules/50.tools/rust.zsh << 'EOF'
# Rust aliases
alias cb='cargo build'
alias cr='cargo run'
alias ct='cargo test'
EOF
```

### Directory-Specific Environment (direnv)

```bash
# In project directory
cat > .envrc << 'EOF'
export DATABASE_URL=postgres://localhost/mydb
export NODE_ENV=development
export API_KEY=secret
EOF

# Approve
direnv allow .
```

### Custom Installation Script

Create environment-specific configs:

```bash
# Create environment file
cat > ~/project/dotfiles/scripts/sh/darwin/env_work.sh << 'EOF'
#!/usr/bin/env bash
# Work-specific installations

declare -A work_tools=(
    ["kubectl"]="formula"
    ["aws-cli"]="formula"
)
brew_install_from_map work_tools "Work Tools"
EOF

# It will be sourced automatically if $ENVIRONMENT is set
```

## Testing Changes

### Test Configuration Changes

```bash
# Test in new shell without affecting current one
zsh -l

# Or reload current shell
source ~/.zshrc
```

### Test Installation Scripts

```bash
# Dry run to preview changes
./scripts/sh/install.sh --dry-run --verbose=2

# Test specific component
./scripts/sh/darwin/apps.sh
```

### Revert Changes

```bash
# Restore from backup
cp ~/dotfiles-backup/.zshrc ~/.zshrc

# Or re-sync from repository
cd ~/project/dotfiles
git checkout .zshrc
./scripts/sh/dotsync.sh
```

## Best Practices

### 1. Version Control

Always commit your changes:

```bash
cd ~/project/dotfiles
git add .
git commit -m "Add custom configuration"
git push
```

### 2. Test Before Committing

```bash
# Test in dry-run mode
./scripts/sh/install.sh --dry-run

# Test in new shell
zsh -l

# Verify changes work
```

### 3. Document Your Changes

Add comments to your configurations:

```bash
# Good
export MY_VAR="value"  # Used for X feature

# Better
##############################################################
# MY CUSTOM CONFIGURATION
##############################################################
# Purpose: Enable X feature for Y workflow
# Dependencies: tool-name
# Reference: https://example.com/docs
##############################################################

export MY_VAR="value"
```

### 4. Keep Sensitive Data Out

Never commit:
- API keys
- Passwords
- Tokens
- Work-specific configurations

Use `.dotignore` or environment variables:

```bash
# Add to .dotignore
echo ".env" >> ~/project/dotfiles/.dotignore
echo ".work-config" >> ~/project/dotfiles/.dotignore

# Use direnv for secrets
echo 'export API_KEY=secret' > .envrc
direnv allow .
```

## Troubleshooting Configuration

### Changes Not Applied

```bash
# Reload shell
source ~/.zshrc

# Or restart terminal
exec zsh
```

### Symlink Issues

```bash
# Re-sync dotfiles
./scripts/sh/dotsync.sh

# Check symlink
ls -la ~/.zshrc
```

### Module Not Loading

```bash
# Check file extension (.zsh required)
ls ~/project/dotfiles/zsh/modules/75.custom/

# Check for syntax errors
zsh -n ~/project/dotfiles/zsh/modules/75.custom/my-file.zsh
```

## Next Steps

- Check [Tools Reference](TOOLS.md) for tool-specific configs
- Read [Usage Guide](USAGE.md) for daily workflows
- See [Troubleshooting](TROUBLESHOOTING.md) for common issues

---

**Remember**: Always test changes before committing!


# Usage Guide

Daily commands and workflows for working with your dotfiles.

## Table of Contents

- [Essential Commands](#essential-commands)
- [Updating](#updating)
- [Modern Tool Usage](#modern-tool-usage)
- [Dotfile Management](#dotfile-management)
- [Development Workflow](#development-workflow)
- [macOS-Specific](#macos-specific)

## Essential Commands

### Quick Reference

| Command | Purpose |
|---------|---------|
| `./scripts/sh/update.sh` | Update everything |
| `./scripts/sh/dotsync.sh` | Sync dotfiles only |
| `z <dir>` | Jump to directory |
| `zi` | Interactive directory picker |
| `Ctrl+R` | Search command history |
| `lg` | Launch lazygit |
| `hx <file>` | Edit file with Helix |

## Updating

### Update Everything

```bash
# Update all components (recommended)
./scripts/sh/update.sh
```

This updates:
- ✅ Homebrew packages
- ✅ Homebrew casks (applications)
- ✅ macOS system updates
- ✅ Xcode Command Line Tools
- ✅ SDKMAN packages
- ✅ Git submodules (Zsh plugins)
- ✅ Dotfiles repository
- ✅ Regenerates Brewfile backup

### Update Options

```bash
# Preview updates without applying
./scripts/sh/update.sh --dry-run

# Non-interactive mode
./scripts/sh/update.sh --skip-confirmation

# Verbose output
./scripts/sh/update.sh --verbose=2

# Quiet mode (errors only)
./scripts/sh/update.sh --quiet
```

### Update Specific Components

```bash
# Update Homebrew packages only
brew update && brew upgrade

# Update Homebrew applications only
brew upgrade --cask --greedy

# Update Zsh plugins only
git submodule update --remote --merge

# Update dotfiles repository only
cd ~/project/dotfiles
git pull origin main
./scripts/sh/dotsync.sh

# Update SDKMAN
sdk update

# Check for macOS updates
softwareupdate --list
```

## Modern Tool Usage

### zoxide (Smarter Directory Navigation)

**Replaces**: `cd`

```bash
# Jump to a directory you've visited
z dotfiles        # Jumps to ~/project/dotfiles
z conf            # Jumps to ~/.config
z doc             # Jumps to ~/Documents

# Interactive picker (fuzzy search)
zi

# Go back
z -

# Add directory manually
z --add /path/to/dir

# Remove directory from database
z --remove /path/to/dir

# See all tracked directories
z -l
```

**Pro Tips:**
- zoxide learns from your habits (uses frequency algorithm)
- Partial matches work: `z dot` → `~/project/dotfiles`
- Case-insensitive: `z DOTFILES` works
- Multiple words: `z pro dot` → `~/project/dotfiles`

### atuin (Magical Shell History)

**Replaces**: `Ctrl+R` history search

```bash
# Interactive fuzzy search (Ctrl+R)
Ctrl+R

# Smart history navigation
Up Arrow          # Context-aware suggestions

# Search history
atuin search git   # Find all git commands
atuin search "git commit"  # Exact phrase

# Sync across machines (optional)
atuin register -u <email>
atuin login -u <email>
atuin sync

# Show stats
atuin stats

# Import existing history
atuin import zsh
```

**Pro Tips:**
- Atuin stores history in SQLite (searchable, fast)
- Tracks working directory, exit code, duration
- `Ctrl+R` is now supercharged
- Optional cloud sync (encrypted)

### ripgrep (Fast Search)

**Replaces**: `grep`

```bash
# Search for pattern in files
rg "function"                  # In current directory
rg "function" ~/project        # In specific directory
rg "function" -g "*.ts"        # Only TypeScript files

# Case-insensitive search
rg -i "Function"

# Show context
rg -C 3 "function"             # 3 lines before/after

# Search specific file types
rg "TODO" -t ts                # TypeScript only
rg "TODO" -t rust              # Rust only

# Exclude directories
rg "function" --glob '!node_modules'

# Search and replace (preview)
rg "old" --replace "new"

# Show only files with matches
rg -l "function"

# Count matches
rg -c "function"
```

### fd (Fast Find)

**Replaces**: `find`

```bash
# Find files by name
fd config                      # Find files named *config*
fd "\.ts$"                     # Find TypeScript files
fd -e rs                       # Find Rust files

# Search in specific directory
fd config ~/.config

# Execute command on results
fd -e ts -x cat                # Cat all TypeScript files

# Find and delete
fd -e tmp -x rm

# Hidden files
fd -H config                   # Include hidden files

# Case-sensitive
fd -s Config                   # Case-sensitive search

# Exclude patterns
fd config -E node_modules
```

### bat (Cat with Superpowers)

**Replaces**: `cat`

```bash
# View file with syntax highlighting
bat file.ts

# View multiple files
bat file1.ts file2.ts

# Show line numbers
bat -n file.ts

# Show git changes
bat -d file.ts

# Page through large files
bat large-file.log

# Plain output (no decorations)
bat -p file.ts

# Specific language
bat --language rust file.txt
```

### eza (Modern ls)

**Replaces**: `ls`

```bash
# List files with icons
eza

# Long format with details
eza -l

# All files (including hidden)
eza -la

# Tree view
eza --tree

# Tree with depth limit
eza --tree --level=2

# Git status
eza -l --git

# Sort by modified time
eza -l --sort=modified

# Human-readable sizes
eza -lh
```

### delta (Beautiful Git Diffs)

**Replaces**: default git diff

```bash
# Already configured as git pager
git diff                       # Uses delta automatically
git log -p                     # Beautiful commit history
git show HEAD                  # Show commit with delta

# Side-by-side view
git diff --side-by-side

# Delta is integrated, no special commands needed!
```

### xh (HTTP Client)

**Replaces**: `curl`, `httpie`

```bash
# GET request
xh https://api.github.com/users/cdrolet

# POST JSON
xh POST https://httpbin.org/post name=value

# Custom headers
xh GET https://api.github.com/user \
   Authorization:"token YOUR_TOKEN"

# Download file
xh --download https://example.com/file.zip

# Pretty print JSON
xh GET https://api.github.com/repos/rust-lang/rust

# Form data
xh --form POST https://httpbin.org/post name=value

# Follow redirects
xh --follow https://shortened.url
```

### procs (Modern ps)

**Replaces**: `ps`

```bash
# List all processes
procs

# Search by name
procs zsh
procs node

# Show tree view
procs --tree

# Sort by CPU
procs --sortd cpu

# Sort by memory
procs --sortd mem

# Watch mode (updates every 2s)
procs --watch
```

## Dotfile Management

### Syncing Dotfiles

```bash
# Sync all dotfiles
./scripts/sh/dotsync.sh

# Force sync (skip confirmation)
./scripts/sh/dotsync.sh -f

# Sync specific file
./scripts/sh/dotsync.sh -t .zshrc
```

### Adding New Dotfiles

```bash
# 1. Add file to repository
cd ~/project/dotfiles
echo "alias test='echo hi'" > .test

# 2. Sync to home directory
./scripts/sh/dotsync.sh

# 3. Verify symlink
ls -la ~/.test  # Should show -> /Users/you/project/dotfiles/.test
```

### Excluding Files

```bash
# Add to .dotignore
echo ".private" >> ~/project/dotfiles/.dotignore

# Re-sync
./scripts/sh/dotsync.sh
```

### Checking Symlink Status

```bash
# See all symlinked dotfiles
ls -la ~ | grep '\->'

# Verify specific file
ls -la ~/.zshrc
```

## Development Workflow

### Typical Day

```bash
# Morning: Update everything
cd ~/project/dotfiles
./scripts/sh/update.sh

# Jump to project
z myproject

# Check git status with lazygit
lg

# Search codebase
rg "TODO"
fd -e ts

# Edit files
hx src/main.ts

# Commit changes (from lazygit)
lg
```

### Testing Dotfile Changes

```bash
# 1. Edit dotfiles
cd ~/project/dotfiles
hx .zshrc

# 2. Sync changes
./scripts/sh/dotsync.sh

# 3. Test in new shell
zsh -l

# 4. If good, commit
git add .zshrc
git commit -m "Update zshrc"
git push
```

### Deploying to Another Machine

```bash
# On new machine
git clone https://github.com/cdrolet/dotfiles.git ~/project/dotfiles
cd ~/project/dotfiles

# Preview installation
./scripts/sh/install.sh --dry-run

# Install
./scripts/sh/install.sh
```

## macOS-Specific

### Setting Default Applications

```bash
# Run default apps configuration
./scripts/sh/darwin/set-defaults.sh
```

This sets:
- Web browser (HTTP/HTTPS protocols)
- Code editor (programming file types)
- Text editor (markdown, config files)

### Configuring macOS Defaults

```bash
# Apply system defaults
./scripts/sh/darwin/system.sh
```

This configures:
- Dock settings (position, size, auto-hide)
- Finder preferences
- Keyboard and trackpad
- Mission Control
- Screenshots location
- And more...

### Managing Dock

```bash
# Dock configuration is in scripts/sh/darwin/system.sh
# Edit and re-run:
hx ~/project/dotfiles/scripts/sh/darwin/system.sh
./scripts/sh/darwin/system.sh
```

### Brewfile Backup

```bash
# Brewfile is auto-generated during updates
cat ~/project/dotfiles/backup/Brewfile

# Restore on new machine
cd ~/project/dotfiles
brew bundle --file=backup/Brewfile
```

## Git Workflows

### Lazygit Essentials

```bash
# Launch lazygit
lg

# Essential keybindings:
# Space - Stage/unstage files
# c     - Commit
# P     - Push
# p     - Pull
# o     - Open file
# e     - Edit file
# d     - Delete/discard
# ?     - Help menu
```

### Git Aliases

Available aliases in `zsh/modules/50.tools/git.zsh`:

```bash
# Status and info
gits        # git status
gitb        # git branch
gitlog      # git log --oneline --graph

# Working with changes
gita        # git add -A
gitc        # git commit -m
gitp        # git push
gitpull     # git pull

# Branches
gitcb       # git checkout -b (create branch)
gitco       # git checkout
gitsw       # git switch
gitswc      # git switch -c

# Undo
gitundo     # git reset --soft HEAD~1
gitrestore  # git restore

# Advanced
gitamend    # git commit --amend --no-edit
gitrebase   # git rebase -i
gitstash    # git stash
```

## Shell Productivity

### Zsh Keybindings

Most useful shortcuts (see `.config/zsh/KEYBINDINGS.md` for full list):

```bash
Ctrl+X Ctrl+S  # Insert sudo at beginning
Ctrl+Y         # Delete backward to slash
Ctrl+Q         # Push line (save, run other, restore)
Esc M          # Duplicate previous word
Ctrl+R         # Atuin search (supercharged)
Up Arrow       # Smart history navigation
Tab            # Completion
```

### Listing Custom Functions

```bash
# Show all custom keybindings
lskeys

# Show all aliases
alias
```

### Direnv (Auto-load Environment)

```bash
# In project directory:
echo 'export DATABASE_URL=postgres://localhost/mydb' > .envrc

# Approve the file
direnv allow .

# Variables auto-load when entering directory
cd myproject     # Variables loaded
cd ..            # Variables unloaded
```

## Advanced Usage

### Performance Profiling

```bash
# Enable profiling in .zshrc
# Set: typeset -i record_metrics=1

# Restart shell
exec zsh

# Check startup time
# Time will be printed on each shell start
```

### Debugging Scripts

```bash
# Run with maximum verbosity
./scripts/sh/install.sh --verbose=3

# Run specific component
./scripts/sh/darwin/apps.sh

# Check for errors
./scripts/sh/install.sh --dry-run | grep -i error
```

### Customizing Installation

```bash
# Install specific packages only
cd ~/project/dotfiles
hx scripts/sh/darwin/apps.sh

# Comment out sections you don't need:
# brew_install_from_map development_IDEs "Development IDEs"

# Re-run
./scripts/sh/darwin/apps.sh
```

## Troubleshooting

### Command Not Available

```bash
# Reload shell
source ~/.zshrc

# Check if installed
which zoxide
brew list | grep zoxide

# Reinstall if needed
brew install zoxide
```

### Symlink Broken

```bash
# Check symlink
ls -la ~/.zshrc

# Re-create
./scripts/sh/dotsync.sh
```

### Shell Slow

```bash
# Profile startup
zsh -i -c exit

# Check which modules are slow
# Enable metrics in .zshrc
```

For more troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## Next Steps

- Explore [Tools Reference](TOOLS.md) for detailed tool documentation
- Learn [Configuration](CONFIGURATION.md) to customize your setup
- Check [Architecture](ARCHITECTURE.md) to understand the structure

---

**Enjoy your enhanced productivity!** ⚡


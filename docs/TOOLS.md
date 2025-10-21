# Tools Reference

Comprehensive guide to all tools included in this dotfiles setup.

## Table of Contents

- [Shell & Terminal](#shell--terminal)
- [Modern CLI Tools](#modern-cli-tools)
- [Editors & IDEs](#editors--ides)
- [Git Tools](#git-tools)
- [macOS Tools](#macos-tools)
- [Development Tools](#development-tools)
- [Quick References](#quick-references)

## Shell & Terminal

### Zsh
**Purpose**: Advanced shell with powerful features

**Key Features:**
- Modular configuration system
- Smart completion
- Syntax highlighting
- History substring search
- Auto-suggestions

**Documentation:**
- [Zsh Configuration](../.config/zsh/README.md)
- [Keybindings Guide](../.config/zsh/KEYBINDINGS.md)
- [Environment Variables](../.config/zsh/ENV.md)

**Quick Command:**
```bash
lskeys  # Show all custom keybindings
```

### Starship
**Purpose**: Fast, customizable shell prompt

**Configuration**: `~/.config/starship/starship.toml`

**Features:**
- Minimal design
- Shows git status, language versions
- Fast (written in Rust)
- Context-aware (only shows relevant info)

**Customize:**
```bash
hx ~/.config/starship/starship.toml
```

### Ghostty
**Purpose**: Modern, fast terminal emulator

**Configuration**: `~/.config/ghostty/config`

**Features:**
- GPU-accelerated
- Native macOS app
- Nord theme configured
- Ligature support
- Fast startup

## Modern CLI Tools

### zoxide (Smart Directory Navigation)
**Replaces**: `cd`  
**GitHub**: https://github.com/ajeetdsouza/zoxide

```bash
# Jump to frequently used directories
z dotfiles        # Jump to ~/project/dotfiles
z conf            # Jump to ~/.config
zi                # Interactive picker (fzf-style)
z -               # Go back

# Add/remove directories
zoxide add /path/to/dir
zoxide remove /path/to/dir
```

**How it works:** Tracks your directory navigation and uses frecency (frequency + recency) to jump smartly.

### atuin (Shell History)
**Replaces**: `Ctrl+R` history  
**GitHub**: https://github.com/atuinsh/atuin

```bash
# Search history
Ctrl+R            # Interactive fuzzy search
atuin search git  # Search for git commands
atuin stats       # Show statistics

# Sync across machines (optional)
atuin register
atuin login
atuin sync
```

**Configuration**: `~/.config/atuin/config.toml`

**Features:**
- SQLite-backed history
- Tracks working directory, exit codes, duration
- Optional encrypted cloud sync
- Fuzzy search

### ripgrep (Fast Search)
**Replaces**: `grep`  
**GitHub**: https://github.com/BurntSushi/ripgrep

```bash
# Basic search
rg "pattern"                    # Search current directory
rg "pattern" -t ts              # Only TypeScript files
rg "pattern" -C 3               # Show 3 lines context
rg -i "pattern"                 # Case-insensitive

# Advanced
rg "pattern" --glob '!node_modules'  # Exclude directories
rg -l "pattern"                 # Only show filenames
rg -c "pattern"                 # Count matches
```

**Alias**: `rg` (already installed)

### fd (Fast Find)
**Replaces**: `find`  
**GitHub**: https://github.com/sharkdp/fd

```bash
# Basic search
fd config                       # Find files named *config*
fd "\.ts$"                      # Find TypeScript files
fd -e rs                        # Find Rust files
fd -H config                    # Include hidden files

# Execute commands
fd -e log -x rm                 # Delete all log files
fd -e ts -x cat                 # Cat all TypeScript files
```

### bat (Cat with Syntax Highlighting)
**Replaces**: `cat`  
**GitHub**: https://github.com/sharkdp/bat

```bash
# View files with syntax highlighting
bat file.ts
bat -n file.ts                  # Show line numbers
bat -d file.ts                  # Show git changes
bat --language rust file.txt    # Specific language
```

**Configuration**: Uses Nord theme automatically

### eza (Modern ls)
**Replaces**: `ls`  
**GitHub**: https://github.com/eza-community/eza

```bash
# List files
eza                             # Basic listing
eza -l                          # Long format
eza -la                         # Include hidden
eza --tree                      # Tree view
eza --tree --level=2            # Limit depth
eza -l --git                    # Show git status
```

**Features:**
- Icons for file types
- Git integration
- Tree view
- Color-coded by type

### delta (Git Diffs)
**Replaces**: Default git diff  
**GitHub**: https://github.com/dandavison/delta

**Already integrated with git!**

```bash
# Just use git normally
git diff                        # Beautiful colored diff
git log -p                      # Pretty commit history
git show HEAD                   # Show commit with delta
```

**Configuration**: `~/project/dotfiles/git/.gitconfig`

**Features:**
- Side-by-side diffs
- Line numbering
- Syntax highlighting
- Nord theme

### procs (Modern Process Viewer)
**Replaces**: `ps`  
**GitHub**: https://github.com/dalance/procs

```bash
# View processes
procs                           # All processes
procs zsh                       # Search by name
procs --tree                    # Tree view
procs --sortd cpu               # Sort by CPU
procs --sortd mem               # Sort by memory
procs --watch                   # Watch mode
```

### xh (HTTP Client)
**Replaces**: `curl`, `httpie`  
**GitHub**: https://github.com/ducaale/xh

```bash
# GET request
xh https://api.github.com/users/cdrolet

# POST JSON
xh POST https://httpbin.org/post name=value

# Custom headers
xh GET https://api.github.com \
   Authorization:"token YOUR_TOKEN"

# Download file
xh --download https://example.com/file.zip
```

### direnv (Auto Environment)
**Purpose**: Automatically load/unload environment variables per directory

```bash
# In project directory
echo 'export DATABASE_URL=postgres://localhost/mydb' > .envrc
direnv allow .

# Variables auto-load/unload
cd myproject     # Variables loaded
cd ..            # Variables unloaded
```

**Configuration**: Automatically integrated with Zsh

## Editors & IDEs

### Helix (Primary Editor)
**Purpose**: Modern terminal-based editor  
**Command**: `hx`  
**GitHub**: https://github.com/helix-editor/helix

```bash
# Open files
hx file.txt
hx .                            # Open current directory

# Multiple files
hx file1.txt file2.txt
```

**Configuration**: `~/.config/helix/`

**Features:**
- Built-in LSP support
- Multiple cursors
- Tree-sitter syntax
- Kakoune-style selection-first editing
- Fast and lightweight

**Key Concepts:**
- Modal editor (like Vim)
- Selection-based (select then act)
- Built-in file picker, grep
- No plugins needed (batteries included)

### Cursor (IDE)
**Purpose**: AI-powered code editor (VSCode fork)

**Installed via**: Homebrew Cask

**Features:**
- AI pair programming
- Full VSCode compatibility
- Built-in chat
- Code generation

### Zed (IDE)
**Purpose**: High-performance collaborative editor

**Features:**
- Extremely fast
- Built-in collaboration
- Written in Rust
- Native macOS app

### IntelliJ IDEA (IDE)
**Purpose**: Java/Kotlin/JVM development

**Installed via**: Homebrew Cask

## Git Tools

### Lazygit
**Purpose**: Terminal UI for Git  
**GitHub**: https://github.com/jesseduffield/lazygit

**Documentation**: [Lazygit Guide](../.config/lazygit/README.md)

```bash
# Launch lazygit
lazygit
# or use alias
lg
```

**Essential Keys:**
- `Space` - Stage/unstage
- `c` - Commit
- `P` - Push
- `p` - Pull
- `?` - Help

**Full guide**: See `.config/lazygit/README.md`

### Git Configuration
**Location**: `~/project/dotfiles/git/.gitconfig`

**Features:**
- Delta for diffs
- Helix as editor
- URL shortcuts (gh:, gist:, bb:)
- Useful aliases
- LFS enabled

**Global Gitignore**: `~/project/dotfiles/git/.gitignore_global`

### GitHub CLI (`gh`)
**Purpose**: GitHub operations from terminal

```bash
# Authenticate
gh auth login

# Repository operations
gh repo clone user/repo
gh repo create
gh repo view

# Pull requests
gh pr create
gh pr list
gh pr view 123

# Issues
gh issue create
gh issue list
```

## macOS Tools

### AeroSpace
**Purpose**: Tiling window manager  
**Configuration**: `~/.config/aerospace/`

**Features:**
- Built-in keybindings
- Tiling layouts
- Multi-monitor support
- Workspace management
- No SIP disable needed

**Usage:**
- Keybindings configured in `aerospace.toml`
- Automatic window tiling
- Workspace switching

### SketchyBar
**Purpose**: Customizable macOS status bar  
**Configuration**: `~/.config/sketchybar/`

**Features:**
- Custom status bar
- Plugins for system info
- Scriptable
- Minimal design

### Borders
**Purpose**: Window border decoration  
**Configuration**: Automatic

**Features:**
- Colored window borders
- Focus indicator
- Configurable colors

### duti
**Purpose**: Set default applications

**Configured via**: `scripts/sh/darwin/set-defaults.sh`

**Usage:**
```bash
# Set default applications
./scripts/sh/darwin/set-defaults.sh
```

## Development Tools

### Homebrew
**Purpose**: Package manager for macOS

```bash
# Search packages
brew search ripgrep

# Install
brew install ripgrep            # CLI tool
brew install --cask cursor      # Application

# Update
brew update && brew upgrade

# Info
brew info ripgrep

# List installed
brew list
```

### SDKMAN
**Purpose**: Manage JVM-based tools

```bash
# Install SDKMAN
curl -s "https://get.sdkman.io" | bash

# Install Java
sdk install java
sdk install java 17.0.0-tem

# Switch versions
sdk use java 17.0.0-tem
sdk default java 21.0.0-tem

# List versions
sdk list java
```

**Pre-configured**:
- Java 17 and 21 environments
- Switching functions: `java17`, `java21`
- See [Environment Variables](../.config/zsh/ENV.md)

### Docker Desktop
**Purpose**: Container runtime

**Installed via**: Homebrew Cask (optional)

### UV (Python Package Manager)
**Purpose**: Ultra-fast Python package installer

```bash
# Install packages
uv pip install requests

# Create venv
uv venv

# Much faster than pip
```

## Quick References

### Documentation Links

| Topic | Documentation |
|-------|---------------|
| Zsh Configuration | [.config/zsh/README.md](../.config/zsh/README.md) |
| Keybindings | [.config/zsh/KEYBINDINGS.md](../.config/zsh/KEYBINDINGS.md) |
| Environment Variables | [.config/zsh/ENV.md](../.config/zsh/ENV.md) |
| Lazygit | [.config/lazygit/README.md](../.config/lazygit/README.md) |
| Architecture | [ARCHITECTURE.md](ARCHITECTURE.md) |
| Installation | [INSTALLATION.md](INSTALLATION.md) |
| Usage | [USAGE.md](USAGE.md) |

### Command Cheat Sheet

| Task | Command |
|------|---------|
| Jump to directory | `z <name>` |
| Search history | `Ctrl+R` |
| Search files | `rg "pattern"` |
| Find files | `fd filename` |
| View file | `bat file` |
| List files | `eza -la` |
| Git UI | `lg` |
| Edit file | `hx file` |
| HTTP request | `xh GET url` |
| Processes | `procs` |

### Aliases

Common aliases defined in `zsh/modules/50.tools/`:

```bash
# Git
gits        # git status
gita        # git add -A
gitc        # git commit -m
gitp        # git push
gitpull     # git pull
lg          # lazygit

# Modern tools (if you want to keep old names)
grep → rg
find → fd
cat → bat
ls → eza
ps → procs
```

## Tool Comparison Matrix

| Category | Traditional | Modern Alternative | Improvement |
|----------|-------------|-------------------|-------------|
| Directory navigation | `cd` | `zoxide` (z) | Frequency-based jumping |
| Shell history | basic history | `atuin` | Searchable, SQLite-backed |
| Text search | `grep` | `ripgrep` (rg) | 10-100x faster |
| File find | `find` | `fd` | Simpler syntax, faster |
| View files | `cat` | `bat` | Syntax highlighting |
| List files | `ls` | `eza` | Icons, git status |
| Git diffs | plain diff | `delta` | Beautiful, readable |
| HTTP client | `curl` | `xh` | Simpler syntax |
| Process viewer | `ps` | `procs` | Better formatting |

## Learning Resources

### Built-in Help

```bash
# Tool help
zoxide --help
atuin --help
rg --help

# Man pages
man zsh
man git

# Zsh-specific
lskeys              # Show custom keybindings
```

### Online Resources

- **Zsh**: https://zsh.sourceforge.io/
- **Starship**: https://starship.rs/
- **Atuin**: https://atuin.sh/
- **Helix**: https://helix-editor.com/
- **Lazygit**: https://github.com/jesseduffield/lazygit

## Tool Configuration Locations

| Tool | Configuration Path |
|------|-------------------|
| Zsh | `~/project/dotfiles/zsh/modules/` |
| Starship | `~/.config/starship/starship.toml` |
| Ghostty | `~/.config/ghostty/config` |
| Helix | `~/.config/helix/` |
| Lazygit | `~/.config/lazygit/config.yml` |
| Atuin | `~/.config/atuin/config.toml` |
| AeroSpace | `~/.config/aerospace/` |
| Git | `~/project/dotfiles/git/.gitconfig` |

## Next Steps

- Read [Usage Guide](USAGE.md) for daily workflows
- Check [Configuration Guide](CONFIGURATION.md) to customize
- See [Troubleshooting](TROUBLESHOOTING.md) for common issues

---

**Tip**: Run `lskeys` to see all custom Zsh keybindings!


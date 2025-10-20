# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository designed to automate macOS development environment setup and configuration management. It uses a symlink-based approach to manage dotfiles and provides automated installation scripts for system configuration, application installation, and shell customization.

**Primary Platform**: macOS (Darwin)
**Shell**: Zsh with modular configuration system
**Package Manager**: Homebrew (with Nix support)
**Terminal**: Ghostty
**Editor**: Helix (hx)

**Modern Rust-Based Tools**:

- **zoxide** - Smarter cd (jump to directories by frecency)
- **atuin** - Magical shell history with search and optional sync
- **direnv** - Auto-load environment variables per directory
- **xh** - Modern HTTP client (httpie alternative)
- **ripgrep** - Fast recursive grep (replaces grep)
- **fd** - Fast find alternative (replaces find)
- **bat** - cat with syntax highlighting (replaces cat)
- **eza** - Modern ls replacement (replaces ls)
- **procs** - Modern ps replacement (replaces ps)
- **delta** - Beautiful git diffs (git pager)

## Key Commands

### Installation & Setup

```bash
# Full system installation (interactive)
scripts/sh/install.sh

# Installation with options
scripts/sh/install.sh --verbose=2          # Detailed output
scripts/sh/install.sh --quiet              # Minimal output
scripts/sh/install.sh --dry-run            # Preview changes without applying
scripts/sh/install.sh --skip-confirmation  # Non-interactive mode
scripts/sh/install.sh --upgrade-outdated   # Update existing packages (use update.sh instead)

# Sync dotfiles only (create/update symlinks)
scripts/sh/dotsync.sh

# macOS-specific installations
scripts/sh/darwin/apps.sh      # Install applications via Homebrew
scripts/sh/darwin/system.sh    # Configure macOS system defaults
```

### Update & Maintenance

```bash
# Update everything (Homebrew, macOS, dotfiles, submodules)
scripts/sh/update.sh

# Update with options
scripts/sh/update.sh --dry-run             # Preview updates without applying
scripts/sh/update.sh --quiet               # Minimal output
scripts/sh/update.sh --skip-confirmation   # Non-interactive mode
scripts/sh/update.sh --verbose=2           # Detailed output

# Update specific components
brew update && brew upgrade                # Update Homebrew packages only
git submodule update --remote --merge      # Update Zsh plugins only
```

**Note:** `update.sh` always runs in upgrade mode (equivalent to `install.sh --upgrade-outdated`). Use `--dry-run` to preview changes before applying.

### Development Workflow

```bash
# Update repository and submodules
scripts/sh/update.sh --dry-run             # Preview updates
scripts/sh/update.sh                       # Apply updates

# Test changes in dry-run mode before applying
scripts/sh/install.sh --dry-run

# View pending changes
git status
git diff
```

## Architecture & Structure

### Core Components

1. **Installation System** (`scripts/sh/`)
   - **install.sh**: Main orchestrator - handles OS detection, Git config, dotfile sync
   - **dotsync.sh**: Symlink manager - creates `~/.* -> repo/*` symlinks
   - **lib/**: Modular library system (1615 lines total)
     - Loaded via `_bootstrap.sh` in dependency order
     - Key modules: `_ui.sh` (terminal formatting), `_commands.sh` (package installation), `_dotsync.sh` (symlink logic), `_git.sh` (Git/GitHub operations)

2. **Platform-Specific** (`scripts/sh/darwin/`)
   - **apps.sh**: Homebrew package installation (dev tools, languages, IDEs)
   - **system.sh**: macOS defaults configuration (Dock, Finder, Safari, etc.)
   - Install utilities for Xcode CLI tools, Homebrew setup, VS Code extensions

3. **Zsh Configuration** (`zsh/modules/`)
   - Numbered module system (10, 40, 50, etc.) ensures predictable load order
   - **10.environment/**: Core environment variables, PATH, ZSH options
   - **40.completion/**: Completion system with zsh-completions submodule
   - **50.tools/**: Tool-specific aliases (git, ssh, maven, gradle, network, etc.)
   - **55.directory/**: zoxide integration for smart directory jumping
   - **60.syntax/**: fast-syntax-highlighting submodule
   - **62.history/**: atuin + zsh-history-substring-search integration
   - **64.editor/**: Editor bindings and functions
   - **66.suggestions/**: zsh-autosuggestions submodule
   - **80.os/**: OS-specific settings (darwin.zsh for macOS Homebrew paths)
   - **90.work/**: Work-specific configs (Airflow, Kafka)

4. **Application Configs** (`.config/`)
   - **aerospace/**: Tiling window manager configuration
   - **sketchybar/**: macOS status bar with plugins
   - **skhd/**: Hotkey daemon for window/space management
   - **starship/**: Shell prompt customization
   - **ghostty/**: Terminal emulator settings
   - **borders/**: Window decoration tool

### Dotfile Synchronization Flow

The `dotsync.sh` script implements a safe symlink-based dotfile management system:

1. Scans repository root and first-level subfolders for files/folders starting with `.`
2. Respects `.dotignore` exclusions (sensitive files, work configs, etc.)
3. Detects conflicts (duplicate filenames from different directories)
4. Previews all changes: new symlinks, existing links, rejected files, broken links
5. Creates symlinks: `$HOME/.file -> /path/to/dotfiles/.file`
6. Cleans up broken symlinks pointing to missing files

**Important**: Only scans 2 levels deep (root + first subfolder) to avoid traversing `.git/` and other deep structures.

### Library Module System

All installation scripts load a common library via `scripts/sh/lib/_bootstrap.sh`. Modules are loaded in dependency order:

1. `_common.sh` - Global constants
2. `_utils.sh` - General utilities
3. `_time.sh` - Execution timing
4. `_errors.sh` - Error tracking
5. `_ui.sh` - Terminal colors, spinners, formatted messages
6. `_commands.sh` - Command installation, progress animation
7. `_git.sh` - Git config, GitHub auth, submodule management
8. `_fonts.sh` - Font installation
9. `_dotsync.sh` - Symlink creation and conflict detection

Key patterns:

- Associative arrays for batch operations (e.g., `install_from_map`)
- `spin()` function wraps long-running commands with progress spinner
- Rich terminal output with success/failure/warning symbols
- Guard clauses prevent duplicate sourcing

## Important Configuration Files

### Git Configuration (`git/.gitconfig`)

- User: cdrolet (GitHub handle)
- Diff tool: Delta with Nord theme, side-by-side layout
- Merge tool: Helix
- Editor: Helix (hx)
- URL shortcuts: `gh:`, `gist:`, `bb:`, `home:` prefixes
- Git LFS enabled
- Default branch: main

### Zsh Keybindings (`.config/zsh/KEYBINDINGS.md`)

Custom keybindings reference guide for productivity shortcuts.

**Most useful shortcuts:**
- `Ctrl+X Ctrl+S` - Insert sudo at beginning of line
- `Ctrl+Y` - Erase backward to slash (path editing)
- `Ctrl+Q` - Push line (save, run other command, restore)
- `Esc M` - Duplicate previous word
- `lskeys` - Show all custom keybindings

**Full keybindings:** See `.config/zsh/KEYBINDINGS.md` or run `lskeys` in terminal

### Lazygit Configuration (`.config/lazygit/config.yml`)

Terminal UI for Git - interactive visual Git client.

**Quick Start:**
```bash
lazygit          # Launch in current repo
alias lg='lazygit'
```

**Essential shortcuts:**
- `Space` - Stage/unstage files
- `c` - Commit
- `P` - Push
- `p` - Pull
- `?` - Help menu

**Features:** Nord theme, Delta integration, Helix editor, interactive rebase, cherry-pick, merge conflict resolution.

**Full guide:** See `.config/lazygit/README.md`

### Dotfile Exclusions (`.dotignore`)

Files/patterns excluded from symlink creation:

- `.git/`, `tmp/`, `.DS_Store`
- Personal work configurations
- Prevents accidental exposure of sensitive files

### Git Submodules (`.gitmodules`)

Four Zsh plugins managed as submodules:

- `zsh-history-substring-search` (history navigation)
- `zsh-autosuggestions` (command suggestions)
- `zsh-completions` (extended completions)
- `fast-syntax-highlighting` (syntax highlighting)

Always update submodules after pulling: `git submodule update --init --recursive`

## Development Notes

### Important Assumptions

**CRITICAL: Always assume `install.sh` has been run and all tools are installed.**

- **Never add fallback logic** in Zsh configuration files
- **Never check if commands exist** with `command -v` or `which`
- Tools are guaranteed to be present after running `install.sh`
- If a tool is missing, the configuration should fail fast (helps with debugging)

**Example - DON'T do this:**

```zsh
# ❌ BAD - Never add fallback logic
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
else
    # fallback to old tool
fi
```

**Example - DO this:**

```zsh
# ✅ GOOD - Assume tool is installed
eval "$(zoxide init zsh)"
```

### Adding New Dotfiles

1. Add file starting with `.` to repository root or first-level subfolder
2. Add to `.dotignore` if it should not be symlinked
3. Run `scripts/sh/dotsync.sh` to create symlink in `$HOME`

### Adding Zsh Modules

1. Create numbered directory in `zsh/modules/` (e.g., `75.custom/`)
2. Add `.zsh` files inside (loaded alphabetically)
3. Lower numbers load first (10 → 90)
4. Modules are auto-sourced by `.zshrc`

### Adding Homebrew Packages

Edit `scripts/sh/darwin/apps.sh`:

- Add to `brew_install_from_map()` calls
- Use associative arrays for batch installation
- Categories: core tools, essentials, languages, IDEs, containers, DevOps

**Important: Package Type Convention**

Each package specifies its installation type explicitly using strings:

- `["package"]="formula"` → CLI tool, library, server (via `brew install`)
- `["package"]="cask"` → GUI application with .app bundle (via `brew install --cask`)

**All packages in the list WILL be installed** - the value only determines the installation method.

Examples:

```bash
declare -A essential_tools=(
    ["helix"]="formula"      # ✓ Installs via: brew install helix
    ["ripgrep"]="formula"    # ✓ Installs via: brew install ripgrep
    ["zoxide"]="formula"     # ✓ Installs via: brew install zoxide
)

declare -A development_IDEs=(
    ["cursor"]="cask"        # ✓ Installs via: brew install --cask cursor
    ["bruno"]="cask"         # ✓ Installs via: brew install --cask bruno
    ["ghostty"]="cask"       # ✓ Installs via: brew install --cask ghostty
)

declare -A terminal_stuff=(
    ["ghostty"]="cask"       # GUI app
    ["kitty"]="cask"         # GUI app
    ["starship"]="formula"   # CLI tool
    ["macchina"]="formula"   # CLI tool
)
```

**How to determine which to use:**

- CLI tools, libraries, servers → `"formula"`
- GUI applications with .app bundles → `"cask"`
- Fonts → `"cask"` (use homebrew-cask-fonts tap)

**To skip a package:** Remove it from the array entirely

**Legacy Support:** The function still accepts `true`/`false` for backward compatibility:

- `false` → treated as `"formula"`
- `true` → treated as `"cask"`

### Using Modern Shell Tools

**zoxide** (Smarter cd):

```bash
z dotfiles        # Jump to ~/project/dotfiles
zi                # Interactive directory picker (fuzzy find)
z -             # Go to previous directory
```

**atuin** (Magical history):

```bash
Ctrl+R            # Interactive fuzzy history search
Up Arrow          # Smart history navigation
atuin search git  # Search history for 'git' commands
atuin sync        # Sync history across machines (optional)
```

**direnv** (Auto-load environment):

```bash
# Create .envrc in project directory:
echo 'export DATABASE_URL=postgres://localhost/mydb' > .envrc
direnv allow .    # Approve the .envrc file
cd ..             # Variables unloaded
cd project        # Variables auto-loaded
```

**xh** (HTTP client):

```bash
xh GET https://api.github.com/users/cdrolet
xh POST https://httpbin.org/post name=value --json
xh --download https://example.com/file.zip
```

### Modifying macOS Defaults

Edit `scripts/sh/darwin/system.sh`:

- Uses `defaults write` commands for system preferences
- Organized by app/component: Dock, Finder, Safari, etc.
- Changes may require logout/restart

### Testing Changes

Always use `--dry-run` flag first:

```bash
scripts/sh/install.sh --dry-run --verbose=2
```

This previews all changes without applying them.

## macOS-Specific Tools

The repository installs and configures several macOS-specific tools:

- **Aerospace**: Tiling window manager (alternative to yabai)
- **skhd**: Simple hotkey daemon for window/space navigation
- **SketchyBar**: Customizable status bar replacement
- **Borders**: Window border decoration utility
- **Ghostty**: Modern terminal emulator

Configuration files are in `.config/` and automatically symlinked by `dotsync.sh`.

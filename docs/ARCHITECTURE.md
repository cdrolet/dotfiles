# Script Architecture

**Date:** October 20, 2025  
**Goal:** OS-agnostic main scripts with OS-specific delegation

---

## Architecture Overview

The dotfiles use a **layered architecture** where main scripts are OS-agnostic and delegate to OS-specific implementations:

```
┌─────────────────────────────────────────────────────────────┐
│                     Main Scripts (OS-Agnostic)              │
│  scripts/sh/install.sh, update.sh, dotsync.sh              │
│  • Argument parsing                                         │
│  • OS detection                                             │
│  • Cross-platform operations                                │
│  • Delegates to OS-specific scripts                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ├─ darwin? ──┐
                              ├─ linux?  ──┤
                              └─ other?  ──┘
                                          │
┌─────────────────────────────────────────────────────────────┐
│                   OS-Specific Scripts                       │
│  scripts/sh/darwin/install.sh, update.sh                   │
│  scripts/sh/linux/install.sh, update.sh (if needed)        │
│  • Platform-specific package managers (brew, apt, etc)     │
│  • Platform-specific tools (Xcode, etc)                    │
│  • Platform-specific configurations                        │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Utility Libraries                        │
│  scripts/sh/lib/_*.sh                                       │
│  scripts/sh/darwin/_*.sh                                    │
│  • Shared functions                                         │
│  • UI helpers                                               │
│  • Installation utilities                                   │
└─────────────────────────────────────────────────────────────┘
```

---

## File Structure

```
scripts/sh/
├── install.sh            # Main installer (OS-agnostic)
├── update.sh             # Main updater (OS-agnostic)  ✨ NEW STRUCTURE
├── dotsync.sh            # Dotfile syncer (OS-agnostic)
│
├── lib/                  # Shared libraries
│   ├── _bootstrap.sh     # Loads all libraries
│   ├── _common.sh        # Common constants
│   ├── _ui.sh            # Terminal UI functions
│   ├── _commands.sh      # Command execution
│   ├── _utils.sh         # General utilities
│   ├── _errors.sh        # Error handling
│   ├── _time.sh          # Timing utilities
│   ├── _git.sh           # Git operations
│   ├── _fonts.sh         # Font installation
│   └── _dotsync.sh       # Dotfile sync logic
│
└── darwin/               # macOS-specific
    ├── install.sh        # macOS installation
    ├── update.sh         # macOS updates ✨ NEW
    ├── apps.sh           # App installation
    ├── system.sh         # System defaults
    ├── set-defaults.sh   # Default apps
    ├── _install_utilities.sh  # Brew helpers
    ├── _dock_utilities.sh     # Dock configuration
    └── _default_utilities.sh  # Defaults helpers
```

---

## Script Responsibilities

### Main Scripts (OS-Agnostic)

#### `install.sh`
**Purpose:** Entry point for system setup

**Responsibilities:**
- ✅ Parse command-line arguments
- ✅ Detect OS (`darwin`, `linux`, etc.)
- ✅ Load bootstrap libraries
- ✅ Delegate to `$OS_NAME/install.sh`
- ✅ Handle git repository setup
- ✅ Sync dotfiles
- ✅ Cleanup variables

**Does NOT:**
- ❌ Install packages directly
- ❌ Configure macOS-specific settings
- ❌ Use Homebrew or other package managers

#### `update.sh` ✨ NEW STRUCTURE
**Purpose:** Entry point for system updates

**Responsibilities:**
- ✅ Parse command-line arguments
- ✅ Detect OS (`darwin`, `linux`, etc.)
- ✅ Load bootstrap libraries
- ✅ Delegate to `$OS_NAME/update.sh`
- ✅ Update dotfiles repository
- ✅ Re-sync dotfiles
- ✅ Cleanup variables

**Does NOT:**
- ❌ Update packages directly
- ❌ Run OS-specific update commands
- ❌ Generate OS-specific backups

#### `dotsync.sh`
**Purpose:** Sync dotfiles to home directory

**Responsibilities:**
- ✅ Find dotfiles in repository
- ✅ Create symlinks to `$HOME`
- ✅ Handle conflicts and backups
- ✅ Platform-agnostic

---

### OS-Specific Scripts

#### `darwin/install.sh`
**Purpose:** macOS-specific installation

**Responsibilities:**
- ✅ Source `apps.sh` (install applications)
- ✅ Source `system.sh` (configure system)
- ✅ Run `set-defaults.sh` (set default apps)
- ✅ Load environment-specific configs
- ✅ Generate Brewfile backup

**Calls:**
- `apps.sh` → Homebrew packages, casks, fonts
- `system.sh` → macOS defaults, Dock, settings
- `generate_brewfile()` → Create backup

#### `darwin/update.sh` ✨ NEW
**Purpose:** macOS-specific updates

**Responsibilities:**
- ✅ Update Homebrew formulae and casks
- ✅ Update Xcode Command Line Tools
- ✅ Update SDKMAN
- ✅ Check for macOS system updates
- ✅ Regenerate Brewfile backup with new versions

**Uses:**
- `brew update/upgrade` → Package updates
- `softwareupdate` → macOS system updates
- `generate_brewfile()` → Updated backup

---

## Data Flow

### Installation Flow

```
User runs: ./scripts/sh/install.sh

1. install.sh (main)
   ├─ Parse arguments (--verbose, --dry-run, etc.)
   ├─ Load _bootstrap.sh → Load all libraries
   ├─ Detect OS → darwin
   └─ Delegate to darwin/install.sh
   
2. darwin/install.sh
   ├─ Source apps.sh
   │  ├─ Install Homebrew
   │  ├─ Install packages via brew_install_from_map()
   │  └─ Install fonts
   ├─ Source system.sh
   │  ├─ Configure Dock
   │  ├─ Set macOS defaults
   │  └─ Configure startup items
   ├─ Run set-defaults.sh
   │  └─ Set default applications (duti)
   └─ Generate backup/Brewfile
   
3. Back to install.sh (main)
   ├─ Configure git
   ├─ Sync dotfiles → dotsync.sh
   └─ Cleanup & exit
```

### Update Flow ✨ NEW

```
User runs: ./scripts/sh/update.sh

1. update.sh (main)
   ├─ Parse arguments (--verbose, --dry-run, etc.)
   ├─ Load _bootstrap.sh → Load all libraries
   ├─ Detect OS → darwin
   └─ Delegate to darwin/update.sh
   
2. darwin/update.sh
   ├─ Update Homebrew
   │  ├─ brew update (refresh formulae database)
   │  ├─ brew upgrade (upgrade packages)
   │  ├─ brew upgrade --cask (upgrade apps)
   │  └─ brew cleanup (remove old versions)
   ├─ Update Xcode CLI tools
   ├─ Update SDKMAN (if installed)
   ├─ Check for macOS updates
   └─ Generate backup/Brewfile (with new versions)
   
3. Back to update.sh (main)
   ├─ Pull dotfiles repository updates
   ├─ Update git submodules
   ├─ Re-sync dotfiles
   └─ Show summary & cleanup
```

---

## Variable Scoping

### Main Script Variables

| Variable | Scope | Purpose | Unset |
|----------|-------|---------|-------|
| `SCRIPT_DIR` | Main scripts | Points to `scripts/sh/` | ✅ |
| `DOTFILES_ROOT` | Main scripts | Points to repo root | ✅ |
| `OS_NAME` | Main scripts | Detected OS (`darwin`, `linux`) | ❌ (needed by delegation) |

### OS-Specific Variables

| Variable | Scope | Purpose | Unset |
|----------|-------|---------|-------|
| `OS_SCRIPT_DIR` | OS scripts | Points to `scripts/sh/darwin/` | ✅ |
| `APP_SCRIPT_DIR` | `apps.sh` | Points to `scripts/sh/` | ✅ |
| `SYSTEM_SCRIPT_DIR` | `system.sh` | Points to `scripts/sh/` | ✅ |

### Library Variables

| Variable | Scope | Purpose | Unset |
|----------|-------|---------|-------|
| `LIBRARY_PATH` | `_bootstrap.sh` only | Points to `scripts/sh/lib/` | ✅ |

---

## Benefits of This Architecture

### ✅ Separation of Concerns
- Main scripts handle orchestration
- OS scripts handle platform specifics
- Libraries provide shared utilities

### ✅ Extensibility
Easy to add support for new platforms:
```bash
mkdir -p scripts/sh/linux
cp scripts/sh/darwin/install.sh scripts/sh/linux/install.sh
# Adapt for apt/yum/pacman instead of brew
```

### ✅ Maintainability
- Changes to macOS-specific code don't affect main scripts
- Main scripts don't need OS-specific conditionals
- Each script has a single, clear purpose

### ✅ Testability
Can test OS-specific scripts independently:
```bash
# Test macOS installation without running main script
./scripts/sh/darwin/install.sh

# Test macOS updates
./scripts/sh/darwin/update.sh
```

### ✅ DRY (Don't Repeat Yourself)
- Main scripts share argument parsing
- OS scripts share utilities via libraries
- No duplication between install and update



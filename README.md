# Dotfiles

> Modern macOS development environment configuration with automated setup

[![macOS](https://img.shields.io/badge/macOS-000000?style=flat&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Zsh](https://img.shields.io/badge/Shell-Zsh-1A2C34?style=flat&logo=gnu-bash&logoColor=white)](https://www.zsh.org/)
[![Homebrew](https://img.shields.io/badge/Package_Manager-Homebrew-FBB040?style=flat&logo=homebrew&logoColor=black)](https://brew.sh/)

## ✨ Features

- 🚀 **Automated Setup** - One command to install everything
- 🔄 **Symlink Management** - Safe dotfile synchronization with backup
- 🎨 **Modern Tools** - Rust-based CLI tools (ripgrep, fd, bat, eza, zoxide)
- ⚡ **Fast Shell** - Modular Zsh configuration with optimized loading
- 🎯 **macOS Optimized** - System defaults, Dock, and app configurations
- 🔧 **Developer Ready** - Git, SDKs, IDEs, and language tools pre-configured

## 📦 What's Included

### Modern CLI Tools (Rust-based)
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smarter cd command (frecency-based directory jumping)
- **[atuin](https://github.com/atuinsh/atuin)** - Magical shell history with search and sync
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - Ultra-fast recursive search
- **[fd](https://github.com/sharkdp/fd)** - Modern find replacement
- **[bat](https://github.com/sharkdp/bat)** - Cat with syntax highlighting
- **[eza](https://github.com/eza-community/eza)** - Modern ls replacement
- **[delta](https://github.com/dandavison/delta)** - Beautiful git diffs
- **[procs](https://github.com/dalance/procs)** - Modern ps replacement
- **[xh](https://github.com/ducaale/xh)** - Fast HTTP client

### Applications & IDEs
- **Terminal**: Ghostty
- **Editor**: Helix (hx)
- **IDEs**: Cursor, Zed, IntelliJ IDEA
- **Window Manager**: AeroSpace (tiling)
- **Status Bar**: SketchyBar
- **Git UI**: Lazygit
- **Browser**: Zen Browser

### Configuration
- **Shell**: Zsh with modular configuration
- **Prompt**: Starship
- **Multiplexer**: Tmux (optional)
- **Theme**: Nord (consistent across tools)

## 🚀 Quick Start

### Prerequisites
- macOS (Ventura or later recommended)
- Command Line Tools (will be installed automatically)
- Internet connection

### Installation

#### Quick Install (Recommended)

```bash
# One-liner installation
curl -fsSL https://raw.githubusercontent.com/cdrolet/dotfiles/main/install | bash
```

This will:
- Install Command Line Tools (if needed)
- Clone the repository to `~/project/dotfiles`
- Run the full installation script

#### Manual Install

```bash
# Clone the repository
git clone https://github.com/cdrolet/dotfiles.git ~/project/dotfiles
cd ~/project/dotfiles

# Run the installer
./scripts/sh/install.sh
```

The installer will:
1. Install Homebrew and essential tools
2. Install applications and development tools
3. Configure macOS system defaults
4. Set up Git configuration
5. Sync dotfiles to your home directory
6. Create a Brewfile backup

### Installation Options

```bash
# Preview changes without applying
./scripts/sh/install.sh --dry-run

# Non-interactive mode (for CI/CD)
./scripts/sh/install.sh --skip-confirmation

# Verbose output for debugging
./scripts/sh/install.sh --verbose=2

# Quiet mode (minimal output)
./scripts/sh/install.sh --quiet
```

## 📚 Documentation

- **[Installation Guide](docs/INSTALLATION.md)** - Detailed installation instructions
- **[Usage Guide](docs/USAGE.md)** - Daily commands and workflows
- **[Architecture](docs/ARCHITECTURE.md)** - Technical design and structure
- **[Configuration](docs/CONFIGURATION.md)** - Customization guide
- **[Tools Reference](docs/TOOLS.md)** - Tool documentation and tips
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions
- **[Contributing](docs/CONTRIBUTING.md)** - How to contribute

## 🔄 Updating

```bash
# Update everything (Homebrew, macOS, dotfiles, submodules)
./scripts/sh/update.sh

# Preview updates without applying
./scripts/sh/update.sh --dry-run

# Update specific components
brew update && brew upgrade        # Homebrew packages only
git submodule update --remote      # Zsh plugins only
```

## 🎯 Key Commands

| Command | Purpose |
|---------|---------|
| `./scripts/sh/install.sh` | Full system installation |
| `./scripts/sh/update.sh` | Update all components |
| `./scripts/sh/dotsync.sh` | Sync dotfiles only |
| `./scripts/sh/darwin/set-defaults.sh` | Set default applications |
| `z <directory>` | Jump to directory (zoxide) |
| `zi` | Interactive directory picker |
| `Ctrl+R` | Search command history (atuin) |
| `lg` | Launch lazygit |
| `hx` | Open Helix editor |

## 🗂️ Repository Structure

```
dotfiles/
├── .config/              # Application configurations
│   ├── aerospace/        # Tiling window manager
│   ├── atuin/           # Shell history
│   ├── ghostty/         # Terminal emulator
│   ├── helix/           # Text editor
│   ├── lazygit/         # Git UI
│   ├── starship/        # Shell prompt
│   └── zsh/             # Zsh-specific configs
├── git/                 # Git configuration
│   ├── .gitconfig       # Git settings
│   └── .gitignore_global # Global gitignore
├── zsh/                 # Zsh modules
│   └── modules/         # Modular configuration
│       ├── 10.environment/  # Core environment
│       ├── 40.completion/   # Completions
│       ├── 50.tools/        # Tool-specific configs
│       ├── 60.syntax/       # Syntax highlighting
│       ├── 62.history/      # History configuration
│       └── 80.os/           # OS-specific settings
├── scripts/sh/          # Installation scripts
│   ├── install.sh       # Main installer
│   ├── update.sh        # Main updater
│   ├── dotsync.sh       # Dotfile syncer
│   ├── lib/            # Shared libraries
│   └── darwin/         # macOS-specific scripts
├── backup/              # Auto-generated backups
│   └── Brewfile        # Package snapshot with versions
└── docs/               # Documentation
```

## 🎨 Customization

### Adding New Dotfiles
1. Add file starting with `.` to repository root
2. Run `./scripts/sh/dotsync.sh` to create symlink
3. Optional: Add to `.dotignore` to exclude from syncing

### Adding Homebrew Packages
Edit `scripts/sh/darwin/apps.sh`:

```bash
declare -A my_tools=(
    ["tool-name"]="formula"   # CLI tool
    ["app-name"]="cask"       # GUI application
)
brew_install_from_map my_tools "My Tools"
```

### Adding Zsh Modules
1. Create directory: `zsh/modules/75.custom/`
2. Add `.zsh` files inside
3. Modules load alphabetically (10 → 90)

See [Configuration Guide](docs/CONFIGURATION.md) for more details.

## 🛠️ Troubleshooting

### Command Not Found After Installation
```bash
# Reload shell configuration
source ~/.zshrc
```

### Symlink Issues
```bash
# Re-run dotfile sync
./scripts/sh/dotsync.sh
```

### Homebrew Issues
```bash
# Reset Homebrew
brew update && brew doctor
```

For more help, see [Troubleshooting Guide](docs/TROUBLESHOOTING.md).

## 🔒 Security

- Work-specific configurations excluded via `.dotignore`
- No sensitive data committed to repository
- Global gitignore prevents accidental commits
- Safe backup before symlink operations

## 📊 System Requirements

- **OS**: macOS 13 (Ventura) or later
- **Disk Space**: ~5GB (applications + tools)
- **RAM**: 8GB minimum (16GB recommended)
- **Internet**: Required for initial setup

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](docs/CONTRIBUTING.md) for details.

## 📝 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

Built with inspiration from the dotfiles community and modern tool authors.

## 📮 Contact

- **GitHub**: [@cdrolet](https://github.com/cdrolet)
- **Issues**: [GitHub Issues](https://github.com/cdrolet/dotfiles/issues)

---

**Note**: This dotfiles repository is designed for macOS. Linux support may be added in the future.

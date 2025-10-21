# Contributing Guide

Thank you for considering contributing to this dotfiles repository!

## Overview

This is a personal dotfiles repository, but contributions that improve the setup, fix bugs, or enhance documentation are welcome.

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. **Check existing issues** first
2. **Create a new issue** with:
   - Clear title
   - Description of the problem
   - Steps to reproduce
   - System information (macOS version, etc.)
   - Expected vs actual behavior

### Suggesting Improvements

For feature requests or improvements:

1. **Open a discussion** or issue
2. **Explain the use case**
3. **Provide examples** if possible

### Contributing Code

#### Setup Development Environment

```bash
# Fork the repository
# Clone your fork
git clone https://github.com/YOUR-USERNAME/dotfiles.git ~/project/dotfiles-dev
cd ~/project/dotfiles-dev

# Test without affecting your main setup
./scripts/sh/install.sh --dry-run
```

#### Making Changes

1. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow existing code style
   - Add comments for complex logic
   - Update documentation if needed

3. **Test thoroughly**
   ```bash
   # Test installation
   ./scripts/sh/install.sh --dry-run --verbose=3

   # Test specific components
   ./scripts/sh/darwin/apps.sh
   ./scripts/sh/dotsync.sh

   # Test in clean shell
   zsh -l
   ```

4. **Commit changes**
   ```bash
   git add .
   git commit -m "feat: add feature description"
   ```

5. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   # Open Pull Request on GitHub
   ```

## Code Style

### Shell Scripts

- Use `#!/usr/bin/env bash` shebang
- 4-space indentation
- Clear variable names
- Add comments for non-obvious code
- Use consistent section headers:

```bash
##############################################################
# SECTION NAME
##############################################################
```

### Zsh Configuration

- Use `.zsh` extension for modules
- Place in appropriate numbered directory
- Follow existing patterns
- Document new functions/aliases

### Documentation

- Use Markdown format
- Clear headings and structure
- Include code examples
- Update table of contents
- Link to related docs

## Testing

Before submitting:

- [ ] Scripts run without errors
- [ ] Changes work on fresh macOS install (if possible)
- [ ] Documentation is updated
- [ ] No sensitive data committed
- [ ] Dry-run mode works correctly

### Test Checklist

```bash
# Installation test
./scripts/sh/install.sh --dry-run

# Individual component tests
./scripts/sh/darwin/apps.sh --dry-run
./scripts/sh/darwin/system.sh --dry-run
./scripts/sh/dotsync.sh

# Shell configuration test
zsh -n ~/.zshrc  # Check syntax
zsh -l           # Test loading

# Update test
./scripts/sh/update.sh --dry-run
```

## What to Contribute

### Welcome Contributions

- **Bug fixes**: Errors in scripts or configurations
- **Documentation**: Improvements, clarifications, examples
- **Performance**: Optimization of shell startup or scripts
- **Compatibility**: Support for different macOS versions
- **Tool updates**: Adding new useful tools

### Consider First

- **Personal preferences**: Color schemes, specific apps
- **Breaking changes**: Discuss before implementing
- **Large refactors**: Open issue to discuss approach

## Architecture Guidelines

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed technical design.

Key principles:

1. **OS-agnostic main scripts** - Keep main scripts platform-independent
2. **Modular design** - One module per concern
3. **Safe defaults** - Dry-run mode, confirmations, backups
4. **Clear separation** - Installation, configuration, and syncing are separate

## Documentation Guidelines

When adding or modifying documentation:

1. **Update README.md** if adding major features
2. **Update relevant docs/** files
3. **Add inline code comments** for complex logic
4. **Include examples** where helpful
5. **Link between documents** for related topics

### Documentation Structure

```
docs/
├── INSTALLATION.md     # Setup instructions
├── USAGE.md            # Daily workflows
├── ARCHITECTURE.md     # Technical design
├── CONFIGURATION.md    # Customization guide
├── TOOLS.md           # Tool reference
├── TROUBLESHOOTING.md # Common issues
└── CONTRIBUTING.md    # This file
```

## Commit Message Guidelines

Use conventional commits format:

```
type(scope): description

[optional body]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, etc.)
- `refactor`: Code change that neither fixes nor adds feature
- `perf`: Performance improvement
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(zsh): add custom keybinding for directory navigation
fix(install): resolve Homebrew permission issue
docs(readme): add troubleshooting section
refactor(scripts): simplify error handling in install.sh
```

## Questions?

- **General questions**: Open a [Discussion](https://github.com/cdrolet/dotfiles/discussions)
- **Bug reports**: Open an [Issue](https://github.com/cdrolet/dotfiles/issues)
- **Feature requests**: Open an [Issue](https://github.com/cdrolet/dotfiles/issues) with "enhancement" label

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

## Thank You!

Every contribution, no matter how small, is appreciated! 🙏

---

**Happy contributing!** 🚀


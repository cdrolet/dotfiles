# Zsh Configuration Documentation

This directory contains Zsh configuration documentation and reference materials.

## Files

### KEYBINDINGS.md
Quick reference guide for custom Zsh Line Editor (ZLE) keybindings.

**View it:**
```bash
bat ~/.config/zsh/KEYBINDINGS.md
```

**Or use the built-in command:**
```bash
lskeys
```

## Related Zsh Modules

The actual keybinding configuration is located at:
- **Bindings:** `~/project/dotfiles/zsh/modules/64.editor/bindings.zsh`
- **Functions:** `~/project/dotfiles/zsh/modules/64.editor/functions.zsh`

## Quick Start

Learn the top 5 most useful shortcuts:

1. `Ctrl+X Ctrl+S` - Insert sudo at start of line
2. `Ctrl+R` - Search history (Atuin)
3. `Ctrl+A` / `Ctrl+E` - Jump to line start/end
4. `Ctrl+U` / `Ctrl+K` - Delete line / delete to end
5. `Ctrl+Y` - Erase backward to slash (path editing)

See KEYBINDINGS.md for complete reference with examples.

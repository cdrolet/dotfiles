# Zsh Keybindings Quick Reference

*Custom keybindings defined in `zsh/modules/64.editor/bindings.zsh`*

Type `lskeys` in your terminal to see the complete list.

---

## 🔥 Most Useful Shortcuts

### Power Features

| Shortcut | Action | Example |
|----------|--------|---------|
| `Ctrl+X Ctrl+S` | **Insert sudo at start** | `apt update` → `sudo apt update` |
| `Ctrl+Q` | **Push line** (save, run other cmd, restore) | Save long command, check something, continue |
| `Ctrl+Y` | **Erase backward to slash** | `/path/to/file` → `/path/to/` |
| `Esc M` | **Duplicate previous word** | `cp file.txt ` → `cp file.txt file.txt` |
| `Space` after `!` | **Expand history reference** | `!cmd ` → expands the command |

---

## 📝 Editing

### Line Navigation
| Shortcut | Action |
|----------|--------|
| `Ctrl+A` | Jump to **beginning of line** |
| `Ctrl+E` | Jump to **end of line** |
| `Home` / `End` | Jump to line start/end |
| `Esc B` | Jump **one word backward** |
| `Esc F` | Jump **one word forward** |

### Deletion
| Shortcut | Action |
|----------|--------|
| `Ctrl+U` | **Erase entire line** |
| `Ctrl+K` | **Erase to end of line** |
| `Esc K` | **Erase to beginning of line** |
| `Ctrl+W` | **Erase one word backward** |
| `Esc D` | **Erase one word forward** |
| `Ctrl+Y` | **Erase backward to slash** (path editing) |

### Undo/Redo
| Shortcut | Action |
|----------|--------|
| `Ctrl+X Ctrl+U` | **Undo** |
| `Ctrl+X Ctrl+R` | **Redo** |

---

## 🔍 History

### Search & Navigation
| Shortcut | Action | Tool |
|----------|--------|------|
| `Ctrl+R` | **Interactive history search** | Atuin (fuzzy search) |
| `Up` / `Ctrl+P` | **History substring search up** | Prefix matching |
| `Down` / `Ctrl+N` | **History substring search down** | Prefix matching |
| `Ctrl+O` | **Execute and load next history line** | - |

### Completion
| Shortcut | Action |
|----------|--------|
| `Ctrl+X Ctrl+X` | **Complete from history** |
| `Ctrl+I` / `Tab` | **Complete with indicator** |
| `Ctrl+Space` (in menu) | **Go to subdirectory** |

---

## 🛠️ Advanced

| Shortcut | Action |
|----------|--------|
| `Esc E` | **Expand command to full path** |
| `Ctrl+X Ctrl+]` | **Match bracket** |
| `Ctrl+L` | **Clear screen** |

---

## 💡 Pro Tips

### 1. Forgot `sudo`?
```bash
$ apt update
[Permission denied]
# Press: Ctrl+X Ctrl+S
$ sudo apt update  # ✨ Magic!
```

### 2. Edit Long Paths Quickly
```bash
$ cd /very/long/path/to/some/directory
# Press Ctrl+Y repeatedly to remove path segments
$ cd /very/long/path/to/some/
$ cd /very/long/path/to/
$ cd /very/long/path/
```

### 3. Duplicate Arguments
```bash
$ mv document.txt 
# Press: Esc M
$ mv document.txt document.txt
# Now edit the second one
$ mv document.txt document-backup.txt
```

### 4. Complex Command? Save It!
```bash
$ kubectl get pods --all-namespaces --field-selector status.phase=Running | grep...
# Press: Ctrl+Q (saves the line)
$ kubectl get nodes  # Check something else
[Output appears]
# Original line is restored automatically!
$ kubectl get pods --all-namespaces --field-selector status.phase=Running | grep...
```

### 5. History Expansion
```bash
$ ls -la /etc/nginx/sites-available
$ vim !$  # !$ = last argument
# Press Space after !$ to see expansion
$ vim /etc/nginx/sites-available  # ✨ Expanded!
```

---

## 🎯 Muscle Memory Shortcuts (Most Used)

**Top 5 to memorize first:**

1. **`Ctrl+X Ctrl+S`** - Insert sudo (you'll use this constantly)
2. **`Ctrl+R`** - Search history (Atuin)
3. **`Ctrl+A` / `Ctrl+E`** - Jump to line start/end
4. **`Ctrl+U` / `Ctrl+K`** - Delete line / delete to end
5. **`Ctrl+Y`** - Erase to slash (path editing)

---

## 🔗 Related Commands

- **`lskeys`** - Show all custom keybindings
- **`bindkey`** - List all Zsh keybindings
- **`man zshzle`** - Full Zsh Line Editor documentation

---

**Configuration:** `~/project/dotfiles/zsh/modules/64.editor/bindings.zsh`

# Lazygit - Terminal UI for Git

Lazygit is a beautiful, interactive Git client that runs in your terminal.

## Quick Start

```bash
# Launch lazygit in current repository
lazygit

# Or add alias to your shell
alias lg='lazygit'
```

## Why Use Lazygit?

Instead of typing multiple Git commands, you get an interactive visual interface:

**Before (CLI):**
```bash
git status
git add file1.txt
git add file2.txt
git commit -m "Update files"
git push
```

**After (Lazygit):**
1. Type `lazygit`
2. Press `Space` to stage files
3. Press `c` to commit
4. Press `P` to push
5. Done! 🚀

## Essential Keybindings

### Navigation
- `j/k` or `↑/↓` - Move up/down
- `h/l` or `←/→` - Switch between panels
- `1-5` - Jump to specific panel
- `Tab` - Cycle through panels

### Files Panel
- `Space` - Stage/unstage file
- `a` - Stage/unstage all
- `c` - Commit staged changes
- `A` - Amend last commit
- `d` - Discard changes
- `e` - Edit file
- `o` - Open file

### Branches Panel
- `n` - New branch
- `Space` - Checkout branch
- `M` - Merge into current branch
- `r` - Rebase branch
- `d` - Delete branch

### Commits Panel
- `s` - Squash commit down
- `r` - Reword commit
- `d` - Drop commit
- `e` - Edit commit
- `p` - Pick commit (for rebase)
- `f` - Fixup commit
- `Space` - Checkout commit

### Universal
- `q` - Quit
- `?` - Help menu
- `P` - Push
- `p` - Pull
- `R` - Refresh
- `x` - Options menu
- `:` - Execute custom git command

## Panels Overview

Lazygit has 5 main panels:

1. **Status** - Repository overview, recent repos
2. **Files** - Working directory changes
3. **Branches** - Local and remote branches
4. **Commits** - Commit history
5. **Stash** - Stashed changes

## Advanced Features

### Interactive Rebase
1. Go to Commits panel
2. Select commit to start from
3. Press `i` to start interactive rebase
4. Use `j/k` to navigate, `s` to squash, `d` to drop
5. Press `Enter` to continue

### Cherry-pick
1. Go to Commits panel
2. Press `c` on commit to copy
3. Switch branch
4. Press `v` to paste (cherry-pick)

### Resolve Merge Conflicts
1. Lazygit detects conflicts automatically
2. Press `Space` on conflicted file
3. Choose: Ours, Theirs, or Manual edit
4. Stage and commit

### Custom Git Commands
Press `:` and type any git command:
```
:reflog
:cherry-pick abc123
:reset --soft HEAD~1
```

## Configuration

Our config includes:
- **Nord theme** - Matches your terminal
- **Delta integration** - Beautiful diffs
- **Helix editor** - Opens in `hx`
- **Auto-fetch** - Keeps branches up to date

Config location: `~/.config/lazygit/config.yml`

## Tips

1. **Learn by doing** - Press `?` for help anytime
2. **Options menu** - Press `x` for context-specific options
3. **Filter files** - Type `/` to search/filter
4. **Diff view** - Select file and see full diff in main panel
5. **Undo** - Press `z` to undo last action

## Common Workflows

### Quick Commit & Push
```
lazygit
→ Space (stage files)
→ c (commit)
→ Type message
→ P (push)
→ q (quit)
```

### Fix Last Commit
```
lazygit
→ Space (stage new changes)
→ A (amend)
→ Edit message or Enter
→ P (force push if needed)
```

### Create Feature Branch
```
lazygit
→ Tab to Branches
→ n (new branch)
→ Type name
→ Work on changes...
→ P (push)
```

### Squash Last 3 Commits
```
lazygit
→ Tab to Commits
→ Navigate to 4th commit from top
→ i (interactive rebase)
→ Select commits, press s (squash)
→ Enter to continue
→ Edit message
```

## Comparison with CLI

| Task | CLI Commands | Lazygit |
|------|-------------|---------|
| Stage & commit | `git add .` + `git commit -m "msg"` | `Space` + `c` |
| Amend commit | `git add .` + `git commit --amend` | `Space` + `A` |
| Interactive rebase | `git rebase -i HEAD~3` (complex) | `i` (visual) |
| Cherry-pick | `git cherry-pick abc123` | `c` + `v` |
| View history | `git log --graph` | Built-in |

## Resources

- Press `?` inside lazygit for full help
- Official docs: https://github.com/jesseduffield/lazygit
- Video tutorials: Search "lazygit tutorial" on YouTube

---

**Pro tip:** Use `lg` alias for quick access: `alias lg='lazygit'`

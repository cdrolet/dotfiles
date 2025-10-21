##############################################################
# FUNCTION
##############################################################


gitAddCommit() {
	echoAndRun git add -A;
	echoAndRun git commit -m "$*";
}

gitAddCommitAmend() {
	echoAndRun git add -A;
	echoAndRun git commit -m "$*" --amend;
}

gitCommit() {
	echoAndRun git commit -m "$*";
}

gitCurrent() {
	git rev-parse --abbrev-ref HEAD
}

gitPushToCurrent() {
	local currentBranch=$(gitCurrent)
	echoAndRun git push origin $currentBranch
}

gitPullFromCurrent() {
	local currentBranch=$(gitCurrent)
	echoAndRun git pull origin $currentBranch
}

gitRemoveBranch() {
	echoAndRun git branch -d "$*"
}

gitRemoveSub() {
    submodule_name=$(echo "$1" | sed 's/\/$//'); shift

    exit_err() {
      [ $# -gt 0 ] && echo "fatal: $*" 1>&2
      exit 1
    }

    if git submodule status "$submodule_name" >/dev/null 2>&1; then
      git submodule deinit -f "$submodule_name"
      git rm -f "$submodule_name"

      git config -f .gitmodules --remove-section "submodule.$submodule_name"
      if [ -z "$(cat .gitmodules)" ]; then
        git rm -f .gitmodules
      else
        git add .gitmodules
      fi
    else
      exit_err "Submodule '$submodule_name' not found"
    fi
}

##############################################################
# ALIAS
##############################################################

alias lg="lazygit"

alias gitsw='git switch'           # Modern alternative to checkout
alias gitswc='git switch -c'       # Create and switch to branch
alias gitrestore='git restore'     # Discard changes (modern)
alias gitunstage='git restore --staged'  # Unstage files (modern)
alias gitundo='git reset --soft HEAD~1'  # Undo last commit (keep changes)
alias gitlog='git log --oneline --graph --all --decorate'
alias gitamend='git commit --amend --no-edit'  # Quick amend without message change

alias gitfake="echoAndRun git commit --allow-empty -m 'Fake commit'"

# Clone - recursively : init and update all sub modules
alias gitcl="echoAndRun git clone --recursive"

# Commit
alias gitc="gitCommit"

# Commit
alias gitac="gitAddCommit"

# Diff
alias gitdiff="git difftool --no-symlinks --dir-diff"

# Merge
alias gitmerge="git mergetool"

# Pull from main
alias gitplm="echoAndRun git pull origin main"

# Pull from current branch
alias gitpl="gitPullFromCurrent"

# Push
alias gitph="gitPushToCurrent"

# Status
alias gits="echoAndRun git status -sb"

# Branch
alias gitb="echoAndRun git branch -av"
alias gitbtree="echoAndRun git branch --format='%(refname:short) %(upstream:short)' --sort=-committerdate"  # Better branch listing

# Remove
alias gitrm="gitRemoveBranch"

# Update submodules
alias gitupdate="echoAndRun git submodule update --remote"

# switches to "main" branch, updates all local branches using native Git, removes all local branches already merged into 'main'
alias gitmain='git switch main; git pull --rebase --autostash; git branch --merged main | grep -v "\* main" | xargs -n 1 git branch -d; git branch;'

alias gitprune='git switch main; git fetch --prune origin'

alias gitprunefull='git switch main; git fsck; git reflog expire --expire=now --all; git gc --prune=now'

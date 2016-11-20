function gitCommit {
	echoAndRun git add -A;
	echoAndRun git commit -m "$*";
}

function gitCheckout {
	echoAndRun git checkout "$*";
}

function gitCurrent {
	git rev-parse --abbrev-ref HEAD
}

function gitPushToCurrent {
	local currentBranch=$(gitCurrent)
	echoAndRun git push origin $currentBranch
}

function gitPullFromCurrent {
	local currentBranch=$(gitCurrent)
	echoAndRun git pull origin $currentBranch
}

function gitRemoveBranch {
	echoAndRun git branch -d -r "$*"
}

# Clone - recursively : init and update all sub modules
alias gitcl="echoAndRun git clone --recursive"

# Commit
alias gitc="gitCommit"

# Checkout
alias gitco="git checkout develop -b "

# Pull
alias gitpld="echoAndRun git pull origin develop"

alias gitpl="gitPullFromCurrent"

# Push
alias gitph="gitPushToCurrent"

# Status
alias gits="echoAndRun git status -sb"

# Release

# Remove
alias gitrm="gitRemoveBranch"

# Update submodules
alias gitu="echoAndRun git submodule update --remote"

# assumes git-up is installed (gem install git-up)
# switches to 'develop' branch, updates all local branches (nicely using git-up), removes all local branches already merged into 'develop'
alias gitdev='git checkout develop; git-up; git branch --merged develop | grep -v "\* develop" | xargs -n 1 git branch -d; git branch;'

removeSubModule() {
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
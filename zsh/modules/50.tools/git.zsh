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

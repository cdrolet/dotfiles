# Zsh Modules Audit - Recommended Fixes

## Priority 1: Security (CRITICAL)

### Issue: Exposed API tokens in 90.work/common.zsh
**Action:**
1. Add `zsh/modules/90.work/common.zsh` to `.dotignore`
2. Remove it from git tracking: `git rm --cached zsh/modules/90.work/common.zsh`
3. Consider using a secrets manager or `.env` files instead

## Priority 2: Broken/Obsolete Code (HIGH)

### 1. Remove Kitty alias (50.tools/images.zsh)
**Delete entire file** - it only contains one broken Kitty alias

### 2. Fix hardcoded paths (50.tools/java.zsh)
Replace:
```zsh
export JAVA_17_HOME=/Users/cdrolet/.sdkman/candidates/java/17.0.0-tem
export JAVA_21_HOME=/Users/cdrolet/.sdkman/candidates/java/21.0.3-tem
```
With:
```zsh
export JAVA_17_HOME=$HOME/.sdkman/candidates/java/17.0.0-tem
export JAVA_21_HOME=$HOME/.sdkman/candidates/java/21.0.3-tem
```

### 3. Remove Python aliases (90.work/airflow.zsh)
Delete these lines:
```zsh
alias python="/opt/homebrew/bin/python3"
alias pip="/opt/homebrew/bin/pip3"
```
They interfere with virtual environments and are unnecessary.

### 4. Fix 'which' usage (50.tools/clipboard.zsh)
Replace all instances of:
```zsh
which xclip &>/dev/null
which xsel &>/dev/null
```
With:
```zsh
command -v xclip &>/dev/null
command -v xsel &>/dev/null
```

## Priority 3: Cleanup (MEDIUM)

### 1. Remove obsolete memtop function (50.tools/memory.zsh)
**Delete entire file** - conflicts with new `procs` alias and is redundant

### 2. Evaluate curl.zsh (50.tools/curl.zsh)
Consider deleting this file since you now use **xh** for HTTP operations.
If you want to keep it, refactor functions to use xh instead:
```zsh
# Modern alternative using xh
curlheader() {
  if [[ -z "$2" ]]; then
    xh -h GET "$1"
  else
    xh -h GET "$2" | grep "$1:"
  fi
}
```

## Priority 4: Consider Disabling (LOW)

### 1. Work-specific modules (90.work/)
- These contain company-specific configurations
- Consider moving to a separate private repository
- Keep them disabled by default (rename directory or use conditional loading)

### 2. Maven/Gradle configs (50.tools/maven.zsh, 50.tools/gradle.zsh)
- If you don't use Java development regularly, consider disabling
- Heavy color configuration that slows down shell startup

## Summary of Files to Modify/Delete

**Delete:**
- ❌ `50.tools/images.zsh` (broken Kitty alias)
- ❌ `50.tools/memory.zsh` (redundant with procs)
- ❌ `50.tools/curl.zsh` (optional - redundant with xh)

**Modify:**
- ✏️ `50.tools/java.zsh` (fix hardcoded paths)
- ✏️ `50.tools/clipboard.zsh` (replace 'which' with 'command -v')
- ✏️ `90.work/airflow.zsh` (remove Python aliases)

**Secure:**
- 🔒 `90.work/common.zsh` (add to .dotignore, remove from git)
- 🔒 `90.work/tis.zsh` (contains work-specific data)

**Total Impact:**
- Files to delete: 2-3
- Files to modify: 3
- Files to secure: 2
- Estimated cleanup time: ~15 minutes

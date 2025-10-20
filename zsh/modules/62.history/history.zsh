##############################################################
# ENVIRONMENT
##############################################################

# Separate history for root and regular user
if (( ! EUID )); then
    HISTFILE=$ZSH_CACHE/history_root
else
    HISTFILE=$ZSH_CACHE/history
fi

# Big enough to be used with many open shells
SAVEHIST=15000
HISTSIZE=15000

##############################################################
# OPTIONS
##############################################################

# Treat the '!' character specially during expansion.
setopt BANG_HIST

# If this is set, zsh sessions will append their history list to the history file, rather than replace it. Thus, multiple parallel zsh sessions will all have the new entries from their history lists added to the history file, in the order that they were entered. The file will still be periodically re-written to trim it when the number of lines grows 20% beyond the value specified by $SAVEHIST (see also the HIST_SAVE_BY_COPY option).
setopt INC_APPEND_HISTORY

# Save each command’s beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file
setopt EXTENDED_HISTORY

# Add ‘|’ to output redirections in the history. This allows history references to clobber files even when CLOBBER is unset.
setopt HIST_ALLOW_CLOBBER

# Do not enter command lines into the history list if they begin with a blank
setopt HIST_IGNORE_SPACE

# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS

# Do not write a duplicate event to the history file.
setopt HIST_SAVE_NO_DUPS

# Whenever the user enters a line with history expansion, don’t execute the line directly; instead, perform history expansion and reload the line into the editing buffer.
setopt HIST_VERIFY

# Remove the history (fc -l) command from the history when invoked.
setopt HIST_NO_STORE

# Beep when accessing non-existent history.
setopt HIST_BEEP

# Expire a duplicate event first when trimming history.
setopt HIST_EXPIRE_DUPS_FIRST

# This option both imports new commands from the history file, and also causes your typed commands to be appended to the history file. The history lines are also output with timestamps
setopt SHARE_HISTORY

##############################################################
# ALIAS
##############################################################

# Show all history with atuin (searchable, timestamped)
alias h='atuin search --interactive'

# Lists the ten most used commands (using atuin stats)
alias history-stat='atuin stats'

# Clear history.
alias history-clear="rm $HISTFILE"

##############################################################
# ATUIN - MAGICAL SHELL HISTORY
##############################################################

# Initialize atuin (replaces default history search with magic)
eval "$(atuin init zsh)"

# atuin provides:
# - Ctrl+R: Interactive history search with fuzzy finding
# - Up arrow: Smart history navigation
# - Optional sync across machines
# - SQLite-backed searchable history

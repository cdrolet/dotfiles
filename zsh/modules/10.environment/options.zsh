##############################################################
# REFERENCE
##############################################################
# http://zsh.sourceforge.net/Doc/Release/Options.html

##############################################################
# GENERAL
##############################################################

# treat  the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation, etc.  (An initial unquoted ‘~’ always produces named directory expansion.)
setopt EXTENDED_GLOB

# do not allows > redirection to truncate existing files, and >> to create files. >! must be used to truncate a file, and >>! to create a file.
setopt NO_CLOBBER

# Allow brace character class list expansion.
setopt BRACE_CCL

# Combine zero-length punctuation characters (accents) with the base character.
setopt COMBINING_CHARS

# Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
setopt RC_QUOTES

# Don't print a warning message if a mail file has been accessed.
unsetopt MAIL_WARNING

##############################################################
# EDITOR
##############################################################

# if unset, output flow control via start/stop characters (usually assigned to ^S/^Q) is disabled in the shell’s editor,
# so I can reuse these keys for more useful feature
setopt NO_FLOW_CONTROL

# Beep on error in line editor.
setopt BEEP

##############################################################
# JOBS
##############################################################

# List jobs in the long format by default.
setopt LONG_LIST_JOBS

# Attempt to resume existing job before creating a new process.
setopt AUTO_RESUME

# Report status of background jobs immediately.
setopt NOTIFY

# Don't run all background jobs at a lower priority.
unsetopt BG_NICE

# Don't kill jobs on shell exit.
unsetopt HUP

# Don't report on jobs when shell exit.
unsetopt CHECK_JOBS

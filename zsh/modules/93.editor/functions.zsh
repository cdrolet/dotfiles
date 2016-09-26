##############################################################
# FUNCTIONS
##############################################################

# Exposes information about the Zsh Line Editor via the $editor_info associative array.
editor-info() {
  # Clean up previous $editor_info.
  unset editor_info
  typeset -gA editor_info

  if [[ "$KEYMAP" == 'vicmd' ]]; then
    editor_info[keymap]="V" #VI cmd mode
  else
    editor_info[keymap]="P" # Primary mode

    if [[ "$ZLE_STATE" == *overwrite* ]]; then
      editor_info[overwrite]="O"
    else
      editor_info[overwrite]="I"
    fi
  fi

  zle reset-prompt
  zle -R
}
zle -N editor-info

# Updates editor information when the keymap changes.
zle-keymap-select() {
  zle editor-info
}
zle -N zle-keymap-select

# Enables terminal application mode and updates editor information.
zle-line-init() {
  # The terminal must be in application mode when ZLE is active for $terminfo values to be valid.
  if (( $+terminfo[smkx] )); then
    # Enable terminal application mode.
    echoti smkx
  fi

  # Update editor information.
  zle editor-info
}
zle -N zle-line-init

# Disables terminal application mode and updates editor information.
zle-line-finish() {
  # The terminal must be in application mode when ZLE is active for $terminfo values to be valid.
  if (( $+terminfo[rmkx] )); then
    # Disable terminal application mode.
    echoti rmkx
  fi

  # Update editor information.
  zle editor-info
}
zle -N zle-line-finish

# Toggles emacs overwrite mode and updates editor information.
overwrite-mode() {
  zle .overwrite-mode
  zle editor-info
}
zle -N overwrite-mode

# Enters vi insert mode and updates editor information.
vi-insert() {
  zle .vi-insert
  zle editor-info
}
zle -N vi-insert

# Moves to the first non-blank character then enters vi insert mode and updates
# editor information.
vi-insert-bol() {
  zle .vi-insert-bol
  zle editor-info
}
zle -N vi-insert-bol

# Enters vi replace mode and updates editor information.
vi-replace()  {
  zle .vi-replace
  zle editor-info
}
zle -N vi-replace

# Displays an indicator when completing.
expand-or-complete-with-indicator() {
  local indicator
  print -Pn "..."
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-indicator

# Inserts 'sudo ' at the beginning of the line.
prepend-sudo() {
  if [[ "$BUFFER" != su(do|)\ * ]]; then
    BUFFER="sudo $BUFFER"
    (( CURSOR += 5 ))
  fi
}
zle -N prepend-sudo

# delete-to-previous-slash
# http://www.zsh.org/mla/users/2005/msg01314.html
backward-delete-to-slash () {
  local WORDCHARS=${WORDCHARS//\//}
  zle .backward-delete-word
}
zle -N backward-delete-to-slash



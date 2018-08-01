##############################################################
# REFERENCE
##############################################################

# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

##############################################################
# TERM INFO
##############################################################

zmodload zsh/terminfo

# Use human-friendly identifiers.
# -g Global, -A Associative array
typeset -gA key_info
key_info=(
  'Control'      '\C-'
  'ControlLeft'  '\e[1;5D \e[5D \e\e[D \eOd'
  'ControlRight' '\e[1;5C \e[5C \e\e[C \eOc'
  'Escape'       '\e'
  'Meta'         '\M-'
  'Backspace'    "^?"
  'Delete'       "^[[3~"
  'F1'           "$terminfo[kf1]"
  'F2'           "$terminfo[kf2]"
  'F3'           "$terminfo[kf3]"
  'F4'           "$terminfo[kf4]"
  'F5'           "$terminfo[kf5]"
  'F6'           "$terminfo[kf6]"
  'F7'           "$terminfo[kf7]"
  'F8'           "$terminfo[kf8]"
  'F9'           "$terminfo[kf9]"
  'F10'          "$terminfo[kf10]"
  'F11'          "$terminfo[kf11]"
  'F12'          "$terminfo[kf12]"
  'Insert'       "$terminfo[kich1]"
  'Home'         "$terminfo[khome]"
  'PageUp'       "$terminfo[kpp]"
  'End'          "$terminfo[kend]"
  'PageDown'     "$terminfo[knp]"
  'Up'           "$terminfo[kcuu1]"
  'Left'         "$terminfo[kcub1]"
  'Down'         "$terminfo[kcud1]"
  'Right'        "$terminfo[kcuf1]"
  'BackTab'      "$terminfo[kcbt]"
)

# Set empty $key_info values to an invalid UTF-8 sequence to induce silent bindkey failure.
for key in "${(k)key_info[@]}"; do
  if [[ -z "$key_info[$key]" ]]; then
    key_info[$key]='�'
  fi
done

##############################################################
# KEY BINDINGS
##############################################################

# -A associative array
typeset -gA keyReferences
keyReferences=()

function addReference() {
   local description=${1}
   local keys=(${@:2})
   keyReferences+=(${description} "${keys}")
}

function lskeys() {
    # Accessing associative array keys
    for key in ${(@k)keyReferences}; do
      printf '%-32s▐ %s\n' "${key}" "${keyReferences[$key]}"
    done
}

# Jump one word backward/forward
for key in "$key_info[Escape]"{B,b}
  bindkey -M emacs "$key" emacs-backward-word
addReference "Jump one word backward" '[Escape] B'

for key in "$key_info[Escape]"{F,f}
  bindkey -M emacs "$key" emacs-forward-word
addReference "Jump one word forward" '[Escape] F'

# Erase to the beginning of the line.
for key in "$key_info[Escape]"{K,k}
  bindkey -M emacs "$key" backward-kill-line
addReference "Erase to the beginning of line" '[Escape] K'

# Redo.
bindkey -M emacs "$key_info[Control]X$key_info[Control]R" redo
addReference "Redo" '[Control]' X '[Control]' R

# Match bracket
bindkey -M emacs "$key_info[Control]X$key_info[Control]]" vi-match-bracket
addReference "Match bracket" '[Control]' X '[Control]' ']'

# History search
if (( $+widgets[history-incremental-pattern-search-backward] )); then
  bindkey -M emacs "$key_info[Control]R" history-incremental-pattern-search-backward
  bindkey -M emacs "$key_info[Control]S" history-incremental-pattern-search-forward
fi
addReference "History search backward" '[Control]' R
addReference "History search forward" '[Control]' S

# History substring search
bindkey -M emacs "$key_info[Up]" history-substring-search-up
bindkey -M emacs "$key_info[Control]P" history-substring-search-up
addReference "History substring search up" '[Up]' 'or' '[Control]' P

bindkey -M emacs "$key_info[Down]" history-substring-search-down
bindkey -M emacs "$key_info[Control]N" history-substring-search-down
addReference "History substring search down" '[Down]' 'or' '[Control]' N

# Standards - no need for reference
bindkey -M emacs "$key_info[Home]" beginning-of-line
bindkey -M emacs "$key_info[End]" end-of-line

bindkey -M emacs "$key_info[Insert]" overwrite-mode
bindkey -M emacs "$key_info[Delete]" delete-char
bindkey -M emacs "$key_info[Backspace]" backward-delete-char

bindkey -M emacs "$key_info[Left]" backward-char
bindkey -M emacs "$key_info[Right]" forward-char

# Expand history reference
# if you type a space after a command that starts with ! (or ^) to refer to (part of) a previous command,
# that history reference is expanded. If you just type a space, the history reference is expanded when you press Enter.
bindkey -M emacs ' ' magic-space
addReference "Expand history reference" '!cmd' '[Space]'

# Clear screen
bindkey -M emacs "$key_info[Control]L" clear-screen
addReference "Clear screen" '[Control]' L

# Expand command name to full path.
for key in "$key_info[Escape]"{E,e}
  bindkey -M emacs "$key" expand-cmd-path
addReference "Expand command to full path" '[Escape]' E

# Duplicate the previous word.
for key in "$key_info[Escape]"{M,m}
  bindkey -M emacs "$key" copy-prev-shell-word
addReference "Duplicate previous word" '[Escape]' M

# Use a more flexible push-line.
# push-line: clears the prompt and waits for you to type something else.
# After executing this new command, it restores your original prompt.
# push-line-or-edit: in addition to push-line behavior, if you are typing a continuation line of a
# multi-line command, redraws the lines as a single block of text, which allows you to edit anything
# you have typed so far.
for key in "$key_info[Control]Q" "$key_info[Escape]"{q,Q}
  bindkey -M emacs "$key" push-line-or-edit
addReference "Clear, wait, restore" '[Control]' Q

# Insert sudo.
bindkey -M emacs "$key_info[Control]X$key_info[Control]S" prepend-sudo
addReference "Insert sudo" '[Control]' X '[Control]' S

# Erase backward to slash
bindkey -M emacs "$key_info[Control]Y" backward-delete-to-slash
addReference "Erase backward to slash" '[Control]' Y

# Complete with indicator...
bindkey -M emacs "$key_info[Control]I" expand-or-complete-with-indicator
addReference "Complete" '[Control]' I 'or' '[Tab]'

# Complete from history
bindkey -M emacs "$key_info[Control]X$key_info[Control]X" hist-complete
addReference "Complete from history" '[Control]' X '[Control]' X

# defined in completion.zsh
addReference "In menu, go to subdirectory" '[Control]' '[Space]'

# =================================================
#               Built-in
# =================================================

addReference "Undo" '[Control]' X '[Control]' U
addReference "Erase one word forward" '[Escape]' D
addReference "Erase one word backward" '[Control]' W
addReference "Erase entire line" '[Control]' U
addReference "Erase to end of line" '[Control]' K
addReference "Jump to beginning of line" '[Control]' A
addReference "Jump to end of line" '[Control]' E
addReference "Return and next history line" '[Control]' O

# =================================================
#               Not Working
# =================================================

# Bind Shift + Tab to go to the previous menu item.
bindkey -M emacs "$key_info[BackTab]" reverse-menu-complete

# Search previous character.
bindkey -M emacs "$key_info[Control]X$key_info[Control]B" vi-find-prev-char

# =================================================

# use emacs-style zsh bindings
bindkey -e

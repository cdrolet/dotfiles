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

function bindKeyReference() {
    local description=$1
    local functionName=$2
    local keys=(${@:3})
    local allKeys=""

    addReference ${description} "${keys}"

    for key in ${keys[@]}; do
        local k=$key
        if [[ $key == "["* ]]; then
            k=${key//'['/};
            k=${k//']'/}
            k=${key_info[$k]}
        fi
        allkeys+=$k;
    done
    bindkey -M emacs $allkeys $functionName
}

function displayReference() {
    # Accessing associative array keys
    for key in ${(@k)keyReferences}; do
      printf '%-30s▐ %s\n' "${key}" "${keyReferences[$key]}"
    done
}

# Adding Control arrow as additional backward / forward
for key in "$key_info[Escape]"{B,b} "${(s: :)key_info[ControlLeft]}"
  bindkey -M emacs "$key" emacs-backward-word
for key in "$key_info[Escape]"{F,f} "${(s: :)key_info[ControlRight]}"
  bindkey -M emacs "$key" emacs-forward-word

# Kill to the beginning of the line.
for key in "$key_info[Escape]"{K,k}
  bindkey -M emacs "$key" backward-kill-line

# Redo.
bindkey -M emacs "$key_info[Escape]_" redo

# Search previous character.
bindkey -M emacs "$key_info[Control]X$key_info[Control]B" vi-find-prev-char

bindKeyReference "Match bracket" vi-match-bracket '[Control]' X '[Control]' ']'

if (( $+widgets[history-incremental-pattern-search-backward] )); then
  bindkey -M emacs "$key_info[Control]R" history-incremental-pattern-search-backward
  bindkey -M emacs "$key_info[Control]S" history-incremental-pattern-search-forward
fi

bindkey -M emacs "$key_info[Control]P" history-substring-search-up
bindkey -M emacs "$key_info[Control]N" history-substring-search-down

bindkey -M emacs "$key_info[Home]" beginning-of-line
bindkey -M emacs "$key_info[End]" end-of-line

bindkey -M emacs "$key_info[Insert]" overwrite-mode
bindkey -M emacs "$key_info[Delete]" delete-char
bindkey -M emacs "$key_info[Backspace]" backward-delete-char

bindkey -M emacs "$key_info[Left]" backward-char
bindkey -M emacs "$key_info[Right]" forward-char

bindkey -M emacs "$key_info[Up]" history-substring-search-up
bindkey -M emacs "$key_info[Down]" history-substring-search-down


# Expand history on space.
# if you type a space after a command that starts with ! (or ^) to refer to (part of) a previous command,
# that history reference is expanded. If you just type a space, the history reference is expanded when you press Enter.
bindkey -M emacs ' ' magic-space
addReference "Expand history reference (!)" '[Space]'

bindKeyReference "Clear screen" clear-screen '[Control]' L

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
addReference "Clear, type and restore" '[Control]' Q


# Bind Shift + Tab to go to the previous menu item.
#TODO Broken? not work on mac need to be tested on arch
bindkey -M emacs "$key_info[BackTab]" reverse-menu-complete

bindKeyReference "Insert sudo" prepend-sudo '[Control]' X '[Control]' S

bindKeyReference "Delete backward to slash" backward-delete-to-slash '[Control]' Y

bindKeyReference "Complete" expand-or-complete-with-indicator '[Control]' I

bindKeyReference "Complete from history" hist-complete '[Control]' X '[Control]' X

# use emacs-style zsh bindings
bindkey -e

##############################################################
# OPTIONS
##############################################################

# if a command is issued that can’t be executed as a normal command, and the command is the name of a directory, perform the cd command to that directory.
setopt AUTO_CD

# make cd push the old directory onto the directory stack.
setopt AUTO_PUSHD

# don’t push multiple copies of the same directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS

# exchanges the meanings of ‘+’ and ‘-’ when used with a number to specify a directory in the stack.
setopt PUSHD_MINUS

##############################################################
# ALIAS
##############################################################

for index ({1..9}) alias "$index"="cd +${index}"; unset index

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

# start with a space to be ignored in history

alias cd..=' ..'
alias cd...=' ...'
alias cd....=' ....'

alias d=' dirs -v | head -10'

alias ls=' ls --color=auto'
alias l=" ls -lAhtr"

# standard directory view
alias v=" clear; l -g"

# show all files in all subdirs plain in a list
alias vs=" v **/*(.)"     


##############################################################
# TODO
##############################################################
# Add bookmark manipulation here
# static named directories
# https://github.com/vincentbernat/zshrc/blob/master/rc/bookmarks.zsh


##############################################################
# OPTIONS
##############################################################

# if a command is issued that can’t be executed as a normal command, and the command is the name of a directory, perform the cd command to that directory.
setopt AUTO_CD

# make cd push the old directory onto the directory stack.
setopt AUTO_PUSHD

# don’t push multiple copies of the same directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS

##############################################################
# ALIAS
##############################################################

for index ({0..9}) alias "$index"="cd +${index}"; unset index

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

# start with a space to be ignored in history

alias cd..=' ..'
alias cd...=' ...'
alias cd....=' ....'

alias d=' dirs -v | head -10'



# standard directory view
alias v=" clear; l -g"

# show all files in all subdirs plain in a list
alias vs=" v **/*(.)"     

##############################################################
# Z - DIRECTORY JUMP
##############################################################

source "${0:h}/external/z.sh" || return 1

# add z directory recording
add_directory_to_z_db () {
    z --add "$(pwd -P)"
}


add-zsh-hook precmd add_directory_to_z_db

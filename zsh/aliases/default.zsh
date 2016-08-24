
aedit() {
    file=${1:-default.zsh}
    $EDITOR $ZSH_CONFIG_HOME/aliases/$file
    source $ZSH_CONFIG_HOME/aliases/$files
}


alias fedit=" $EDITOR $ZSH_CONFIG_HOME/modules/*functions.zsh; source $ZSH_CONFIG/modules/*functions.zsh"

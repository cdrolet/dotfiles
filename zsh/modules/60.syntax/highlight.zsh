source "${0:h}/external/zsh-syntax-highlighting.zsh" || return 1

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=red"

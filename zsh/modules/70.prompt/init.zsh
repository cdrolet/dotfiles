# https://github.com/bhilburn/powerlevel9k#customizing-prompt-segments
# https://github.com/bhilburn/powerlevel9k/wiki/Stylizing-Your-Prompt

source "${0:h}/external/powerlevel9k.zsh-theme" || return 1

DEFAULT_USER=$USER
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_SHORTEN_STRATEGY=truncate_middle
#POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context aws docker_machine dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(nvm status history time)
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''

POWERLEVEL9K_NVM_FOREGROUND='000'
POWERLEVEL9K_NVM_BACKGROUND='072'
POWERLEVEL9K_SHOW_CHANGESET=true


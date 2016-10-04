##############################################################
# REFERENCE
##############################################################
# https://github.com/bhilburn/powerlevel9k#customizing-prompt-segments
# https://github.com/bhilburn/powerlevel9k/wiki/Stylizing-Your-Prompt

source "${0:h}/external/powerlevel9k.zsh-theme" || return 1

##############################################################
# CUSTOMIZATION
##############################################################

DEFAULT_USER=$USER


#POWERLEVEL9K_SHORTEN_STRATEGY=truncate_middle
#POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context aws docker_machine dir vcs)
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs_joined history_joined time_joined)

POWERLEVEL9K_SHOW_CHANGESET=true



POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_FAIL_ICON='☠'
POWERLEVEL9K_STATUS_ERROR_BACKGROUND="none"
POWERLEVEL9K_STATUS_ERROR_FOREGROUND="white"

POWERLEVEL9K_ROOT_ICON='ϟ'
POWERLEVEL9K_ROOT_BACKGROUND="none"
POWERLEVEL9K_ROOT_FOREGROUND="white"

POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="none"
POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="white"

POWERLEVEL9K_TIME_BACKGROUND='none'
POWERLEVEL9K_TIME_FOREGROUND="10"
POWERLEVEL9K_HISTORY_BACKGROUND='none'
POWERLEVEL9K_HISTORY_FOREGROUND="12"
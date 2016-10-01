source "${0:h}/external/zsh-history-substring-search.zsh" || return 1

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=white,fg=black,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=yellow,fg=black,bold'
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
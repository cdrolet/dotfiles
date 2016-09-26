# Load dependencies.
pmodload 'editor'

# Source module files.
source "${0:h}/external/zsh-autosuggestions.zsh" || return 1


ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

if [[ -n "$key_info" ]]; then
  bindkey -M viins "$key_info[Control]F" vi-forward-word
  bindkey -M viins "$key_info[Control]E" vi-add-eol
fi

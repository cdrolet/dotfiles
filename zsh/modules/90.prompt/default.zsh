# A modified version of the agnoster's prompt - https://gist.github.com/3712874

# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).


init() {
    
    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'

    CURRENT_BG='NONE'
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    # Special Powerline characters
    SEGMENT_SEPARATOR=$'\ue0b0'
    PL_BRANCH_CHAR=$'\ue0a0' # 
    PROMPT='%{%f%b%k%}$(build_prompt) '
    SYMBOL_FORMAT="%{%F{white}%}"
}

# status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
    local symbols=()
    [ $RETVAL -ne 0 ] && symbols+="${SYMBOL_FORMAT}☠"
    [ $UID -eq 0 ] && symbols+="${SYMBOL_FORMAT}ϟ"
    [ $(jobs -l | wc -l) -gt 0 ] && symbols+="${SYMBOL_FORMAT}⚙"

    [ -n "$symbols" ] && prompt_segment black default "$symbols"
}

# user@hostname
prompt_user_host() {
    local context;
    
    if [[ ! (${PROMPT_HIDDEN_USER[(i)$USER]} -le ${#PROMPT_HIDDEN_USER}) ]]; then
        context="%(!.%{%F{yellow}%}.)$USER"
    fi
    
    if [[ -n $SSH_CLIENT ]]; then
        context+="@$HOST"
    fi

    if [[ -n $context ]]; then
        prompt_segment black default $context
    fi    
}

# current working directory
prompt_dir() {
    prompt_segment blue black '%~'
}

# branch/detached head, dirty status
prompt_git() {
    local ref dirty mode repo_path
    repo_path=$(git rev-parse --git-dir 2>/dev/null)

    if ! $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        return
    fi
    
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if (is_dirty); then
        prompt_segment yellow black
    else
        prompt_segment green black
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
        mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
        mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
        mode=" >R>"
    fi
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
}

# is git working tree is dirty
is_dirty() {
    local STATUS=$(command git status '--porcelain' 2> /dev/null | tail -n1)
    if [[ -n $STATUS ]]; then
        return 0
    else
        return 1
    fi
}

# end the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
    local bg fg
    [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
    [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
    if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
        echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
    else
        echo -n "%{$bg%}%{$fg%} "
    fi
    CURRENT_BG=$1
    [[ -n $3 ]] && echo -n $3
}

build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_user_host
  prompt_dir
  prompt_git
  prompt_end
}

init

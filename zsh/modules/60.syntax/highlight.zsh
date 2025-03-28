source "${0:h}/external/fast-syntax-highlighting.plugin.zsh" || return 1

# Configure fast-syntax-highlighting
FAST_HIGHLIGHT[use_brackets]=1
FAST_HIGHLIGHT[use_async]=1
FAST_HIGHLIGHT[use_async_always]=1
FAST_HIGHLIGHT[async_init]=1
FAST_HIGHLIGHT[async_highlighting]=1
FAST_HIGHLIGHT[async_highlighting_delay]=0.5

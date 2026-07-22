# ~/.config/zsh/bindings.zsh

# Cursor shape per vi mode
ZVM_CURSOR_STYLE_ENABLED=false

# Disable command mode line highlight
ZVM_VI_HIGHLIGHT_BACKGROUND=none
ZVM_VI_HIGHLIGH_FOREGROUND=none
ZVM_VI_HIGHLIGHT_EXTRASTYLE=none

# Custom bindings register
zvm_after_init() {
    # Ctrl + Right -> Move forward one word
    bindkey '^[[1;5C' forward-word

    # Ctrl + Left -> Move backward one word
    bindkey '^[[1;5D' backward-word

    # Ctrl + F -> fzf file picker (no hidden files)
    bindkey '^F' _fzf_file_no_hidden

    # Ctrl + \ -> Toggle autosuggestions
    bindkey '^\' autosuggest-toggle

    # Up/Down -> History search by substring
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
}

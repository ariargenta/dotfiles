# ~/.config/zsh/aliases.zsh

# Detailed listing including hidden files
alias ls='eza --icons'
alias ll='eza -lh --icons --git'
alias la='eza -lah --icons --git'
alias tree='eza --tree --icons'

# Reuse `ls` completions for eza, avoids defining separate completion function
compdef eza=ls

if command -v bat >/dev/null 2>&1; then
    alias cat='bat'
elif command -v batcat >/dev/null 2>&1; then
    alias bat='batcat'
    alias cat='batcat'
fi

if command -v fdfind >/dev/null 2>&1; then
    alias fd='fdfind'
fi

# Core utilities
alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'
alias -- -='cd -' # Prevents `-` being parsed as a flag, `cd -` jumps to previous directory

# Git
alias bare='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias glog='PAGER="less -F -X" git log'
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'

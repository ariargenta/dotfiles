# ~/.config/zsh/.zshenv

# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Default text editor
export EDITOR="vim"
export VISUAL="vim"

# GPG
export GPG_TTY=$(tty)

# Path
export PATH="$HOME/.local/bin:$PATH"

# Pager
if command -v bat >/dev/null 2>&1; then
    export MANPAGER="bat -l man -p"
elif command -v batcat >/dev/null 2>&1; then
    export MANPAGER="batcat -l man -p"
fi

# Starship
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"

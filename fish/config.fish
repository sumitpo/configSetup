# put this file in ~/.config/fish/config.fish
# Unset invalid LS_COLORS early to prevent parse errors
set -gx LS_COLORS ''

# Load dircolors if available, convert LS_COLORS → fish_color_*
if test -f ~/.dircolors
    eval (dircolors ~/.dircolors | string replace 'LS_COLORS' 'fish_color' | tr \; \\n)
end

# Optional: Set up basic aliases
alias ls 'ls --color=auto'
alias ll 'ls -la --color=auto'
alias grep 'grep --color=auto'

# Prompt (optional)
fish_config prompt plain

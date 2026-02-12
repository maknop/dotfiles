# Fish Shell Configuration

# Homebrew setup (must be first to ensure proper PATH)
# Support both Apple Silicon and Intel Macs
if test -f /opt/homebrew/bin/brew
    # Apple Silicon
    eval (/opt/homebrew/bin/brew shellenv)
else if test -f /usr/local/bin/brew
    # Intel Mac
    eval (/usr/local/bin/brew shellenv)
end

# Disable fish greeting
set -g fish_greeting

# Theme Configuration (bobthefish theme)
set -g theme_nerd_fonts yes
set -g theme_color_scheme zenburn

# Environment Variables
set -gx TERM xterm-256color

# GPG and Security
set -gx GPG_TTY (tty)

# Go paths
if test -d /usr/local/go/bin
    fish_add_path /usr/local/go/bin
end
if set -q GOROOT
    fish_add_path $GOROOT/bin
end

# NVM setup for fish
# Note: nvm.fish plugin is installed via Fisher
# It will be available automatically after fisher update
if test -d $HOME/.nvm
    # If using bass (allows running bash scripts in fish)
    if type -q bass
        bass source $HOME/.nvm/nvm.sh
    end
end

# Load custom functions directory
# Fish automatically loads functions from ~/.config/fish/functions/
set -gx fish_function_path $fish_function_path ~/.config/fish/functions

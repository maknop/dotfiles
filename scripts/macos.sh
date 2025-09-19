#!/bin/bash

# macOS-specific installation script
set -e

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source shared functions
source "$SCRIPT_DIR/functions.sh"

log_info "Starting macOS installation..."

# Check if we're on macOS
if [[ $(uname) != "Darwin" ]]; then
    log_error "This script is for macOS only"
    exit 1
fi

# Check macOS version
macos_version=$(sw_vers -productVersion)
log_info "macOS version: $macos_version"

# Run the main installation
run_installation "Darwin"

# macOS-specific post-installation steps
log_info "Running macOS-specific configurations..."

# Set up shell integration for Homebrew (if needed)
if command_exists brew; then
    # Check if Homebrew path is in shell profile
    shell_profile=""
    if [[ $SHELL == *"zsh"* ]]; then
        shell_profile="$HOME/.zshrc"
    elif [[ $SHELL == *"bash"* ]]; then
        shell_profile="$HOME/.bash_profile"
    fi
    
    if [[ -n "$shell_profile" ]]; then
        if ! grep -q "brew shellenv" "$shell_profile" 2>/dev/null; then
            log_info "Adding Homebrew to shell profile: $shell_profile"
            echo '' >> "$shell_profile"
            echo '# Homebrew' >> "$shell_profile"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$shell_profile"
        fi
    fi
fi

# Install additional macOS-specific tools
if command_exists brew; then
    log_info "Installing macOS-specific development tools..."
    
    # Useful tools for development
    local macos_tools=("tree" "htop" "jq" "fzf" "bat" "exa" "delta")
    
    for tool in "${macos_tools[@]}"; do
        if ! command_exists "$tool"; then
            log_info "Installing $tool..."
            brew install "$tool" 2>/dev/null || log_warning "Failed to install $tool"
        else
            log_success "$tool is already installed"
        fi
    done
fi

log_success "macOS installation completed successfully!"
log_info ""
log_info "Next steps:"
log_info "1. Restart your terminal or run: source ~/.zshrc (or ~/.bash_profile)"
log_info "2. Start Neovim with: nvim"
log_info "3. Wait for plugins to install automatically"
log_info "4. Enjoy your new Lua-based Neovim configuration!"

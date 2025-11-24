#!/bin/bash

# macOS-specific installation script
set -e

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source shared functions
# shellcheck source=functions.sh disable=SC1091
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

# Verify Homebrew is available after dotfiles installation
if ! command_exists brew; then
    log_error "Homebrew is not available. Installation may have failed."
    log_error "Please check the installation logs above."
    exit 1
fi

log_success "Homebrew is configured (initialized via dotfiles)"

# Install additional macOS-specific tools
log_info "Installing macOS-specific development tools..."

# Useful tools for development
macos_tools=("tree" "htop" "jq" "fzf" "bat" "exa" "delta")

for tool in "${macos_tools[@]}"; do
    if ! command_exists "$tool"; then
        log_info "Installing $tool..."
        if brew install "$tool"; then
            log_success "$tool installed successfully"
        else
            log_warning "Failed to install $tool (continuing anyway)"
        fi
    else
        log_success "$tool is already installed"
    fi
done

log_success "macOS installation completed successfully!"
log_info ""
log_info "Next steps:"
log_info "1. Restart your terminal or run: source ~/.zshrc (or ~/.bash_profile)"
log_info "2. Start Neovim with: nvim"
log_info "3. Wait for plugins to install automatically"
log_info "4. Enjoy your new Lua-based Neovim configuration!"

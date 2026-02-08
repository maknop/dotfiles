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

# Check which tools are already installed
to_install_tools=()
already_installed_tools=()

for tool in "${macos_tools[@]}"; do
    if brew_is_installed "$tool" || command_exists "$tool"; then
        already_installed_tools+=("$tool")
    else
        to_install_tools+=("$tool")
    fi
done

# Report already installed tools
if [ ${#already_installed_tools[@]} -gt 0 ]; then
    log_success "Already installed: ${already_installed_tools[*]}"
fi

# Batch install tools that need installation
if [ ${#to_install_tools[@]} -gt 0 ]; then
    log_info "Installing: ${to_install_tools[*]}"
    log_info "This may take a few minutes..."
    if brew install "${to_install_tools[@]}"; then
        log_success "macOS tools installed successfully"
    else
        log_warning "Some tools failed to install (continuing anyway)"
    fi
else
    log_success "All macOS tools are already installed"
fi

log_success "macOS installation completed successfully!"
log_info ""
log_info "Next steps:"
log_info "1. Restart your terminal or run: source ~/.zshrc (or ~/.bash_profile)"
log_info "2. Start Neovim with: nvim"
log_info "3. Wait for plugins to install automatically"
log_info "4. Enjoy your new Lua-based Neovim configuration!"

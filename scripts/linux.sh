#!/bin/bash

# Linux-specific installation script
set -e

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source shared functions
# shellcheck source=functions.sh disable=SC1091
source "$SCRIPT_DIR/functions.sh"

log_info "Starting Linux installation..."

# Check if we're on Linux
if [[ $(uname) != "Linux" ]]; then
    log_error "This script is for Linux only"
    exit 1
fi

# Detect Linux distribution
if [ -f /etc/os-release ]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    DISTRO=$ID
    log_info "Detected Linux distribution: $PRETTY_NAME"
else
    log_warning "Could not detect Linux distribution"
    DISTRO="unknown"
fi

# Run the main installation
run_installation "Linux"

# Linux-specific post-installation steps
log_info "Running Linux-specific configurations..."

# Install additional development tools based on distribution
case "$DISTRO" in
    "ubuntu"|"debian")
        log_info "Installing Ubuntu/Debian-specific tools..."
        
        # Update package list
        sudo apt-get update
        
        # Additional useful tools
        debian_tools=("tree" "htop" "jq" "fzf" "bat" "exa" "build-essential")
        
        for tool in "${debian_tools[@]}"; do
            if ! dpkg -l | grep -q "^ii  $tool "; then
                log_info "Installing $tool..."
                sudo apt-get install -y "$tool" 2>/dev/null || log_warning "Failed to install $tool"
            else
                log_success "$tool is already installed"
            fi
        done
        
        # Install snap packages if snapd is available
        if command_exists snap; then
            log_info "Installing snap packages..."
            sudo snap install code --classic 2>/dev/null || log_warning "Failed to install VS Code via snap"
        fi
        ;;
        
    "fedora"|"rhel"|"centos")
        log_info "Installing Red Hat-based distribution tools..."
        
        # Additional useful tools
        rhel_tools=("tree" "htop" "jq" "fzf" "bat" "exa" "gcc" "gcc-c++" "make")
        
        for tool in "${rhel_tools[@]}"; do
            if ! rpm -qa | grep -q "$tool"; then
                log_info "Installing $tool..."
                sudo yum install -y "$tool" 2>/dev/null || log_warning "Failed to install $tool"
            else
                log_success "$tool is already installed"
            fi
        done
        ;;
        
    "arch"|"manjaro")
        log_info "Installing Arch-based distribution tools..."
        
        # Update package database
        sudo pacman -Sy
        
        # Additional useful tools
        arch_tools=("tree" "htop" "jq" "fzf" "bat" "exa" "base-devel")
        
        for tool in "${arch_tools[@]}"; do
            if ! pacman -Qi "$tool" >/dev/null 2>&1; then
                log_info "Installing $tool..."
                sudo pacman -S --noconfirm "$tool" 2>/dev/null || log_warning "Failed to install $tool"
            else
                log_success "$tool is already installed"
            fi
        done
        ;;
        
    *)
        log_warning "Unknown distribution: $DISTRO"
        log_info "Skipping distribution-specific package installation"
        ;;
esac

# Note: Fish shell is now configured automatically via config.fish
# No need for legacy shell profile setup since fish is the default shell

log_success "Linux installation completed successfully!"
log_info ""
log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_info "🎉 Installation Complete!"
log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_info ""
log_info "📌 What's Been Configured:"
log_info ""
if command_exists fish; then
    log_success "   ✓ Fish shell installed and set as default"
    log_success "   ✓ Fisher plugin manager installed"
    log_success "   ✓ All fish plugins installed (Tide, nvm.fish, bass)"
    log_success "   ✓ All aliases converted to fish functions"
else
    log_warning "   ✗ Fish shell installation may have failed"
fi
if command_exists nvim; then
    log_success "   ✓ Neovim $(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
else
    log_warning "   ✗ Neovim installation may have failed"
fi
if command_exists tmux; then
    log_success "   ✓ Tmux with TPM (Tmux Plugin Manager)"
else
    log_warning "   ✗ Tmux installation may have failed"
fi
log_info ""
log_info "📌 Next Steps:"
log_info ""
log_info "1️⃣  Restart your terminal to start using fish shell"
log_info ""
log_info "2️⃣  Customize your prompt (optional):"
log_info "   → Run: tide configure"
log_info ""
log_info "3️⃣  Start using Neovim:"
log_info "   → Run: nvim"
log_info "   → Plugins will install automatically on first launch"
log_info ""
log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log_success "🚀 All done! Enjoy your new development environment!"
log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

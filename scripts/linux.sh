#!/bin/bash

# Linux-specific installation script
set -e

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source shared functions
source "$SCRIPT_DIR/functions.sh"

log_info "Starting Linux installation..."

# Check if we're on Linux
if [[ $(uname) != "Linux" ]]; then
    log_error "This script is for Linux only"
    exit 1
fi

# Detect Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    VERSION=$VERSION_ID
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
        local debian_tools=("tree" "htop" "jq" "fzf" "bat" "exa" "build-essential")
        
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
        local rhel_tools=("tree" "htop" "jq" "fzf" "bat" "exa" "gcc" "gcc-c++" "make")
        
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
        local arch_tools=("tree" "htop" "jq" "fzf" "bat" "exa" "base-devel")
        
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

# Set up shell configuration
shell_profile=""
if [[ $SHELL == *"zsh"* ]]; then
    shell_profile="$HOME/.zshrc"
elif [[ $SHELL == *"bash"* ]]; then
    shell_profile="$HOME/.bashrc"
fi

if [[ -n "$shell_profile" ]]; then
    log_info "Setting up shell configuration in $shell_profile"
    
    # Add useful aliases if they don't exist
    if ! grep -q "# Neovim alias" "$shell_profile" 2>/dev/null; then
        echo '' >> "$shell_profile"
        echo '# Neovim alias' >> "$shell_profile"
        echo 'alias vim=nvim' >> "$shell_profile"
        echo 'alias vi=nvim' >> "$shell_profile"
    fi
    
    # Add local bin to PATH if it exists
    if [[ -d "$HOME/.local/bin" ]] && ! grep -q ".local/bin" "$shell_profile" 2>/dev/null; then
        echo '' >> "$shell_profile"
        echo '# Local bin path' >> "$shell_profile"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$shell_profile"
    fi
fi

log_success "Linux installation completed successfully!"
log_info ""
log_info "Next steps:"
log_info "1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
log_info "2. Start Neovim with: nvim"
log_info "3. Wait for plugins to install automatically"
log_info "4. Enjoy your new Lua-based Neovim configuration!"

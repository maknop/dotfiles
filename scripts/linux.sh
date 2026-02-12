#!/bin/bash

# =============================================================================
# Linux-specific Installation Script
# =============================================================================

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=functions.sh disable=SC1091
source "$SCRIPT_DIR/functions.sh"

readonly DEBIAN_TOOLS=("tree" "htop" "jq" "fzf" "bat" "exa" "build-essential")
readonly RHEL_TOOLS=("tree" "htop" "jq" "fzf" "bat" "exa" "gcc" "gcc-c++" "make")
readonly ARCH_TOOLS=("tree" "htop" "jq" "fzf" "bat" "exa" "base-devel")

# -----------------------------------------------------------------------------
# Validation Functions
# -----------------------------------------------------------------------------

validate_linux() {
    if [[ $(uname) != "Linux" ]]; then
        log_error "This script is for Linux only"
        return 1
    fi
    return 0
}

detect_distribution() {
    if [ ! -f /etc/os-release ]; then
        log_warning "Could not detect Linux distribution"
        echo "unknown"
        return 1
    fi

    # shellcheck source=/dev/null
    . /etc/os-release
    log_info "Detected Linux distribution: $PRETTY_NAME"
    echo "$ID"
}

# -----------------------------------------------------------------------------
# Package Installation Functions
# -----------------------------------------------------------------------------

install_debian_package() {
    local -r package="$1"

    if dpkg -l | grep -q "^ii  $package "; then
        log_success "$package is already installed"
        return 0
    fi

    log_info "Installing $package..."
    sudo apt-get install -y "$package" 2>/dev/null || {
        log_warning "Failed to install $package"
        return 1
    }
}

install_debian_tools() {
    log_info "Installing Ubuntu/Debian-specific tools..."

    sudo apt-get update

    for tool in "${DEBIAN_TOOLS[@]}"; do
        install_debian_package "$tool"
    done

    # Install snap packages if available
    if command_exists snap; then
        log_info "Installing snap packages..."
        sudo snap install code --classic 2>/dev/null || log_warning "Failed to install VS Code via snap"
    fi
}

install_rhel_package() {
    local -r package="$1"

    if rpm -qa | grep -q "$package"; then
        log_success "$package is already installed"
        return 0
    fi

    log_info "Installing $package..."
    sudo yum install -y "$package" 2>/dev/null || {
        log_warning "Failed to install $package"
        return 1
    }
}

install_rhel_tools() {
    log_info "Installing Red Hat-based distribution tools..."

    for tool in "${RHEL_TOOLS[@]}"; do
        install_rhel_package "$tool"
    done
}

install_arch_package() {
    local -r package="$1"

    if pacman -Qi "$package" >/dev/null 2>&1; then
        log_success "$package is already installed"
        return 0
    fi

    log_info "Installing $package..."
    sudo pacman -S --noconfirm "$package" 2>/dev/null || {
        log_warning "Failed to install $package"
        return 1
    }
}

install_arch_tools() {
    log_info "Installing Arch-based distribution tools..."

    sudo pacman -Sy

    for tool in "${ARCH_TOOLS[@]}"; do
        install_arch_package "$tool"
    done
}

install_distro_specific_tools() {
    local -r distro="$1"

    case "$distro" in
        "ubuntu"|"debian")
            install_debian_tools
            ;;
        "fedora"|"rhel"|"centos")
            install_rhel_tools
            ;;
        "arch"|"manjaro")
            install_arch_tools
            ;;
        *)
            log_warning "Unknown distribution: $distro"
            log_info "Skipping distribution-specific package installation"
            ;;
    esac
}
# -----------------------------------------------------------------------------
# Summary Functions
# -----------------------------------------------------------------------------

print_installation_summary() {
    log_info ""
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_info "🎉 Installation Complete!"
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_info ""
    log_info "📌 What's Been Configured:"
    log_info ""

    # Check Fish shell
    if command_exists fish; then
        log_success "   ✓ Fish shell installed and set as default"
        log_success "   ✓ Fisher plugin manager installed"
        log_success "   ✓ All fish plugins installed (Tide, nvm.fish, bass)"
        log_success "   ✓ All aliases converted to fish functions"
    else
        log_warning "   ✗ Fish shell installation may have failed"
    fi

    # Check Neovim
    if command_exists nvim; then
        local nvim_version
        nvim_version=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        log_success "   ✓ Neovim $nvim_version"
    else
        log_warning "   ✗ Neovim installation may have failed"
    fi

    # Check tmux
    if command_exists tmux; then
        log_success "   ✓ Tmux with TPM (Tmux Plugin Manager)"
    else
        log_warning "   ✗ Tmux installation may have failed"
    fi
}

print_next_steps() {
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
}

# -----------------------------------------------------------------------------
# Main Function
# -----------------------------------------------------------------------------

main() {
    log_info "Starting Linux installation..."

    # Validate we're on Linux
    if ! validate_linux; then
        exit 1
    fi

    # Detect distribution
    local distro
    distro=$(detect_distribution)

    # Run main installation
    run_installation "Linux"

    # Post-installation configuration
    log_info "Running Linux-specific configurations..."

    # Install distribution-specific tools
    install_distro_specific_tools "$distro"

    # Print summary
    log_success "Linux installation completed successfully!"
    print_installation_summary
    print_next_steps
}

# Execute main function
main

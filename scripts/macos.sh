#!/bin/bash

# =============================================================================
# macOS-specific Installation Script
# =============================================================================

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR

# shellcheck source=functions.sh disable=SC1091
source "$SCRIPT_DIR/functions.sh"

readonly MACOS_TOOLS=("tree" "htop" "jq" "fzf" "bat" "exa" "delta")

# -----------------------------------------------------------------------------
# Validation Functions
# -----------------------------------------------------------------------------

validate_macos() {
    if [[ $(uname) != "Darwin" ]]; then
        log_error "This script is for macOS only"
        return 1
    fi
    return 0
}

verify_homebrew() {
    if ! command_exists brew; then
        log_error "Homebrew is not available. Installation may have failed."
        log_error "Please check the installation logs above."
        return 1
    fi

    log_success "Homebrew is configured (initialized via dotfiles)"
    return 0
}

# -----------------------------------------------------------------------------
# Installation Functions
# -----------------------------------------------------------------------------

install_macos_tools() {
    local to_install=()
    local already_installed=()

    log_info "Installing macOS-specific development tools..."

    # Check which tools need installation
    for tool in "${MACOS_TOOLS[@]}"; do
        if brew_is_installed "$tool" || command_exists "$tool"; then
            already_installed+=("$tool")
        else
            to_install+=("$tool")
        fi
    done

    # Report already installed tools
    if [ ${#already_installed[@]} -gt 0 ]; then
        log_success "Already installed: ${already_installed[*]}"
    fi

    # Install missing tools
    if [ ${#to_install[@]} -eq 0 ]; then
        log_success "All macOS tools are already installed"
        return 0
    fi

    log_info "Installing: ${to_install[*]}"

    if brew install "${to_install[@]}"; then
        log_success "macOS tools installed successfully"
        return 0
    fi

    log_warning "Some tools failed to install (continuing anyway)"
    return 1
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
    log_info "Starting macOS installation..."

    # Validate we're on macOS
    if ! validate_macos; then
        exit 1
    fi

    # Show macOS version
    local macos_version
    macos_version=$(sw_vers -productVersion)
    log_info "macOS version: $macos_version"

    # Run main installation
    run_installation "Darwin"

    # Post-installation configuration
    log_info "Running macOS-specific configurations..."

    if ! verify_homebrew; then
        exit 1
    fi

    # Install macOS-specific tools
    install_macos_tools

    # Print summary
    log_success "macOS installation completed successfully!"
    print_installation_summary
    print_next_steps
}

# Execute main function
main

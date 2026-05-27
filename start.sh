#!/bin/bash

# =============================================================================
# Dotfiles Installation Script
# Supports macOS (Darwin) and Linux
# =============================================================================

# -----------------------------------------------------------------------------
# Constants
# -----------------------------------------------------------------------------

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

readonly SUPPORTED_OS=("Linux" "Darwin")

# -----------------------------------------------------------------------------
# Logging Functions
# -----------------------------------------------------------------------------

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# -----------------------------------------------------------------------------
# Utility Functions
# -----------------------------------------------------------------------------

print_banner() {
    echo "=================================================="
    echo "    🚀 Dotfiles Installation Script 🚀"
    echo "=================================================="
    echo ""
}

is_supported_os() {
    local -r os="$1"
    for supported in "${SUPPORTED_OS[@]}"; do
        if [[ "$os" == "$supported" ]]; then
            return 0
        fi
    done
    return 1
}

validate_environment() {
    local -r script_dir="$1"

    if [ ! -d "$script_dir/scripts" ]; then
        log_error "Scripts directory not found: $script_dir/scripts"
        log_error "Please make sure you're running this from the dotfiles directory"
        return 1
    fi

    return 0
}

run_os_installation_script() {
    local -r os_name="$1"
    local -r script_dir="$2"

    case "$os_name" in
        "Linux")
            log_info "Running Linux installation script..."
            "$script_dir/scripts/linux.sh"
            ;;
        "Darwin")
            log_info "Running macOS installation script..."
            "$script_dir/scripts/macos.sh"
            ;;
    esac
}

# -----------------------------------------------------------------------------
# Main Function
# -----------------------------------------------------------------------------

main() {
    local -r script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local -r os_name=$(uname)

    print_banner

    log_info "Starting dotfiles installation..."
    log_info "Script directory: $script_dir"
    log_info "Detected OS: $os_name"

    # Validate environment
    if ! validate_environment "$script_dir"; then
        exit 1
    fi

    # Check OS support
    if ! is_supported_os "$os_name"; then
        log_error "Unsupported operating system: $os_name"
        log_error "This script supports Linux and macOS (Darwin) only"
        exit 1
    fi

    # Make scripts executable
    chmod +x "$script_dir/scripts"/*.sh

    # Run OS-specific installation
    run_os_installation_script "$os_name" "$script_dir"

    # Print completion message
    echo ""
    echo "=================================================="
    log_success "🎉 Dotfiles installation completed! 🎉"
    echo "=================================================="
}

# Execute main function
main


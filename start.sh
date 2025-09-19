#!/bin/bash

# Dotfiles Installation Script
# Supports macOS (Darwin) and Linux

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Print banner
echo "=================================================="
echo "    🚀 Dotfiles Installation Script 🚀"
echo "=================================================="
echo ""

log_info "Starting dotfiles installation..."
log_info "Script directory: $SCRIPT_DIR"

# Detect operating system
os_name=$(uname)
log_info "Detected OS: $os_name"

# Check if scripts directory exists
if [ ! -d "$SCRIPT_DIR/scripts" ]; then
    log_error "Scripts directory not found: $SCRIPT_DIR/scripts"
    log_error "Please make sure you're running this from the dotfiles directory"
    exit 1
fi

# Make scripts executable
chmod +x "$SCRIPT_DIR/scripts"/*.sh

# Run OS-specific installation
case "$os_name" in
    "Linux")
        log_info "Running Linux installation script..."
        "$SCRIPT_DIR/scripts/linux.sh"
        ;;
    "Darwin")
        log_info "Running macOS installation script..."
        "$SCRIPT_DIR/scripts/macos.sh"
        ;;
    *)
        log_error "Unsupported operating system: $os_name"
        log_error "This script supports Linux and macOS (Darwin) only"
        exit 1
        ;;
esac

echo ""
echo "=================================================="
log_success "🎉 Dotfiles installation completed! 🎉"
echo "=================================================="


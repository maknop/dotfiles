#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS=$(uname)

case "$OS" in
    Linux|Darwin) ;;
    *) echo "Unsupported OS: $OS" >&2; exit 1 ;;
esac

# shellcheck source=scripts/functions.sh disable=SC1091
source "$DOTFILES_DIR/scripts/functions.sh"

echo ""
echo "Dotfiles Installation — OS: $OS"
echo ""

run_installation "$OS" "$DOTFILES_DIR"

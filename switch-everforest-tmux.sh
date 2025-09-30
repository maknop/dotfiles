#!/bin/bash

# Switch Everforest Tmux Theme Script
# This script helps you switch between different Everforest tmux theme variants

THEME_DIR="$HOME/.tmux-everforest"
CONFIG_FILE="$HOME/.config/tmux/tmux.conf"

echo "🌲 Everforest Tmux Theme Switcher"
echo ""

# Check if theme directory exists
if [ ! -d "$THEME_DIR" ]; then
    echo "❌ Everforest tmux theme not found at $THEME_DIR"
    echo "   Please run the installation first"
    exit 1
fi

# List available themes
echo "Available Everforest themes:"
echo "1. dark-medium (default)"
echo "2. dark-soft"
echo "3. light-medium"
echo "4. light-soft"
echo ""

# Get user choice
read -rp "Enter theme number (1-4): " choice

case $choice in
    1)
        THEME="dark-medium"
        ;;
    2)
        THEME="dark-soft"
        ;;
    3)
        THEME="light-medium"
        ;;
    4)
        THEME="light-soft"
        ;;
    *)
        echo "❌ Invalid choice. Using default (dark-medium)"
        THEME="dark-medium"
        ;;
esac

echo "🔄 Switching to Everforest $THEME theme..."

# Update the config file
sed -i.bak "s|source-file ~/.tmux-everforest/tmux-everforest-.*\.conf|source-file ~/.tmux-everforest/tmux-everforest-$THEME.conf|" "$CONFIG_FILE"

# Reload tmux configuration
if tmux source-file "$CONFIG_FILE" 2>/dev/null; then
    echo "✅ Theme switched to Everforest $THEME"
    echo "   The theme is now active in your current tmux session"
    echo "   New tmux sessions will also use this theme"
else
    echo "⚠️  Theme updated in config but couldn't reload tmux"
    echo "   Please run: tmux source-file ~/.config/tmux/tmux.conf"
fi

echo ""
echo "🎨 Current theme: Everforest $THEME"
echo "   Config file: $CONFIG_FILE"

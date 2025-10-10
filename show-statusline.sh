#!/bin/bash

# Show Statusline Configuration Script
# Display current Neovim statusline theme configuration

echo "🎨 Neovim Statusline Configuration"
echo ""

# Check current theme
if grep -q 'local colorscheme = "nordic"' ~/.config/nvim/lua/config/colorscheme.lua 2>/dev/null; then
    CURRENT_THEME="Nordic"
    THEME_COLOR="🔵"
elif grep -q 'local colorscheme = "everforest"' ~/.config/nvim/lua/config/colorscheme.lua 2>/dev/null; then
    CURRENT_THEME="Everforest"
    THEME_COLOR="🌲"
else
    CURRENT_THEME="Unknown"
    THEME_COLOR="❓"
fi

echo "Current Theme: $THEME_COLOR $CURRENT_THEME"
echo ""

# Show statusline configuration
echo "Statusline Features:"
echo "  • Theme-aware colors"
echo "  • Current theme indicator"
echo "  • Line and column numbers"
echo "  • File information"
echo "  • Git branch (if available)"
echo "  • Tabline with separators"
echo "  • Auto-disable when tmux is active"
echo ""

# Show airline theme
if [ -f ~/.config/nvim/lua/config/statusline.lua ]; then
    echo "Airline Configuration:"
    if [ "$CURRENT_THEME" = "Nordic" ]; then
        echo "  • Theme: nord (Nordic colors)"
    elif [ "$CURRENT_THEME" = "Everforest" ]; then
        echo "  • Theme: everforest (Everforest colors)"
    else
        echo "  • Theme: default"
    fi
    echo "  • Powerline fonts: enabled"
    echo "  • Tabline: enabled"
    echo "  • Theme indicator: enabled"
fi

echo ""
echo "To switch themes: ./switch-theme.sh"
echo "To test in Neovim: nvim"

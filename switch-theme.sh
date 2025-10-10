#!/bin/bash

# Theme Switcher Script
# Switch between Nordic and Everforest themes for both Neovim and tmux

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration files
NVIM_CONFIG="$HOME/.config/nvim/lua/config/colorscheme.lua"
TMUX_CONFIG="$HOME/.config/tmux/tmux.conf"
TMUX_NORDIC="$HOME/.config/tmux/tmux-nordic.conf"
TMUX_EVERFOREST="$HOME/.tmux-everforest/tmux-everforest-dark-soft.conf"

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ️${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

# Function to check if files exist
check_files() {
    local missing_files=()
    
    if [ ! -f "$NVIM_CONFIG" ]; then
        missing_files+=("$NVIM_CONFIG")
    fi
    
    if [ ! -f "$TMUX_CONFIG" ]; then
        missing_files+=("$TMUX_CONFIG")
    fi
    
    if [ ! -f "$TMUX_NORDIC" ]; then
        missing_files+=("$TMUX_NORDIC")
    fi
    
    if [ ! -f "$TMUX_EVERFOREST" ]; then
        missing_files+=("$TMUX_EVERFOREST")
    fi
    
    if [ ${#missing_files[@]} -gt 0 ]; then
        print_error "Missing required files:"
        for file in "${missing_files[@]}"; do
            echo "  - $file"
        done
        exit 1
    fi
}

# Function to switch Neovim theme
switch_nvim_theme() {
    local theme="$1"
    
    print_info "Switching Neovim theme to $theme..."
    
    if [ "$theme" = "nordic" ]; then
        # Switch to Nordic
        cat > "$NVIM_CONFIG" << 'EOF'
-- Colorscheme configuration
-- This function safely sets a colorscheme with fallback

local M = {}

-- Set colorscheme with fallback
function M.setup()
  local colorscheme = "nordic"
  
  -- Configure Nordic theme with custom options
  local nordic_ok, nordic = pcall(require, "nordic")
  if nordic_ok then
    nordic.setup({
      bold_keywords = false,
      italic_comments = true,
      transparent = {
        bg = false,
        float = false,
      },
      bright_border = false,
      reduced_blue = true,
      swap_backgrounds = false,
      cursorline = {
        bold = false,
        bold_number = true,
        theme = 'dark',
        blend = 0.85,
      },
      noice = {
        style = 'classic',
      },
      telescope = {
        style = 'flat',
      },
      leap = {
        dim_backdrop = false,
      },
      ts_context = {
        dark_background = true,
      }
    })
    -- Load Nordic theme
    nordic.load()
  else
    -- Try to set the colorscheme directly
    local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
    if not status_ok then
      -- Fallback to default if colorscheme not found
      vim.notify("Colorscheme " .. colorscheme .. " not found! Using default.", vim.log.levels.WARN)
      vim.cmd("colorscheme default")
    end
  end
  
  -- Configure statusline to reflect current theme
  local statusline_ok, statusline = pcall(require, "config.statusline")
  if statusline_ok then
    statusline.setup()
  end
end

return M
EOF
        print_status "Neovim configured for Nordic theme with statusline"
        
    elif [ "$theme" = "everforest" ]; then
        # Switch to Everforest
        cat > "$NVIM_CONFIG" << 'EOF'
-- Colorscheme configuration
-- This function safely sets a colorscheme with fallback

local M = {}

-- Set colorscheme with fallback
function M.setup()
  local colorscheme = "everforest"
  
  -- Try to set the colorscheme directly
  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
  if not status_ok then
    -- Fallback to default if colorscheme not found
    vim.notify("Colorscheme " .. colorscheme .. " not found! Using default.", vim.log.levels.WARN)
    vim.cmd("colorscheme default")
  end
  
  -- Configure statusline to reflect current theme
  local statusline_ok, statusline = pcall(require, "config.statusline")
  if statusline_ok then
    statusline.setup()
  end
end

return M
EOF
        print_status "Neovim configured for Everforest theme with statusline"
    fi
}

# Function to switch tmux theme
switch_tmux_theme() {
    local theme="$1"
    
    print_info "Switching tmux theme to $theme..."
    
    if [ "$theme" = "nordic" ]; then
        # Switch to Nordic
        sed -i.bak 's|source-file ~/.tmux-everforest/tmux-everforest-dark-soft.conf|source-file ~/.config/tmux/tmux-nordic.conf|' "$TMUX_CONFIG"
        print_status "Tmux configured for Nordic theme"
        
    elif [ "$theme" = "everforest" ]; then
        # Switch to Everforest
        sed -i.bak 's|source-file ~/.config/tmux/tmux-nordic.conf|source-file ~/.tmux-everforest/tmux-everforest-dark-soft.conf|' "$TMUX_CONFIG"
        print_status "Tmux configured for Everforest theme"
    fi
}

# Function to reload configurations
reload_configs() {
    print_info "Reloading configurations..."
    
    # Reload tmux configuration
    if command -v tmux >/dev/null 2>&1; then
        if tmux source-file "$TMUX_CONFIG" 2>/dev/null; then
            print_status "Tmux configuration reloaded"
        else
            print_warning "Could not reload tmux configuration (tmux may not be running)"
        fi
    fi
    
    print_info "Neovim configuration will be loaded on next startup"
}

# Function to show current theme
show_current_theme() {
    print_info "Current theme status:"
    
    # Check Neovim theme
    if grep -q 'local colorscheme = "nordic"' "$NVIM_CONFIG" 2>/dev/null; then
        echo "  Neovim: Nordic"
    elif grep -q 'local colorscheme = "everforest"' "$NVIM_CONFIG" 2>/dev/null; then
        echo "  Neovim: Everforest"
    else
        echo "  Neovim: Unknown"
    fi
    
    # Check tmux theme
    if grep -q 'tmux-nordic.conf' "$TMUX_CONFIG" 2>/dev/null; then
        echo "  Tmux: Nordic"
    elif grep -q 'tmux-everforest' "$TMUX_CONFIG" 2>/dev/null; then
        echo "  Tmux: Everforest"
    else
        echo "  Tmux: Unknown"
    fi
}

# Main function
main() {
    echo -e "${CYAN}🎨 Theme Switcher${NC}"
    echo "Switch between Nordic and Everforest themes for Neovim and tmux"
    echo ""
    
    # Check if files exist
    check_files
    
    # Show current theme
    show_current_theme
    echo ""
    
    # Get user choice
    echo "Available themes:"
    echo "1. Nordic (cool, blue-toned)"
    echo "2. Everforest (warm, green-toned)"
    echo ""
    
    read -rp "Enter theme number (1-2): " choice
    
    case $choice in
        1)
            THEME="nordic"
            ;;
        2)
            THEME="everforest"
            ;;
        *)
            print_error "Invalid choice. Exiting."
            exit 1
            ;;
    esac
    
    echo ""
    print_info "Switching to $THEME theme..."
    
    # Switch themes
    switch_nvim_theme "$THEME"
    switch_tmux_theme "$THEME"
    
    # Reload configurations
    reload_configs
    
    echo ""
    print_status "Theme switch complete!"
    echo ""
    print_info "To see the changes:"
    echo "  - Neovim: Start a new session with 'nvim'"
    echo "  - Tmux: The theme is already active in your current session"
    echo "  - Statusline: Automatically disabled in tmux, enabled outside tmux"
    echo ""
    print_info "Current configuration:"
    show_current_theme
}

# Run main function
main "$@"

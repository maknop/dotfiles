#!/bin/bash

# Install Tmux Plugins Script
# This script helps install TPM plugins for enhanced tmux functionality

echo "🔧 Installing Tmux Plugins..."

# Check if TPM is installed
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "❌ TPM not found. Installing TPM first..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "✅ TPM installed"
fi

# Start tmux session to install plugins
echo "🚀 Starting tmux session to install plugins..."
echo "   After tmux starts, press: Ctrl+Space + I"
echo "   This will install all configured plugins"
echo "   Then press: Ctrl+Space + U to update plugins"
echo "   Finally, press: Ctrl+Space + X to exit tmux"
echo ""

# Start tmux with the configuration
tmux new-session -s plugin_install -c /Users/mknop/workspace/dotfiles

echo "✅ Plugin installation session completed!"
echo ""
echo "To enable the enhanced statusline with plugins:"
echo "1. Edit ~/.config/tmux/tmux.conf"
echo "2. Uncomment the plugin lines (remove # from the beginning)"
echo "3. Uncomment the TPM run line at the bottom"
echo "4. Run: tmux source-file ~/.config/tmux/tmux.conf"

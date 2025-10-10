#!/bin/bash

# Tmux Configuration Test Script

echo "🔧 Testing tmux configuration..."
echo ""

# Check if tmux is installed
if ! command -v tmux >/dev/null 2>&1; then
    echo "❌ tmux is not installed"
    exit 1
fi

echo "✅ tmux is installed: $(tmux -V)"

# Check if config file exists
if [ ! -f ~/.config/tmux/tmux.conf ]; then
    echo "❌ tmux config file not found at ~/.config/tmux/tmux.conf"
    exit 1
fi

echo "✅ tmux config file exists"

# Test config syntax
if tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null; then
    echo "✅ tmux config syntax is valid"
else
    echo "❌ tmux config has syntax errors"
    echo "Run: tmux source-file ~/.config/tmux/tmux.conf"
    exit 1
fi

# Check if TPM is installed
if [ -d ~/.tmux/plugins/tpm ]; then
    echo "✅ TPM (Tmux Plugin Manager) is installed"
else
    echo "⚠️  TPM is not installed. Installing now..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "✅ TPM installed"
fi

# Check zsh configuration
if [ -f ~/.zshrc ]; then
    if [ -L ~/.zshrc ]; then
        echo "✅ .zshrc is symlinked to dotfiles"
    else
        echo "⚠️  .zshrc exists but is not symlinked"
    fi
else
    echo "❌ .zshrc not found"
fi

# Check aliases
if [ -f ~/.zsh_aliases ]; then
    if [ -L ~/.zsh_aliases ]; then
        echo "✅ .zsh_aliases is symlinked to dotfiles"
    else
        echo "⚠️  .zsh_aliases exists but is not symlinked"
    fi
else
    echo "❌ .zsh_aliases not found"
fi

echo ""
echo "🚀 Configuration test complete!"
echo ""
echo "To start tmux with your configuration:"
echo "  tmux"
echo ""
echo "To install tmux plugins (run inside tmux):"
echo "  Press: Ctrl+Space + I"
echo ""
echo "Useful tmux commands:"
echo "  tmux ls                    # List sessions"
echo "  tmux new -s <name>         # Create named session"
echo "  tmux attach -t <name>      # Attach to session"
echo "  tmux kill-session -t <name> # Kill session"

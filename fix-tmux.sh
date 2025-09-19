#!/bin/bash

echo "🔧 Fixing tmux PATH issue..."

# Check if tmux is accessible
if command -v tmux >/dev/null 2>&1; then
    echo "✅ tmux is already accessible: $(which tmux)"
    echo "✅ tmux version: $(tmux -V)"
else
    echo "❌ tmux not found in PATH"
    
    # Check if it exists in Homebrew location
    if [[ -f "/opt/homebrew/bin/tmux" ]]; then
        echo "✅ tmux found in Homebrew: /opt/homebrew/bin/tmux"
        echo "🔧 Setting up Homebrew environment..."
        
        # Add Homebrew to current session
        eval "$(/opt/homebrew/bin/brew shellenv)"
        
        if command -v tmux >/dev/null 2>&1; then
            echo "✅ tmux is now accessible: $(which tmux)"
        else
            echo "❌ Still can't find tmux after Homebrew setup"
        fi
    else
        echo "❌ tmux not found in Homebrew location either"
        echo "🔧 Installing tmux..."
        /opt/homebrew/bin/brew install tmux
    fi
fi

echo ""
echo "🚀 Solution:"
echo "1. Restart your terminal, OR"
echo "2. Run: source ~/.zshrc"
echo "3. Then try: tmux"
echo ""
echo "Your .zshrc has been updated to automatically set up Homebrew paths."

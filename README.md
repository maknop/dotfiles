# Dotfiles

A modern Neovim configuration written in Lua with automated installation scripts.

## 🚀 Quick Start

```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run the installation script
./start.sh
```

## 📁 Structure

```
dotfiles/
├── start.sh                    # Main installation script
├── scripts/
│   ├── functions.sh           # Shared installation functions
│   ├── macos.sh              # macOS-specific installation
│   └── linux.sh              # Linux-specific installation
├── .zshrc                     # Zsh configuration
├── .zsh_aliases               # Zsh aliases
├── .zsh_profile               # Zsh profile
├── .gitconfig                 # Git configuration
└── .config/
    ├── nvim/                  # Neovim configuration
    │   ├── init.lua          # Main Neovim configuration
    │   └── lua/config/
    │       ├── options.lua   # General settings
    │       ├── keymaps.lua   # Key mappings
    │       ├── autocmds.lua  # Autocommands
    │       ├── lazy.lua      # Plugin management (lazy.nvim)
    │       ├── lsp.lua       # LSP configuration
    │       └── cmp.lua       # Completion configuration
    └── tmux/
        └── tmux.conf         # Tmux configuration
```

## ✨ Features

### Neovim Configuration
- **Modern Lua-based configuration** - Fast and maintainable
- **Lazy loading plugins** - Quick startup times with lazy.nvim
- **Modular structure** - Easy to customize and extend
- **LSP support** - Built-in language server support for:
  - Python (pyright, ruff)
  - Go (gopls)
  - TypeScript/JavaScript (ts_ls)
- **Intelligent completion** - nvim-cmp with multiple sources
- **File navigation** - Telescope fuzzy finder
- **Syntax highlighting** - Treesitter integration
- **Multiple color schemes** - catppuccin, gruvbox, everforest, and more

### Shell & Terminal Configuration
- **Zsh configuration** - Oh My Zsh integration with custom theme and plugins
- **Tmux setup** - Modern terminal multiplexer with catppuccin theme
- **Custom aliases** - Convenient shortcuts for git, tmux, and development
- **TPM integration** - Tmux Plugin Manager for extensibility

### Installation Script Features
- **Cross-platform** - Supports macOS and Linux
- **Automatic dependency installation** - Installs Neovim, tmux, LSP servers, and tools
- **Safe symlinking** - Backs up existing configurations before linking
- **Package manager detection** - Uses Homebrew on macOS, apt/yum/pacman on Linux
- **Colored output** - Clear progress indicators and error messages

## 🛠 What Gets Installed

### Core Tools
- **Neovim** - Latest version via package manager
- **Tmux** - Terminal multiplexer with TPM (Tmux Plugin Manager)
- **Git** - Version control
- **Node.js & npm** - For TypeScript LSP and tools
- **Python 3 & pip** - For Python LSP servers
- **Go** - For Go development and gopls
- **ripgrep** - Fast text search for Telescope
- **fd** - Fast file finder

### LSP Servers
- **pyright** - Python language server
- **ruff-lsp** - Python linting and formatting
- **typescript-language-server** - TypeScript/JavaScript support
- **gopls** - Go language server

### Additional Tools (OS-specific)
- **macOS**: tree, htop, jq, fzf, bat, exa, delta
- **Linux**: tree, htop, jq, fzf, bat, exa, build-essential

## 📋 Manual Installation Steps

If you prefer to install manually:

1. **Install Neovim** (version 0.8+)
2. **Backup existing config**: `mv ~/.config/nvim ~/.config/nvim.backup`
3. **Symlink configuration**: `ln -sf /path/to/dotfiles/.config/nvim ~/.config/nvim`
4. **Install dependencies**: See the installation script for your OS
5. **Start Neovim**: `nvim` (plugins will install automatically)

## ⚙️ Customization

### Adding Plugins
Edit `~/.config/nvim/lua/config/lazy.lua` and add your plugins following the lazy.nvim syntax.

### Modifying Settings
- **General settings**: `~/.config/nvim/lua/config/options.lua`
- **Key mappings**: `~/.config/nvim/lua/config/keymaps.lua`
- **LSP configuration**: `~/.config/nvim/lua/config/lsp.lua`

### Color Schemes
The configuration includes several color schemes. Change the active one in `options.lua`:
```lua
vim.cmd("colorscheme catppuccin")  -- or gruvbox, everforest, etc.
```

## 🔧 Troubleshooting

### Plugin Installation Issues
```bash
# Open Neovim and run:
:Lazy sync
```

### LSP Server Issues
```bash
# Check LSP server status in Neovim:
:LspInfo

# Install missing LSP servers manually:
pip install pyright ruff-lsp
npm install -g typescript typescript-language-server
go install golang.org/x/tools/gopls@latest
```

### Permission Issues
```bash
# Make scripts executable:
chmod +x start.sh scripts/*.sh
```

## 📝 Key Mappings

| Key | Mode | Action |
|-----|------|--------|
| `,` | Normal | Leader key |
| `jk` / `JK` | Insert | Exit insert mode |
| `;` | Normal | Enter command mode |
| `<C-n>` | Normal | Toggle NERDTree |
| `<leader>ff` | Normal | Find files (Telescope) |
| `<leader>fg` | Normal | Live grep (Telescope) |
| `<leader>fb` | Normal | Find buffers (Telescope) |
| `<leader>r` | Normal | Recent files (Telescope) |
| `<C-h/j/k/l>` | Normal | Navigate windows |

## 🤝 Contributing

Feel free to fork and customize this configuration for your needs. If you find improvements or fixes, pull requests are welcome!

## 📄 License

This configuration is provided as-is. Feel free to use and modify as needed.

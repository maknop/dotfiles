# Dotfiles

A modern Neovim configuration written in Lua with automated installation scripts.

## 🚀 Quick Start

```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run the installation script
./start.sh

# Or use the Makefile
make install
```

## 📁 Structure

```
dotfiles/
├── Makefile                   # Build automation and linting
├── start.sh                   # Main installation script
├── scripts/
│   ├── functions.sh          # Shared installation functions
│   ├── macos.sh             # macOS-specific installation
│   └── linux.sh             # Linux-specific installation
├── .gitconfig                 # Git configuration
└── .config/
    ├── fish/                  # Fish shell configuration
    │   ├── config.fish       # Main fish configuration
    │   ├── fish_plugins      # Fisher plugin list
    │   └── functions/        # Fish function definitions (aliases)
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
- **Fish shell** - Modern shell with excellent defaults and completions
  - Automatically installed and set as default shell
  - Fisher plugin manager with modern prompt (Tide theme)
  - All aliases converted to native fish functions
  - Enhanced completions for git, docker, kubectl, and more
- **Tmux setup** - Modern terminal multiplexer with everforest theme
- **Custom aliases/functions** - Convenient shortcuts for git, tmux, docker, kubectl, and development
- **TPM integration** - Tmux Plugin Manager for extensibility

### Installation Script Features
- **Cross-platform** - Supports macOS and Linux
- **Automatic dependency installation** - Installs Neovim, tmux, LSP servers, and tools
- **Safe symlinking** - Automatically replaces existing configurations
- **Package manager detection** - Uses Homebrew on macOS, apt/yum/pacman on Linux
- **Colored output** - Clear progress indicators and error messages

## 🛠 What Gets Installed

### Core Tools
- **Neovim** - Latest version via package manager
- **Tmux** - Terminal multiplexer with TPM (Tmux Plugin Manager)
- **Fish Shell** - Modern shell with excellent defaults (NEW!)
  - Fisher plugin manager
  - Tide prompt theme
  - nvm.fish for Node version management
  - All aliases converted to fish functions
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
2. **Remove existing config** (if any): `rm -rf ~/.config/nvim`
3. **Symlink configuration**: `ln -sf /path/to/dotfiles/.config/nvim ~/.config/nvim`
4. **Install dependencies**: See the installation script for your OS
5. **Start Neovim**: `nvim` (plugins will install automatically)

## 🐚 Fish Shell

The installation script automatically:
- ✅ Installs fish shell
- ✅ Configures fish with all environment variables
- ✅ Installs Fisher plugin manager
- ✅ Installs all fish plugins (Tide theme, nvm.fish, bass)
- ✅ Converts all aliases to fish functions
- ✅ Sets fish as your default shell

After installation, **simply restart your terminal** and you'll be using fish!

### Customizing Fish

**Configure the Tide prompt:**
```bash
tide configure
```

**Add custom functions:**
Create new files in `~/.config/fish/functions/` - fish automatically loads them.

**Install additional plugins:**
```bash
fisher install <plugin-name>
```

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

## 🛠 Development & Maintenance

### Makefile Targets

The repository includes a Makefile for common development tasks:

```bash
# Show all available targets
make help

# Run linting checks
make lint                # Run all linting (shellcheck)
make shellcheck         # Run only shellcheck on shell scripts

# Installation and testing
make install            # Run the installation script
make test              # Run configuration tests
make check             # Run basic validation checks

# Maintenance
make clean             # Clean up temporary files
make fix-permissions   # Fix script permissions
make list              # List all shell scripts
```

### Code Quality

All shell scripts are linted with shellcheck:
```bash
make shellcheck         # Check all scripts
make shellcheck-verbose # Detailed output
make pre-commit        # Run before committing changes
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

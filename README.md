# Dotfiles

A modern Neovim configuration written in Lua with automated installation scripts.

## Quick Start

```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run the installation script
./start.sh

# Or use the Makefile
make install
```

## Structure

```
dotfiles/
├── Makefile                   # Build automation and linting
├── start.sh                   # Main installation script
├── scripts/
│   ├── functions.sh          # Shared installation functions
│   ├── macos.sh             # macOS-specific installation
│   └── linux.sh             # Linux-specific installation
└── .config/
    ├── fish/                  # Fish shell configuration
    │   ├── config.fish       # Main fish configuration
    │   ├── fish_plugins      # Fisher plugin list
    │   └── fish_variables    # Fish variables
    ├── nvim/                  # Neovim configuration
    │   ├── init.lua          # Entry point — loads config modules
    │   ├── lazy-lock.json    # Locked plugin versions
    │   └── lua/config/
    │       ├── options.lua   # General settings
    │       ├── keymaps.lua   # Key mappings
    │       ├── autocmds.lua  # Autocommands
    │       ├── lazy.lua      # Plugin management (lazy.nvim)
    │       ├── lsp.lua       # LSP configuration
    │       ├── cmp.lua       # Completion configuration
    │       ├── colorscheme.lua # Colorscheme setup
    │       ├── noice.lua     # UI enhancements (noice.nvim)
    │       └── statusline.lua # Status line configuration
    └── tmux/
        └── tmux.conf         # Tmux configuration
```

## Features

### Neovim Configuration
- **Modern Lua-based configuration** - Fast and maintainable
- **Lazy loading plugins** - Quick startup times with lazy.nvim
- **Modular structure** - Easy to customize and extend
- **LSP support** - Built-in language server support via Neovim 0.11 native API:
  - Python (pyright, ruff)
  - Go (gopls)
  - TypeScript/JavaScript (ts_ls, with Vue plugin support)
- **Intelligent completion** - nvim-cmp with buffer, path, LSP, and cmdline sources
- **File navigation** - Telescope fuzzy finder + NvimTree file explorer
- **Syntax highlighting** - Treesitter integration
- **Multiple color schemes** - catppuccin, gruvbox, everforest-nvim, nordic, material, and more
- **Enhanced UI** - noice.nvim for command line and notifications
- **Status line** - vim-airline

### Shell & Terminal Configuration
- **Fish shell** - Modern shell with excellent defaults and completions
  - Automatically installed and set as default shell
  - Fisher plugin manager with bobthefish prompt theme
  - nvm.fish for Node version management
  - bass for running bash scripts in fish
- **Tmux setup** - Modern terminal multiplexer with Everforest theme
- **Custom key bindings** - Convenient shortcuts for tmux pane navigation
- **TPM integration** - Tmux Plugin Manager for extensibility

### Installation Script Features
- **Cross-platform** - Supports macOS and Linux (Ubuntu, Debian, RHEL/CentOS, Fedora, Arch)
- **Automatic dependency installation** - Installs Neovim, tmux, LSP servers, and tools
- **Safe symlinking** - Automatically replaces existing configurations
- **Package manager detection** - Uses Homebrew on macOS, apt/yum/dnf/pacman on Linux
- **Colored output** - Clear progress indicators and error messages

## What Gets Installed

### Core Tools
- **Neovim** - Version 0.11+ (enforced on macOS and Ubuntu; other distros use system package manager)
- **Tmux** - Terminal multiplexer with TPM (Tmux Plugin Manager)
- **Fish Shell** - Modern shell with excellent defaults
  - Fisher plugin manager
  - bobthefish prompt theme
  - nvm.fish for Node version management
  - bass for running bash scripts
- **Git** - Version control
- **Node.js & npm** - For TypeScript LSP and tools
- **Python 3 & pip** - For Python LSP servers
- **Go** - For Go development and gopls
- **ripgrep** - Fast text search for Telescope
- **fd** - Fast file finder

### LSP Servers
- **pyright** - Python language server
- **ruff** - Python linting and formatting (`ruff server`)
- **typescript-language-server** - TypeScript/JavaScript support
- **gopls** - Go language server

### Additional Tools (OS-specific)
- **macOS**: tree, htop, jq, fzf, bat, exa, delta
- **Linux (Debian/Ubuntu)**: tree, htop, jq, fzf, bat, exa, build-essential
- **Linux (RHEL/CentOS)**: tree, htop, jq, fzf, bat, exa, gcc, make
- **Linux (Arch)**: tree, htop, jq, fzf, bat, exa, base-devel

## Manual Installation Steps

If you prefer to install manually:

1. **Install Neovim** (version 0.11+)
2. **Remove existing config** (if any): `rm -rf ~/.config/nvim`
3. **Symlink configuration**: `ln -sf /path/to/dotfiles/.config/nvim ~/.config/nvim`
4. **Install dependencies**: See the installation script for your OS
5. **Start Neovim**: `nvim` (plugins will install automatically via lazy.nvim)

## Fish Shell

The installation script automatically:
- Installs fish shell
- Configures fish with all environment variables
- Installs Fisher plugin manager
- Installs all fish plugins (bobthefish theme, nvm.fish, bass)
- Sets fish as your default shell

After installation, **simply restart your terminal** and you'll be using fish.

### Fish Plugins

Managed via Fisher (`fish_plugins`):
- `jorgebucaran/fisher` - Plugin manager
- `oh-my-fish/theme-bobthefish` - Prompt theme
- `jorgebucaran/nvm.fish` - Node version management
- `edc/bass` - Run bash scripts in fish

### Customizing Fish

**Configure the bobthefish prompt** — edit theme variables in `config.fish`:
```fish
set -g theme_nerd_fonts yes
set -g theme_color_scheme zenburn
```

**Add custom functions:**
Create new files in `~/.config/fish/functions/` — fish automatically loads them.

**Install additional plugins:**
```fish
fisher install <plugin-name>
```

## Customization

### Adding Neovim Plugins
Edit `~/.config/nvim/lua/config/lazy.lua` and add plugins following the lazy.nvim syntax.

### Modifying Settings
- **General settings**: `~/.config/nvim/lua/config/options.lua`
- **Key mappings**: `~/.config/nvim/lua/config/keymaps.lua`
- **LSP configuration**: `~/.config/nvim/lua/config/lsp.lua`
- **Colorscheme**: `~/.config/nvim/lua/config/colorscheme.lua`

### Color Schemes
The configuration includes several color schemes. Change the active one in `colorscheme.lua`.
Available schemes from installed plugins: catppuccin, gruvbox, everforest, nordic, material, oceanic-material.

## Development & Maintenance

### Makefile Targets

```bash
# Show all available targets
make help

# Run linting checks
make lint           # Run all linting (shellcheck + fish + lua)
make shellcheck     # Run only shellcheck on shell scripts
make fish-lint      # Check fish syntax on all .fish files
make lua-lint       # Run luacheck on Neovim Lua config

# Installation and testing
make install        # Run the installation script
make test           # Run configuration tests
make check          # Run basic validation checks

# Maintenance
make clean          # Clean up temporary files
make fix-permissions # Fix script permissions
make list           # List all shell scripts
make pre-commit     # Run lint + check before committing
```

### Code Quality

Shell scripts are linted with shellcheck, fish files with `fish --no-execute`, and Lua files with luacheck:
```bash
make lint           # Run all linting
make shellcheck-verbose  # Detailed shellcheck output
```

## Troubleshooting

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

## Key Mappings

| Key | Mode | Action |
|-----|------|--------|
| `,` | Normal | Leader key |
| `jk` / `JK` | Insert | Exit insert mode |
| `;` | Normal | Enter command mode |
| `H` | Normal | Jump to start of line (`^`) |
| `L` | Normal | Jump to end of line (`$`) |
| `w` | Normal | Move back one word (`b`) |
| `<C-n>` | Normal | Toggle NvimTree |
| `<C-m>` | Normal | Find current file in NvimTree |
| `<C-h/j/k/l>` | Normal | Navigate windows |
| `<C-c>` | Visual | Copy to system clipboard |
| `<C-p>` | Normal | Toggle paste mode |
| `<leader>ff` | Normal | Find files (Telescope) |
| `<leader>fg` | Normal | Live grep (Telescope) |
| `<leader>fb` | Normal | Find buffers (Telescope) |
| `<leader>fh` | Normal | Find help tags (Telescope) |
| `<leader>r` | Normal | Recent files (Telescope) |

### Tmux Key Bindings

| Key | Action |
|-----|--------|
| `C-Space` | Prefix key |
| `prefix + -` | Split pane horizontally |
| `prefix + =` | Split pane vertically |
| `prefix + h/j/k/l` | Navigate panes (vi-style) |
| `prefix + C-h/j/k/l` | Resize panes |
| `prefix + b` | Toggle status bar |
| `v` (copy mode) | Begin selection |
| `y` (copy mode) | Yank selection |

## Contributing

Feel free to fork and customize this configuration for your needs. If you find improvements or fixes, pull requests are welcome!

## License

This configuration is provided as-is. Feel free to use and modify as needed.

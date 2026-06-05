# Dotfiles

A modern Neovim configuration written in Lua with automated installation scripts.

## Quick Start

```bash
# Clone the repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Run the installation script
./start.sh
```

## Structure

```
dotfiles/
├── Makefile                   # Build automation and linting
├── start.sh                   # Main installation script (Linux + macOS)
├── scripts/
│   └── functions.sh          # All installation functions
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
- **Cross-platform** - Supports macOS and Fedora Linux
- **Automatic dependency installation** - Installs Neovim, tmux, LSP servers, and tools
- **Safe symlinking** - Automatically replaces existing configurations
- **Package manager detection** - Uses Homebrew on macOS, apt/yum/dnf/pacman on Linux
- **Colored output** - Clear progress indicators and error messages


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

# Dotfiles — Claude Code Guidelines

## Cross-platform requirement

These dotfiles must work on **both Fedora Linux and macOS**. Every change must be verified on both platforms before being considered complete.

### Platform detection

- `start.sh` and `scripts/functions.sh` branch on `$(uname)`: `Darwin` for macOS, `Linux` for Linux.
- Linux distro is detected via `/etc/os-release` (`$ID`): primary target is `fedora`.
- When adding any OS-specific logic, always add both a `Darwin` branch and a `fedora` branch.

### Package managers

| Platform | Manager | Notes |
|----------|---------|-------|
| macOS | Homebrew (`brew`) | Installed automatically if missing; supports both Apple Silicon (`/opt/homebrew`) and Intel (`/usr/local`) |
| Fedora | `dnf` | Primary Linux target |

When adding a new tool, add it to both the `Darwin` and `fedora` sections of `install_extra_tools` and `install_dependencies`.

### Fish shell

- Fish config lives in `.config/fish/config.fish`.
- **Do not use bash/POSIX syntax in `.fish` files.** Fish is not POSIX-compatible.
  - Wrong: `export PATH="$HOME/.local/bin:$PATH"` — `$PATH` in fish is a list; quoting joins elements with spaces, mangling PATH.
  - Correct: `fish_add_path $HOME/.local/bin`
- The Homebrew `if/else if/end` block in `config.fish` is intentional — it is a no-op on Linux.

### Neovim

- Minimum required version: **0.11** (enforced in `functions.sh` via `version_gte`).
- macOS: enforced via Homebrew (`brew install/upgrade neovim`).
- Fedora: installed via `dnf install neovim`. Fedora 41+ ships 0.11+. If version enforcement becomes necessary, mirror the Ubuntu GitHub-tarball fallback path.
- LSP config uses the Neovim 0.11 native LSP API (`vim.lsp.config` / `vim.lsp.enable`) — do not revert to `nvim-lspconfig`.

### LSP servers

Both `pyright` and `ruff` are enabled in `lsp.lua` and must be installed by `install_lsp_servers`. Keep the pip install line in sync with what `lsp.lua` enables.

### Clipboard in tmux

`tmux-yank` requires:
- macOS: `pbcopy`/`pbpaste` (built in, no action needed)
- Linux: `xclip` (installed via `install_extra_tools`)

### Package name differences to watch for

| Tool | macOS (brew) | Fedora (dnf) |
|------|-------------|-------------|
| modern `ls` replacement | `eza` | `eza` |
| fast find | `fd` | `fd-find` |

## Linting

Run `make lint` before committing. This runs shellcheck, fish syntax check, and luacheck.

The CI workflows in `.github/workflows/` mirror these checks.

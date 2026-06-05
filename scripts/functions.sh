#!/bin/bash

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

readonly REQUIRED_NVIM_VERSION="0.11"
readonly NVIM_INSTALL_DIR="/opt/nvim"
readonly NVIM_BIN_LINK="/usr/local/bin/nvim"
readonly TPM_DIR="$HOME/.tmux/plugins/tpm"

log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1"; }

command_exists() { command -v "$1" >/dev/null 2>&1; }

version_gte() {
    local lower
    lower=$(printf '%s\n%s' "$1" "$2" | sort -V | head -n1)
    [[ "$lower" == "$2" ]]
}

get_nvim_version() {
    command_exists nvim && nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?'
}

get_linux_distro() {
    if [ -f /etc/os-release ]; then
        # shellcheck source=/dev/null
        . /etc/os-release
        echo "$ID"
        return
    fi
    echo "unknown"
}

# -----------------------------------------------------------------------------
# Symlink management
# -----------------------------------------------------------------------------

create_symlink() {
    local source="$1" target="$2"
    [ -e "$source" ] || { log_error "Source not found: $source"; return 1; }
    mkdir -p "$(dirname "$target")"
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
    fi
    ln -sf "$source" "$target" && log_success "Linked $(basename "$target")"
}

install_dotfiles_config() {
    local dotfiles_dir="$1" failed=0
    local configs=(".config/nvim" ".config/tmux" ".config/fish")

    for config in "${configs[@]}"; do
        local source="$dotfiles_dir/$config"
        if [ -d "$source" ]; then
            create_symlink "$source" "$HOME/$config" || failed=1
        else
            log_warning "Not found: $source (skipping)"
        fi
    done

    local gitconfig="$dotfiles_dir/.gitconfig"
    if [ -f "$gitconfig" ]; then
        create_symlink "$gitconfig" "$HOME/.gitconfig" || failed=1
    fi

    return $failed
}

# -----------------------------------------------------------------------------
# Package manager
# -----------------------------------------------------------------------------

install_package_manager() {
    local os="$1"
    case "$os" in
        Darwin)
            if ! command_exists brew; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                if [[ $(uname -m) == "arm64" ]]; then
                    eval "$(/opt/homebrew/bin/brew shellenv)"
                else
                    eval "$(/usr/local/bin/brew shellenv)"
                fi
                command_exists brew || { log_error "Homebrew installation failed"; return 1; }
                log_success "Homebrew installed"
            fi
            ;;
        Linux)
            local distro
            distro=$(get_linux_distro)
            case "$distro" in
                ubuntu|debian)      sudo apt-get update || true ;;
                fedora)             sudo dnf check-update || true ;;
                rhel|centos)        sudo yum check-update || true ;;
                arch|manjaro)       sudo pacman -Sy || true ;;
                *)
                    if command_exists dnf; then sudo dnf check-update || true
                    elif command_exists apt-get; then sudo apt-get update || true
                    elif command_exists yum; then sudo yum check-update || true
                    fi ;;
            esac
            ;;
    esac
}

# -----------------------------------------------------------------------------
# Neovim
# -----------------------------------------------------------------------------

install_neovim() {
    local os="$1"
    local current_version
    current_version=$(get_nvim_version)

    if [[ -n "$current_version" ]] && version_gte "$current_version" "$REQUIRED_NVIM_VERSION"; then
        log_success "Neovim $current_version already meets requirements"
        return 0
    fi

    [[ -n "$current_version" ]] && log_warning "Neovim $current_version is below minimum $REQUIRED_NVIM_VERSION"
    log_info "Installing Neovim..."

    case "$os" in
        Darwin)
            command_exists brew || { log_error "Homebrew required for Neovim"; return 1; }
            brew install neovim || brew upgrade neovim || return 1
            ;;
        Linux)
            _install_neovim_linux
            ;;
    esac
}

_install_neovim_linux() {
    local distro
    distro=$(get_linux_distro)

    if [[ "$distro" == "ubuntu" ]]; then
        _install_neovim_ubuntu
        return $?
    fi

    if command_exists dnf; then sudo dnf install -y neovim
    elif command_exists pacman; then sudo pacman -S --noconfirm neovim
    elif command_exists apt-get; then sudo apt-get install -y neovim
    elif command_exists yum; then sudo yum install -y neovim
    else log_error "No supported package manager found"; return 1
    fi
}

_install_neovim_ubuntu() {
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64)        arch="linux64" ;;
        aarch64|arm64) arch="linux-arm64" ;;
        *) log_error "Unsupported architecture: $arch"; return 1 ;;
    esac

    if command_exists add-apt-repository; then
        grep -q "neovim-ppa/unstable" /etc/apt/sources.list.d/*.list 2>/dev/null || \
            sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt-get update && sudo apt-get install -y neovim && return 0
    fi

    _install_neovim_from_github "$arch"
}

_install_neovim_from_github() {
    local arch="$1"
    local url="https://github.com/neovim/neovim/releases/latest/download/nvim-${arch}.tar.gz"
    local tmp
    tmp=$(mktemp -d)

    log_info "Downloading Neovim from GitHub releases..."
    curl -L -o "$tmp/nvim.tar.gz" "$url" || { rm -rf "$tmp"; return 1; }

    sudo rm -rf "$NVIM_INSTALL_DIR"

    if ! sudo tar -xzf "$tmp/nvim.tar.gz" -C /opt --transform='s/^nvim-linux[^/]*/nvim/' 2>/dev/null; then
        sudo tar -xzf "$tmp/nvim.tar.gz" -C /opt
        local extracted
        extracted=$(find /opt -maxdepth 1 -name "nvim-*" -type d | head -1)
        [[ -n "$extracted" ]] && sudo mv "$extracted" "$NVIM_INSTALL_DIR"
    fi

    sudo ln -sf "$NVIM_INSTALL_DIR/bin/nvim" "$NVIM_BIN_LINK"
    rm -rf "$tmp"

    if [[ -x "$NVIM_BIN_LINK" ]]; then
        log_success "Neovim installed from GitHub"
        return 0
    fi
    log_error "Failed to install Neovim from GitHub"
    return 1
}

# -----------------------------------------------------------------------------
# Dependencies
# -----------------------------------------------------------------------------

install_dependencies() {
    local os="$1"
    log_info "Installing dependencies..."

    case "$os" in
        Darwin)
            local pkgs=(git curl wget ripgrep fd node python3 go)
            local to_install=()
            for pkg in "${pkgs[@]}"; do
                brew list "$pkg" &>/dev/null || command_exists "$pkg" || to_install+=("$pkg")
            done
            [[ ${#to_install[@]} -gt 0 ]] && brew install "${to_install[@]}"
            ;;
        Linux)
            local distro
            distro=$(get_linux_distro)
            case "$distro" in
                ubuntu|debian)
                    sudo apt-get install -y git curl wget ripgrep fd-find nodejs npm python3 python3-pip golang-go ;;
                fedora)
                    sudo dnf install -y git curl wget ripgrep fd-find nodejs npm python3 python3-pip golang ;;
                rhel|centos)
                    sudo yum install -y git curl wget ripgrep fd-find nodejs npm python3 python3-pip golang ;;
                arch|manjaro)
                    sudo pacman -S --noconfirm git curl wget ripgrep fd nodejs npm python python-pip go ;;
                *)
                    if command_exists dnf; then
                        sudo dnf install -y git curl wget ripgrep fd-find nodejs npm python3 python3-pip golang
                    elif command_exists apt-get; then
                        sudo apt-get install -y git curl wget ripgrep fd-find nodejs npm python3 python3-pip golang-go
                    elif command_exists yum; then
                        sudo yum install -y git curl wget ripgrep fd-find nodejs npm python3 python3-pip golang
                    fi ;;
            esac
            ;;
    esac
}

install_extra_tools() {
    local os="$1"
    log_info "Installing extra tools..."

    case "$os" in
        Darwin)
            local pkgs=(tree htop jq fzf bat eza delta)
            local to_install=()
            for pkg in "${pkgs[@]}"; do
                brew list "$pkg" &>/dev/null || command_exists "$pkg" || to_install+=("$pkg")
            done
            [[ ${#to_install[@]} -gt 0 ]] && brew install "${to_install[@]}"
            ;;
        Linux)
            local distro
            distro=$(get_linux_distro)
            case "$distro" in
                ubuntu|debian)   sudo apt-get install -y tree htop jq fzf bat exa build-essential ;;
                fedora)          sudo dnf install -y tree htop jq fzf bat eza gcc gcc-c++ make ;;
                rhel|centos)     sudo yum install -y tree htop jq fzf bat gcc gcc-c++ make ;;
                arch|manjaro)    sudo pacman -S --noconfirm tree htop jq fzf bat eza base-devel ;;
                *)               log_warning "Unknown distro '$distro', skipping extra tools" ;;
            esac
            ;;
    esac
}

# -----------------------------------------------------------------------------
# Tmux
# -----------------------------------------------------------------------------

install_tmux_setup() {
    local os="$1"

    if ! command_exists tmux; then
        log_info "Installing tmux..."
        case "$os" in
            Darwin) brew install tmux ;;
            Linux)
                if command_exists dnf; then sudo dnf install -y tmux
                elif command_exists apt-get; then sudo apt-get install -y tmux
                elif command_exists yum; then sudo yum install -y tmux
                elif command_exists pacman; then sudo pacman -S --noconfirm tmux
                fi ;;
        esac
    fi

    if [ ! -d "$TPM_DIR" ]; then
        log_info "Installing TPM..."
        if git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"; then
            log_success "TPM installed"
        else
            log_warning "TPM installation failed"
        fi
    fi
}

# -----------------------------------------------------------------------------
# LSP servers
# -----------------------------------------------------------------------------

install_lsp_servers() {
    log_info "Installing LSP servers..."

    if command_exists pip3; then
        pip3 install --user pyright || log_warning "pyright install failed"
    fi

    if command_exists npm; then
        npm install -g typescript typescript-language-server || log_warning "typescript-language-server install failed"
    fi

    if command_exists go; then
        go install golang.org/x/tools/gopls@latest || log_warning "gopls install failed"
    fi
}

# -----------------------------------------------------------------------------
# Fish shell
# -----------------------------------------------------------------------------

_add_fish_to_shells() {
    local fish_path
    fish_path=$(command -v fish)
    grep -q "$fish_path" /etc/shells 2>/dev/null || echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
}

install_fish_shell() {
    local os="$1"

    if command_exists fish; then
        log_success "Fish already installed ($(fish --version 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1))"
        return 0
    fi

    log_info "Installing fish shell..."
    case "$os" in
        Darwin) brew install fish ;;
        Linux)
            if command_exists dnf; then sudo dnf install -y fish
            elif command_exists apt-get; then sudo apt-get install -y fish
            elif command_exists yum; then sudo yum install -y fish
            elif command_exists pacman; then sudo pacman -S --noconfirm fish
            else log_error "No supported package manager for fish"; return 1
            fi ;;
    esac

    _add_fish_to_shells
}

install_fisher_and_plugins() {
    command_exists fish || { log_warning "Fish not installed, skipping Fisher"; return 1; }

    if ! fish -c "type -q fisher" 2>/dev/null; then
        log_info "Installing Fisher..."
        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher" || \
            { log_warning "Fisher installation failed"; return 1; }
    fi

    if [ -f "$HOME/.config/fish/fish_plugins" ]; then
        fish -c "fisher update" || log_warning "Some fish plugins failed to install"
    fi
}

set_fish_as_default_shell() {
    command_exists fish || { log_warning "Fish not installed"; return 1; }

    local fish_path
    fish_path=$(command -v fish)
    [[ "$SHELL" == "$fish_path" ]] && { log_success "Fish is already the default shell"; return 0; }

    _add_fish_to_shells

    if chsh -s "$fish_path"; then
        log_success "Default shell set to fish (restart terminal to apply)"
    else
        log_warning "Could not set fish as default — run: chsh -s $fish_path"
    fi
}

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------

print_summary() {
    echo ""
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_success "Installation complete!"
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    if command_exists fish; then log_success "  fish + fisher + plugins"; else log_warning "  fish (may have failed)"; fi
    if command_exists nvim; then log_success "  neovim $(get_nvim_version)"; else log_warning "  neovim (may have failed)"; fi
    if command_exists tmux; then log_success "  tmux + TPM"; else log_warning "  tmux (may have failed)"; fi

    echo ""
    log_info "Next steps:"
    log_info "  1. Restart terminal to use fish shell"
    log_info "  2. Run: nvim  (plugins install automatically on first launch)"
    log_info "  3. In tmux: prefix + I to install plugins"
    log_info "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# -----------------------------------------------------------------------------
# Main orchestration
# -----------------------------------------------------------------------------

run_installation() {
    local os="$1"
    local dotfiles_dir="$2"
    local failed=0

    log_info "Installing dotfiles for $os..."

    install_package_manager "$os"           || { log_error "Package manager setup failed"; return 1; }
    install_neovim "$os"                    || failed=1
    install_dependencies "$os"              || failed=1
    install_dotfiles_config "$dotfiles_dir" || failed=1
    install_tmux_setup "$os"               || failed=1
    install_lsp_servers                     || failed=1
    install_fish_shell "$os"               || failed=1
    install_fisher_and_plugins              || failed=1
    set_fish_as_default_shell              || failed=1
    install_extra_tools "$os"              || failed=1

    print_summary

    [[ $failed -eq 0 ]] || log_warning "Some steps had warnings — review output above"
    return $failed
}

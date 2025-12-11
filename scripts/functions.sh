#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ ! -e "$source" ]; then
        log_error "Source $source does not exist"
        return 1
    fi
    
    # Create target directory if it doesn't exist
    local target_dir
    target_dir=$(dirname "$target")
    if [ ! -d "$target_dir" ]; then
        log_info "Creating directory $target_dir"
        mkdir -p "$target_dir"
    fi
    
    # Remove existing file/directory if it exists
    if [ -e "$target" ] || [ -L "$target" ]; then
        log_info "Removing existing $target"
        rm -rf "$target"
    fi

    # Create symlink
    log_info "Creating symlink: $target -> $source"
    if ln -sf "$source" "$target"; then
        log_success "Successfully created symlink for $(basename "$target")"
        return 0
    else
        log_error "Failed to create symlink for $(basename "$target")"
        return 1
    fi
}

# Install all dotfiles configurations
install_dotfiles_config() {
    local dotfiles_dir="$1"
    
    log_info "Installing dotfiles configurations..."
    
    # Install Neovim configuration
    local nvim_config_source="$dotfiles_dir/.config/nvim"
    local nvim_config_target="$HOME/.config/nvim"
    
    if [ -d "$nvim_config_source" ]; then
        create_symlink "$nvim_config_source" "$nvim_config_target"
        
        # Check if Neovim is installed
        if command_exists nvim; then
            log_success "Neovim is installed"
            log_info "Configuration will be loaded on next Neovim startup"
            log_info "Lazy.nvim will automatically install plugins on first run"
        else
            log_warning "Neovim is not installed. Please install it first."
        fi
    else
        log_warning "Neovim config source directory not found: $nvim_config_source"
    fi
    
    # Install tmux configuration
    local tmux_config_source="$dotfiles_dir/.config/tmux"
    local tmux_config_target="$HOME/.config/tmux"
    
    if [ -d "$tmux_config_source" ]; then
        create_symlink "$tmux_config_source" "$tmux_config_target"
        log_success "Tmux configuration linked"
    else
        log_warning "Tmux config source directory not found: $tmux_config_source"
    fi
    
    # Install shell configuration files
    local shell_configs=(".zshrc" ".zsh_aliases" ".zsh_profile" ".gitconfig")
    
    for config in "${shell_configs[@]}"; do
        local source_file="$dotfiles_dir/$config"
        local target_file="$HOME/$config"
        
        if [ -f "$source_file" ]; then
            create_symlink "$source_file" "$target_file"
            log_success "Linked $config"
        else
            log_info "Config file not found: $source_file (skipping)"
        fi
    done
}

# Install package manager (if not exists)
install_package_manager() {
    local os_name="$1"

    case "$os_name" in
        "Darwin")
            if ! command_exists brew; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

                # Add Homebrew to PATH for current shell session
                if [[ $(uname -m) == "arm64" ]]; then
                    # Apple Silicon
                    log_info "Detected Apple Silicon, setting up Homebrew path..."
                    eval "$(/opt/homebrew/bin/brew shellenv)"
                else
                    # Intel Mac
                    log_info "Detected Intel Mac, setting up Homebrew path..."
                    eval "$(/usr/local/bin/brew shellenv)"
                fi

                # Verify brew is now available
                if ! command_exists brew; then
                    log_error "Homebrew installation failed or not in PATH"
                    return 1
                fi

                log_success "Homebrew installed and configured successfully"
            else
                log_success "Homebrew is already installed"
            fi
            ;;
        "Linux")
            # Detect Linux distribution
            if command_exists apt-get; then
                log_info "Detected Debian/Ubuntu system"
                sudo apt-get update
            elif command_exists yum; then
                log_info "Detected Red Hat/CentOS system"
            elif command_exists pacman; then
                log_info "Detected Arch Linux system"
            else
                log_warning "Could not detect package manager"
            fi
            ;;
    esac
}

# Install Neovim
install_neovim() {
    local os_name="$1"
    
    if command_exists nvim; then
        log_success "Neovim is already installed"
        nvim --version | head -1
        return 0
    fi
    
    log_info "Installing Neovim..."
    
    case "$os_name" in
        "Darwin")
            if command_exists brew; then
                if brew install neovim; then
                    log_success "Neovim installed successfully via Homebrew"
                else
                    log_error "Failed to install Neovim via Homebrew"
                    return 1
                fi
            else
                log_error "Homebrew not found. Please install Homebrew first."
                return 1
            fi
            ;;
        "Linux")
            if command_exists apt-get; then
                sudo apt-get install -y neovim
            elif command_exists yum; then
                sudo yum install -y neovim
            elif command_exists pacman; then
                sudo pacman -S neovim
            else
                log_error "Could not install Neovim. Please install manually."
                return 1
            fi
            ;;
    esac
    
    if command_exists nvim; then
        log_success "Neovim installed successfully"
        nvim --version | head -1
    else
        log_error "Failed to install Neovim"
        return 1
    fi
}

# Check if a brew package is installed (faster than command_exists for brew packages)
brew_is_installed() {
    local package="$1"
    brew list "$package" &>/dev/null
}

# Install additional dependencies
install_dependencies() {
    local os_name="$1"
    
    log_info "Installing additional dependencies..."
    
    case "$os_name" in
        "Darwin")
            if ! command_exists brew; then
                log_error "Homebrew not available. Cannot install dependencies."
                return 1
            fi
            
            # Essential quick-install packages (small, fast)
            local essential_deps=("git" "curl" "wget" "ripgrep" "fd")
            
            # Large/slow packages (install separately with better feedback)
            local large_deps=("node" "python3" "go")
            
            # Check and collect packages that need installation
            local to_install=()
            local already_installed=()
            
            log_info "Checking which packages are already installed..."
            for dep in "${essential_deps[@]}"; do
                if brew_is_installed "$dep" || command_exists "$dep"; then
                    already_installed+=("$dep")
                else
                    to_install+=("$dep")
                fi
            done
            
            # Report already installed packages
            if [ ${#already_installed[@]} -gt 0 ]; then
                log_success "Already installed: ${already_installed[*]}"
            fi
            
            # Batch install essential packages
            if [ ${#to_install[@]} -gt 0 ]; then
                log_info "Installing essential packages: ${to_install[*]}"
                log_info "This may take a few minutes..."
                if brew install "${to_install[@]}"; then
                    log_success "Essential packages installed successfully"
                else
                    log_warning "Some essential packages failed to install (continuing anyway)"
                fi
            else
                log_success "All essential packages are already installed"
            fi
            
            # Install large packages separately with progress feedback
            # Note: These can take 5-15 minutes each, so we install them one at a time
            # with clear feedback
            local large_to_install=()
            for dep in "${large_deps[@]}"; do
                if brew_is_installed "$dep" || command_exists "$dep"; then
                    log_success "$dep is already installed"
                else
                    large_to_install+=("$dep")
                fi
            done
            
            if [ ${#large_to_install[@]} -gt 0 ]; then
                log_info "Installing large packages: ${large_to_install[*]}"
                log_warning "These packages can take 5-15 minutes each to install"
                log_info "Brew will show progress during installation..."
                
                for dep in "${large_to_install[@]}"; do
                    log_info "Installing $dep (this may take 5-15 minutes)..."
                    if brew install "$dep"; then
                        log_success "$dep installed successfully"
                    else
                        log_warning "Failed to install $dep (you can install it manually later with: brew install $dep)"
                    fi
                done
            fi
            ;;
        "Linux")
            if command_exists apt-get; then
                deps+=("git" "curl" "wget" "ripgrep" "fd-find" "nodejs" "npm" "python3" "python3-pip" "golang-go")
                
                for dep in "${deps[@]}"; do
                    if ! dpkg -l | grep -q "^ii  $dep "; then
                        log_info "Installing $dep..."
                        sudo apt-get install -y "$dep"
                    else
                        log_success "$dep is already installed"
                    fi
                done
            elif command_exists yum; then
                deps+=("git" "curl" "wget" "ripgrep" "fd-find" "nodejs" "npm" "python3" "python3-pip" "golang")
                
                for dep in "${deps[@]}"; do
                    if ! rpm -qa | grep -q "$dep"; then
                        log_info "Installing $dep..."
                        sudo yum install -y "$dep"
                    else
                        log_success "$dep is already installed"
                    fi
                done
            fi
            ;;
    esac
}

# Install LSP servers
install_lsp_servers() {
    log_info "Installing LSP servers..."
    
    # Python LSP servers
    if command_exists pip3; then
        log_info "Installing Python LSP servers..."
        pip3 install --user pyright ruff-lsp 2>/dev/null || log_warning "Failed to install some Python LSP servers"
    fi
    
    # TypeScript LSP server
    if command_exists npm; then
        log_info "Installing TypeScript LSP server..."
        npm install -g typescript typescript-language-server 2>/dev/null || log_warning "Failed to install TypeScript LSP server"
    fi
    
    # Go LSP server (gopls is usually installed with Go)
    if command_exists go; then
        log_info "Installing Go LSP server..."
        go install golang.org/x/tools/gopls@latest 2>/dev/null || log_warning "Failed to install gopls"
    fi
    
    log_success "LSP server installation completed"
}

# Install tmux and TPM (Tmux Plugin Manager)
install_tmux_setup() {
    local os_name="$1"
    
    log_info "Setting up tmux..."
    
    # Install tmux if not present
    case "$os_name" in
        "Darwin")
            if ! command_exists tmux; then
                if command_exists brew; then
                    log_info "Installing tmux..."
                    if brew install tmux; then
                        log_success "tmux installed successfully via Homebrew"
                    else
                        log_error "Failed to install tmux via Homebrew"
                        return 1
                    fi
                else
                    log_error "Homebrew not found. Please install tmux manually."
                    return 1
                fi
            else
                log_success "tmux is already installed"
            fi
            ;;
        "Linux")
            if ! command_exists tmux; then
                if command_exists apt-get; then
                    sudo apt-get install -y tmux
                elif command_exists yum; then
                    sudo yum install -y tmux
                elif command_exists pacman; then
                    sudo pacman -S tmux
                else
                    log_error "Could not install tmux. Please install manually."
                    return 1
                fi
            else
                log_success "tmux is already installed"
            fi
            ;;
    esac
    
    # Install TPM (Tmux Plugin Manager)
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [ ! -d "$tpm_dir" ]; then
        log_info "Installing TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
        log_success "TPM installed successfully"
        log_info "Run 'tmux source ~/.config/tmux/tmux.conf' and then 'prefix + I' to install plugins"
    else
        log_success "TPM is already installed"
    fi
}

# Main installation function
run_installation() {
    local os_name="$1"
    local dotfiles_dir
    dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    
    log_info "Starting dotfiles installation for $os_name"
    log_info "Dotfiles directory: $dotfiles_dir"
    
    # Install package manager
    install_package_manager "$os_name"
    
    # Install Neovim
    install_neovim "$os_name"
    
    # Install dependencies
    install_dependencies "$os_name"
    
    # Install dotfiles configurations
    install_dotfiles_config "$dotfiles_dir"
    
    # Install tmux and TPM
    install_tmux_setup "$os_name"
    
    # Install LSP servers
    install_lsp_servers
    
    log_success "Installation completed!"
    log_info "You can now start Neovim with 'nvim'"
    log_info "On first startup, lazy.nvim will automatically install all plugins"
}

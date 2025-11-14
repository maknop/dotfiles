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

# Create backup of existing file/directory
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ]; then
        local backup
        backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        log_warning "Backing up existing $target to $backup"
        if mv "$target" "$backup" 2>/dev/null; then
            return 0
        else
            log_error "Failed to backup $target to $backup"
            return 1
        fi
    fi
    return 0
}

# Create symlink with backup
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
        mkdir -p "$target_dir" || {
            log_error "Failed to create directory $target_dir"
            return 1
        }
    fi
    
    # Backup existing file/directory
    backup_if_exists "$target" || log_warning "Could not backup existing $target, continuing anyway"
    
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
    
    if [ -z "$dotfiles_dir" ]; then
        log_error "Dotfiles directory not provided"
        return 1
    fi
    
    if [ ! -d "$dotfiles_dir" ]; then
        log_error "Dotfiles directory does not exist: $dotfiles_dir"
        return 1
    fi
    
    log_info "Installing dotfiles configurations..."
    log_info "Source directory: $dotfiles_dir"
    
    # Install Neovim configuration
    local nvim_config_source="$dotfiles_dir/.config/nvim"
    local nvim_config_target="$HOME/.config/nvim"
    
    if [ -d "$nvim_config_source" ]; then
        create_symlink "$nvim_config_source" "$nvim_config_target" || log_warning "Failed to create Neovim config symlink"
        
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
        create_symlink "$tmux_config_source" "$tmux_config_target" || log_warning "Failed to create tmux config symlink"
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
            create_symlink "$source_file" "$target_file" || log_warning "Failed to create symlink for $config"
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
                
                # Add Homebrew to PATH for Apple Silicon Macs
                if [[ $(uname -m) == "arm64" ]]; then
                    # shellcheck disable=SC2016
                    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                    eval "$(/opt/homebrew/bin/brew shellenv)"
                fi
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
                brew install neovim
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

# Install additional dependencies
install_dependencies() {
    local os_name="$1"
    
    log_info "Installing additional dependencies..."
    
    # Dependencies for LSP servers and tools
    local deps=()
    
    case "$os_name" in
        "Darwin")
            if command_exists brew; then
                # Add common dependencies
                deps+=("git" "curl" "wget" "ripgrep" "fd" "node" "python3" "go")
                
                for dep in "${deps[@]}"; do
                    if ! command_exists "$dep"; then
                        log_info "Installing $dep..."
                        brew install "$dep"
                    else
                        log_success "$dep is already installed"
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
                    brew install tmux
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
    
    # Try to get dotfiles directory from BASH_SOURCE, falling back to script location
    # When sourced, BASH_SOURCE[0] points to functions.sh, so we need to go up one level
    local script_path="${BASH_SOURCE[0]}"
    if [ -z "$script_path" ]; then
        # Fallback: try to find the script directory
        script_path="${0}"
    fi
    
    # Get the directory containing functions.sh (scripts/), then go up one level
    dotfiles_dir="$(cd "$(dirname "$script_path")/.." && pwd)" || {
        log_error "Failed to determine dotfiles directory"
        return 1
    }
    
    log_info "Starting dotfiles installation for $os_name"
    log_info "Dotfiles directory: $dotfiles_dir"
    
    # Verify the dotfiles directory exists and has expected structure
    if [ ! -d "$dotfiles_dir" ]; then
        log_error "Dotfiles directory does not exist: $dotfiles_dir"
        return 1
    fi
    
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

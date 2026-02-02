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

# Compare version strings (returns 0 if $1 >= $2)
version_gte() {
    local version1="$1"
    local version2="$2"

    # Use sort -V for version comparison
    local lower
    lower=$(printf '%s\n%s' "$version1" "$version2" | sort -V | head -n1)

    # If the lower version equals version2, then version1 >= version2
    [[ "$lower" == "$version2" ]]
}

# Get installed Neovim version (returns empty string if not installed)
get_nvim_version() {
    if command_exists nvim; then
        nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?'
    fi
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

    local config_failed=0

    # Install Neovim configuration
    local nvim_config_source="$dotfiles_dir/.config/nvim"
    local nvim_config_target="$HOME/.config/nvim"

    if [ -d "$nvim_config_source" ]; then
        if create_symlink "$nvim_config_source" "$nvim_config_target"; then
            # Check if Neovim is installed
            if command_exists nvim; then
                log_success "Neovim is installed"
                log_info "Configuration will be loaded on next Neovim startup"
                log_info "Lazy.nvim will automatically install plugins on first run"
            else
                log_warning "Neovim is not installed. Please install it first."
            fi
        else
            log_error "Failed to link Neovim configuration"
            config_failed=1
        fi
    else
        log_warning "Neovim config source directory not found: $nvim_config_source"
        config_failed=1
    fi

    # Install tmux configuration
    local tmux_config_source="$dotfiles_dir/.config/tmux"
    local tmux_config_target="$HOME/.config/tmux"

    if [ -d "$tmux_config_source" ]; then
        if create_symlink "$tmux_config_source" "$tmux_config_target"; then
            log_success "Tmux configuration linked"
        else
            log_error "Failed to link tmux configuration"
            config_failed=1
        fi
    else
        log_warning "Tmux config source directory not found: $tmux_config_source"
    fi

    # Install shell configuration files
    local shell_configs=(".zshrc" ".zsh_aliases" ".zprofile" ".gitconfig")

    for config in "${shell_configs[@]}"; do
        local source_file="$dotfiles_dir/$config"
        local target_file="$HOME/$config"

        if [ -f "$source_file" ]; then
            if create_symlink "$source_file" "$target_file"; then
                log_success "Linked $config"
            else
                log_error "Failed to link $config"
                config_failed=1
            fi
        else
            log_info "Config file not found: $source_file (skipping)"
        fi
    done

    if [ $config_failed -ne 0 ]; then
        return 1
    fi
    return 0
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
# Requires Neovim >= 0.11 for full feature support (macOS and Ubuntu only)
REQUIRED_NVIM_VERSION="0.11"

# Check if we should enforce version requirements (macOS and Ubuntu only)
should_enforce_nvim_version() {
    local os_name="$1"

    if [[ "$os_name" == "Darwin" ]]; then
        return 0  # Enforce on macOS
    fi

    if [[ "$os_name" == "Linux" ]]; then
        # Check if Ubuntu
        if [ -f /etc/os-release ]; then
            # shellcheck source=/dev/null
            . /etc/os-release
            if [[ "$ID" == "ubuntu" ]]; then
                return 0  # Enforce on Ubuntu
            fi
        fi
    fi

    return 1  # Don't enforce on other systems
}

install_neovim() {
    local os_name="$1"
    local current_version
    local needs_install=false
    local needs_upgrade=false
    local enforce_version=false

    # Determine if we should enforce version requirements
    if should_enforce_nvim_version "$os_name"; then
        enforce_version=true
    fi

    current_version=$(get_nvim_version)

    if [[ -n "$current_version" ]]; then
        log_info "Found Neovim version: $current_version"
        if [[ "$enforce_version" == true ]]; then
            if version_gte "$current_version" "$REQUIRED_NVIM_VERSION"; then
                log_success "Neovim $current_version meets minimum requirement (>= $REQUIRED_NVIM_VERSION)"
                return 0
            else
                log_warning "Neovim $current_version is below minimum required version $REQUIRED_NVIM_VERSION"
                needs_upgrade=true
            fi
        else
            log_success "Neovim is already installed"
            return 0
        fi
    else
        log_info "Neovim is not installed"
        needs_install=true
    fi

    if [[ "$enforce_version" == true ]]; then
        if [[ "$needs_install" == true ]]; then
            log_info "Installing Neovim >= $REQUIRED_NVIM_VERSION..."
        else
            log_info "Upgrading Neovim to >= $REQUIRED_NVIM_VERSION..."
        fi
    else
        log_info "Installing Neovim..."
    fi

    case "$os_name" in
        "Darwin")
            if command_exists brew; then
                if [[ "$needs_upgrade" == true ]]; then
                    log_info "Upgrading Neovim via Homebrew..."
                    if brew upgrade neovim; then
                        log_success "Neovim upgraded successfully via Homebrew"
                    else
                        log_error "Failed to upgrade Neovim via Homebrew"
                        return 1
                    fi
                else
                    if brew install neovim; then
                        log_success "Neovim installed successfully via Homebrew"
                    else
                        log_error "Failed to install Neovim via Homebrew"
                        return 1
                    fi
                fi
            else
                log_error "Homebrew not found. Please install Homebrew first."
                return 1
            fi
            ;;
        "Linux")
            install_neovim_linux "$needs_upgrade"
            ;;
    esac

    # Verify installation
    current_version=$(get_nvim_version)
    if [[ -n "$current_version" ]]; then
        if [[ "$enforce_version" == true ]]; then
            if version_gte "$current_version" "$REQUIRED_NVIM_VERSION"; then
                log_success "Neovim $current_version installed successfully"
                return 0
            else
                log_error "Neovim $current_version was installed but does not meet minimum version $REQUIRED_NVIM_VERSION"
                log_info "You may need to install from source or use a different method"
                return 1
            fi
        else
            log_success "Neovim $current_version installed successfully"
            return 0
        fi
    else
        log_error "Failed to install Neovim"
        return 1
    fi
}

# Install Neovim on Linux with version >= 0.11 (Ubuntu only)
# For other distros, use standard package manager without version requirements
install_neovim_linux() {
    local needs_upgrade="$1"

    # Detect Linux distribution
    local distro=""
    if [ -f /etc/os-release ]; then
        # shellcheck source=/dev/null
        . /etc/os-release
        distro="$ID"
    fi

    # Only enforce version requirements for Ubuntu
    if [[ "$distro" == "ubuntu" ]]; then
        install_neovim_ubuntu "$needs_upgrade"
        return $?
    fi

    # For other distros, use standard package manager (no version requirements)
    log_info "Installing Neovim via system package manager..."

    if command_exists dnf; then
        if [[ "$needs_upgrade" == true ]]; then
            sudo dnf upgrade -y neovim
        else
            sudo dnf install -y neovim
        fi
    elif command_exists yum; then
        if [[ "$needs_upgrade" == true ]]; then
            sudo yum update -y neovim
        else
            sudo yum install -y neovim
        fi
    elif command_exists pacman; then
        if [[ "$needs_upgrade" == true ]]; then
            sudo pacman -Syu --noconfirm neovim
        else
            sudo pacman -S --noconfirm neovim
        fi
    elif command_exists apt-get; then
        # Non-Ubuntu Debian-based distros
        if [[ "$needs_upgrade" == true ]]; then
            sudo apt-get update && sudo apt-get upgrade -y neovim
        else
            sudo apt-get update && sudo apt-get install -y neovim
        fi
    else
        log_error "No supported package manager found"
        return 1
    fi
}

# Install Neovim >= 0.11 on Ubuntu
install_neovim_ubuntu() {
    local needs_upgrade="$1"

    # Detect architecture
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64) arch="linux64" ;;
        aarch64|arm64) arch="linux-arm64" ;;
        *)
            log_error "Unsupported architecture: $arch"
            return 1
            ;;
    esac

    log_info "Attempting to install Neovim >= $REQUIRED_NVIM_VERSION via PPA (Ubuntu)..."

    # Check if add-apt-repository is available
    if command_exists add-apt-repository; then
        # Remove old neovim if upgrading
        if [[ "$needs_upgrade" == true ]]; then
            log_info "Removing old Neovim version..."
            sudo apt-get remove -y neovim neovim-runtime 2>/dev/null || true
        fi

        # Add Neovim unstable PPA for latest versions
        if ! grep -q "neovim-ppa/unstable" /etc/apt/sources.list.d/*.list 2>/dev/null; then
            log_info "Adding Neovim unstable PPA..."
            sudo add-apt-repository -y ppa:neovim-ppa/unstable
        fi
        sudo apt-get update

        if sudo apt-get install -y neovim; then
            return 0
        fi
    fi

    # Fallback: Install from GitHub releases
    log_info "PPA method failed, trying GitHub releases..."
    install_neovim_from_github "$arch"
    return $?
}

# Install Neovim from GitHub releases (for getting latest version)
install_neovim_from_github() {
    local arch="$1"
    local install_dir="/opt/nvim"
    local bin_link="/usr/local/bin/nvim"

    log_info "Downloading Neovim from GitHub releases..."

    # Get the latest stable release URL
    local download_url="https://github.com/neovim/neovim/releases/latest/download/nvim-${arch}.tar.gz"
    local temp_dir
    temp_dir=$(mktemp -d)

    # Download and extract
    if ! curl -L -o "$temp_dir/nvim.tar.gz" "$download_url"; then
        log_error "Failed to download Neovim from GitHub"
        rm -rf "$temp_dir"
        return 1
    fi

    # Remove old installation if exists
    if [[ -d "$install_dir" ]]; then
        log_info "Removing old Neovim installation..."
        sudo rm -rf "$install_dir"
    fi

    # Extract to /opt/nvim
    log_info "Extracting Neovim to $install_dir..."
    sudo mkdir -p "$install_dir"
    if ! sudo tar -xzf "$temp_dir/nvim.tar.gz" -C /opt --transform='s/^nvim-linux[^/]*/nvim/' 2>/dev/null; then
        # Try without transform for different archive structures
        sudo tar -xzf "$temp_dir/nvim.tar.gz" -C /opt
        # Find and rename the extracted directory
        local extracted_dir
        extracted_dir=$(find /opt -maxdepth 1 -name "nvim-*" -type d | head -1)
        if [[ -n "$extracted_dir" && "$extracted_dir" != "$install_dir" ]]; then
            sudo rm -rf "$install_dir"
            sudo mv "$extracted_dir" "$install_dir"
        fi
    fi

    # Create symlink
    log_info "Creating symlink at $bin_link..."
    sudo ln -sf "$install_dir/bin/nvim" "$bin_link"

    # Cleanup
    rm -rf "$temp_dir"

    # Verify installation
    if [[ -x "$bin_link" ]]; then
        log_success "Neovim installed from GitHub releases"
        return 0
    else
        log_error "Failed to install Neovim from GitHub"
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

    local lsp_failed=0

    # Python LSP servers
    if command_exists pip3; then
        log_info "Installing Python LSP servers..."
        if pip3 install --user pyright ruff-lsp 2>&1; then
            log_success "Python LSP servers installed successfully"
        else
            log_warning "Failed to install some Python LSP servers"
            lsp_failed=1
        fi
    else
        log_warning "pip3 not found, skipping Python LSP servers"
    fi

    # TypeScript LSP server
    if command_exists npm; then
        log_info "Installing TypeScript LSP server..."
        if npm install -g typescript typescript-language-server 2>&1; then
            log_success "TypeScript LSP server installed successfully"
        else
            log_warning "Failed to install TypeScript LSP server"
            lsp_failed=1
        fi
    else
        log_warning "npm not found, skipping TypeScript LSP server"
    fi

    # Go LSP server (gopls is usually installed with Go)
    if command_exists go; then
        log_info "Installing Go LSP server..."
        if go install golang.org/x/tools/gopls@latest 2>&1; then
            log_success "Go LSP server (gopls) installed successfully"
        else
            log_warning "Failed to install gopls"
            lsp_failed=1
        fi
    else
        log_warning "go not found, skipping Go LSP server"
    fi

    if [ $lsp_failed -eq 0 ]; then
        log_success "LSP server installation completed successfully"
    else
        log_warning "LSP server installation completed with some warnings"
    fi
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
        if git clone https://github.com/tmux-plugins/tpm "$tpm_dir" 2>&1; then
            log_success "TPM installed successfully"
            log_info "Run 'tmux source ~/.config/tmux/tmux.conf' and then 'prefix + I' to install plugins"
        else
            log_error "Failed to clone TPM repository"
            log_warning "You can manually install TPM later with: git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
            return 1
        fi
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

    local install_failed=0

    # Install package manager
    log_info "Step 1/6: Installing package manager..."
    if install_package_manager "$os_name"; then
        log_success "Package manager setup completed"
    else
        log_error "Package manager setup failed"
        install_failed=1
        return 1
    fi

    # Install Neovim
    log_info "Step 2/6: Installing Neovim..."
    if install_neovim "$os_name"; then
        log_success "Neovim installation completed"
    else
        log_warning "Neovim installation failed (continuing anyway)"
        install_failed=1
    fi

    # Install dependencies
    log_info "Step 3/6: Installing dependencies..."
    if install_dependencies "$os_name"; then
        log_success "Dependencies installation completed"
    else
        log_warning "Dependencies installation failed (continuing anyway)"
        install_failed=1
    fi

    # Install dotfiles configurations
    log_info "Step 4/6: Installing dotfiles configurations..."
    if install_dotfiles_config "$dotfiles_dir"; then
        log_success "Dotfiles configuration completed"
    else
        log_warning "Dotfiles configuration failed (continuing anyway)"
        install_failed=1
    fi

    # Install tmux and TPM
    log_info "Step 5/6: Installing tmux and TPM..."
    if install_tmux_setup "$os_name"; then
        log_success "Tmux setup completed"
    else
        log_warning "Tmux setup failed (continuing anyway)"
        install_failed=1
    fi

    # Install LSP servers
    log_info "Step 6/6: Installing LSP servers..."
    if install_lsp_servers; then
        log_success "LSP servers installation completed"
    else
        log_warning "LSP servers installation failed (continuing anyway)"
        install_failed=1
    fi

    if [ $install_failed -eq 0 ]; then
        log_success "Installation completed successfully!"
    else
        log_warning "Installation completed with some warnings/errors"
        log_info "Please review the log messages above for details"
    fi

    log_info ""
    log_info "You can now start Neovim with 'nvim'"
    log_info "On first startup, lazy.nvim will automatically install all plugins"
}

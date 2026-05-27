#!/bin/bash

# =============================================================================
# Dotfiles Installation Functions
# =============================================================================

# -----------------------------------------------------------------------------
# Constants
# -----------------------------------------------------------------------------

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Version requirements
readonly REQUIRED_NVIM_VERSION="0.11"

# Installation paths
readonly NVIM_INSTALL_DIR="/opt/nvim"
readonly NVIM_BIN_LINK="/usr/local/bin/nvim"
readonly TPM_DIR="$HOME/.tmux/plugins/tpm"

# Package lists
readonly MACOS_ESSENTIAL_DEPS=("git" "curl" "wget" "ripgrep" "fd")
readonly MACOS_LARGE_DEPS=("node" "python3" "go")
readonly LINUX_APT_DEPS=("git" "curl" "wget" "ripgrep" "fd-find" "nodejs" "npm" "python3" "python3-pip" "golang-go")
readonly LINUX_YUM_DEPS=("git" "curl" "wget" "ripgrep" "fd-find" "nodejs" "npm" "python3" "python3-pip" "golang")

# -----------------------------------------------------------------------------
# Logging Functions
# -----------------------------------------------------------------------------

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

# -----------------------------------------------------------------------------
# Utility Functions
# -----------------------------------------------------------------------------

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

# -----------------------------------------------------------------------------
# Dotfiles Configuration Functions
# -----------------------------------------------------------------------------

# Create target directory for symlink if needed
_ensure_target_directory() {
    local -r target_dir=$(dirname "$1")

    if [ -d "$target_dir" ]; then
        return 0
    fi

    log_info "Creating directory $target_dir"
    mkdir -p "$target_dir"
}

# Remove existing file/symlink at target location
_remove_existing_target() {
    local -r target="$1"

    if [ -e "$target" ] || [ -L "$target" ]; then
        log_info "Removing existing $target"
        rm -rf "$target"
    fi
}

# Create symlink
create_symlink() {
    local -r source="$1"
    local -r target="$2"

    if [ ! -e "$source" ]; then
        log_error "Source $source does not exist"
        return 1
    fi

    _ensure_target_directory "$target"
    _remove_existing_target "$target"

    log_info "Creating symlink: $target -> $source"
    if ln -sf "$source" "$target"; then
        log_success "Successfully created symlink for $(basename "$target")"
        return 0
    fi

    log_error "Failed to create symlink for $(basename "$target")"
    return 1
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

    # Install fish configuration
    local fish_config_source="$dotfiles_dir/.config/fish"
    local fish_config_target="$HOME/.config/fish"

    if [ -d "$fish_config_source" ]; then
        if create_symlink "$fish_config_source" "$fish_config_target"; then
            log_success "Fish shell configuration linked"
        else
            log_error "Failed to link fish configuration"
            config_failed=1
        fi
    else
        log_warning "Fish config source directory not found: $fish_config_source"
    fi

    # Install gitconfig
    local gitconfig_source="$dotfiles_dir/.gitconfig"
    local gitconfig_target="$HOME/.gitconfig"

    if [ -f "$gitconfig_source" ]; then
        if create_symlink "$gitconfig_source" "$gitconfig_target"; then
            log_success "Linked .gitconfig"
        else
            log_error "Failed to link .gitconfig"
            config_failed=1
        fi
    else
        log_info "Config file not found: $gitconfig_source (skipping)"
    fi

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

# -----------------------------------------------------------------------------
# Neovim Installation Functions
# -----------------------------------------------------------------------------

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

# Download Neovim tarball from GitHub
_download_neovim_tarball() {
    local -r download_url="$1"
    local -r temp_dir="$2"

    if ! curl -L -o "$temp_dir/nvim.tar.gz" "$download_url"; then
        log_error "Failed to download Neovim from GitHub"
        rm -rf "$temp_dir"
        return 1
    fi
    return 0
}

# Extract Neovim tarball to installation directory
_extract_neovim_tarball() {
    local -r temp_dir="$1"
    local -r install_dir="$2"

    log_info "Extracting Neovim to $install_dir..."
    sudo mkdir -p "$install_dir"

    # Try with transform first, fallback to manual rename
    if ! sudo tar -xzf "$temp_dir/nvim.tar.gz" -C /opt --transform='s/^nvim-linux[^/]*/nvim/' 2>/dev/null; then
        sudo tar -xzf "$temp_dir/nvim.tar.gz" -C /opt

        local extracted_dir
        extracted_dir=$(find /opt -maxdepth 1 -name "nvim-*" -type d | head -1)

        if [[ -n "$extracted_dir" && "$extracted_dir" != "$install_dir" ]]; then
            sudo rm -rf "$install_dir"
            sudo mv "$extracted_dir" "$install_dir"
        fi
    fi
    return 0
}

# Install Neovim from GitHub releases (for getting latest version)
install_neovim_from_github() {
    local -r arch="$1"
    local -r download_url="https://github.com/neovim/neovim/releases/latest/download/nvim-${arch}.tar.gz"
    local temp_dir

    log_info "Downloading Neovim from GitHub releases..."

    temp_dir=$(mktemp -d)

    # Download tarball
    if ! _download_neovim_tarball "$download_url" "$temp_dir"; then
        return 1
    fi

    # Remove old installation if exists
    if [[ -d "$NVIM_INSTALL_DIR" ]]; then
        log_info "Removing old Neovim installation..."
        sudo rm -rf "$NVIM_INSTALL_DIR"
    fi

    # Extract tarball
    if ! _extract_neovim_tarball "$temp_dir" "$NVIM_INSTALL_DIR"; then
        rm -rf "$temp_dir"
        return 1
    fi

    # Create symlink
    log_info "Creating symlink at $NVIM_BIN_LINK..."
    sudo ln -sf "$NVIM_INSTALL_DIR/bin/nvim" "$NVIM_BIN_LINK"

    # Cleanup
    rm -rf "$temp_dir"

    # Verify installation
    if [[ -x "$NVIM_BIN_LINK" ]]; then
        log_success "Neovim installed from GitHub releases"
        return 0
    fi

    log_error "Failed to install Neovim from GitHub"
    return 1
}

# Check if a brew package is installed (faster than command_exists for brew packages)
brew_is_installed() {
    local package="$1"
    brew list "$package" &>/dev/null
}

# -----------------------------------------------------------------------------
# Dependency Installation Functions
# -----------------------------------------------------------------------------

# Check which packages need installation
_filter_uninstalled_packages() {
    local packages_to_check_name=$1
    local result_array_name=$2
    local installed_array_name=$3

    eval "local packages_to_check=(\"\${${packages_to_check_name}[@]}\")"

    # shellcheck disable=SC2154
    for pkg in "${packages_to_check[@]}"; do
        if brew_is_installed "$pkg" || command_exists "$pkg"; then
            eval "${installed_array_name}+=(\"$pkg\")"
        else
            eval "${result_array_name}+=(\"$pkg\")"
        fi
    done
}

# Install packages via Homebrew
_install_brew_packages() {
    local packages_name=$1
    local package_type="$2"

    eval "local packages=(\"\${${packages_name}[@]}\")"

    # shellcheck disable=SC2154
    if [ ${#packages[@]} -eq 0 ]; then
        log_success "All $package_type packages are already installed"
        return 0
    fi

    log_info "Installing $package_type packages: ${packages[*]}"

    if brew install "${packages[@]}"; then
        log_success "$package_type packages installed successfully"
        return 0
    fi

    log_warning "Some $package_type packages failed to install (continuing anyway)"
    return 1
}

# Install large packages individually with progress feedback
_install_large_packages_individually() {
    local packages_name=$1

    eval "local packages=(\"\${${packages_name}[@]}\")"

    for pkg in "${packages[@]}"; do
        log_info "Installing $pkg..."
        log_warning "This may take several minutes..."

        if brew install "$pkg"; then
            log_success "$pkg installed successfully"
        else
            log_warning "Failed to install $pkg (you can install it manually later with: brew install $pkg)"
        fi
    done
}

# Install dependencies on macOS
_install_macos_dependencies() {
    if ! command_exists brew; then
        log_error "Homebrew not available. Cannot install dependencies."
        return 1
    fi

    # shellcheck disable=SC2034
    local essential_to_install=()
    local essential_installed=()
    local large_to_install=()

    # Check essential packages
    log_info "Checking which packages are already installed..."
    # shellcheck disable=SC2034
    local essential_deps=("${MACOS_ESSENTIAL_DEPS[@]}")
    _filter_uninstalled_packages essential_deps essential_to_install essential_installed

    if [ ${#essential_installed[@]} -gt 0 ]; then
        log_success "Already installed: ${essential_installed[*]}"
    fi

    # Batch install essential packages
    _install_brew_packages essential_to_install "essential"

    # Check large packages
    local large_deps=("${MACOS_LARGE_DEPS[@]}")
    for pkg in "${large_deps[@]}"; do
        if brew_is_installed "$pkg" || command_exists "$pkg"; then
            log_success "$pkg is already installed"
        else
            large_to_install+=("$pkg")
        fi
    done

    # Install large packages individually
    if [ ${#large_to_install[@]} -gt 0 ]; then
        _install_large_packages_individually large_to_install
    fi
}

# Install a single package via apt-get
_install_apt_package() {
    local -r package="$1"

    if dpkg -l | grep -q "^ii  $package "; then
        log_success "$package is already installed"
        return 0
    fi

    log_info "Installing $package..."
    sudo apt-get install -y "$package"
}

# Install a single package via yum
_install_yum_package() {
    local -r package="$1"

    if rpm -qa | grep -q "$package"; then
        log_success "$package is already installed"
        return 0
    fi

    log_info "Installing $package..."
    sudo yum install -y "$package"
}

# Install dependencies on Linux
_install_linux_dependencies() {
    if command_exists apt-get; then
        for pkg in "${LINUX_APT_DEPS[@]}"; do
            _install_apt_package "$pkg"
        done
    elif command_exists yum; then
        for pkg in "${LINUX_YUM_DEPS[@]}"; do
            _install_yum_package "$pkg"
        done
    else
        log_warning "No supported package manager found"
        return 1
    fi
}

# Install additional dependencies
install_dependencies() {
    local -r os_name="$1"

    log_info "Installing additional dependencies..."

    case "$os_name" in
        "Darwin")
            _install_macos_dependencies
            ;;
        "Linux")
            _install_linux_dependencies
            ;;
        *)
            log_error "Unsupported OS: $os_name"
            return 1
            ;;
    esac
}

# -----------------------------------------------------------------------------
# LSP Server Installation Functions
# -----------------------------------------------------------------------------

# Install Python LSP servers
_install_python_lsp() {
    if ! command_exists pip3; then
        log_warning "pip3 not found, skipping Python LSP servers"
        return 1
    fi

    log_info "Installing Python LSP servers..."
    if pip3 install --user pyright ruff-lsp 2>&1; then
        log_success "Python LSP servers installed successfully"
        return 0
    fi

    log_warning "Failed to install some Python LSP servers"
    return 1
}

# Install TypeScript LSP server
_install_typescript_lsp() {
    if ! command_exists npm; then
        log_warning "npm not found, skipping TypeScript LSP server"
        return 1
    fi

    log_info "Installing TypeScript LSP server..."
    if npm install -g typescript typescript-language-server 2>&1; then
        log_success "TypeScript LSP server installed successfully"
        return 0
    fi

    log_warning "Failed to install TypeScript LSP server"
    return 1
}

# Install Go LSP server
_install_go_lsp() {
    if ! command_exists go; then
        log_warning "go not found, skipping Go LSP server"
        return 1
    fi

    log_info "Installing Go LSP server..."
    if go install golang.org/x/tools/gopls@latest 2>&1; then
        log_success "Go LSP server (gopls) installed successfully"
        return 0
    fi

    log_warning "Failed to install gopls"
    return 1
}

# Install LSP servers
install_lsp_servers() {
    log_info "Installing LSP servers..."

    local lsp_failed=0

    _install_python_lsp || lsp_failed=1
    _install_typescript_lsp || lsp_failed=1
    _install_go_lsp || lsp_failed=1

    if [ $lsp_failed -eq 0 ]; then
        log_success "LSP server installation completed successfully"
        return 0
    fi

    log_warning "LSP server installation completed with some warnings"
    return 1
}

# -----------------------------------------------------------------------------
# Tmux Setup Functions
# -----------------------------------------------------------------------------

# Install tmux on macOS
_install_tmux_macos() {
    if command_exists tmux; then
        log_success "tmux is already installed"
        return 0
    fi

    if ! command_exists brew; then
        log_error "Homebrew not found. Please install tmux manually."
        return 1
    fi

    log_info "Installing tmux..."
    if brew install tmux; then
        log_success "tmux installed successfully via Homebrew"
        return 0
    fi

    log_error "Failed to install tmux via Homebrew"
    return 1
}

# Install tmux on Linux
_install_tmux_linux() {
    if command_exists tmux; then
        log_success "tmux is already installed"
        return 0
    fi

    if command_exists apt-get; then
        sudo apt-get install -y tmux
    elif command_exists yum; then
        sudo yum install -y tmux
    elif command_exists pacman; then
        sudo pacman -S --noconfirm tmux
    else
        log_error "Could not install tmux. Please install manually."
        return 1
    fi
}

# Install TPM (Tmux Plugin Manager)
_install_tpm() {
    if [ -d "$TPM_DIR" ]; then
        log_success "TPM is already installed"
        return 0
    fi

    log_info "Installing TPM (Tmux Plugin Manager)..."

    if git clone https://github.com/tmux-plugins/tpm "$TPM_DIR" 2>&1; then
        log_success "TPM installed successfully"
        log_info "Run 'tmux source ~/.config/tmux/tmux.conf' and then 'prefix + I' to install plugins"
        return 0
    fi

    log_error "Failed to clone TPM repository"
    log_warning "You can manually install TPM later with: git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
    return 1
}

# Install tmux and TPM (Tmux Plugin Manager)
install_tmux_setup() {
    local -r os_name="$1"

    log_info "Setting up tmux..."

    case "$os_name" in
        "Darwin")
            _install_tmux_macos || return 1
            ;;
        "Linux")
            _install_tmux_linux || return 1
            ;;
        *)
            log_error "Unsupported OS: $os_name"
            return 1
            ;;
    esac

    _install_tpm
}

# -----------------------------------------------------------------------------
# Fish Shell Setup Functions
# -----------------------------------------------------------------------------

# Get fish version
_get_fish_version() {
    fish --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1
}

# Add fish to /etc/shells if not present
_add_fish_to_shells() {
    local -r fish_path=$(command -v fish)

    if grep -q "$fish_path" /etc/shells 2>/dev/null; then
        return 0
    fi

    log_info "Adding fish to /etc/shells..."
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
    log_success "Fish added to /etc/shells"
}

# Install fish on macOS
_install_fish_macos() {
    if ! command_exists brew; then
        log_error "Homebrew not found. Please install fish manually."
        return 1
    fi

    log_info "Installing fish shell via Homebrew..."
    if brew install fish; then
        log_success "Fish shell installed successfully"
        return 0
    fi

    log_error "Failed to install fish via Homebrew"
    return 1
}

# Install fish on Linux
_install_fish_linux() {
    if command_exists apt-get; then
        log_info "Installing fish shell via apt..."
        sudo apt-get update
        sudo apt-get install -y fish
    elif command_exists yum; then
        log_info "Installing fish shell via yum..."
        sudo yum install -y fish
    elif command_exists pacman; then
        log_info "Installing fish shell via pacman..."
        sudo pacman -S --noconfirm fish
    elif command_exists dnf; then
        log_info "Installing fish shell via dnf..."
        sudo dnf install -y fish
    else
        log_error "No supported package manager found for fish installation"
        return 1
    fi
}

# Verify fish installation
_verify_fish_installation() {
    if ! command_exists fish; then
        log_error "Fish installation verification failed"
        return 1
    fi

    local fish_version
    fish_version=$(_get_fish_version)
    log_success "Fish shell version $fish_version installed successfully"

    _add_fish_to_shells
    return 0
}

# Install fish shell
install_fish_shell() {
    local -r os_name="$1"

    log_info "Setting up fish shell..."

    # Check if already installed
    if command_exists fish; then
        local fish_version
        fish_version=$(_get_fish_version)
        log_success "Fish shell is already installed (version $fish_version)"
        return 0
    fi

    # Install based on OS
    case "$os_name" in
        "Darwin")
            _install_fish_macos || return 1
            ;;
        "Linux")
            _install_fish_linux || return 1
            ;;
        *)
            log_error "Unsupported OS: $os_name"
            return 1
            ;;
    esac

    _verify_fish_installation
}

# Install Fisher plugin manager and fish plugins
install_fisher_and_plugins() {
    log_info "Setting up Fisher plugin manager..."

    # Check if fish is installed
    if ! command_exists fish; then
        log_warning "Fish shell is not installed. Skipping Fisher setup."
        return 1
    fi

    # Check if Fisher is already installed
    if fish -c "type -q fisher" 2>/dev/null; then
        log_success "Fisher is already installed"
    else
        log_info "Installing Fisher plugin manager..."

        # Install Fisher
        if fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher" 2>&1; then
            log_success "Fisher installed successfully"
        else
            log_warning "Failed to install Fisher automatically"
            log_info "You can install Fisher manually by running in fish shell:"
            log_info "  curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
            return 1
        fi
    fi

    # Install plugins from fish_plugins file
    local fish_plugins_file="$HOME/.config/fish/fish_plugins"
    if [ -f "$fish_plugins_file" ]; then
        log_info "Installing fish plugins from fish_plugins file..."

        # Fisher will automatically read from fish_plugins file
        if fish -c "fisher update" 2>&1; then
            log_success "Fish plugins installed successfully"
            log_info "Installed plugins:"
            fish -c "fisher list" 2>/dev/null || true
        else
            log_warning "Some fish plugins may have failed to install"
            log_info "You can manually install plugins later with: fisher update"
        fi
    else
        log_warning "fish_plugins file not found at $fish_plugins_file"
        log_info "You can manually install plugins later"
    fi

    return 0
}

# Set fish as default shell
set_fish_as_default_shell() {
    log_info "Setting fish as default shell..."

    # Check if fish is installed
    if ! command_exists fish; then
        log_warning "Fish shell is not installed. Cannot set as default."
        return 1
    fi

    local fish_path
    fish_path=$(command -v fish)

    # Check if already using fish
    if [[ "$SHELL" == "$fish_path" ]]; then
        log_success "Fish is already your default shell"
        return 0
    fi

    # Ensure fish is in /etc/shells
    if ! grep -q "$fish_path" /etc/shells 2>/dev/null; then
        log_info "Adding fish to /etc/shells..."
        echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
    fi

    # Change default shell to fish
    log_info "Changing default shell to fish..."
    if chsh -s "$fish_path"; then
        log_success "Default shell changed to fish!"
        log_info "Please restart your terminal for changes to take effect"
        return 0
    else
        log_warning "Failed to change default shell automatically"
        log_info "You can manually set fish as default with: chsh -s $fish_path"
        return 1
    fi
}

# -----------------------------------------------------------------------------
# Main Installation Function
# -----------------------------------------------------------------------------

# Execute installation step with error handling
_execute_step() {
    local -r step_number="$1"
    local -r step_name="$2"
    local -r step_function="$3"
    shift 3
    local -a step_args=("$@")

    log_info "Step $step_number: $step_name..."

    if "$step_function" "${step_args[@]}"; then
        log_success "$step_name completed"
        return 0
    fi

    # Only return error for critical steps
    if [[ "$step_number" == "1/9" ]]; then
        log_error "$step_name failed"
        return 1
    fi

    log_warning "$step_name failed (continuing anyway)"
    return 2  # Non-critical failure
}

# Main installation function
run_installation() {
    local -r os_name="$1"
    local dotfiles_dir
    dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

    log_info "Starting dotfiles installation for $os_name"
    log_info "Dotfiles directory: $dotfiles_dir"

    local install_failed=0

    # Execute all installation steps
    _execute_step "1/9" "Installing package manager" install_package_manager "$os_name" || return 1
    _execute_step "2/9" "Installing Neovim" install_neovim "$os_name" || install_failed=1
    _execute_step "3/9" "Installing dependencies" install_dependencies "$os_name" || install_failed=1
    _execute_step "4/9" "Installing dotfiles configurations" install_dotfiles_config "$dotfiles_dir" || install_failed=1
    _execute_step "5/9" "Installing tmux and TPM" install_tmux_setup "$os_name" || install_failed=1
    _execute_step "6/9" "Installing LSP servers" install_lsp_servers || install_failed=1
    _execute_step "7/9" "Installing fish shell" install_fish_shell "$os_name" || install_failed=1
    _execute_step "8/9" "Installing Fisher plugin manager and fish plugins" install_fisher_and_plugins || install_failed=1
    _execute_step "9/9" "Setting fish as default shell" set_fish_as_default_shell || install_failed=1

    # Report final status
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

# Dotfiles Makefile
# Provides convenient targets for linting, testing, and installation

# Variables
SHELL_SCRIPTS := start.sh $(wildcard scripts/*.sh)
NVIM_CONFIG := .config/nvim
SHELLCHECK := shellcheck

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
BLUE := \033[0;34m
YELLOW := \033[1;33m
NC := \033[0m # No Color

.PHONY: help lint shellcheck install test clean all

# Default target
all: lint

# Help target
help:
	@echo "$(BLUE)Dotfiles Makefile$(NC)"
	@echo ""
	@echo "Available targets:"
	@echo "  $(GREEN)help$(NC)       - Show this help message"
	@echo "  $(GREEN)lint$(NC)       - Run all linting checks"
	@echo "  $(GREEN)shellcheck$(NC) - Run shellcheck on all shell scripts"
	@echo "  $(GREEN)install$(NC)    - Run the installation script"
	@echo "  $(GREEN)test$(NC)       - Run configuration tests"
	@echo "  $(GREEN)clean$(NC)      - Clean up temporary files"
	@echo "  $(GREEN)list$(NC)       - List all shell scripts that will be checked"
	@echo ""
	@echo "Examples:"
	@echo "  make lint          # Run all linting"
	@echo "  make shellcheck    # Run only shellcheck"
	@echo "  make install       # Install dotfiles"

# List all shell scripts
list:
	@echo "$(BLUE)Shell scripts to be checked:$(NC)"
	@for script in $(SHELL_SCRIPTS); do \
		echo "  - $$script"; \
	done

# Run shellcheck on all shell scripts
shellcheck:
	@echo "$(BLUE)Running shellcheck on shell scripts...$(NC)"
	@failed=0; \
	for script in $(SHELL_SCRIPTS); do \
		if [ -f "$$script" ]; then \
			printf "Checking %-25s " "$$script:"; \
			if $(SHELLCHECK) "$$script" >/dev/null 2>&1; then \
				echo "$(GREEN)✓ PASS$(NC)"; \
			else \
				echo "$(RED)✗ FAIL$(NC)"; \
				$(SHELLCHECK) "$$script"; \
				failed=1; \
			fi; \
		else \
			echo "$(YELLOW)Warning: $$script not found$(NC)"; \
		fi; \
	done; \
	if [ $$failed -eq 0 ]; then \
		echo "$(GREEN)All shell scripts passed shellcheck!$(NC)"; \
	else \
		echo "$(RED)Some shell scripts failed shellcheck.$(NC)"; \
		exit 1; \
	fi

# Check if shellcheck is installed
check-shellcheck:
	@if ! command -v $(SHELLCHECK) >/dev/null 2>&1; then \
		echo "$(RED)Error: shellcheck is not installed$(NC)"; \
		echo "Install it with: brew install shellcheck"; \
		exit 1; \
	fi

# Run all linting checks
lint: check-shellcheck shellcheck
	@echo "$(GREEN)All linting checks completed successfully!$(NC)"

# Install dotfiles
install:
	@echo "$(BLUE)Installing dotfiles...$(NC)"
	@./start.sh

# Test configurations
test:
	@echo "$(BLUE)Running configuration tests...$(NC)"
	@echo "$(YELLOW)No tests configured$(NC)"

# Clean up temporary files
clean:
	@echo "$(BLUE)Cleaning up temporary files...$(NC)"
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@find . -name "*.bak" -delete 2>/dev/null || true
	@echo "$(GREEN)Cleanup completed$(NC)"

# Verbose shellcheck (shows all output)
shellcheck-verbose:
	@echo "$(BLUE)Running shellcheck (verbose) on shell scripts...$(NC)"
	@for script in $(SHELL_SCRIPTS); do \
		if [ -f "$$script" ]; then \
			echo "$(BLUE)Checking $$script:$(NC)"; \
			$(SHELLCHECK) "$$script" || true; \
			echo ""; \
		fi; \
	done

# Fix permissions on shell scripts
fix-permissions:
	@echo "$(BLUE)Fixing permissions on shell scripts...$(NC)"
	@for script in $(SHELL_SCRIPTS); do \
		if [ -f "$$script" ]; then \
			chmod +x "$$script"; \
			echo "Made $$script executable"; \
		fi; \
	done
	@echo "$(GREEN)Permissions fixed$(NC)"

# Check for common issues
check:
	@echo "$(BLUE)Running basic checks...$(NC)"
	@echo "Checking for executable permissions..."
	@for script in $(SHELL_SCRIPTS); do \
		if [ -f "$$script" ] && [ ! -x "$$script" ]; then \
			echo "$(YELLOW)Warning: $$script is not executable$(NC)"; \
		fi; \
	done
	@echo "Checking for required files..."
	@required_files="start.sh scripts/functions.sh .zshrc .config/nvim/init.lua"; \
	for file in $$required_files; do \
		if [ ! -f "$$file" ]; then \
			echo "$(RED)Error: Required file $$file not found$(NC)"; \
		else \
			echo "$(GREEN)✓$(NC) $$file"; \
		fi; \
	done

# Development target - run before committing
pre-commit: lint check
	@echo "$(GREEN)Pre-commit checks completed successfully!$(NC)"

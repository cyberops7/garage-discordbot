#!/usr/bin/env bash

# Enable strict error handling
set -euo pipefail

# Import logging functions
REPO_DIR="$(git rev-parse --show-toplevel)"
source "${REPO_DIR}/dev/logger.sh"

# Colors for special output
SUCCESS_COLOR="\033[32m"
ERROR_COLOR="\033[31m"
NO_COLOR="\033[0m"

# Dependency Check Function
check_dependency() {
    local cmd="$1"
    local name="$2"
    local install_url="$3"
    local check_cmd="${4:-}"

    echo -n "     ${name} "

    # Use custom check command if provided, otherwise fallback to `command -v`
    if [ -n "$check_cmd" ]; then
        if ! $check_cmd >/dev/null 2>&1; then
            echo -e "${ERROR_COLOR}✘${NO_COLOR}"
            error "${name} is not installed or configured."
            if [ -n "$install_url" ]; then
                warn "You can install ${name} from: ${install_url}"
            fi
            exit 1
        fi
    else
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo -e "${ERROR_COLOR}✘${NO_COLOR}"
            error "${name} is not installed or not in your PATH."
            if [ -n "$install_url" ]; then
                warning "You can install ${name} from: ${install_url}"
            fi
            exit 1
        fi
    fi
    echo -e "${SUCCESS_COLOR}✔${NO_COLOR}"
}

# Check for required dependencies
info "Checking dependencies..."

# Dependency: Docker
check_dependency \
    "docker" \
    "Docker" \
    "https://www.docker.com/get-started"

# Dependency: Docker buildx
check_dependency \
    "docker buildx" \
    "Docker buildx" \
    "https://docs.docker.com/buildx/working-with-buildx/" \
    "docker buildx version"

# Dependency: Skopeo
check_dependency \
    "skopeo" \
    "Skopeo" \
    "https://github.com/containers/skopeo/blob/main/install.md"

# Dependency: Trivy
check_dependency \
    "trivy" \
    "Trivy" \
    "https://trivy.dev/dev/getting-started/#get-trivy"

# Dependency: UV
check_dependency \
    "uv" \
    "UV" \
    "https://github.com/astral-sh/uv"

success "All dependencies are installed!"

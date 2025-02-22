#!/usr/bin/env bash

# Enable strict error handling
set -euo pipefail

# Colors for output
SUCCESS_COLOR="\033[32m"
ERROR_COLOR="\033[31m"
WARNING_COLOR="\033[33m"
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
            echo -e "${ERROR_COLOR}Error: ${name} is not installed or configured.${NO_COLOR}"
            if [ -n "$install_url" ]; then
                echo -e "${WARNING_COLOR}You can install ${name} from: ${install_url}${NO_COLOR}"
            fi
            exit 1
        fi
    else
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo -e "${ERROR_COLOR}✘${NO_COLOR}"
            echo -e "${ERROR_COLOR}Error: ${name} is not installed or not in your PATH.${NO_COLOR}"
            if [ -n "$install_url" ]; then
                echo -e "${WARNING_COLOR}You can install ${name} from: ${install_url}${NO_COLOR}"
            fi
            exit 1
        fi
    fi
    echo -e "${SUCCESS_COLOR}✔${NO_COLOR}"
}

# Check for required dependencies
echo "Checking dependencies..."

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

# Dependency: UV
check_dependency \
    "uv" \
    "UV" \
    "https://github.com/astral-sh/uv"

echo -e "${SUCCESS_COLOR}All dependencies are installed!${NO_COLOR}"

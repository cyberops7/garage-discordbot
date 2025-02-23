#!/usr/bin/env bash

# Exit on error
set -e

# Import logging functions
REPO_DIR="$(git rev-parse --show-toplevel)"
source "${REPO_DIR}/dev/logger.sh"

echo "---------------------------------------------------------------------------------------"
info "Running isort ()..."
isort "$REPO_DIR"

echo "---------------------------------------------------------------------------------------"
info "Running trivy file scanner for misconfig, secrets, and vulnerabilities..."
trivy fs --scanners misconfig,secret,vuln "$REPO_DIR"

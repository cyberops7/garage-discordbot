#!/usr/bin/env bash

# Exit on error
set -e

# Import logging functions
REPO_DIR="$(git rev-parse --show-toplevel)"
source "${REPO_DIR}/scripts/logger.sh"

info "Signing in to 1Password..."
eval "$(op signin)"
success "Signin successful."

info "Retrieving GitHub PAT..."
PAT="$(op item get 'GitHub PAT - github-package-token' --fields 'label=token' --reveal)"

if [ -n "${PAT}" ]; then
    success "GitHub PAT retrieved."
else
    error "Unable to retrieve GitHub PAT."
fi

info "Logging in to GitHub container registry..."
if  echo "${PAT}" | docker login ghcr.io -u cyberops7 --password-stdin; then
    success "Login successful."
else
    error "There was a problem logging into ghcr."
fi

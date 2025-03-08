#!/usr/bin/env bash

REPO_DIR="$(git rev-parse --show-toplevel)"

source "${REPO_DIR}/scripts/logger.sh"

info "Running pytest..."
uv run pytest

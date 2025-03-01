#!/usr/bin/env bash

# Import logging functions
REPO_DIR="$(git rev-parse --show-toplevel)"
source "${REPO_DIR}/scripts/logger.sh"

# Default to check-only mode (dry-run)
FIX_MODE=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --fix) # Enable fix mode if --fix flag is present
            FIX_MODE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --fix       Run checks in fix mode (e.g., auto-format with isort)."
            echo "  --help      Show this help message and exit."
            echo ""
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            warning "run '$0 --help for usage information."
            exit 1
            ;;
    esac
done

source .venv/bin/activate

divider
if $FIX_MODE; then
    info "Formatting with ruff format (fix mode)..."
    if ! uvx ruff format "$REPO_DIR"; then
        error "ruff format (fix mode) failed!"
    fi
else
    info "Formatting with ruff format (check mode)..."
    if ! uvx ruff format --check "$REPO_DIR"; then
        error "ruff format (check mode) detected issues!"
    fi
fi

divider
if $FIX_MODE; then
    info "Linting with ruff check (fix mode)..."
    if ! uvx ruff check --fix "$REPO_DIR"; then
        error "ruff check (fix mode) failed!"
    fi
else
    info "Linting with ruff check (check mode)..."
    if ! uvx ruff check "$REPO_DIR"; then
        error "ruff check (check mode) detected issues!"
    fi
fi

divider
info "Type checking with pyre check..."
if ! pyre check; then
    error "pyre check detected issues!"
fi

#divider
#info "Type checking with pyright..."
#if ! pyright; then
#    error "pyright detected issues!"
#fi

divider
info "Linting bash files with shellcheck..."
if ! shellcheck -x "${REPO_DIR}"/scripts/*.sh; then
    error "shellcheck detected issues!"
else
    success "shellcheck passed"
fi


divider
info "Running trivy file scanner for misconfig, secrets, and vulnerabilities..."
TRIVY_CMD="trivy fs --scanners misconfig,secret,vuln ${REPO_DIR}"
if ! eval "$TRIVY_CMD"; then
    error "trivy scan failed!"
fi

divider
info "Linting yaml files with yamllint..."
if ! yamllint --strict "$REPO_DIR"; then
    error "yamllint detected issues!"
else
    success "yamllint passed"
fi

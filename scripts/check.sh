#!/usr/bin/env bash

# Import logging functions
REPO_DIR="$(git rev-parse --show-toplevel)"
source "${REPO_DIR}/scripts/logger.sh"

# Track fail vs pass
FAIL=0

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

# Log whether running in check-only mode or fix mode
if $FIX_MODE; then
    note "Running in FIX mode: Issues will attempt to be automatically fixed where possible."
else
    note "Running in CHECK mode: Issues will only be detected without making changes."
fi

source .venv/bin/activate

# Generic Function for Running Checks
run_check() {
    local name="$1"        # Human-Friendly Name of the Check
    local command="$2"     # Command to Run the Check
    local fix_mode="$3"    # Command to Run in Fix Mode (optional)

    divider
    info "Running: $name..."

    # Choose fix or check command
    if $FIX_MODE && [[ -n "$fix_mode" ]]; then
        if ! eval "$fix_mode"; then
            error "$name failed in fix mode!"
            FAIL=1
        else
            success "$name fixed successfully."
        fi
    else
        if ! eval "$command"; then
            error "$name failed in check mode!"
            FAIL=1
        else
            success "$name passed check mode successfully."
        fi
    fi
}

# Run All Checks
run_check "Ruff Format" \
    "uvx ruff format --check \"$REPO_DIR\"" \
    "uvx ruff format \"$REPO_DIR\""

run_check "Ruff Lint" \
    "uvx ruff check \"$REPO_DIR\"" \
    "uvx ruff check --fix \"$REPO_DIR\""

run_check "Pyre Type Check" \
    "pyre check"

# Uncomment the following block for Pyright checks if needed
# run_check "Pyright Type Check" \
#    "pyright"

run_check "ShellCheck Lint" \
    "shellcheck -x \"${REPO_DIR}\"/scripts/*.sh"

run_check "Trivy File Scanner" \
    "trivy fs --scanners misconfig,secret,vuln \"$REPO_DIR\""

run_check "YAMLLint" \
    "yamllint --strict \"$REPO_DIR\""

# Exit with the appropriate status based on check results
divider
if [[ FAIL -ne 0 ]]; then
    error "One or more steps failed. Exiting with status code 1."
    exit 1
else
    success "All steps passed successfully!"
    exit 0
fi






#divider
#if $FIX_MODE; then
#    info "Formatting with ruff format (fix mode)..."
#    if ! uvx ruff format "$REPO_DIR"; then
#        error "ruff format (fix mode) failed!"
#        FAIL=1
#    fi
#else
#    info "Formatting with ruff format (check mode)..."
#    if ! uvx ruff format --check "$REPO_DIR"; then
#        error "ruff format (check mode) detected issues!"
#        FAIL=1
#    fi
#fi
#
#divider
#if $FIX_MODE; then
#    info "Linting with ruff check (fix mode)..."
#    if ! uvx ruff check --fix "$REPO_DIR"; then
#        error "ruff check (fix mode) failed!"
#        FAIL=1
#    fi
#else
#    info "Linting with ruff check (check mode)..."
#    if ! uvx ruff check "$REPO_DIR"; then
#        error "ruff check (check mode) detected issues!"
#        FAIL=1
#    fi
#fi
#
#divider
#info "Type checking with pyre check..."
#if ! pyre check; then
#    error "pyre check detected issues!"
#    FAIL=1
#fi
#
##divider
##info "Type checking with pyright..."
##if ! pyright; then
##    error "pyright detected issues!"
##fi
#
#divider
#info "Linting bash files with shellcheck..."
#if ! shellcheck -x "${REPO_DIR}"/scripts/*.sh; then
#    error "shellcheck detected issues!"
#    FAIL=1
#else
#    success "shellcheck passed"
#fi
#
#
#divider
#info "Running trivy file scanner for misconfig, secrets, and vulnerabilities..."
#TRIVY_CMD="trivy fs --scanners misconfig,secret,vuln ${REPO_DIR}"
#if ! eval "$TRIVY_CMD"; then
#    error "trivy scan failed!"
#    FAIL=1
#fi
#
#divider
#info "Linting yaml files with yamllint..."
#if ! yamllint --strict "$REPO_DIR"; then
#    error "yamllint detected issues!"
#    FAIL=1
#else
#    success "yamllint passed"
#fi




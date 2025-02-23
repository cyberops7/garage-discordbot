#!/usr/bin/env bash

# Exit on error
set -e

# Default values
REPO_DIR="$(git rev-parse --show-toplevel)"
SCANNER="trivy"  # Default scanner
TAG="latest"  # Default tag

# Import logging functions
source "${REPO_DIR}/dev/logger.sh"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
    --help|-h)
        echo "Usage: $0 [--tag <image-tag>] [--tarball <file>] [--scanner <scanner-name>]"
        echo "Options:"
        echo "  --help,     -h             Display this help message and exit."
        echo "  --scanner,  -s <scanner>   Specify the vulnerability scanner (e.g., 'trivy', 'grype', 'snyk') (default: 'trivy')."
        echo "  --tag,      -t <tag>       Specify the Docker image tag to scan (default: 'latest')."
        exit 0
        ;;
    --scanner|-s)
        SCANNER="$2"
        shift 2
        ;;
    --tag)
        TAG="$2"
        shift 2
        ;;
    *)
        echo "Unknown option: $1"
        echo "Run '$0 --help' for usage information."
        exit 1
        ;;
    esac
done

# Define the full image name
IMAGE="ghcr.io/cyberops7/discord-bot:$TAG"

info "Selected scanner: ${SCANNER}"
info "Targeted image: ${IMAGE}"

# Functions to handle each scanner
run_grype() {
    echo "Running scan with Grype..."
    if ! command -v grype &> /dev/null; then
        error "Grype not found."
        warn "You can install Grype from: https://github.com/anchore/grype?tab=readme-ov-file#installation"
        exit 1
    fi

    grype "$IMAGE"
    success "Grype scan completed."
}

run_snyk() {
    info "Running scan with Snyk..."
    if ! command -v snyk &> /dev/null; then
        error "Snyk not found."
        warn "You can install Snyk from: https://docs.snyk.io/snyk-cli/install-or-update-the-snyk-cli"
        exit 1
    fi
    # Authenticate Snyk if required (requires access to `snyk auth`)
    if ! snyk auth --help &> /dev/null; then
        echo "Snyk requires authentication. Run 'snyk auth' locally to authenticate with Snyk."
        exit 1
    fi

    snyk container test "$IMAGE"
    success "Snyk scan completed."
}

run_trivy() {
    info "Running scan with Trivy..."
    trivy image "$IMAGE"
    success "Trivy scan completed."
}

# Execute the appropriate scanner
case "$SCANNER" in
    grype)
        run_grype
        ;;
    snyk)
        run_snyk
        ;;
    trivy)
        run_trivy
        ;;
    *)
        error "Unsupported scanner '$SCANNER'. Supported scanners are: grype, snyk, trivy (default)"
        exit 1
        ;;
esac
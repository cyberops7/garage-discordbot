#!/usr/bin/env bash

set -e

# Default values
TAG="latest"
SCANNER="trivy" # Default scanner

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case "$1" in
    --tag)
        TAG="$2"
        shift 2
        ;;
    --scanner|-s)
        SCANNER="$2"
        shift 2
        ;;
    --help|-h)
        echo "Usage: $0 [--tag <image-tag>] [--scanner <scanner-name>]"
        echo "Options:"
        echo "  --help,     -h             Display this help message and exit."
        echo "  --scanner,  -s <scanner>   Specify the vulnerability scanner (e.g., 'trivy', 'grype', 'snyk') (default: 'trivy')."
        echo "  --tag,      -t <tag>       Specify the Docker image tag to scan (default: 'latest')."
        exit 0
        ;;
    *)
        echo "Unknown option: $1"
        echo "Run '$0 --help' for usage information."
        exit 1
        ;;
    esac
done

# Validate image tag
if [[ -z "$TAG" ]]; then
    echo "Error: Image tag must be provided."
    exit 1
fi

# Define the full image name
IMAGE_TAG="ghcr.io/cyberops7/discord-bot:$TAG"

echo "Selected scanner: $SCANNER"
echo "Scanning image: $IMAGE_TAG"

# Functions to handle each scanner
run_grype() {
    echo "Running scan with Grype..."
    if ! command -v grype &> /dev/null; then
        echo "Grype not found. Installing..."
        curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh
        mv grype /usr/local/bin/
    fi
    grype "$IMAGE_TAG"
}

run_snyk() {
    echo "Running scan with Snyk..."
    if ! command -v snyk &> /dev/null; then
        echo "Snyk not found. Installing..."
        npm install -g snyk
    fi
    # Authenticate Snyk if required (requires access to `snyk auth`)
    if ! snyk auth --help &> /dev/null; then
        echo "Snyk requires authentication. Run 'snyk auth' locally to authenticate with Snyk."
        exit 1
    fi
    snyk container test "$IMAGE_TAG"
}

run_trivy() {
    echo "Running scan with Trivy..."
    if ! command -v trivy &> /dev/null; then
        echo "Trivy not found. Installing..."
        wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_$(uname -s)_$(uname -m).tar.gz
        tar zxvf trivy_$(uname -s)_$(uname -m).tar.gz
        mv trivy /usr/local/bin/
    fi
    trivy image "$IMAGE_TAG"
}

# Execute the appropriate scanner
case "$SCANNER" in
    trivy)
        run_trivy
        ;;
    grype)
        run_grype
        ;;
    snyk)
        run_snyk
        ;;
    *)
        echo "Error: Unsupported scanner '$SCANNER'. Supported scanners are: trivy, grype, snyk."
        exit 1
        ;;
esac
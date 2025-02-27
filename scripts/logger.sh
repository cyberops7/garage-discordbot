#!/usr/bin/env bash
# logger.sh: A simple library for logging

# Define text colors
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
CYAN='\033[1;36m'
RESET='\033[0m'

# Log functions
info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${RESET} $1"
}
warning() {
    warn "$@"
}

error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

note() {
    echo -e "${CYAN}[NOTE]${RESET} $1"
}

# Print a line of a character repeated N times
divider() {
    local char="${1:-*}"  # Default to "#" if no character is provided
    local num="${2:-100}" # Default to 100 if no number is provided

    # Validate inputs
    if [[ "$num" -le 0 ]]; then
        error "Invalid input. The number must be positive."
        return 1
    fi

    # Print the separator
    echo -e "${CYAN}$(printf "%0.s${char}" $(seq 1 "$num"))${RESET}"
}


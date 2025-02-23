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

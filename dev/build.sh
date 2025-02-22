#!/usr/bin/env bash

# Exit on error
set -e

# Get script directory
SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")

# Define context and Dockerfile relative to the script location
CONTEXT="${SCRIPT_DIR}/.."
DOCKERFILE="${SCRIPT_DIR}/Dockerfile"

# Default values
CACHE_FLAG="--no-cache"     # Default behavior is to disable caching
OUTPUT_TAR=""               # Default is no tarball output
PUSH_FLAG=""                # Default behavior is to build, but not push
TAG="test-$(date +%Y%m%d)"  # Default image tag

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --cache)
      CACHE_FLAG="" # If --cache flag is present, remove --no-cache
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [--tag <tag>] [--push] [--cache]"
      echo "Options:"
      echo "  --help,  -h                   Show this help message and exit."
      echo "  --cache                       Enable Docker caching (default is no cache)."
      echo "  --output-tar <output-path>    Output the built image as a tarball to the specified file."
      echo "  --push                        Enable pushing the image to the registry."
      echo "  --tag,   -t <tag>             Specify the image tag (default: 'test-YYYYMMDD')."
      exit 0
      ;;
    --output-tar)
        # Check if the next argument exists and isn't empty or another flag
        if [[ -z "$2" || "$2" == -* ]]; then
            echo "Error: '--output-tar' option requires a file path."
            echo "Run '$0 --help' for usage information."
            exit 1
        fi
        OUTPUT_TAR="--output type=tar,dest=$2"
        shift 2
        ;;
    --push)
      PUSH_FLAG="--push"
      shift
      ;;
    --tag|-t)
      # Check if the next argument exists and isn't empty or another flag
      if [[ -z "$2" || "$2" == -* ]]; then
        echo "Error: '--tag' option requires a value."
        echo "Run '$0 --help' for usage information."
        exit 1
      fi
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

# Check if the builder already exists
BUILDER_NAME="temp-multiarch-builder"
EXISTING_BUILDER=$(docker buildx ls | grep -w "$BUILDER_NAME" || true)
if [ -z "$EXISTING_BUILDER" ]; then
    echo "Builder '${BUILDER_NAME}' does not exist. Creating it now..."
    docker buildx create --name "${BUILDER_NAME}" --use
    echo "Builder '${BUILDER_NAME}' has been created and set as the current builder."
else
    echo "Builder '${BUILDER_NAME}' already exists. Using it now..."
    docker buildx use "$BUILDER_NAME"
fi

docker buildx inspect --bootstrap

docker buildx build \
  --tag ghcr.io/cyberops7/discord-bot:"${TAG}" \
  --platform linux/amd64,linux/arm64 \
  ${CACHE_FLAG} \
  ${PUSH_FLAG} \
  -f "${DOCKERFILE}" \
  "${OUTPUT_TAR}" \
  "${CONTEXT}"

docker buildx rm "${BUILDER_NAME}"

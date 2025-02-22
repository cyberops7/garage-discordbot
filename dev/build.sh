#!/usr/bin/env bash

# Exit on error
set -e

if [ -z "$1" ]; then
  TAG="test-$(date +%Y%m%d)"
  echo "Using default tag: ${TAG}"
else
  TAG="$1"
  echo "Using tag: ${TAG}"
fi

# Set Dockerfile and context
DOCKERFILE=$(dirname "$(pwd)")/Dockerfile
CONTEXT=$(dirname "$(pwd)")
BUILDER_NAME="temp-multiarch-builder"

# Check if the builder already exists
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
  --platform linux/amd64,linux/arm64 \
  --tag ghcr.io/cyberops7/discord-bot:"${TAG}" \
  --no-cache \
  --push \
  -f dev/Dockerfile .

docker buildx rm "${BUILDER_NAME}"

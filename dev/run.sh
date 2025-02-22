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

docker run --name bot-test -it -d --env-file .env \
  ghcr.io/cyberops7/discord-bot:"${TAG}"

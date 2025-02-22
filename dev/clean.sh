#!/usr/bin/env bash

set -e

BUILDER_NAME="temp-multiarch-builder"
CONTAINER_NAME=bot-test

# Remove the container if it is running
if [ "$(docker ps --filter "name=${CONTAINER_NAME}" --filter "status=running" -q)" ]; then
  echo "Container '${CONTAINER_NAME}' is running. Stopping and removing it..."
  docker stop "${CONTAINER_NAME}"
  docker rm "${CONTAINER_NAME}"
else
  echo "Container '${CONTAINER_NAME}' is not running."
fi

# Remove the container if it exists, but is stopped
if [ "$(docker ps -a --filter "name=${CONTAINER_NAME}" --filter "status=exited" -q)" ]; then
  echo "Container '${CONTAINER_NAME}' exists, but is stopped. Removing it..."
  docker rm "${CONTAINER_NAME}"
else
  echo "No stopped container named '${CONTAINER_NAME}' exists."
fi

# Clean up the buildx builder, if it exists
if docker buildx ls | grep -qw "${BUILDER_NAME}"; then
  echo "Builder '${BUILDER_NAME}' exists. Removing it..."
  docker buildx rm "${BUILDER_NAME}"
else
  echo "Builder '${BUILDER_NAME}' does not exist."
fi

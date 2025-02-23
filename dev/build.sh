#!/usr/bin/env bash

# Exit on error
set -e

# Get repo directory
REPO_DIR="$(git rev-parse --show-toplevel)"
SCRIPT_DIR="${REPO_DIR}/dev"

# Import logging functions
source "${SCRIPT_DIR}/logger.sh"

info "Repo directory: ${REPO_DIR}"

# Define context and Dockerfile relative to the script location
CONTEXT="${REPO_DIR}"
DOCKERFILE="${SCRIPT_DIR}/Dockerfile"
IMAGE_NAME=ghcr.io/cyberops7/discord-bot

# Default values
CACHE_FLAG="--no-cache"     # Default behavior is to disable caching
LOCAL_FLAG=""               # Default is no local import into the Docker daemon
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
      echo "  --help,  -h           Show this help message and exit."
      echo "  --cache               Enable Docker caching (default is no cache)."
      echo "  --local               Export the built image from the buildx builder to the local Docker daemon."
      echo "  --push                Enable pushing the image to the registry."
      echo "  --tag,   -t <tag>     Specify the image tag (default: 'test-YYYYMMDD')."
      exit 0
      ;;
    --local)
        LOCAL_FLAG="--output type=oci,dest=.tmp/oci-image.tar"
        shift
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

info "Using tag: ${TAG}"

# Check if the builder already exists
BUILDER_NAME="temp-multiarch-builder"
EXISTING_BUILDER=$(docker buildx ls | grep -w "$BUILDER_NAME" || true)
if [ -z "$EXISTING_BUILDER" ]; then
    info "Builder '${BUILDER_NAME}' does not exist. Creating it now..."
    docker buildx create --name "${BUILDER_NAME}" --use
    success "Builder '${BUILDER_NAME}' has been created and set as the current builder."
else
    info "Builder '${BUILDER_NAME}' already exists. Using it now..."
    docker buildx use "$BUILDER_NAME"
fi

info "Bootstrapping builder..."
docker buildx inspect --bootstrap
success "Builder bootstrapped successfully."

# Build the docker build command
CMD="docker buildx build \
    --tag ${IMAGE_NAME}:${TAG} \
    --platform linux/amd64,linux/arm64"

# Include --no-cache flag if set
if [[ -n "$CACHE_FLAG" ]]; then
    CMD+=" $CACHE_FLAG"
    info "Caching disabled."
else
    info "Caching enabled."
fi

# Add oci output if it's not empty
if [[ -n "$LOCAL_FLAG" ]]; then
    CMD+=" $LOCAL_FLAG"
    info "Image will be exported to the local Docker daemon."
fi

# Add PUSH_FLAG if it's not empty
if [[ -n "$PUSH_FLAG" ]]; then
    CMD+=" $PUSH_FLAG"
    info "Image will be pushed to the registry"
fi

# Specify Dockerfile and context at the end
CMD+=" -f ${DOCKERFILE} ${CONTEXT}"

# Print the final command (for debugging)
info "Final build command:"
echo -e "${CYAN}${CMD}${RESET}"

# Execute the constructed command
echo -e "--------------------------------------------------------------------------"
info "Building the image..."
eval "$CMD"
success "Image built successfully with tag: ${TAG}"
echo -e "--------------------------------------------------------------------------"

# Output the path to the tarball if --local was passed
if [[ -n "$LOCAL_FLAG" ]]; then
    info "Converting the OCI image to Docker format..."
    skopeo copy --override-os linux --override-arch \
        arm64 oci-archive:"${CONTEXT}/.tmp/oci-image.tar" \
        docker-archive:"${CONTEXT}/.tmp/docker-compatible-image.tar":"${IMAGE_NAME}:${TAG}"
    success "OCI image converted to Docker archive."

    info "Importing the image into the Docker daemon"
    docker load < "${CONTEXT}/.tmp/docker-compatible-image.tar"
    success "Image imported into Docker daemon. Image now available locally."
    docker image ls "${IMAGE_NAME}"

    info "Performing clean-up of temporary files..."
    rm "${CONTEXT}/.tmp/oci-image.tar" \
        "${CONTEXT}/.tmp/docker-compatible-image.tar" \
        2>/dev/null || true
    success "Temporary files cleaned."
fi

info "Removing builder '${BUILDER_NAME}'..."
docker buildx rm "${BUILDER_NAME}"
success "Builder '${BUILDER_NAME}' removed successfully."

info "Cleaning up unused dangling images..."
docker image prune -f
success "Clean-up complete. Dangling images removed."

success "Build process completed!"


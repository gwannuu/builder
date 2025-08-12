#!/bin/bash

# Define the image name and tag
IMAGE_NAME="gwanwoo/base"
IMAGE_TAG="0.0.0"

# Check if the first argument is "--no-cache"
if [ "$1" = "--no-cache" ]; then
    # If "--no-cache" is provided, set the flag and shift arguments
    echo "Building with --no-cache option."
    NO_CACHE_FLAG="--no-cache"
    shift
else
    # Otherwise, don't use the --no-cache flag
    NO_CACHE_FLAG=""
fi

# Execute the Docker build command
docker build \
  ${NO_CACHE_FLAG} \
  --build-arg HOST_UID=$(id -u) \
  --build-arg HOST_GID=$(id -g) \
  -t "${IMAGE_NAME}:${IMAGE_TAG}" \
  .

#!/usr/bin/env bash
set -euo pipefail

# Check Docker
if ! command -v docker &>/dev/null; then
    echo "Docker is required to build and run OpenHands."
    exit 1
fi

# Exit if already inside Docker
if [ -f /.dockerenv ]; then
    echo "Running inside a Docker container. Exiting..."
    exit 0
fi

# Determine workspace
OPENHANDS_WORKSPACE=$(git rev-parse --show-toplevel || echo "$PWD")
cd "$OPENHANDS_WORKSPACE/containers/dev/" || exit 1

# Environment variables
export BACKEND_HOST="0.0.0.0"
export SANDBOX_USER_ID=$(id -u)
export WORKSPACE_BASE="${WORKSPACE_BASE:-$OPENHANDS_WORKSPACE/workspace}"

# Run using old docker-compose syntax
if command -v docker-compose &>/dev/null; then
    docker-compose run --rm -p 3000:3000 -p 3001:3001 "$@" dev
else
    echo "docker-compose not found. Please install it."
    exit 1
fi
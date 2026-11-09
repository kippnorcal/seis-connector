#!/usr/bin/env bash
#
# Runs the SEIS pipeline container.
# Usage: run_seis.sh

set -euo pipefail

KEY_DIR="/home/data_admin/keys"
LOCK_FILE="/tmp/run_seis.lock"
IMAGE="seis-connector"

# --- This script takes no arguments ---
if [[ $# -ne 0 ]]; then
    echo "Usage: $0   (no arguments)" >&2
    exit 1
fi

# --- Prevent overlapping runs ---
exec 9> "$LOCK_FILE"
if ! flock -n 9; then
    echo "Another run is still in progress; skipping." >&2
    exit 0
fi

/usr/bin/docker run --rm \
    -v "$KEY_DIR/seis_pipeline:/root/.ssh/seis_pipeline:ro" \
    -v "$KEY_DIR/seis_known_hosts:/root/.ssh/known_hosts:ro" \
    "$IMAGE"
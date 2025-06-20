#!/bin/bash
export IMMICH_PORT="${DEV_SERVER_PORT:-2283}"
export DEV_PORT="${DEV_PORT:-3000}"

# search for immich directory inside workspace.
# /workspaces/immich is the bind mount, but other directories can be mounted if runing
# Devcontainer: Clone [repository|pull request] in container volumne
WORKSPACES_DIR="/workspaces"
IMMICH_DIR="$WORKSPACES_DIR/immich"
LIBRARY_DIR="$UPLOAD_LOCATION"
IMMICH_DEVCONTAINER_LOG="$HOME/immich-devcontainer.log"
USER_ID=$(id -u)

export IMMICH_WORKSPACE="$IMMICH_DIR"

log() {
    # Display command on console, log with timestamp to file
    echo "$*"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >>"$IMMICH_DEVCONTAINER_LOG"
}

run_cmd() {
    # Ensure log directory exists
    mkdir -p "$(dirname "$IMMICH_DEVCONTAINER_LOG")"

    log "$@"

    # Execute command: display normally on console, log with timestamps to file
    "$@" 2>&1 | tee >(while IFS= read -r line; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line" >>"$IMMICH_DEVCONTAINER_LOG"
    done)

    # Preserve exit status
    return "${PIPESTATUS[0]}"
}

fix_permissions() {

    log "Fixing permissions for ${IMMICH_WORKSPACE}"

    run_cmd sudo chown "$USER_ID" -R "${LIBRARY_DIR}"
    run_cmd sudo find "${IMMICH_WORKSPACE}" -not -path "*/node_modules/*" -not -path "*/.git/*" -exec chown "$USER_ID" {} +

    #run_cmd sudo chown $USER_ID -R "${IMMICH_WORKSPACE}"

    log ""
}

install_dependencies() {

    log "Installing dependencies"
    (
        cd "${IMMICH_WORKSPACE}" || exit 1
        run_cmd make install-server
        run_cmd make install-sdk
        run_cmd make build-sdk
        run_cmd make install-web
    )
    log ""
}

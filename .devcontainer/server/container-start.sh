#!/bin/bash
# shellcheck source=common.sh
# shellcheck disable=SC1091
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/container-common.sh"

log "Fix git permissions"
git config --global --add safe.directory /workspaces/immich

log "Setting up Immich dev container..."
fix_permissions

log "Installing npm dependencies (node_modules)..."
install_dependencies

log "Setup complete"
log
log "Only the infra services are started (ML, redis, postgres). Server and Web should be started manually, using the following aliases"
log
log "$ runserver"
log "$ runweb"
log
log "From different terminal windows, as these scripts automatically restart the server"
log "on error, and will continuously run in a loop"

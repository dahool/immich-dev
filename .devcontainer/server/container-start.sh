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

log "Setup complete, please wait while backend and frontend services automatically start"
log
log "If necessary, the services may be manually started using"
log
log "$ container-start-backend.sh"
log "$ container-start-frontend.sh"
log
log "From different terminal windows, as these scripts automatically restart the server"
log "on error, and will continuously run in a loop"

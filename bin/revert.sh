#!/bin/bash

#
# This script revert the fresh start script to git branch
#
# Source: https://github.com/evertramos/nginx-proxy-automation
#

# Get the script name and its real file path
SCRIPT_PATH="$(dirname "$(readlink -f "$0")")"
SCRIPT_NAME="${0##*/}"
CURRENT_PATH=$(pwd)

# Go to script path if not there
cd "${SCRIPT_PATH}/../"

# Stop compose
export COMPOSE_INTERACTIVE_NO_CLI=1
docker compose down 2&> /dev/null || true

# Remove newly created files/folder
sudo rm -rf ./data .env docker-compose.yml.backup_* .env.backup_* .env

# Restore docker-compose.yml 
git restore docker-compose.yml

echo 'Repo restored!'

exit 0


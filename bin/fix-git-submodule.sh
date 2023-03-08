#!/bin/bash

#
# This script updates the branch name to 'main'
#
# Source: https://github.com/evertramos/nginx-proxy-automation
#

# Get the script name and its real file path
SCRIPT_PATH="$(dirname "$(readlink -f "$0")")"
SCRIPT_NAME="${0##*/}"
CURRENT_PATH=$(pwd)

cd "${SCRIPT_PATH}/../basescript"

# Set submodules
git submodule init
git submodule update

if [[ ! "${SCRIPT_PATH}" == "${CURRENT_PATH}" ]]; then
  cd - 1>/dev/null 2>/dev/null
fi

exit 0


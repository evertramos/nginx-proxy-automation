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

cd "${SCRIPT_PATH}/../"

# Update template with the latest version of nginx template
curl https://raw.githubusercontent.com/jwilder/nginx-proxy/master/nginx.tmpl > nginx.tmpl

cd - 1>/dev/null 2>/dev/null

exit 0


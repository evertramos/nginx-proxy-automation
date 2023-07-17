#!/bin/bash

#-----------------------------------------------------------------------
#
# Install script - configure the requirements for this project
#
# https://github.com/evertramos/nginx-proxy-automation
#
# Script developed by
#   Evert Ramos <evert.ramos@gmail.com>
#
# Copyright Evert Ramos
#
#-----------------------------------------------------------------------

# Bash settings (do not mess with it)
shopt -s nullglob globstar

# Get the script name and its file real path
SCRIPT_PATH="$(dirname "$(readlink -f "$0")")"
SCRIPT_NAME="${0##*/}"

# basescript (remove and install)
BASESCRIPT_VERSION=v0.6.2
BASESCRIPT_BASE_PATH=${SCRIPT_PATH}/../src/scripts
mkdir -p ${BASESCRIPT_BASE_PATH}
cd ${BASESCRIPT_BASE_PATH}
rm -rf "basescript"
git clone https://github.com/evertramos/basescript.git &> /dev/null
cd basescript
git checkout ${BASESCRIPT_VERSION} &> /dev/null
cd ${SCRIPT_PATH}
source "${BASESCRIPT_BASE_PATH}/basescript/bootstrap.sh"
BASESCRIPT_LOG_BASE_PATH=${BASESCRIPT_BASE_PATH}/logs
mkdir -p ${BASESCRIPT_LOG_BASE_PATH}
# Source localscripts
#source ${BASESCRIPT_BASE_PATH}"/localscripts/bootstrap.sh"

log "testing..."

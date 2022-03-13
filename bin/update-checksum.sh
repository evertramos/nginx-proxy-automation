#!/bin/bash

#-----------------------------------------------------------------------
#
# Update checksum in .env files
#
# Part of https://github.com/evertramos/nginx-proxy-automation
#
# Script written by
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

# Source basescript functions
source $SCRIPT_PATH"/../basescript/bootstrap.sh"

# Source localscripts
source $SCRIPT_PATH"/localscript/bootstrap.sh"

# Log
printf "${energy} Start execution '${SCRIPT_PATH}/${SCRIPT_NAME} "
log "Start execution"
log "$@"

#-----------------------------------------------------------------------
# Initial check - DO NOT CHANGE SETTINGS BELOW
#-----------------------------------------------------------------------

# Check if there is an .env file in local folder
run_function check_local_env_file

# Specific PID File if needs to run multiple scripts
NEW_PID_FILE=${PID_FILE_FRESH_INSTALL:-".update_checksum"}

# Run initial check function
run_function starts_initial_check $NEW_PID_FILE

# Save PID
system_save_pid $NEW_PID_FILE

# DO NOT CHANGE ANY OPTIONS ABOVE THIS LINE!

#-----------------------------------------------------------------------
# [function] Undo script actions
#-----------------------------------------------------------------------
local_undo_restore() {
#  local LOCAL_KEEP_RESTORE_FILES
#
#  LOCAL_KEEP_RESTORE_FILES=${1:-$KEEP_RESTORE_FILES}

  echoerror \
    "It seems something went wrong! \
    \nRunning '${FUNCNAME[0]} to try to UNDO all actions done by this script. \
    \nPlease make sure everything was put it back in place." false

  # If docker network was created
#  if [[ "$ACTION_DOCKER_NETWORK_CREATED" == true ]]; then
#    [[ "$SILENT" != true ]] && echowarning "[undo] Deleting created docker network '$DOCKER_NETWORK_NAME'."
#    run_function docker_network_remove $DOCKER_NETWORK_NAME
#    ACTION_DOCKER_NETWORK_CREATED=false
#  fi

  exit 0
}

#-----------------------------------------------------------------------
# Verify checksum of docker-compose.yml and .env.sample files
#-----------------------------------------------------------------------
run_function md5_check_checksum "$SCRIPT_PATH/../" "docker-compose.yml" $MD5_SUM_DOCKER_COMPOSE
if [[ ! "$MD5_CHECKSUM" == true ]]; then
    DOCKER_COMPOSE_CHECKSUM=$(md5sum "$SCRIPT_PATH/../docker-compose.yml" | awk '{print $1}')
    echowarning "Updating the checksum for 'MD5_SUM_DOCKER_COMPOSE'"
    run_function env_update_variable "$SCRIPT_PATH" "MD5_SUM_DOCKER_COMPOSE" "$DOCKER_COMPOSE_CHECKSUM"
else
    echosuccess "Checksum for 'MD5_SUM_DOCKER_COMPOSE' is just fine!"
fi

run_function md5_check_checksum "$SCRIPT_PATH/../" ".env.sample" $MD5_SUM_ENV_SAMPLE
if [[ ! "$MD5_CHECKSUM" == true ]]; then
    ENV_CHECKSUM=$(md5sum "$SCRIPT_PATH/../.env.sample" | awk '{print $1}')
    echowarning "Updating the checksum for 'MD5_SUM_ENV_SAMPLE'"
    run_function env_update_variable "$SCRIPT_PATH" "MD5_SUM_ENV_SAMPLE" "$ENV_CHECKSUM"
else
    echosuccess "Checksum for 'MD5_SUM_ENV_SAMPLE' is just fine!"
fi

exit 0

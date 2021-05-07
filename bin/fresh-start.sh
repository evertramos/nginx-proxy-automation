#!/bin/bash

#-----------------------------------------------------------------------
#
# Fresh Start script - set up nginx-proxy in a fresh installed server
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

# Source basescript functions
source $SCRIPT_PATH"/../basescript/bootstrap.sh"

# Source localscripts
source $SCRIPT_PATH"/localscript/bootstrap.sh"

# Log
printf "${energy} Start execution '${SCRIPT_PATH}/${SCRIPT_NAME} "
log "Start execution"
log "$@"

#-----------------------------------------------------------------------
# Process arguments
#-----------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
  -d)
    ARG_DATA_LOCATION="${2}"
    if [[ $ARG_DATA_LOCATION == "" ]]; then
      echoerror "Invalid option for -d"
      break
    fi
    shift 2
    ;;
  --data-files-location=*)
    ARG_DATA_LOCATION="${1#*=}"
    if [[ $ARG_DATA_LOCATION == "" ]]; then
      echoerror "Invalid option for --data-files-location=''"
      break
    fi
    shift 1
    ;;
  -e)
    ARG_DEFAULT_EMAIL="${2}"
    if [[ $ARG_DEFAULT_EMAIL == "" ]]; then
      echoerror "Invalid option for -e"
      break
    fi
    shift 2
    ;;
  --default-email=*)
    ARG_DEFAULT_EMAIL="${1#*=}"
    if [[ $ARG_DEFAULT_EMAIL == "" ]]; then
      echoerror "Invalid option for --default-email=''"
      break
    fi
    shift 1
    ;;
  -pn)
    ARG_NGINX_PROXY_SERVICE_NAME="${2}"
    if [[ $ARG_NGINX_PROXY_SERVICE_NAME == "" ]]; then
      echoerror "Invalid option for -pn"
      break
    fi
    shift 2
    ;;
  --proxy-name=*)
    ARG_NGINX_PROXY_SERVICE_NAME="${1#*=}"
    if [[ $ARG_NGINX_PROXY_SERVICE_NAME == "" ]]; then
      echoerror "Invalid option for --proxy-name=''"
      break
    fi
    shift 1
    ;;
  -ln)
    ARG_LETSENCRYPT_SERVICE_NAME="${2}"
    if [[ $ARG_LETSENCRYPT_SERVICE_NAME == "" ]]; then
      echoerror "Invalid option for -ln"
      break
    fi
    shift 2
    ;;
  --letsencrypt-name=*)
    ARG_LETSENCRYPT_SERVICE_NAME="${1#*=}"
    if [[ $ARG_LETSENCRYPT_SERVICE_NAME == "" ]]; then
      echoerror "Invalid option for --letsencrypt-name=''"
      break
    fi
    shift 1
    ;;
  -gn)
    ARG_DOCKER_GEN_SERVICE_NAME="${2}"
    if [[ $ARG_DOCKER_GEN_SERVICE_NAME == "" ]]; then
      echoerror "Invalid option for -gn"
      break
    fi
    shift 2
    ;;
  --docker-gen-name=*)
    ARG_DOCKER_GEN_SERVICE_NAME="${1#*=}"
    if [[ $ARG_DOCKER_GEN_SERVICE_NAME == "" ]]; then
      echoerror "Invalid option for --docker-gen-name=''"
      break
    fi
    shift 1
    ;;
  -piv)
    ARG_NGINX_PROXY_IMAGE_VERSION="${2}"
    if [[ $ARG_NGINX_PROXY_IMAGE_VERSION == "" ]]; then
      echoerror "Invalid option for -pversion"
      break
    fi
    shift 2
    ;;
  --proxy-image-version=*)
    ARG_NGINX_PROXY_IMAGE_VERSION="${1#*=}"
    if [[ $ARG_NGINX_PROXY_IMAGE_VERSION == "" ]]; then
      echoerror "Invalid option for --proxy-image-version=''"
      break
    fi
    shift 1
    ;;
  -liv)
    ARG_LETSENCRYPT_IMAGE_VERSION="${2}"
    if [[ $ARG_LETSENCRYPT_IMAGE_VERSION == "" ]]; then
      echoerror "Invalid option for -liv"
      break
    fi
    shift 2
    ;;
  --letsencrypt-image-version=*)
    ARG_LETSENCRYPT_IMAGE_VERSION="${1#*=}"
    if [[ $ARG_LETSENCRYPT_IMAGE_VERSION == "" ]]; then
      echoerror "Invalid option for --letsencrypt-image-version=''"
      break
    fi
    shift 1
    ;;
  -giv)
    ARG_DOCKER_GEN_IMAGE_VERSION="${2}"
    if [[ $ARG_DOCKER_GEN_IMAGE_VERSION == "" ]]; then
      echoerror "Invalid option for -giv"
      break
    fi
    shift 2
    ;;
  --docker-gen-image-version=*)
    ARG_DOCKER_GEN_IMAGE_VERSION="${1#*=}"
    if [[ $ARG_DOCKER_GEN_IMAGE_VERSION == "" ]]; then
      echoerror "Invalid option for --docker-gen-image-version=''"
      break
    fi
    shift 1
    ;;

  # Network options
  -ip)
    ARG_IP_ADDRESS="${2}"
    if [[ $ARG_IP_ADDRESS == "" ]]; then
      echoerror "Invalid option for -ip"
      break
    fi
    shift 2
    ;;
  --ip-address=*)
    ARG_IP_ADDRESS="${1#*=}"
    if [[ $ARG_IP_ADDRESS == "" ]]; then
      echoerror "Invalid option for --ip-address"
      break
    fi
    shift 1
    ;;
  -ipv6)
    ARG_IPv6_ADDRESS="${2}"
    if [[ $ARG_IPv6_ADDRESS == "" ]]; then
      echoerror "Invalid option for -ipv6"
      break
    fi
    shift 2
    ;;
  --ipv6-address=*)
    ARG_IPv6_ADDRESS="${1#*=}"
    if [[ $ARG_IPv6_ADDRESS == "" ]]; then
      echoerror "Invalid option for --ipv6-address"
      break
    fi
    shift 1
    ;;
  -net)
    ARG_NETWORK_NAME="${2}"
    if [[ $ARG_NETWORK_NAME == "" ]]; then
      echoerror "Invalid option for -net"
      break
    fi
    shift 2
    ;;
  --network-name=*)
    ARG_NETWORK_NAME="${1#*=}"
    if [[ $ARG_NETWORK_NAME == "" ]]; then
      echoerror "Invalid option for --network-name"
      break
    fi
    shift 1
    ;;
  -netopt)
    NETWORK_OPTION="${2}"
    if [[ $NETWORK_OPTION == "" ]]; then
      echoerror "Invalid option for -netopt"
      break
    fi
    shift 2
    ;;
  --network-option=*)
    NETWORK_OPTION="${1#*=}"
    if [[ $NETWORK_OPTION == "" ]]; then
      echoerror "Invalid option for --network-option"
      break
    fi
    shift 1
    ;;

  # Log settings
  -lpd)
    ARG_NGINX_PROXY_LOG_DRIVER="${2}"
    if [[ $ARG_NGINX_PROXY_LOG_DRIVER == "" ]]; then
      echoerror "Invalid option for -lpd"
      break
    fi
    shift 2
    ;;
  --log-nginx-proxy-driver=*)
    ARG_NGINX_PROXY_LOG_DRIVER="${1#*=}"
    if [[ $ARG_NGINX_PROXY_LOG_DRIVER == "" ]]; then
      echoerror "Invalid option for --log-nginx-proxy-driver"
      break
    fi
    shift 1
    ;;
  -lpms)
    ARG_NGINX_PROXY_LOG_MAX_SIZE="${2}"
    if [[ $ARG_NGINX_PROXY_LOG_MAX_SIZE == "" ]]; then
      echoerror "Invalid option for -lpms"
      break
    fi
    shift 2
    ;;
  --log-nginx-proxy-max_size=*)
    ARG_NGINX_PROXY_LOG_MAX_SIZE="${1#*=}"
    if [[ $ARG_NGINX_PROXY_LOG_MAX_SIZE == "" ]]; then
      echoerror "Invalid option for --log-nginx-proxy-max_size"
      break
    fi
    shift 1
    ;;
  -lpmf)
    ARG_NGINX_PROXY_LOG_MAX_FILE="${2}"
    if [[ $ARG_NGINX_PROXY_LOG_MAX_FILE == "" ]]; then
      echoerror "Invalid option for -lpmf"
      break
    fi
    shift 2
    ;;
  --log-nginx-proxy-max_file=*)
    ARG_NGINX_PROXY_LOG_MAX_FILE="${1#*=}"
    if [[ $ARG_NGINX_PROXY_LOG_MAX_FILE == "" ]]; then
      echoerror "Invalid option for --log-nginx-proxy-max_file"
      break
    fi
    shift 1
    ;;
  -lgd)
    ARG_DOCKER_GEN_LOG_DRIVER="${2}"
    if [[ $ARG_DOCKER_GEN_LOG_DRIVER == "" ]]; then
      echoerror "Invalid option for -lgd"
      break
    fi
    shift 2
    ;;
  --log-docker-gen-driver=*)
    ARG_DOCKER_GEN_LOG_DRIVER="${1#*=}"
    if [[ $ARG_DOCKER_GEN_LOG_DRIVER == "" ]]; then
      echoerror "Invalid option for --log-docker-gen-driver"
      break
    fi
    shift 1
    ;;
  -lgms)
    ARG_DOCKER_GEN_LOG_MAX_SIZE="${2}"
    if [[ $ARG_DOCKER_GEN_LOG_MAX_SIZE == "" ]]; then
      echoerror "Invalid option for -lgms"
      break
    fi
    shift 2
    ;;
  --log-docker-gen-max_size=*)
    ARG_DOCKER_GEN_LOG_MAX_SIZE="${1#*=}"
    if [[ $ARG_DOCKER_GEN_LOG_MAX_SIZE == "" ]]; then
      echoerror "Invalid option for --log-docker-gen-max_size"
      break
    fi
    shift 1
    ;;
  -lgmf)
    ARG_DOCKER_GEN_LOG_MAX_FILE="${2}"
    if [[ $ARG_DOCKER_GEN_LOG_MAX_FILE == "" ]]; then
      echoerror "Invalid option for -lgmf"
      break
    fi
    shift 2
    ;;
  --log-docker-gen-max_file=*)
    ARG_DOCKER_GEN_LOG_MAX_FILE="${1#*=}"
    if [[ $ARG_DOCKER_GEN_LOG_MAX_FILE == "" ]]; then
      echoerror "Invalid option for --log-docker-gen-max_file"
      break
    fi
    shift 1
    ;;
  -lld)
    ARG_LETSENCRYPT_LOG_DRIVER="${2}"
    if [[ $ARG_LETSENCRYPT_LOG_DRIVER == "" ]]; then
      echoerror "Invalid option for -lld"
      break
    fi
    shift 2
    ;;
  --log-letsencrypt-driver=*)
    ARG_LETSENCRYPT_LOG_DRIVER="${1#*=}"
    if [[ $ARG_LETSENCRYPT_LOG_DRIVER == "" ]]; then
      echoerror "Invalid option for --log-letsencrypt-driver"
      break
    fi
    shift 1
    ;;
  -llms)
    ARG_LETSENCRYPT_LOG_MAX_SIZE="${2}"
    if [[ $ARG_LETSENCRYPT_LOG_MAX_SIZE == "" ]]; then
      echoerror "Invalid option for -llms"
      break
    fi
    shift 2
    ;;
  --log-letsencrypt-max_size=*)
    ARG_LETSENCRYPT_LOG_MAX_SIZE="${1#*=}"
    if [[ $ARG_LETSENCRYPT_LOG_MAX_SIZE == "" ]]; then
      echoerror "Invalid option for --log-letsencrypt-max_size"
      break
    fi
    shift 1
    ;;
  -llmf)
    ARG_LETSENCRYPT_LOG_MAX_FILE="${2}"
    if [[ $ARG_LETSENCRYPT_LOG_MAX_FILE == "" ]]; then
      echoerror "Invalid option for -llmf"
      break
    fi
    shift 2
    ;;
  --log-letsencrypt-max_file=*)
    ARG_LETSENCRYPT_LOG_MAX_FILE="${1#*=}"
    if [[ $ARG_LETSENCRYPT_LOG_MAX_FILE == "" ]]; then
      echoerror "Invalid option for --log-letsencrypt-max_file"
      break
    fi
    shift 1
    ;;

  # Port binginds
  -phttp)
    ARG_DOCKER_HTTP="${2}"
    if [[ $ARG_DOCKER_HTTP == "" ]]; then
      echoerror "Invalid option for -phttp"
      break
    fi
    shift 2
    ;;
  --port-http=*)
    ARG_DOCKER_HTTP="${1#*=}"
    if [[ $ARG_DOCKER_HTTP == "" ]]; then
      echoerror "Invalid option for --port-http"
      break
    fi
    shift 1
    ;;
  -phttps)
    ARG_DOCKER_HTTPS="${2}"
    if [[ $ARG_DOCKER_HTTPS == "" ]]; then
      echoerror "Invalid option for -phttps"
      break
    fi
    shift 2
    ;;
  --port-https=*)
    ARG_DOCKER_HTTPS="${1#*=}"
    if [[ $ARG_DOCKER_HTTPS == "" ]]; then
      echoerror "Invalid option for --port-https"
      break
    fi
    shift 1
    ;;

  # SSL Policy
  -sp)
    ARG_SSL_POLICY="${2}"
    if [[ $ARG_SSL_POLICY == "" ]]; then
      echoerror "Invalid option for -sp"
      break
    fi
    shift 2
    ;;
  --ssl-policy=*)
    ARG_SSL_POLICY="${1#*=}"
    if [[ $ARG_SSL_POLICY == "" ]]; then
      echoerror "Invalid option for --ssl-policy"
      break
    fi
    shift 1
    ;;

  # IPv6 options
  --ipv6-subnet=*)
    ARG_IPv6_SUBNET="${1#*=}"
    if [[ $ARG_IPv6_SUBNET == "" ]]; then
      echoerror "Invalid option for --ipv6-subnet"
      break
    fi
    shift 1
    ;;
  --activate-ipv6)
    ACTIVATE_IPV6=true
    shift 1
    ;;

  --update-nginx-template)
    UPDATE_NGINX_TEMPLATE=true
    shift 1
    ;;
  --skip-docker-image-check)
    SKIP_DOCKER_IMAGE_CHECK=true
    shift 1
    ;;
  --use-nginx-conf-files)
    USE_NGINX_CONF_FILES=true
    shift 1
    ;;
  --yes)
    REPLY_YES=true
    shift 1
    ;;
  --debug)
    DEBUG=true
    shift 1
    ;;
  --silent)
    SILENT=true
    shift 1
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echoerror "Unknown argument: $1" false
    usage
    exit 0
    ;;
  esac
done

#-----------------------------------------------------------------------
# Initial check - DO NOT CHANGE SETTINGS BELOW
#-----------------------------------------------------------------------

# Check if there is an .env file in local folder
run_function check_local_env_file

# Specific PID File if needs to run multiple scripts
NEW_PID_FILE=${PID_FILE_FRESH_INSTALL:-".fresh_start"}

# Run initial check function
run_function starts_initial_check $NEW_PID_FILE true

# Save PID
system_save_pid $NEW_PID_FILE

# DO NOT CHANGE ANY OPTIONS ABOVE THIS LINE!

#-----------------------------------------------------------------------
# [function] Undo script actions
#-----------------------------------------------------------------------
local_undo_restore() {
  local LOCAL_KEEP_RESTORE_FILES

  LOCAL_KEEP_RESTORE_FILES=${1:-$KEEP_RESTORE_FILES}

  echoerror \
    "It seems something went wrong running '${FUNCNAME[0]}' \
        \nwe will try to UNDO all actions done by this script. \
        \nPlease make sure everything was put it back in place." false

  # If docker network was created
  if [[ "$ACTION_DOCKER_NETWORK_CREATED" == true ]]; then
    [[ "$SILENT" != true ]] && echowarning "[undo] Deleting created docker network '$DOCKER_NETWORK_NAME'."
    run_function docker_network_remove $DOCKER_NETWORK_NAME
    ACTION_DOCKER_NETWORK_CREATED=false
  fi

  # If docker-compose file was renamed (backup)
  if [[ "$ACTION_DOCKER_COMPOSE_FILE_RENAMED" == true ]]; then
    [[ "$SILENT" != true ]] && echowarning "[undo] Renaming docker-compose.yml file '$LOCAL_BACKUP_DOCKER_COMPOSE_FILE'."
    mv $LOCAL_BACKUP_DOCKER_COMPOSE_FILE "$SCRIPT_PATH/../docker-compose.yml"
    ACTION_DOCKER_COMPOSE_FILE_RENAMED=false
  fi

  # If .env file was renamed (backup)
  if [[ "$ACTION_ENV_FILE_RENAMED" == true ]]; then
    [[ "$SILENT" != true ]] && echowarning "[undo] Renaming .env file '$LOCAL_BACKUP_ENV_FILE'."
    mv $LOCAL_BACKUP_ENV_FILE "$SCRIPT_PATH/../.env"
    ACTION_ENV_FILE_RENAMED=false
  fi

  # If docker-compose file was renamed (backup)
  if [[ "$ACTION_DOCKER_COMPOSE_FILE_RENAMED" == true ]]; then
    [[ "$SILENT" != true ]] && echowarning "[undo] Renaming docker-compose file '$LOCAL_BACKUP_DOCKER_COMPOSE_FILE'."
    mv $LOCAL_BACKUP_DOCKER_COMPOSE_FILE "$SCRIPT_PATH/../docker-compose.yml"
    ACTION_DOCKER_COMPOSE_FILE_RENAMED=false
  fi

  # If the service was stopped try to restart it
  if [[ "$ACTION_DOCKER_COMPOSE_STOPPED" == true ]]; then
    [[ "$SILENT" != true ]] && echowarning "[undo] Stopping docker-compose service '$SCRIPT_PATH/../'."
    run_function docker_compose_start "$SCRIPT_PATH/../"
    ACTION_DOCKER_COMPOSE_STOPPED=false
  fi

  exit 0
}

#-----------------------------------------------------------------------
# [function] Docker images and version check
#-----------------------------------------------------------------------
local_check_docker_hub_image_version() {
  local LOCAL_DOCKER_IMAGE_NAME LOCAL_DOCKER_IMAGE_VERSION

  LOCAL_DOCKER_IMAGE_NAME=${1:-null}
  LOCAL_DOCKER_IMAGE_VERSION=${2:-null}

  # Check image exists
  run_function dockerhub_check_image_exists $LOCAL_DOCKER_IMAGE_NAME

  if [[ "$DOCKERHUB_IMAGE_EXISTS" != true ]]; then
    echoerror "It seems the image '$LOCAL_DOCKER_IMAGE_NAME' does not exist in docker hub (https://hub.docker.com) or the site is down. Wait a few minutes and try again." false
    local_undo_restore
  fi

  # Check if image and version exists in docker hub
  run_function dockerhub_check_image_exists $LOCAL_DOCKER_IMAGE_NAME $LOCAL_DOCKER_IMAGE_VERSION

  if [[ "$DOCKERHUB_IMAGE_EXISTS" != true ]]; then
    echoerror "It seems the image '$LOCAL_DOCKER_IMAGE_NAME:$LOCAL_DOCKER_IMAGE_VERSION' does not exist in docker hub (https://hub.docker.com) or the site is down. Wait a few minutes and try again." false
    local_undo_restore
  fi
}

#-----------------------------------------------------------------------
# Check if the docker-compose is already running
#-----------------------------------------------------------------------
LOCAL_DOCKER_COMPOSE_FILE_FULL_PATH="$SCRIPT_PATH/../ "
run_function docker_compose_check_service_exists $LOCAL_DOCKER_COMPOSE_FILE_FULL_PATH

if [[ "$DOCKER_COMPOSE_SERVICE_EXISTS" == true ]]; then
  [[ "$SILENT" != true ]] && echowarning \
    "The services in the docker compose file below is already running: \
        \n'$LOCAL_DOCKER_COMPOSE_FILE_FULL_PATH' \
        \nIf you continue, the services will be stopped and all settings replaced \
        \nif you are uncertain, check your current files settings before continue."

  if [[ "$REPLY_YES" == true ]]; then
    LOCAL_STOP_CURRENT_NGINX_PROXY_SERVICES=true
    LOCAL_BACKUP_OLD_DOCKER_COMPOSE_FILE=true
  else
    run_function confirm_user_action "Your services for this project are already running, \
            \nare you sure you want to continue?"

    [[ "$USER_ACTION_RESPONSE" == true ]] && LOCAL_STOP_CURRENT_NGINX_PROXY_SERVICES=true && LOCAL_BACKUP_OLD_DOCKER_COMPOSE_FILE=true
  fi
fi

#-----------------------------------------------------------------------
# Check if the .env file was already configured
#-----------------------------------------------------------------------
run_function check_docker_nginx_proxy_automation_env_file_exits

# Result from function above
if [[ "$DOCKER_NGINX_PROXY_AUTOMATION_ENV_FILE_EXISTS" == true ]]; then
  [[ "$SILENT" != true ]] && echowarning \
    "There is an '.env' file already set to your project, if you continue \
        \nall settings will be replaced, there is no turn back on that, ok?."

  if [[ "$REPLY_YES" == true ]]; then
    LOCAL_BACKUP_OLD_ENV_FILE=true
    LOCAL_BACKUP_OLD_DOCKER_COMPOSE_FILE=true
  else
    run_function confirm_user_action "There is an .env file at your proxy folder, \
            \nall settings at will be replaced with new values, \
            \nare you sure you want to continue?"
    [[ "$USER_ACTION_RESPONSE" == true ]] && LOCAL_BACKUP_OLD_ENV_FILE=true && LOCAL_BACKUP_OLD_DOCKER_COMPOSE_FILE=true
  fi
fi

#-----------------------------------------------------------------------
# Arguments validation and variables fulfillment
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# NGINX-proxy service/container name
#
# Parameters: -pn | --proxy-name
#
# Final result:
#   - NGINX_PROXY_SERVICE_NAME
#
# Further action:
#   - LOCAL_STOP_AND_REMOVE_NGINX_PROXY_SERVICE_CONTAINER
#-----------------------------------------------------------------------
LOCAL_DEFAULT_NGINX_PROXY_SERVICE_NAME="proxy-web-auto"
if [[ $ARG_NGINX_PROXY_SERVICE_NAME == "" ]] && [[ ! "$REPLY_YES" == true ]]; then

  # Get user's response
  run_function common_read_user_input "Please enter the nginx-proxy service name (default: $LOCAL_DEFAULT_NGINX_PROXY_SERVICE_NAME):"

  LOCAL_NGINX_PROXY_SERVICE_NAME=${USER_INPUT_RESPONSE:-$LOCAL_DEFAULT_NGINX_PROXY_SERVICE_NAME}
else
  LOCAL_NGINX_PROXY_SERVICE_NAME=${ARG_NGINX_PROXY_SERVICE_NAME:-$LOCAL_DEFAULT_NGINX_PROXY_SERVICE_NAME}
fi

# Validate the name
run_function string_remove_all_special_char_string $LOCAL_NGINX_PROXY_SERVICE_NAME "-_"
NGINX_PROXY_SERVICE_NAME=${STRING_REMOVE_ALL_SPECIAL_CHAR_STRING_RESPONSE:-null}
[[ $NGINX_PROXY_SERVICE_NAME == null ]] && echoerror "The service name can not contain special chars, neither be empty"

# Check exists a container with this name
run_function docker_check_container_exists $NGINX_PROXY_SERVICE_NAME

if [[ "$DOCKER_CONTAINER_EXISTS" == true ]]; then
  # Check if there is a container running with this name
  run_function docker_check_container_is_running $NGINX_PROXY_SERVICE_NAME

  if [[ "$DOCKER_CONTAINER_IS_RUNNING" == true ]]; then
    [[ "$SILENT" != true ]] && echowarning \
      "The container '$NGINX_PROXY_SERVICE_NAME' is running in this server \
            \nmake sure you have unique names for each container. This script \
            \nmight stop and remove the container if you set '--yes' or reply \
            \n'yes' on the line below, but, there is no turn back on this action!"

    if [[ "$REPLY_YES" == true ]]; then
      LOCAL_STOP_AND_REMOVE_NGINX_PROXY_SERVICE_CONTAINER=true
    else
      run_function confirm_user_action \
        "The container '$NGINX_PROXY_SERVICE_NAME' is running in this server. We will \
                \nstop and REMOVE it, do you want to continue?"

      [[ "$USER_ACTION_RESPONSE" == true ]] && LOCAL_STOP_AND_REMOVE_NGINX_PROXY_SERVICE_CONTAINER=true
    fi
  else
    [[ "$SILENT" != true ]] && echowarning \
      "The container '$NGINX_PROXY_SERVICE_NAME' is exist in this server, but it is not running \
            \nmake sure you have unique names for each container. This script \
            \nmight stop and remove the container if you set '--yes' or reply \
            \n'yes' on the line below, but, there is no turn back on this action!"

    if [[ "$REPLY_YES" == true ]]; then
      LOCAL_STOP_AND_REMOVE_NGINX_PROXY_SERVICE_CONTAINER=true
    else
      run_function confirm_user_action \
        "The container '$NGINX_PROXY_SERVICE_NAME' exist in this server. We will \
                \nREMOVE it, do you want to continue?"

      [[ "$USER_ACTION_RESPONSE" == true ]] && LOCAL_STOP_AND_REMOVE_NGINX_PROXY_SERVICE_CONTAINER=true
    fi
    # We kept STOP and REMOVE because the stop function will not break the script even if the container isn't running
  fi
fi

#-----------------------------------------------------------------------
# Let's Encrypt service/container name
#
# Parameters: -ln | --letsencrypt-name
#
# Final result:
#   - LETSENCRYPT_SERVICE_NAME
#
# Further action:
#   - LOCAL_STOP_AND_REMOVE_LETSENCRYPT_SERVICE_CONTAINER
#-----------------------------------------------------------------------
LOCAL_DEFAULT_LETSENCRYPT_SERVICE_NAME="letsencrypt-auto"
if [[ $ARG_LETSENCRYPT_SERVICE_NAME == "" ]] && [[ ! "$REPLY_YES" == true ]]; then

  # Get user's response
  run_function common_read_user_input "Please enter the letsencrypt service name (default: $LOCAL_DEFAULT_LETSENCRYPT_SERVICE_NAME):"

  LOCAL_LETSENCRYPT_SERVICE_NAME=${USER_INPUT_RESPONSE:-$LOCAL_DEFAULT_LETSENCRYPT_SERVICE_NAME}
else
  LOCAL_LETSENCRYPT_SERVICE_NAME=${ARG_LETSENCRYPT_SERVICE_NAME:-$LOCAL_DEFAULT_LETSENCRYPT_SERVICE_NAME}
fi

# Validate the name
run_function string_remove_all_special_char_string $LOCAL_LETSENCRYPT_SERVICE_NAME "-_"
LETSENCRYPT_SERVICE_NAME=${STRING_REMOVE_ALL_SPECIAL_CHAR_STRING_RESPONSE:-null}
[[ $LETSENCRYPT_SERVICE_NAME == null ]] && echoerror "The service name can not contain special chars, neither be empty"

# Check exists a container with this name
run_function docker_check_container_exists $LETSENCRYPT_SERVICE_NAME

if [[ "$DOCKER_CONTAINER_EXISTS" == true ]]; then
  # Check if there is a container running with this name
  run_function docker_check_container_is_running $LETSENCRYPT_SERVICE_NAME

  if [[ "$DOCKER_CONTAINER_IS_RUNNING" == true ]]; then
    [[ "$SILENT" != true ]] && echowarning \
      "The container '$LETSENCRYPT_SERVICE_NAME' is running in this server \
            \nmake sure you have unique names for each container. This script \
            \nmight stop and remove the container if you set '--yes' or reply \
            \n'yes' on the line below, but, there is no turn back on this action!"

    if [[ "$REPLY_YES" == true ]]; then
      LOCAL_STOP_AND_REMOVE_LETSENCRYPT_SERVICE_CONTAINER=true
    else
      run_function confirm_user_action \
        "The container '$LETSENCRYPT_SERVICE_NAME' is running in this server. We will \
                \nstop and REMOVE it, do you want to continue?"

      [[ "$USER_ACTION_RESPONSE" == true ]] && LOCAL_STOP_AND_REMOVE_LETSENCRYPT_SERVICE_CONTAINER=true
    fi
  else
    [[ "$SILENT" != true ]] && echowarning \
      "The container '$LETSENCRYPT_SERVICE_NAME' is exist in this server, but it is not running \
            \nmake sure you have unique names for each container. This script \
            \nmight stop and remove the container if you set '--yes' or reply \
            \n'yes' on the line below, but, there is no turn back on this action!"

    if [[ "$REPLY_YES" == true ]]; then
      LOCAL_STOP_AND_REMOVE_LETSENCRYPT_SERVICE_CONTAINER=true
    else
      run_function confirm_user_action \
        "The container '$LETSENCRYPT_SERVICE_NAME' exist in this server. We will \
                \nREMOVE it, do you want to continue?"

      [[ "$USER_ACTION_RESPONSE" == true ]] && LOCAL_STOP_AND_REMOVE_LETSENCRYPT_SERVICE_CONTAINER=true
    fi
    # We kept STOP and REMOVE because the stop function will not break the script even if the container isn't running
  fi
fi

#-----------------------------------------------------------------------
# Docker-gen service/container name
#
# Parameters: -gn | --docker-gen-name
#
# Final result:
#   - DOCKER_GEN_SERVICE_NAME
#
# Further action:
#   - LOCAL_STOP_AND_REMOVE_DOCKER_GEN_SERVICE_CONTAINER
#-----------------------------------------------------------------------
LOCAL_DEFAULT_DOCKER_GEN_SERVICE_NAME="docker-gen-auto"
if [[ $ARG_DOCKER_GEN_SERVICE_NAME == "" ]] && [[ ! "$REPLY_YES" == true ]]; then

  # Get user's response
  run_function common_read_user_input "Please enter the docker-gen service name (default: $LOCAL_DEFAULT_DOCKER_GEN_SERVICE_NAME):"

  LOCAL_DOCKER_GEN_SERVICE_NAME=${USER_INPUT_RESPONSE:-$LOCAL_DEFAULT_DOCKER_GEN_SERVICE_NAME}
else
  LOCAL_DOCKER_GEN_SERVICE_NAME=${ARG_DOCKER_GEN_SERVICE_NAME:-$LOCAL_DEFAULT_DOCKER_GEN_SERVICE_NAME}
fi

# Validate the name
run_function string_remove_all_special_char_string $LOCAL_DOCKER_GEN_SERVICE_NAME "-_"
DOCKER_GEN_SERVICE_NAME=${STRING_REMOVE_ALL_SPECIAL_CHAR_STRING_RESPONSE:-null}
[[ $DOCKER_GEN_SERVICE_NAME == null ]] && echoerror "The service name can not contain special chars, neither be empty"

# Check exists a container with this name
run_function docker_check_container_exists $DOCKER_GEN_SERVICE_NAME

if [[ "$DOCKER_CONTAINER_EXISTS" == true ]]; then
  # Check if there is a container running with this name
  run_function docker_check_container_is_running $DOCKER_GEN_SERVICE_NAME

  if [[ "$DOCKER_CONTAINER_IS_RUNNING" == true ]]; then
    [[ "$SILENT" != true ]] && echowarning \
      "The container '$DOCKER_GEN_SERVICE_NAME' is running in this server \
            \nmake sure you have unique names for each container. This script \
            \nmight stop and remove the container if you set '--yes' or reply \
            \n'yes' on the line below, but, there is no turn back on this action!"

    if [[ "$REPLY_YES" == true ]]; then
      LOCAL_STOP_AND_REMOVE_DOCKER_GEN_SERVICE_CONTAINER=true
    else
      run_function confirm_user_action \
        "The container '$DOCKER_GEN_SERVICE_NAME' is running in this server. We will \
                \nstop and REMOVE it, do you want to continue?"

      [[ "$USER_ACTION_RESPONSE" == true ]] && LOCAL_STOP_AND_REMOVE_DOCKER_GEN_SERVICE_CONTAINER=true
    fi
  else
    [[ "$SILENT" != true ]] && echowarning \
      "The container '$DOCKER_GEN_SERVICE_NAME' is exist in this server, but it is not running \
            \nmake sure you have unique names for each container. This script \
            \nmight stop and remove the container if you set '--yes' or reply \
            \n'yes' on the line below, but, there is no turn back on this action!"

    if [[ "$REPLY_YES" == true ]]; then
      LOCAL_STOP_AND_REMOVE_DOCKER_GEN_SERVICE_CONTAINER=true
    else
      run_function confirm_user_action \
        "The container '$DOCKER_GEN_SERVICE_NAME' exist in this server. We will \
                \nREMOVE it, do you want to continue?"

      [[ "$USER_ACTION_RESPONSE" == true ]] && LOCAL_STOP_AND_REMOVE_DOCKER_GEN_SERVICE_CONTAINER=true
    fi
    # We kept STOP and REMOVE because the stop function will not break the script even if the container isn't running
  fi
fi

#-----------------------------------------------------------------------
# nginx-proxy image version
#
# Parameters: -piv | --proxy-image-version
#
# Final result:
#   - NGINX_PROXY_IMAGE_VERSION
#-----------------------------------------------------------------------
LOCAL_DEFAULT_NGINX_PROXY_IMAGE_NAME=${DEFAULT_NGINX_PROXY_IMAGE_NAME:-nginx}
LOCAL_DEFAULT_NGINX_PROXY_IMAGE_VERSION=${DEFAULT_NGINX_PROXY_IMAGE_VERSION:-latest}
# We have commented the lines below once the proxy will use a regular nginx container and it's not optional today
#if [[ $ARG_NGINX_PROXY_IMAGE_VERSION == "" ]] && [[ ! "$REPLY_YES" == true ]]; then
#    # Get user's response
#    run_function dockerhub_list_tags $LOCAL_DEFAULT_NGINX_PROXY_IMAGE_NAME
#    run_function select_one_option "${DOCKERHUB_LIST_TAGS[*]}" "Please select a tag for the image '$LOCAL_DEFAULT_NGINX_PROXY_IMAGE_NAME' (the list below comes from https://hub.docker.com):"
#
#    [[ $SELECT_ONE_OPTION_NAME == "" ]] && echowarning "Once you did not select any option, '$LOCAL_DEFAULT_NGINX_PROXY_IMAGE_VERSION' will be used."
#    NGINX_PROXY_IMAGE_VERSION=${SELECT_ONE_OPTION_NAME:-$LOCAL_DEFAULT_NGINX_PROXY_IMAGE_VERSION}
#else
NGINX_PROXY_IMAGE_VERSION=${ARG_NGINX_PROXY_IMAGE_VERSION:-$LOCAL_DEFAULT_NGINX_PROXY_IMAGE_VERSION}
#fi
#
#if [[ "$NGINX_PROXY_IMAGE_VERSION" == null ]] || [[ "$LOCAL_DEFAULT_NGINX_PROXY_IMAGE_NAME" == null ]]; then
#    echoerror "It seems there is no default image or version, please check the .env file at '$SCRIPT_PATH'"
#fi

# Final check image a version with dockerhub
[[ "$SKIP_DOCKER_IMAGE_CHECK" != true ]] && [[ ! "$REPLY_YES" == true ]] && local_check_docker_hub_image_version $LOCAL_DEFAULT_NGINX_PROXY_IMAGE_NAME $NGINX_PROXY_IMAGE_VERSION

#-----------------------------------------------------------------------
# Let's Encrypt image version
#
# Parameters: -liv | --letsencrypt-image-version
#
# Final result:
#   - LETSENCRYPT_IMAGE_VERSION
#-----------------------------------------------------------------------
LOCAL_DEFAULT_LETSENCRYPT_IMAGE_NAME=${DEFAULT_LETSENCRYPT_IMAGE_NAME:-null}
LOCAL_DEFAULT_LETSENCRYPT_IMAGE_VERSION=${DEFAULT_LETSENCRYPT_IMAGE_VERSION:-null}
if [[ $ARG_LETSENCRYPT_IMAGE_VERSION == "" ]] && [[ ! "$REPLY_YES" == true ]]; then
  # Get user's response
  run_function dockerhub_list_tags $LOCAL_DEFAULT_LETSENCRYPT_IMAGE_NAME
  run_function select_one_option "${DOCKERHUB_LIST_TAGS[*]}" "Please select a tag for the image '$LOCAL_DEFAULT_LETSENCRYPT_IMAGE_NAME' (the list below comes from https://hub.docker.com):"

  [[ $SELECT_ONE_OPTION_NAME == "" ]] && echowarning "Once you did not select any option, '$LOCAL_DEFAULT_LETSENCRYPT_IMAGE_VERSION' will be used."
  LETSENCRYPT_IMAGE_VERSION=${SELECT_ONE_OPTION_NAME:-$LOCAL_DEFAULT_LETSENCRYPT_IMAGE_VERSION}
else
  LETSENCRYPT_IMAGE_VERSION=${ARG_LETSENCRYPT_IMAGE_VERSION:-$LOCAL_DEFAULT_LETSENCRYPT_IMAGE_VERSION}
fi

if [[ "$LETSENCRYPT_IMAGE_VERSION" == null ]] || [[ "$LOCAL_DEFAULT_LETSENCRYPT_IMAGE_VERSION" == null ]]; then
  echoerror "It seems there is no default image or version, please check the .env file at '$SCRIPT_PATH'"
fi

# Final check image a version with dockerhub
[[ "$SKIP_DOCKER_IMAGE_CHECK" != true ]] && [[ ! "$REPLY_YES" == true ]] && local_check_docker_hub_image_version $LOCAL_DEFAULT_LETSENCRYPT_IMAGE_NAME $LETSENCRYPT_IMAGE_VERSION

#-----------------------------------------------------------------------
# docker-gen image version
#
# Parameters: -giv | --docker-gen-image-versio
#
# Final result:
#   - DOCKER_GEN_IMAGE_VERSION
#-----------------------------------------------------------------------
LOCAL_DEFAULT_DOCKER_GEN_IMAGE_NAME=${DEFAULT_DOCKER_GEN_IMAGE_NAME:-null}
LOCAL_DEFAULT_DOCKER_GEN_IMAGE_VERSION=${DEFAULT_DOCKER_GEN_IMAGE_VERSION:-null}
if [[ $ARG_DOCKER_GEN_IMAGE_VERSION == "" ]] && [[ ! "$REPLY_YES" == true ]]; then
  # Get user's response
  run_function dockerhub_list_tags $LOCAL_DEFAULT_DOCKER_GEN_IMAGE_NAME false
  run_function select_one_option "${DOCKERHUB_LIST_TAGS[*]}" "Please select a tag for the image '$LOCAL_DEFAULT_DOCKER_GEN_IMAGE_NAME' (the list below comes from https://hub.docker.com):"

  [[ $SELECT_ONE_OPTION_NAME == "" ]] && echowarning "Once you did not select any option, '$LOCAL_DEFAULT_DOCKER_GEN_IMAGE_VERSION' will be used."
  DOCKER_GEN_IMAGE_VERSION=${SELECT_ONE_OPTION_NAME:-$LOCAL_DEFAULT_DOCKER_GEN_IMAGE_VERSION}
else
  DOCKER_GEN_IMAGE_VERSION=${ARG_DOCKER_GEN_IMAGE_VERSION:-$LOCAL_DEFAULT_DOCKER_GEN_IMAGE_VERSION}
fi

if [[ "$DOCKER_GEN_IMAGE_VERSION" == null ]] || [[ "$LOCAL_DEFAULT_DOCKER_GEN_IMAGE_VERSION" == null ]]; then
  echoerror "It seems there is no default image or version, please check the .env file at '$SCRIPT_PATH'"
fi

# Final check image a version with dockerhub
[[ "$SKIP_DOCKER_IMAGE_CHECK" != true ]] && [[ ! "$REPLY_YES" == true ]] && local_check_docker_hub_image_version $LOCAL_DEFAULT_DOCKER_GEN_IMAGE_NAME $DOCKER_GEN_IMAGE_VERSION

#-----------------------------------------------------------------------
# IP address (IPv4)
#
# Parameters: -ip   | --ip-address
#
# Final result:
#   - IP_ADDRESS
#-----------------------------------------------------------------------
if [[ $ARG_IP_ADDRESS == "" ]] && [[ ! "$REPLY_YES" == true ]]; then

  run_function ip_get_external_ipv4

  # Get user's response
  run_function common_read_user_input \
    "Please enter the IP address (ipv4) that your server uses to connect to the internet. \
    \nYou might try the following '$IP_EXTERNAL_IPV4' (default: 0.0.0.0):"

  LOCAL_IP_ADDRESS=${USER_INPUT_RESPONSE:-"0.0.0.0"}
else
  LOCAL_IP_ADDRESS=${ARG_IP_ADDRESS:-"0.0.0.0"}
fi

# Check the IP address
run_function ip_check_ipv4 $LOCAL_IP_ADDRESS

if [[ ! "$IP_IPV4" == true ]]; then
  echoerror "The IP address '$LOCAL_IP_ADDRESS' seems to be in wrong format. Please try again or keep the default value."
  local_undo_restore
else
  IP_ADDRESS=${LOCAL_IP_ADDRESS:-"0.0.0.0"}
fi

#-----------------------------------------------------------------------
# IP address (IPv6)
#
# Parameters: -ipv6 | --ipv6-address
#
# Final result:
#   - IPv6_ADDRESS
#-----------------------------------------------------------------------
if [[ "$ACTIVATE_IPV6" == true ]]; then

  # Check the ipv6
  if [[ $ARG_IPv6_ADDRESS == "" ]] && [[ ! "$REPLY_YES" == true ]]; then

    run_function ip_get_external_ipv6

    # Get user's response
    run_function common_read_user_input \
      "Please enter the IP address (ipv6) that your server uses to connect to the internet. \
      \nYou might try the following '$IP_EXTERNAL_IPV6' (default: ::0):"

    LOCAL_IPv6_ADDRESS=${USER_INPUT_RESPONSE:-"::0"}
  else
    LOCAL_IPv6_ADDRESS=${ARG_IPv6_ADDRESS:-"::0"}
  fi

  # Check the IP address
  run_function ip_check_ipv6 $LOCAL_IPv6_ADDRESS

  if [[ ! "$IP_IPV6" == true ]]; then
    echoerror "The IP address '$LOCAL_IPv6_ADDRESS' seems to be in wrong format. Please try again or keep the default value."
    local_undo_restore
  else
    IPv6_ADDRESS=${LOCAL_IPv6_ADDRESS:-"::0"}
  fi
fi

#-----------------------------------------------------------------------
# Docker network for the nginx-proxy
#
# Parameters: -net | --network-name
#
# Final result:
#   - DOCKER_NETWORK_NAME
#-----------------------------------------------------------------------
LOCAL_DEFAULT_DOCKER_NETWORK_NAME=${DEFAULT_DOCKER_NETWORK_NAME:-"proxy"}
if [[ $ARG_NETWORK_NAME == "" ]] && [[ ! "$REPLY_YES" == true ]]; then

  # Get user's response
  run_function common_read_user_input "Please enter the network name for your nginx-proxy (default: $LOCAL_DEFAULT_DOCKER_NETWORK_NAME):"

  LOCAL_DOCKER_NETWORK_NAME=${USER_INPUT_RESPONSE:-$LOCAL_DEFAULT_DOCKER_NETWORK_NAME}
else
  LOCAL_DOCKER_NETWORK_NAME=${ARG_NETWORK_NAME:-$LOCAL_DEFAULT_DOCKER_NETWORK_NAME}
fi

# Validate the name
run_function string_remove_all_special_char_string $LOCAL_DOCKER_NETWORK_NAME "-_"
DOCKER_NETWORK_NAME=${STRING_REMOVE_ALL_SPECIAL_CHAR_STRING_RESPONSE:-null}
[[ $DOCKER_NETWORK_NAME == null ]] && echoerror "The network name can not contain special chars, neither be empty"

#-----------------------------------------------------------------------
# Data location for nginx-proxy files
#
# Parameters: -d | --data-files-location
#
# Final result:
#   - DATA_LOCATION
#-----------------------------------------------------------------------
LOCAL_DEFAULT_DATA_LOCATION=${DEFAULT_DATA_LOCATION:-"$SCRIPT_PATH/../data"}
if [[ $ARG_DATA_LOCATION == "" ]] && [[ ! "$REPLY_YES" == true ]]; then

  # Get user's response
  run_function common_read_user_input "Please enter the path location where you wish to place your nginx-proxy files (default: $LOCAL_DEFAULT_DATA_LOCATION):"

  DATA_LOCATION=${USER_INPUT_RESPONSE:-$LOCAL_DEFAULT_DATA_LOCATION}
else
  DATA_LOCATION=${ARG_DATA_LOCATION:-$LOCAL_DEFAULT_DATA_LOCATION}
fi

# Create folder if it does not exist
run_function common_create_folder $DATA_LOCATION

#-----------------------------------------------------------------------
# Default email address for the Lets Encrypt certificates
#
# Parameters: -e | --default-email
#
# Final result:
#   - DEFAULT_EMAIL
#-----------------------------------------------------------------------
if [[ $ARG_DEFAULT_EMAIL == "" ]]; then

  # Get user's response
  run_function common_read_user_input "You must inform a valid email address in order to continue. Please check the docs:"

  DEFAULT_EMAIL=${USER_INPUT_RESPONSE}
else
  DEFAULT_EMAIL=${ARG_DEFAULT_EMAIL}
fi

# Check if email is valid
run_function email_check_is_valid $DEFAULT_EMAIL

[[ ! "$EMAIL_IS_VALID" == true ]] && echoerror "You must inform a valid email address in order to continue. Please try again."

#-----------------------------------------------------------------------
# Log settings for nginx-proxy
#
# We would like to comment that this is a very specific configuration
# that, once we will not offer the available options we decided to
# simplify these options once was not a common issue setting up
#-----------------------------------------------------------------------
NGINX_PROXY_LOG_DRIVER=${ARG_NGINX_PROXY_LOG_DRIVER:-"json-file"}
NGINX_PROXY_LOG_MAX_SIZE=${ARG_NGINX_PROXY_LOG_MAX_SIZE:-"4m"}
NGINX_PROXY_LOG_MAX_FILE=${ARG_NGINX_PROXY_LOG_MAX_FILE:-"10"}

DOCKER_GEN_LOG_DRIVER=${ARG_DOCKER_GEN_LOG_DRIVER:-"json-file"}
DOCKER_GEN_LOG_MAX_SIZE=${ARG_DOCKER_GEN_LOG_MAX_SIZE:-"2m"}
DOCKER_GEN_LOG_MAX_FILE=${ARG_DOCKER_GEN_LOG_MAX_FILE:-"10"}

LETSENCRYPT_LOG_DRIVER=${ARG_LETSENCRYPT_LOG_DRIVER:-"json-file"}
LETSENCRYPT_LOG_MAX_SIZE=${ARG_LETSENCRYPT_LOG_MAX_SIZE:-"2m"}
LETSENCRYPT_LOG_MAX_FILE=${ARG_LETSENCRYPT_LOG_MAX_FILE:-"10"}

#-----------------------------------------------------------------------
# Port binding
#
# We would like to comment out that the settings below seems to be
# rearly changes by the users, so we kept that pretty simple in
# this script, if that is all right with you! Thank you!
#-----------------------------------------------------------------------
DOCKER_HTTP=${ARG_DOCKER_HTTP:-"80"}
DOCKER_HTTPS=${ARG_DOCKER_HTTPS:-"443"}

#-----------------------------------------------------------------------
# SSL policy (set to Mozilla-Intermediate)
#
# Please read the options at the url below:
# https://github.com/nginx-proxy/nginx-proxy#how-ssl-support-works
#-----------------------------------------------------------------------
SSL_POLICY=${ARG_SSL_POLICY:-"Mozilla-Intermediate"}

#-----------------------------------------------------------------------
# Start actions!
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Verify checksum of docker-compose.yml and .env.sample files
#-----------------------------------------------------------------------
run_function md5_check_checksum "$SCRIPT_PATH/../" "docker-compose.yml" $MD5_SUM_DOCKER_COMPOSE
if [[ ! "$MD5_CHECKSUM" == true ]] && [[ ! "$REPLY_YES" == true ]]; then

  run_function confirm_user_action \
    "We could not verify the checksum (md5) for the docker-compose.yml \
        \n are you sure you want to continue?"
fi

run_function md5_check_checksum "$SCRIPT_PATH/../" ".env.sample" $MD5_SUM_ENV_SAMPLE
if [[ ! "$MD5_CHECKSUM" == true ]] && [[ ! "$REPLY_YES" == true ]]; then

  run_function confirm_user_action \
    "We could not verify the checksum (md5) for the .env \
        \n are you sure you want to continue?"
fi

#-----------------------------------------------------------------------
# Stop services (docker-compose) if they are running
#-----------------------------------------------------------------------
if [[ "$LOCAL_STOP_CURRENT_NGINX_PROXY_SERVICES" == true ]]; then
  run_function docker_compose_stop "$SCRIPT_PATH/../"

  ACTION_DOCKER_COMPOSE_STOPPED=true

  [[ "$ERROR_DOCKER_COMPOSE_START" == true ]] && local_undo_restore

  # If there is no error when stopping container backup docker-compose file
  run_function backup_file "$SCRIPT_PATH/../docker-compose.yml"
  ACTION_DOCKER_COMPOSE_FILE_RENAMED=true
  LOCAL_BACKUP_DOCKER_COMPOSE_FILE=$BACKUP_FILE
fi

#-----------------------------------------------------------------------
# Add nginx config folder (conf.d)
#-----------------------------------------------------------------------
if [[ "$USE_NGINX_CONF_FILES" == true ]]; then
  # Create the conf folder if it does not exists
  run_function common_create_folder "$DATA_LOCATION/conf.d"

  # Copy the special configurations to the nginx conf folder
  cp -R $SCRIPT_PATH/../conf.d/* $DATA_LOCATION/conf.d/

  # Check if there was an error and try with sudo
  if [ $? -ne 0 ]; then
      echo "sudo cp -R $SCRIPT_PATH/../conf.d/* $DATA_LOCATION/conf.d/"
      exit 0
      sudo cp -R $SCRIPT_PATH/../conf.d/* $DATA_LOCATION/conf.d/
  fi

  # If there was any errors inform the user
  if [ $? -ne 0 ]; then
    echoerror "There was an error trying to copy the nginx conf files. \
      \nThe proxy will still work with default options, but \
      \nthe custom settings might not be loaded."
  fi
fi

#-----------------------------------------------------------------------
# Update the nginx.template with the latest version
#-----------------------------------------------------------------------
DEFAULT_NGINX_TEMPLATE_URL="https://raw.githubusercontent.com/nginx-proxy/nginx-proxy/master/nginx.tmpl"
if [[ "$UPDATE_NGINX_TEMPLATE" == true ]]; then
  cd "$SCRIPT_PATH/../"
  curl -L $DEFAULT_NGINX_TEMPLATE_URL -o nginx.tmpl
  cd - > /dev/null 2>&1
fi

#-----------------------------------------------------------------------
# Backup .env file if exists
#-----------------------------------------------------------------------
if [[ "$LOCAL_BACKUP_OLD_ENV_FILE" == true ]]; then
  run_function backup_file "$SCRIPT_PATH/../.env"
  ACTION_ENV_FILE_RENAMED=true
  LOCAL_BACKUP_ENV_FILE=$BACKUP_FILE
fi

#-----------------------------------------------------------------------
# Backup docker-compose.yml file if exists
#-----------------------------------------------------------------------
if [[ "$LOCAL_BACKUP_OLD_DOCKER_COMPOSE_FILE" == true ]]; then
  run_function backup_file "$SCRIPT_PATH/../docker-compose.yml"
  ACTION_DOCKER_COMPOSE_FILE_RENAMED=true
  LOCAL_BACKUP_DOCKER_COMPOSE_FILE=$BACKUP_FILE
fi

#-----------------------------------------------------------------------
# Create and update .env file for nginx-proxy
#-----------------------------------------------------------------------
cp "$SCRIPT_PATH/../.env.sample" "$SCRIPT_PATH/../.env"

run_function local_update_env_new_site_variables "$SCRIPT_PATH/../"

#-----------------------------------------------------------------------
# Create docker network if it does not exist
#-----------------------------------------------------------------------
run_function docker_check_network_exists $DOCKER_NETWORK_NAME

if [[ ! "$DOCKER_NETWORK_EXISTS" == true ]]; then

  run_function docker_network_create $DOCKER_NETWORK_NAME $ACTIVATE_IPV6 $ARG_IPv6_SUBNET

  if [[ "$ERROR_DOCKER_NETWORK_CREATE" == true ]]; then
    echoerror "There was error when creating the docker network $DOCKER_NETWORK_NAME [IPv6 enabled: ${ACTIVATE_IPV6:-'false'} ]" false
    local_undo_restore
  else
    ACTION_DOCKER_NETWORK_CREATED=true
  fi
fi

#-----------------------------------------------------------------------
# Update docker-compose file
#-----------------------------------------------------------------------
run_function local_update_docker_compose_file "$SCRIPT_PATH/../"

#-----------------------------------------------------------------------
# Start proxy
#-----------------------------------------------------------------------
run_function docker_compose_start "$SCRIPT_PATH/../"

if [[ "$ERROR_DOCKER_COMPOSE_START" == true ]]; then
  echoerror "There was an error starting the service at '$SCRIPT_PATH/../'"
  local_undo_restore
fi

#-----------------------------------------------------------------------
# Show data for the user to take notes
#-----------------------------------------------------------------------
echosuccess "Your proxy was started successfully!"

# @todo - testing the proxy
#
# attention:
# 1. if yes don't ask for testing unless splicit
# 2. timeout optional yes|no as default?
# 3. url for testing - test dns first
# 4. option for ssl testing as well
#
# without ssl
# docker run -d -e VIRTUAL_HOST=$DOMAIN --network=$NETWORK --name test-web httpd:alpine
#
# with ss
# docker run -d -e VIRTUAL_HOST=$DOMAIN -e LETSENCRYPT_HOST=$DOMAIN --network=$NETWORK --name $NAME httpd:alpine
#
# stop testint - timeout?!
# docker stop test-web && docker rm test-web

exit 0

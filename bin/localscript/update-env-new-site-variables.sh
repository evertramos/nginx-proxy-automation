#-----------------------------------------------------------------------
#
# Server Automation - https://github.com/evertramos/server-automation
#
# Developed by
#   Evert Ramos <evert.ramos@gmail.com>
#
# Copyright Evert Ramos
#
#-----------------------------------------------------------------------
#
# Be careful when editing this file, it is part of a bigger script!
#
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# This function has one main objective:
# 1. Update all variables in .env file for fresh start script
#
# You must/might inform the parameters below:
# 1. Path where .env is located
# 2. [optional] (default: ) n/a
#
#-----------------------------------------------------------------------

local_update_env_new_site_variables()
{
    local LOCAL_FILE_PATH

    LOCAL_FILE_PATH=${1:-null}

    [[ $LOCAL_FILE_PATH == "" || $LOCAL_FILE_PATH == null ]] && echoerror "You must inform the required argument(s) to the function: '${FUNCNAME[0]}'"

    [[ "$DEBUG" == true ]] && echo "Updating all variables in .env file for nginx-proxy (file: ${LOCAL_FILE_PATH})"

    # Docker servides and image versions
    run_function env_update_variable $LOCAL_FILE_PATH "NGINX_WEB_SEVICE_NAME" "$NGINX_PROXY_SERVICE_NAME"
    run_function env_update_variable $LOCAL_FILE_PATH "NGINX_IMAGE_VERSION" "$NGINX_PROXY_IMAGE_VERSION"
    run_function env_update_variable $LOCAL_FILE_PATH "DOCKER_GEN_SEVICE_NAME" "$DOCKER_GEN_SERVICE_NAME"
    run_function env_update_variable $LOCAL_FILE_PATH "DOCKER_GEN_IMAGE_VERSION" "$DOCKER_GEN_IMAGE_VERSION"
    run_function env_update_variable $LOCAL_FILE_PATH "LETS_ENCRYPT_SEVICE_NAME" "$LETSENCRYPT_SERVICE_NAME"
    run_function env_update_variable $LOCAL_FILE_PATH "NGINX_PROXY_COMPANION_IMAGE_VERSION" "$LETSENCRYPT_IMAGE_VERSION"

    # IPs
    run_function env_update_variable $LOCAL_FILE_PATH "IPv4" "$IP_ADDRESS"
    [[ "$ACTIVATE_IPV6" == true ]] && run_function env_update_variable $LOCAL_FILE_PATH "IPv6" "$IPv6_ADDRESS"

    # Network
    run_function env_update_variable $LOCAL_FILE_PATH "NETWORK" "$DOCKER_NETWORK_NAME"

    # Data files path
    run_function env_update_variable $LOCAL_FILE_PATH "NGINX_FILES_PATH" "$DATA_LOCATION"

    # Log variables
    # proxy
    run_function env_update_variable $LOCAL_FILE_PATH "NGINX_WEB_LOG_DRIVER" "$NGINX_PROXY_LOG_DRIVER"
    run_function env_update_variable $LOCAL_FILE_PATH "NGINX_WEB_LOG_MAX_SIZE" "$NGINX_PROXY_LOG_MAX_SIZE"
    run_function env_update_variable $LOCAL_FILE_PATH "NGINX_WEB_LOG_MAX_FILE" "$NGINX_PROXY_LOG_MAX_FILE"
    # docker-gen
    run_function env_update_variable $LOCAL_FILE_PATH "NGINX_GEN_LOG_DRIVER" "$DOCKER_GEN_LOG_DRIVER"
    run_function env_update_variable $LOCAL_FILE_PATH "NGINX_GEN_LOG_MAX_SIZE" "$DOCKER_GEN_LOG_MAX_SIZE"
    run_function env_update_variable $LOCAL_FILE_PATH "NGINX_GEN_LOG_MAX_FILE" "$DOCKER_GEN_LOG_MAX_FILE"
    # Lets Encrypt
    run_function env_update_variable $LOCAL_FILE_PATH "NGINX_LETSENCRYPT_LOG_DRIVER" "$LETSENCRYPT_LOG_DRIVER"
    run_function env_update_variable $LOCAL_FILE_PATH "NGINX_LETSENCRYPT_LOG_MAX_SIZE" "$LETSENCRYPT_LOG_MAX_SIZE"
    run_function env_update_variable $LOCAL_FILE_PATH "NGINX_LETSENCRYPT_LOG_MAX_FILE" "$LETSENCRYPT_LOG_MAX_FILE"

    # Port bindings
    run_function env_update_variable $LOCAL_FILE_PATH "DOCKER_HTTP_" "$DOCKER_HTTP"
    run_function env_update_variable $LOCAL_FILE_PATH "DOCKER_HTTPS" "$DOCKER_HTTPS"

    # SSL Policy
    run_function env_update_variable $LOCAL_FILE_PATH "SSL_POLICY" "$SSL_POLICY"

    # Default email address
    run_function env_update_variable $LOCAL_FILE_PATH "DEFAULT_EMAIL" "$DEFAULT_EMAIL"

    # Default host
    run_function env_update_variable $LOCAL_FILE_PATH "DEFAULT_HOST" "${ARG_DEFAULT_HOST:-localhost}"

    return 0
}

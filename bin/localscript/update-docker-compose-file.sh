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

# ----------------------------------------------------------------------
# This function has one main objective:
# 1. Update all variables in docker-compose file
#
# You must/might inform the parameters below:
# 1. Path where docker-compose.yml file is located
# 2. [optional] (default: )
#
# ----------------------------------------------------------------------

local_update_docker_compose_file()
{
    local LOCAL_FULL_PATH 

    LOCAL_FULL_PATH=${1}

    [[ $LOCAL_FULL_PATH == "" || $LOCAL_FULL_PATH == null ]] && echoerr "You must inform the required argument(s) to the function: '${FUNCNAME[0]}'"

    [[ "$DEBUG" == true ]] && echo "Updating all variables in docker-compose.yml file for nginx-proxy (file: ${LOCAL_FULL_PATH})"

    # Services name
    run_function docker_compose_replace_string $LOCAL_FULL_PATH "$REPLACE_NGINX_PROXY_SERVICE_NAME" "$NGINX_PROXY_SERVICE_NAME"
    run_function docker_compose_replace_string $LOCAL_FULL_PATH "$REPLACE_DOCKER_GEN_SERVICE_NAME" "$DOCKER_GEN_SERVICE_NAME"
    run_function docker_compose_replace_string $LOCAL_FULL_PATH "$REPLACE_LETSENCRYPT_SERVICE_NAME" "$LETSENCRYPT_SERVICE_NAME"

    # Uncomment in case of IPv6 activation or uncomment
    [[ "$ACTIVATE_IPV6" == true ]] && run_function file_uncomment_line_with_string ${LOCAL_FULL_PATH%/}"/docker-compose.yml" "IPv6" && run_function file_uncomment_line_with_string ${LOCAL_FULL_PATH%/}"/docker-compose.yml" "IPV6"
    [[ ! "$ACTIVATE_IPV6" == true ]] && run_function file_comment_line_with_string ${LOCAL_FULL_PATH%/}"/docker-compose.yml" "IPv6" && run_function file_comment_line_with_string ${LOCAL_FULL_PATH%/}"/docker-compose.yml" "IPV6"
    # We are aware that it will set two '#' if the IPv6 is already commented

    return 0
}

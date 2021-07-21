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
# This script has one main objective:
# 1. Check if the .env file already exists for the
# docker-nginx-proxy-automation
#-----------------------------------------------------------------------

check_docker_nginx_proxy_automation_env_file_exits()
{
    [[ "$DEBUG" == true ]] && echo "Check if '.env' file exists for the nginx-proxy."

    if [[ -e ./../.env ]]; then
        DOCKER_NGINX_PROXY_AUTOMATION_ENV_FILE_EXISTS=true
    fi
}

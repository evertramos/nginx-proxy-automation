#-----------------------------------------------------------------------
#
# Basescript function
#
# The basescript functions were designed to work as abstract function,
# so it could be used in many different contexts executing specific job
# always remembering Unix concept DOTADIW - "Do One Thing And Do It Well"
#
# Developed by
#   Evert Ramos <evert.ramos@gmail.com>
#
# Copyright Evert Ramos
#
#-----------------------------------------------------------------------
#
# Be carefull when editing this file, it is part of a bigger script!
#
# Basescript - https://github.com/evertramos/basescript
#
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# This function has one main objective:
# 1. Script to check if docker is running
#
# You must/might inform the parameters below:
# 1. n/a
# 2. [optional] (default: ) n/a
#
#-----------------------------------------------------------------------

DOCKER_COMMAND="docker"

# Check if Docker is installed in the System
checkdocker() 
{
    if [[ "$DEBUG" == true ]]; then
        echo "Check if '$DOCKER_COMMAND' is installed and running."
    fi
    if [[ ! -x "$(command -v "$DOCKER_COMMAND")" ]]; then
        MESSAGE="'docker' is not installed!"
        return 1
    fi

    if [[ ! "$(systemctl is-active "$DOCKER_COMMAND")" == "active" ]]; then
        MESSAGE="'docker' is not running..."
        return 1
    fi
}

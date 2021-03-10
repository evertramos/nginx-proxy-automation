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
# 1. Check if the .env file exists in the current folder
#-----------------------------------------------------------------------

check_local_env_file()
{
    [[ "$DEBUG" == true ]] && echo "Check if local '.env' file is set."

    if [[ -e .env ]]; then
        source .env
    else 
        MESSAGE="'.env' file not found! \n Cheers!"
        return 1
    fi
}

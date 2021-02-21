#-----------------------------------------------------------------------
#
# Basescript functions
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
# Be carefull when editing this file, it is part of a bigger scripts!
#
# Basescript - https://github.com/evertramos/basescript
#
#-----------------------------------------------------------------------

# ----------------------------------------------------------------------
# This function has one main objective:
# 1. Check initial setup 
#
# You must inform the parameters below:
# 1. [optional] Pid file name (default: )
#
# ----------------------------------------------------------------------
starts_initial_check()
{
    local LOCAL_PID_FILE
    
    LOCAL_PID_FILE=${1:-$PID_FILE}

    # Check if docker is installed
    run_function checkdocker

    # Check if there is an .env file in base folder
    run_function checkbaseenvfile

    # Check if you are already running an instance of this Script
    run_function check_running_script $LOCAL_PID_FILE
}

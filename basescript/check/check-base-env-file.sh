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
# 1. Check if the .env file exists in the base folder
#
# You must/might inform the parameters below:
# 1. n/a
# 2. [optional] (default: ) n/a
#
#-----------------------------------------------------------------------

checkbaseenvfile() 
{
    if [[ "$DEBUG" == true ]]; then
        echo "Check if base folder '.env' file is set."
    fi

    cd $SCRIPT_PATH"/../"

    if [[ -e .env ]]; then
        source .env
        cd - > /dev/null 2>&1
    else 
        MESSAGE="'.env' file not found at the base folder. Please check! \n\n path: $(pwd)"
        return 1
    fi
}

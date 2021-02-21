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
# This script has one main objective:
# 1. Load all functions in local folder and subfolders
#
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# Fill out local variables 
#-----------------------------------------------------------------------
# Get Current directory
LOCAL_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

# Bootstrap file name
BOOTSTRAP_FILE_NAME="bootstrap.sh"

#-----------------------------------------------------------------------
# Debug message
#-----------------------------------------------------------------------
[[ "$DEBUG" == true ]] && "Reading base script files... [bootstrap.sh]"

#-----------------------------------------------------------------------
# Read files with extension '.sh'
#-----------------------------------------------------------------------
# Loop the base folder and source all files in root folder
for file in $LOCAL_PATH/*.sh
do
    [[ $file != $LOCAL_PATH/$BOOTSTRAP_FILE_NAME ]] && source $file
done

# Loop through all folders in the base folder and source all files inside
for dir in $LOCAL_PATH/*/
do
    local_dir=${dir%*/}

    for file in $local_dir/*.sh
    do
        [[ $file != $LOCAL_PATH/$BOOTSTRAP_FILE_NAME ]] && source $file
    done
done

return 0

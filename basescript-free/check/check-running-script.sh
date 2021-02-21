# This file is part of a bigger script!
#
# Be carefull when editing it

# ----------------------------------------------------------------------
#   
# Script devoloped to BM Digital
#
# Developed by
#   Evert Ramos <evert.ramos@gmail.com>     
#
# Copyright Evert Ramos with usage right granted to BM Digital
#
# ----------------------------------------------------------------------

# Script to check if there is another instance of the script running
check_running_script() 
{
    local LOCAL_PID_FILE
    
    LOCAL_PID_FILE=${1:-$PID_FILE}
    
    [[ "$DEBUG" == true ]] && echo "Check if there is another instance of the script running..."

    PID=$SCRIPT_PATH/$LOCAL_PID_FILE
    
    [[ "$DEBUG" = true ]] && echo "pid: "$PID

    if [[ -e "$PID" ]]; then
        MESSAGE="Script already running."
        return 1
    fi
}

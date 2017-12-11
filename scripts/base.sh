#!/bin/bash
#
# Basic scripts
#

# 1. Check if .env file exists
check_env_file() {
    if [ -e .env ]; then
        source .env
    else
        echo
        echo "Please set up your .env file before starting your enviornment."
        echo
        exit 1
    fi
}



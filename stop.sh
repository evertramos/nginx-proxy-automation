#!/bin/bash

#
# This file should be used to stop your WebProxy after set up your .env file
# Source: https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion
#
# Call it from the checkout directory of docker-compose-letsencrypt-nginx-proxy-companion

# 1. Check if .env file exists
if [ -e .env ]; then
    source .env
else 
    echo "Please set up your .env file before starting your environment."
    exit 1
fi

# 2. Stop containers
docker-compose down

# 3. Remove  docker network
docker network rm $NETWORK

exit 0

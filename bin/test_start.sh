#!/bin/bash

# Set up your DOMAIN
if [ $# -eq 0 ]; then
    echo "Please inform your domain name to test your proxy."
    echo "./test_start.sh $1"
    exit 1
else
    DOMAIN=$1
fi

# Read your .env file
source .env

# Testing your proxy
if [ -z ${SERVICE_NETWORK+X} ]; then
    docker run -d -e VIRTUAL_HOST=$DOMAIN --network=$NETWORK --name test-web httpd:alpine
else
    docker run -d -e VIRTUAL_HOST=$DOMAIN --network=$SERVICE_NETWORK --name test-web httpd:alpine
fi

exit 0

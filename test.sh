#!/bin/bash

# Set up your DOMAIN
if [ $# -eq 0 ]; then
    echo "Please inform your domain name to test your proxy."
    echo "./test.sh $1"
    exit 1
else
    DOMAIN=$1
fi

# Read your .env file
source .env

# Testing your proxy
docker run -d -e VIRTUAL_HOST=$DOMAIN --network=$NETWORK --name test-web httpd:alpine

exit 0

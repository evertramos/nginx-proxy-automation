#!/bin/bash

NAME=test-web


# Set up your DOMAIN
if [ $# -eq 0 ]; then
    echo "Please inform your domain name to test your proxy."
    echo "./test_start_ssl.sh $1"
    exit 1
else
    DOMAIN=$1
fi

# Read your .env file
source .env

# Testing your proxy
if [ -z ${SERVICE_NETWORK+X} ]; then
    docker run -d -e VIRTUAL_HOST=$DOMAIN -e LETSENCRYPT_HOST=$DOMAIN --network=$NETWORK --name $NAME httpd:alpine
else
    docker run -d -e VIRTUAL_HOST=$DOMAIN -e LETSENCRYPT_HOST=$DOMAIN --network=$SERVICE_NETWORK --name $NAME httpd:alpine
fi

exit 0

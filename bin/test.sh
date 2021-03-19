#!/bin/bash

#-----------------------------------------------------------------------
#
# test-proxy script - testing nginx-proxy
#
# https://github.com/evertramos/nginx-proxy-automation
#
# Script developed by
#   Evert Ramos <evert.ramos@gmail.com>
#
# Copyright Evert Ramos
#
#-----------------------------------------------------------------------

# Set up your DOMAIN
if [ $# -eq 0 ]; then
    echo "Please inform your domain name to test your proxy."
    echo "./test.sh $1"
    exit 1
else
    DOMAIN=$1
fi

# Read your .env file
source ./../.env

# Stop if test is running
docker stop test-web
docker rm test-web

# Testing your proxy
docker run -d -e VIRTUAL_HOST=$DOMAIN --network=$NETWORK --rm --name test-web httpd:alpine

exit 0

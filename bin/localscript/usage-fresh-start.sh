#-----------------------------------------------------------------------
#
# Server Automation - https://github.com/evertramos/server-automation
#
# Developed by
#   Evert Ramos <evert.ramos@gmail.com>
#
# Copyright Evert Ramos
#
#-----------------------------------------------------------------------
#
# Be careful when editing this file, it is part of a bigger script!
#
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# This script has one main objective:
# 1. Show the script usage (helper)
#-----------------------------------------------------------------------

#
# NGINX use special conf files
#
# In case you want to add some special configuration to your NGINX Web Proxy you could
# add your files to ./conf.d/ folder as of sample file 'uploadsize.conf'
#
# [WARNING] This setting was built to use our `start.sh`.
#
# [WARNING] Once you set this options to true all your files will be copied to data
#           folder (./data/conf.d). If you decide to remove this special configuration
#           you must delete your files from data folder ./data/conf.d.
#
#  USE_NGINX_CONF_FILES=true

#-----------------------------------------------------------------------
#
# Docker network options
#
# The docker network has many options when creating a new network, you can
# check the url below for more information about the docker network creation
# in our 'fresh_start.sh' script you can enable the network encryption option
#
# https://docs.docker.com/engine/reference/commandline/network_create/
#
# NETWORK_OPTIONS="--opt encrypted=true"

usage()
{
    cat << USAGE >&2
${purple}
=============================================================================
|  _____                         _____     _                 _   _          |
| |   __|___ ___ _ _ ___ ___ ___|  _  |_ _| |_ ___ _____ ___| |_|_|___ ___  |
| |__   | -_|  _| | | -_|  _|___|     | | |  _| . |     | .'|  _| | . |   | |
| |_____|___|_|  \_/|___|_|     |__|__|___|_| |___|_|_|_|__,|_| |_|___|_|_| |
|                                                                           |
=============================================================================
${reset}${blue}
Usage:
    $SCRIPT_NAME -e "john.doe@example.com"
                [-d "/server/proxy/data"]
                [-pn "proxy"] [-ln "letsencrypt"] [-gn "docker-gen"]
                [-net "proxy"]
                [--use-nginx-conf-files] [--update-nginx-template]
                [--yes]
                [--debug]
                [--docker-rootless]

    Required
    -e | --default-email          Default email address require to issue ssl
                                  certificates with Let's Encrypt service

    Basic options
    -d      | --data-files-location     Proxy files location
    -pn     | --proxy-name              Proxy service and container name
    -ln     | --letsencrypt-name        Let's Encrypt service & container name
    -gn     | --docker-gen-name         Docker-gen service and container name
    -net    | --network-name            Docker network name for proxy services
    -ip     | --ip-address              IP address for external connectivity

    Proxy config
    --use-nginx-conf-files              Add basic config folder to the Proxy
    --update-nginx-template             Download the latest nginx.tmpl

    Network
    -netopt | --network-option          Network options please check the docs
    --ipv4-subnet                       You may inform IPv4 subnet to create
                                        a docker network
                                        (default: 172.17.0.0/16)

    Docker image
    -piv    | --proxy-image-version       Proxy image version
    -liv    | --letsencrypt-image-version Let's Encrypt image version
    -giv    | --docker-gen-image-version  Docker-gen image version

    --skip-docker-image-check             Use this option to skip docker image
                                          verification which might takes a few
                                          seconds to check if images exists in
                                          docker hub api

    Docker log
    -lpd    | --log-nginx-proxy-driver    Proxy service log driver
    -lpms   | --log-nginx-proxy-max_size  Proxy service log max file size
    -lpmf   | --log-nginx-proxy-max_file  Proxy service log max files
    -lgd    | --log-docker-gen-driver     Docker-gen service log driver
    -lgms   | --log-docker-gen-max_size   Docker-gen service log max file size
    -lgmf   | --log-docker-gen-max_file   Docker-gen service log max files
    -lld    | --log-letsencrypt-driver    Let's Encrypt service log driver
    -llms   | --log-letsencrypt-max_size  Let's Encrypt service log max size
    -llmf   | --log-letsencrypt-max_file  Let's Encrypt service log max files

    Proxy port binding
    -phttp  | --port-http               Proxy http port (default: 80)
    -phttps | --port-https              Proxy https port (default: 443)

    Proxy SSL policy
    -sp     | --ssl-policy              Proxy SSL suport
                                        (default: Mozilla-Intermediate)

    Default Host
    -df     | --default-host            The default host where nginx-proxy will redirect all requests to
                                        the container that matches the VIRTUAL_HOST

    IPv6 support
    --activate-ipv6                     Use to activate IPv6 support
    -ipv6   | --ipv6-address            IPv6 address for external connectivity
    --ipv6-subnet                       You must inform IPv6 subnet to create
                                        a docker network
                                        (default: 2001:db8:1:1::/112)

    Other options
    --yes                               Set "yes" to all, use it with caution
    --debug                             Show script debug options
    --silent                            Hide all script message
    -dr | --docker-rootless             Add Docker rootless support by adding the
                                        the current user's $XDG_RUNTIME_DIR and
                                        concat with the '/docker.sock' in the
                                        DOCKER_HOST_ROOTLESS_PATH .env file.
    -h | --help                         Display this help

${reset}
USAGE
    exit 1
}

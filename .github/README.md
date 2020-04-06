# Web Proxy using Docker, NGINX and Let's Encrypt

With this repo you will be able to set up your server with multiple sites using a single NGINX proxy to manage your connections, automating your apps container (port 80 and 443) to auto renew your ssl certificates with Let´s Encrypt.

Something like:

![Web Proxy environment](https://github.com/evertramos/images/raw/master/webproxy.jpg)


## Why use it?

Using this set up you will be able start a production environment in a few seconds. For each new web project simply start the containers with the option `-e VIRTUAL_HOST=your.domain.com` and you will be ready to go. If you want to use SSL (Let's Encrypt) just add the tag `-e LETSENCRYPT_HOST=your.domain.com`. Done!

Easy and trustworthy!


## Prerequisites

In order to use this compose file (docker-compose.yml) you must have:

1. docker (https://docs.docker.com/engine/installation/)
2. docker-compose (https://docs.docker.com/compose/install/)


## How to use it

1. Clone this repository:

```bash
git clone https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion.git
```

2. Make a copy of our `.env.sample` and rename it to `.env`:

Update this file with your preferences.

```
#
# docker-compose-letsencrypt-nginx-proxy-companion
#
# A Web Proxy using docker with NGINX and Let's Encrypt
# Using the great community docker-gen, nginx-proxy and docker-letsencrypt-nginx-proxy-companion
#
# This is the .env file to set up your webproxy enviornment

#
# Your local containers NAME
#
NGINX_WEB=nginx-web
DOCKER_GEN=nginx-gen
LETS_ENCRYPT=nginx-letsencrypt

#
# Set the IP address of the external access Interface
#
IP=0.0.0.0

#
# Default Network
#
NETWORK=webproxy

# If you want to customize the created network, use the following variable
#NETWORK_OPTIONS="--opt encrypted=true"

#
# Service Network (Optional)
#
# In case you decide to add a new network to your services containers you can set this
# network as a SERVICE_NETWORK
#
# [WARNING] This setting was built to use our `start.sh` script or in that special case
#           you could use the docker-composer with our multiple network option, as of:
#           `docker-compose -f docker-compose-multiple-networks.yml up -d`
#
#SERVICE_NETWORK=webservices

# If you want to customize the created network, use the following variable
#SERVICE_NETWORK_OPTIONS="--opt encrypted=true"

#
## NGINX file path (mount into the host)
# Here you can configure the path where nginx stores all the configurations and certificates.
# With the value ./nginx-data it creates a new sub-folder into your current path.

NGINX_FILES_PATH=./nginx-data

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
#USE_NGINX_CONF_FILES=true

#
# Docker Logging Config
#
# This section offers two options max-size and max-file, which follow the docker documentation
# as follow:
#
# logging:
#      driver: "json-file"
#      options:
#        max-size: "200k"
#        max-file: "10"
#
#NGINX_WEB_LOG_DRIVER=json-file
#NGINX_WEB_LOG_MAX_SIZE=4m
#NGINX_WEB_LOG_MAX_FILE=10

#NGINX_GEN_LOG_DRIVER=json-file
#NGINX_GEN_LOG_MAX_SIZE=2m
#NGINX_GEN_LOG_MAX_FILE=10

#NGINX_LETSENCRYPT_LOG_DRIVER=json-file
#NGINX_LETSENCRYPT_LOG_MAX_SIZE=2m
#NGINX_LETSENCRYPT_LOG_MAX_FILE=10
```

3. Run our start script

```bash
./start.sh
```

Your proxy is ready to go!

## Starting your web containers

After following the steps above you can start new web containers with port 80 open and add the option `-e VIRTUAL_HOST=your.domain.com` so proxy will automatically generate the reverse script in NGINX Proxy to forward new connections to your web/app container, as of:

```bash
docker run -d -e VIRTUAL_HOST=your.domain.com \
              --network=webproxy \
              --name my_app \
              httpd:alpine
```

To have SSL in your web/app you just add the option `-e LETSENCRYPT_HOST=your.domain.com`, as follow:

```bash
docker run -d -e VIRTUAL_HOST=your.domain.com \
              -e LETSENCRYPT_HOST=your.domain.com \
              -e LETSENCRYPT_EMAIL=your.email@your.domain.com \
              --network=webproxy \
              --name my_app \
              httpd:alpine
```

> You don´t need to open port *443* in your container, the certificate validation is managed by the web proxy.


> Please note that when running a new container to generate certificates with LetsEncrypt (`-e LETSENCRYPT_HOST=your.domain.com`), it may take a few minutes, depending on multiples circumstances.

## Further Options

1. Basic Authentication Support

In order to be able to secure your virtual host with basic authentication, you must create a htpasswd file within `${NGINX_FILES_PATH}/htpasswd/${VIRTUAL_HOST}` via:

```bash
sudo sh -c "echo -n '[username]:' >> ${NGINX_FILES_PATH}/htpasswd/${VIRTUAL_HOST}"
sudo sh -c "openssl passwd -apr1 >> ${NGINX_FILES_PATH}/htpasswd/${VIRTUAL_HOST}"
```

> Please substitute the `${NGINX_FILES_PATH}` with your path information, replace `[username]` with your username and `${VIRTUAL_HOST}` with your host's domain. You will be prompted for a password.

2. Using multiple networks

If you want to use more than one network to better organize your environment you could set the option `SERVICE_NETWORK` in our `.env.sample` or you can just create your own network and attach all your containers as of:

```bash
docker network create myownnetwork
docker network connect myownnetwork nginx-web
docker network connect myownnetwork nginx-gen
docker network connect myownnetwork nginx-letsencrypt
```

3. Using different ports to be proxied

If your service container runs on port 8545 you probably will need to add the `VIRTUAL_PORT` environment variable to your container, in the `docker-compose.yml`, as of:

```bash
parity
    image: parity/parity:v1.8.9
    [...]
    environment:
      [...]
      VIRTUAL_PORT: 8545
```

Or as of below:

```bash
docker run [...] -e VIRTUAL_PORT=8545 [...]
```

4. Restarting proxy container

In some cases you will need to restart the proxy in order to read, as an example, the Basic Auth, if you set it after your service container is already up and running. So, the way I use to restart the proxy (NGINX) is as following, which has no downtime:

```bash
docker exec -it ${NGINX_WEB} nginx -s reload
```

Where *${NGINX_WEB}* is your proxy container name, which in the original `.env` file is set as *nginx-web*.


## Testing your proxy with scripts preconfigured 

1. Run the script `test.sh` informing your domain already configured in your DNS to point out to your server as follow:

```bash
./test_start_ssl.sh your.domain.com
```

or simply run:

```bash
docker run -dit -e VIRTUAL_HOST=your.domain.com --network=webproxy --name test-web httpd:alpine
```

Access your browser with your domain!

To stop and remove your test container run our `stop_test.sh` script:

```bash
./test_stop.sh
```

Or simply run:

```bash
docker stop test-web && docker rm test-web
```

## Running this Proxy on a Synology NAS

Please checkout this [howto](https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion/blob/master/docs/HOWTO-Synlogy.md).

## Production Environment using Web Proxy

Following are links to docker containers using this web proxy:

1. [docker-wordpress-letsencrypt](https://github.com/evertramos/docker-wordpress-letsencrypt)
2. [docker-portainer-letsencrypt](https://github.com/evertramos/docker-portainer-letsencrypt)
3. [docker-nextcloud-letsencrypt](https://github.com/evertramos/docker-nextcloud-letsencrypt)
4. [docker-registry-letsencrypt](https://github.com/evertramos/docker-registry-letsencrypt)
5. [gitlab-docker-letsencrypt](https://github.com/steevepay/gitlab-docker-letsencrypt)
6. [docker-webtrees-letsencrypt](https://github.com/mstroppel/docker-webtrees-letsencrypt)

## Credits

Without the repositories below this webproxy wouldn´t be possible.

Credits goes to:
- nginx-proxy [@jwilder](https://github.com/jwilder/nginx-proxy)
- docker-gen [@jwilder](https://github.com/jwilder/docker-gen)
- docker-letsencrypt-nginx-proxy-companion [@JrCs](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)

### Special thanks to:

- [@j7an](https://github.com/j7an) - Many contributions and the ipv6 branch!
- [@buchdag](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion/pull/226#event-1145800062)
- [@fracz](https://github.com/fracz) - Many contributions!


## Support on Beerpay
Hey dude! Help me out for a couple of :beers:!

[![Beerpay](https://beerpay.io/evertramos/docker-compose-letsencrypt-nginx-proxy-companion/badge.svg?style=beer-square)](https://beerpay.io/evertramos/docker-compose-letsencrypt-nginx-proxy-companion)  [![Beerpay](https://beerpay.io/evertramos/docker-compose-letsencrypt-nginx-proxy-companion/make-wish.svg?style=flat-square)](https://beerpay.io/evertramos/docker-compose-letsencrypt-nginx-proxy-companion?focus=wish)

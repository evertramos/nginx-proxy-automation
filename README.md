# Usage of Docker Compose (docker-compose) with NGINX Proxy and Letsencrypt

Docker Compose (docker-compose) for [docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)


## Purpose

This docker-compose file, version '3', was built to help using NGINX as web proxy to your containers, integrated with LetsEncrypt certification, using the great work of [@jwilder](https://github.com/jwilder) with [docker-gen](https://github.com/jwilder/docker-gen) and [nginx-proxy](https://github.com/jwilder/nginx-proxy) along with the ultimate tool [docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) designed by [JrCs](https://github.com/JrCs) to integrate the great SSL Certificates from the best [LetsEncrypt](https://letsencrypt.org/).


## Usage

In order to use, you must follow these steps:

1. Clone this repository:

```bash
git clone https://github.com/evertramos/webproxy.git
```

Or just copy the content of `docker-compose.yml`, as of below and substitute with your own configuration settings:

```bash
version: '3'
services:
  nginx:
    image: nginx
    labels:
        com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy: "true"
    container_name: ${NGINX_WEB}
    restart: unless-stopped
    ports:
      - "${IP}:80:80"
      - "${IP}:443:443"
    volumes:
      - ${NGINX_FILES_PATH}/conf.d:/etc/nginx/conf.d
      - ${NGINX_FILES_PATH}/vhost.d:/etc/nginx/vhost.d
      - ${NGINX_FILES_PATH}/html:/usr/share/nginx/html
      - ${NGINX_FILES_PATH}/certs:/etc/nginx/certs:ro

  nginx-gen:
    image: jwilder/docker-gen
    command: -notify-sighup nginx -watch -wait 5s:30s /etc/docker-gen/templates/nginx.tmpl /etc/nginx/conf.d/default.conf
    container_name: ${DOCKER_GEN}
    restart: unless-stopped
    volumes:
      - ${NGINX_FILES_PATH}/conf.d:/etc/nginx/conf.d
      - ${NGINX_FILES_PATH}/vhost.d:/etc/nginx/vhost.d
      - ${NGINX_FILES_PATH}/html:/usr/share/nginx/html
      - ${NGINX_FILES_PATH}/certs:/etc/nginx/certs:ro
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - ./nginx.tmpl:/etc/docker-gen/templates/nginx.tmpl:ro

  nginx-letsencrypt:
    image: jrcs/letsencrypt-nginx-proxy-companion
    container_name: ${LETS_ENCRYPT}
    restart: unless-stopped
    volumes:
      - ${NGINX_FILES_PATH}/conf.d:/etc/nginx/conf.d
      - ${NGINX_FILES_PATH}/vhost.d:/etc/nginx/vhost.d
      - ${NGINX_FILES_PATH}/html:/usr/share/nginx/html
      - ${NGINX_FILES_PATH}/certs:/etc/nginx/certs:rw
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      NGINX_DOCKER_GEN_CONTAINER: ${DOCKER_GEN}
      NGINX_PROXY_CONTAINER: ${NGINX_WEB}

networks:
  default:
    external:
      name: ${NETWORK}
```

2. Create an `.env` file as of our `.env.sample`, save it in the same folder as your compose file:

```
#
# WEBPROXY
#
# A Web Proxy using docker with NGINX with Let's Encrypt
# And our great community docker-gen, nginx-proxy and docker-letsencrypt-nginx-proxy-companion
#
# This is the .env file to set up your webproxy enviornment

# Define the names for your local containers
NGINX_WEB=nginx-web
DOCKER_GEN=nginx-gen
LETS_ENCRYPT=nginx-letsencrypt

# Your external IP address
IP=0.0.0.0

# Network name
NETWORK=webproxy

# NGINX file path
NGINX_FILES_PATH=/path/to/your/nginx/data
```

4. Run our start script

```bash
# ./run.sh
```

Your proxy is ready to go!


> Please note that when running a new container to generate certificates with LetsEncrypt it may take a few minutes, depending on multiples circunstances.



## Next Step


### If you want to test how it works please check this working sample (docker-compose.yml)

[wordpress-docker-letsencrypt](https://github.com/evertramos/wordpress-docker-letsencrypt)

Or you can run your own containers with the option `-e VIRTUAL_HOST=foo.bar.com` alongside with `LETSENCRYPT_HOST=foo.bar.com`, exposing port 80 and 443, and your certificate will be generated and always valid.


## Credits

All credits goes to:
- nginx-proxy [@jwilder](https://github.com/jwilder/nginx-proxy)
- docker-gen [@jwilder](https://github.com/jwilder/docker-gen)
- dockher-letsencrypt-nginx-proxy-companion [@JrCs](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)


### Special thanks to:

- [@buchdag](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion/pull/226#event-1145800062)
- [@fracz](https://github.com/fracz) - Update repo to use `.env` file

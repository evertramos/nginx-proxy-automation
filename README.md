# A Web Proxy using Docker, NGINX and Let's Encrypt

With this repo you will be able to set up your server with multiple sites using a single NGINX proxy to manage your connections.

Something like:

![Proxy Enviornment](https://cdn-images-1.medium.com/max/873/1*rnzxfcy2N_ffJPnBundJQw.jpeg)


## Why use it?

Using this set up you will be able start a productyion enviornment in a few seconds. And to start new web project simply start new containers the option `-e VIRTUAL_HOST=your.domain.com` and will be ready to go, if you want to use SSL (Let's Encrypt) just add the tag `-e LETSENCRYPT_HOST=your.domain.com`. Done!

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

5. Test your proxy

Run our `test.sh` informing your domain already configured in your DNS server as follow:

```bash
# ./test.sh your.domain.com
```

or simply run:

```bash
 docker run -dit -e VIRTUAL_HOST=your.domain.com --network=webproxy --name test-web httpd:alpine
```


Access your browser with your domain!


> Please note that when running a new container to generate certificates with LetsEncrypt (`-e LETSENCRYPT_HOST=your.domain.com`), it may take a few minutes, depending on multiples circunstances.

6. Stop and remove your test container

Run our `stop_test.sh` script:

```bash
# ./stop_test.sh
```

Or simply run:

```bash
docker stop test-web && docker rm test-web 
```

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

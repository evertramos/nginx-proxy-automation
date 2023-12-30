# NGINX Proxy Automation 🔥

## What this project does

This script will _power up_ your new server with the [*nginx-proxy*](https://github.com/nginx-proxy/nginx-proxy), where you will be able to host multiple sites, 
auto renewing Let´s Encrypt certificates! ❤️

We strongly recommend you (please do! 🙏) to read all documentation before starting in production as well as the [nginx-proxy docs](https://github.com/nginx-proxy/nginx-proxy).

> To access the previous version of this project please access [version 0.4](https://github.com/evertramos/nginx-proxy-automation/tree/v0.4).

### Upgrading from previous version

If you are upgrading from the previous version please follow the guide below carefully:

https://github.com/evertramos/nginx-proxy-automation/blob/master/docs/upgrade-guide.md

## Prerequisites

1.  🐧 Linux! (just in case...)

> Please check all requirements at [requirements](/docs/requirements.md).

In order to use this compose file (docker-compose.yml) you must have:

2. 🐋 Docker installed (https://docs.docker.com/engine/installation/)

3. Docker-compose installed (https://docs.docker.com/compose/install/)

> I have an [easy-server](https://github.com/evertramos/easy-server) for myself which I use to install 
> docker and docker-compose in new servers and some aliases and other stuff. Feel free to use it, **but**
> it is not related to this repo and maintainance it's for my own use only.  Check './install/docker' folder.

Also, you will need to make sure you have:

4. Port 80 and 443 available for binding - which means apache/nginx or other web services should not be 
   running in your server
   
5. Server must be accessible by a public IP address 

## How to use it

1. Clone this repository **using the option _--recurse-submodules_**:

```bash
git clone --recurse-submodules https://github.com/evertramos/nginx-proxy-automation.git proxy 
```

> Make sure you use the option '--recurse-submodules' once we use an external module in this project, please check 
> [basescript](https://github.com/evertramos/basescript)

> Please note we use 'proxy' as folder at the end. But you can change it to whatever fits you better  

2. 🚀 Run the script 'fresh_start.sh'
   
```bash
cd proxy/bin
./fresh-start.sh
```
This script will walk you through all config process.  

When it finishes you are good to go! :checkered_flag:

> ✈️ If you are in a 'hurry' just run `$ ./fresh-start.sh --yes -e your_email@domain --skip-docker-image-check`

> ⚠️ You can check all available options to run the script `$ ./fresh-start.sh --help`

> 🗒️ From version _v0.3_ the script will output logs to _/var/log/basescript.log_

3. Fire your new site with the following options:

```yaml
  VIRTUAL_HOST=your.domain.com
  LETSENCRYPT_HOST=your.domain.com
  LETSENCRYPT_EMAIL=your.email@your.domain.com
  NETWORK=proxy
```

The fresh start script asked you for the proxy network name if you changed set a name differente from 
the default please update the option *'NETWORK'* in the examples below before running it. 

- Simple site without Let's Encrypt certificate 
```bash
docker run -d -e VIRTUAL_HOST=your.domain.com \
            --network=proxy \
            --name my_app \
            httpd:alpine
```

- To have SSL in your web/app you must add the option `-e LETSENCRYPT_HOST=your.domain.com`, as follow:

```bash
docker run -d -e VIRTUAL_HOST=your.domain.com \
            -e LETSENCRYPT_HOST=your.domain.com \
            -e LETSENCRYPT_EMAIL=your.email@your.domain.com \
            --network=proxy \
            --name my_app \
            httpd:alpine
```

> You don´t need to open port *443* in your container, the certificate validation is managed by the web proxy

> Please note that when running a new container to generate certificates with Let's Encrypt 
> (`-e LETSENCRYPT_HOST=your.domain.com`), it may take a few minutes


## Further Options

1. Basic Authentication Support

In order to be able to secure your virtual host with basic authentication, you must create a htpasswd file 
within `${NGINX_FILES_PATH}/htpasswd/${VIRTUAL_HOST}` via:

```bash
sudo sh -c "echo -n '[username]:' >> ${NGINX_FILES_PATH}/htpasswd/${VIRTUAL_HOST}"
sudo sh -c "openssl passwd -apr1 >> ${NGINX_FILES_PATH}/htpasswd/${VIRTUAL_HOST}"
```

> Please replace the `${NGINX_FILES_PATH}` with real path to information, replace `[username]` with your username and `${VIRTUAL_HOST}` with your host's domain. You will be prompted for a password.

2. Using different networks

If you want to use more than one network to better organize your environment you could set the option `SERVICE_NETWORK` in our `.env.sample` or you can just create your own network and attach all your containers as of:

```bash
docker network create myownnetwork
docker network connect myownnetwork nginx-web
docker network connect myownnetwork nginx-gen
docker network connect myownnetwork nginx-letsencrypt
```

3. Ports

If your service container runs on port 8545 you probably will need to add the `VIRTUAL_PORT` environment variable to your container, 
in the `docker-compose.yml`, so it can be proxied, as of:

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

5. **sudo** options

If you need to save the nginx-proxy data files in a folder which the user running 'fresh-start.sh' script does not have access, you might accomplish that using _sudo_. In order to allow the script to run some commands with _sudo_ you need to set _true_ to the variable ['ALLOW_RUN_WITH_SUDO'](https://github.com/evertramos/nginx-proxy-automation/blob/d48b2477ed28cbda37738046079e35df219ba3e9/.env.sample#L20) at '.env.sample' file **before** running fresh-start.sh script, as of:

```bash
# Allow run commands with sudo if needed
ALLOW_RUN_WITH_SUDO=true
```

## Testing nginx-proxy

1. Run the script `test.sh` informing your domain already configured in your DNS to point out to your server as follow:

```bash
./test.sh your.domain.com
```

or simply run:

```bash
docker run -dit -e VIRTUAL_HOST=your.domain.com --network=proxy --name test-web httpd:alpine
```

> If you want to test the Let's Encrypt certificate as well use `ssl_test.sh your.domain.com`

Access your browser with your domain!

To stop and remove your test container run our `stop.sh` script:

```bash
./stop.sh
```

Or simply run:

```bash
docker stop test-web && docker rm test-web
```

## **PRODUCTION** ⚠️ [IMPORTANT]

If you are using this project in production enviroment, check all license involved and consider the following recomendation:

- [rootless docker](https://docs.docker.com/engine/security/rootless/)
- [docker compose files](https://docs.docker.com/compose/production/)

## Other projects using nginx-proxy
Following are links to docker containers using this web proxy:
1. [docker-wordpress-letsencrypt](https://github.com/evertramos/docker-wordpress-letsencrypt)
2. [docker-portainer-letsencrypt](https://github.com/evertramos/docker-portainer-letsencrypt)
3. [docker-nextcloud-letsencrypt](https://github.com/evertramos/docker-nextcloud-letsencrypt)
4. [docker-registry-letsencrypt](https://github.com/evertramos/docker-registry-letsencrypt)
5. [gitlab-docker-letsencrypt](https://github.com/steevepay/gitlab-docker-letsencrypt)
6. [docker-webtrees-letsencrypt](https://github.com/mstroppel/docker-webtrees-letsencrypt)

## Running this Proxy on a Synology NAS
Please checkout this [howto](https://github.com/evertramos/nginx-proxy-automation/blob/master/docs/HOWTO-Synlogy.md).


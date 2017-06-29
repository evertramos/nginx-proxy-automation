# Usage of Docker Compose (docker-compose) with NGINX proxy and Letsencrypt

Docker Compose (docker-compose) for [docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)


## Purpose

This docker-compose file, version '3', was built to help using NGINX as web proxy to your containers, integrated with LetsEncrypt certification, using the great work of [@jwilder](https://github.com/jwilder) with [docker-gen](https://github.com/jwilder/docker-gen) and [nginx-proxy](https://github.com/jwilder/nginx-proxy) along with the ultimate tool [docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) designed by [JrCs](https://github.com/JrCs) to integrate the great SSL Certificates from the best [LetsEncrypt](https://letsencrypt.org/).


## Usage

In order to use, you must follow these steps:

1. Clone this repository:

```bash
git clone https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion.git
```

Or just copy the content of `docker-compose.yml`, as of below:

```bash
version: '3'
services:
  nginx:
    image: nginx
    labels:
        com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy: "true"
    container_name: nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /path/to/your/nginx/data/conf.d:/etc/nginx/conf.d
      - /path/to/your/nginx/data/vhost.d:/etc/nginx/vhost.d
      - /path/to/your/nginx/data/html:/usr/share/nginx/html
      - /path/to/your/nginx/data/certs:/etc/nginx/certs:ro

  nginx-gen:
    image: jwilder/docker-gen
    command: -notify-sighup nginx -watch -wait 5s:30s /etc/docker-gen/templates/nginx.tmpl /etc/nginx/conf.d/default.conf
    container_name: nginx-gen
    restart: unless-stopped
    volumes:
      - /path/to/your/nginx/data/conf.d:/etc/nginx/conf.d
      - /path/to/your/nginx/data/vhost.d:/etc/nginx/vhost.d
      - /path/to/your/nginx/data/html:/usr/share/nginx/html
      - /path/to/your/nginx/data/certs:/etc/nginx/certs:ro
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - ./nginx.tmpl:/etc/docker-gen/templates/nginx.tmpl:ro

  nginx-letsencrypt:
    image: jrcs/letsencrypt-nginx-proxy-companion
    container_name: nginx-letsencrypt
    restart: unless-stopped
    volumes:
      - /path/to/your/nginx/data/conf.d:/etc/nginx/conf.d
      - /path/to/your/nginx/data/vhost.d:/etc/nginx/vhost.d
      - /path/to/your/nginx/data/html:/usr/share/nginx/html
      - /path/to/your/nginx/data/certs:/etc/nginx/certs:rw
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      NGINX_DOCKER_GEN_CONTAINER: "nginx-gen"
```

2. Change the file `docker-compose.yml` with you own settings:

2.1. Use a specific network (optional)

In order to use an specific network add the following lines at the end of your file:
```bash
networks:
  default:
    external:
      name: your-network-name
```

2.2. Set your IP address (optional)

On the line `ports` add as follow:
```bash
    ports:
      - "YOUR_PUBLIC_IP:80:80"
      - "YOUR_PUBLIC_IP:443:443"

```

2.3. Change the configuration path where you will locate the nginx files

```bash
    volumes:
      - /CHANGE/HERE/conf.d:/etc/nginx/conf.d
      - /CHANGE/HERE/vhost.d:/etc/nginx/vhost.d
      - /CHANGE/HERE/html:/usr/share/nginx/html
```

3. Get the latest version of **nginx.tmpl** file (only if you have not cloned this repostiry)

```bash
curl https://raw.githubusercontent.com/jwilder/nginx-proxy/master/nginx.tmpl > nginx.tmpl
```
Make sure you are in the same folder of docker-compose file, if not, you must update the the settings `- ./nginx.tmpl:/etc/docker-gen/templates/nginx.tmpl:ro`.

4. Start your project
```bash
docker-compose up -d
```

> Please note that when running a new container to generate certificates with LetsEncrypt it may take a few minutes, depending on multiples circunstances.


Your proxy is ready to go!


## Next Step


### If you want to test how it works please check this working sample (docker-compose.yml)

[wordpress-docker-letsencrypt](https://github.com/evertramos/wordpress-docker-letsencrypt)

Or you can run your own containers with the option `-e VIRTUAL_HOST=foo.bar.com` alongside with `LETSENCRYPT_HOST=foo.bar.com`, exposing port 80 and 443, and your certificate will be generated and always valid.


## Credits

All credits goes to:
1. [@jwilder](https://github.com/jwilder/nginx-proxy)
2. [@JrCs](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)

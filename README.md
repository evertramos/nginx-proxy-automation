# Web Proxy using Docker, NGINX and Let's Encrypt

With this repo you will be able to set up your server with multiple sites using a single NGINX proxy to manage your connections, automating your apps container (port 80 and 443) to auto renew your ssl certificates with Let´s Encrypt.


More information on https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion

## How to use it

1. Clone this repository:

```bash
git clone https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion.git
```

2. Make a copy of our `.env.sample` and rename it to `.env`:

Copy & edit the environment variables for your requirements

```bash
cp .env.sample .env
nano .env
```

4. Run our start script

```bash
# ./start.sh
```

Your proxy is ready to go!

## Starting your web containers

You can see an example app on /exampleapp with a docker-compose.
Copy the .env.sample to .env and edit the variables accordingly

- NETWORK: the network you choose for the web proxy
- DOMAINS: the domains that you want ot register for SSL
- LETSENCRYPT_EMAIL: the mails for registering the domain

In case your image is exposing multiple ports, you need to precise which one to proxy with the variable `VIRTUAL_PORT`.

## Credits

Without the repositories below this webproxy wouldn´t be possible.

Credits goes to:
- docker-compose-letsencrypt-nginx-proxy-companion [@evertramos](https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion)
- nginx-proxy [@jwilder](https://github.com/jwilder/nginx-proxy)
- docker-gen [@jwilder](https://github.com/jwilder/docker-gen)
- docker-letsencrypt-nginx-proxy-companion [@JrCs](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)

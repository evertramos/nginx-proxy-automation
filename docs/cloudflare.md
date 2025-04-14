# Cloudflare integration

If using Cloudflare services, an API Token to allow your server to validate your domain with DNS-01 might be needed.

> We recommend using Cloudflare for a couple of reasons...

Follow the steps below to use DNS-01:

## 1. Generate an API Token for ACME DNS-01

In Cloudflare go to your profile and find API Token option:
![image](https://github.com/user-attachments/assets/bbc3d316-7f71-4022-abf5-dfe0e704dadf)

You can manually create one or use the _'Edit zone DNS'_ template. Remember to add your domains which you would like to allow this token to have access to it and the source IP address:
![image](https://github.com/user-attachments/assets/42bc2833-6ddb-44ac-9e6b-cea72d0f0ee5)

Save your token and place it in .env at CLOUDFLARE_DNS_TOKEN.

## 2. Activate in your nginx proxy

Uncomment the following lines:
https://github.com/evertramos/nginx-proxy-automation/blob/462b224ce4fd9dce4b2b796e2b4524d4ee36b084/docker-compose.yml#L63-L66

And restart your service running `docker compose up &` at your root folder.

## Disclaimer

As of [acme-compnation](https://github.com/nginx-proxy/acme-companion) if we can not comply to use HTTP-01, using DNS-01 could be used, as also per [acme.sh](https://github.com/acmesh-official/acme.sh/wiki/dnsapi) as well.
So, following [acme-compnation instruction ](https://github.com/nginx-proxy/acme-companion/blob/main/docs/Let's-Encrypt-and-ACME.md#dns-01-acme-challenge) a global API Key could be used, but we do not like this idea much due to security resons, reason why we suggest creating a more restrict API Token as indicated above.


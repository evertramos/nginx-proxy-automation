
# NGINX Proxy Automation 🔥

<p align="center">
   <a target="_blank" href="https://docs.docker.com/"><img src="https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white" /></a>
   <a target="_blank" href="https://docs.nginx.com/"><img src="https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white" /></a>
   <a target="_blank" href="https://developer.wordpress.org/"><img src="https://img.shields.io/badge/Wordpress-21759B?style=for-the-badge&logo=wordpress&logoColor=white" /></a>
</p>
<p align="center">
   <a target="_blank" href="https://letsencrypt.org/docs/"><img src="https://img.shields.io/badge/Secured_by-Let's_Encrypt-blue.svg?logo=let%E2%80%99s-encrypt" /></a>
</p>

<p align="center">
   <img src="https://github.com/evertramos/images/raw/master/webproxy.jpg" />
</p>

## How to start 🔰
[![shell script](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://github.com/evertramos)


1. Clone this repository using the option **_--recurse-submodules_** ⚠️

```bash
git clone --recurse-submodules https://github.com/evertramos/nginx-proxy-automation.git proxy 
```

We use submodule for [basescript](https://github.com/evertramos/basescript)

2. 🚀 Run the script 'fresh_start.sh' from the _./proxy/bin_ folder
   
```bash
cd proxy/bin && ./fresh-start.sh --yes --skip-docker-image-check -e your_email@domain
```

Update the email above with your real e-mail address

3. 🧪 Test the proxy

```bash
docker run -dit -e VIRTUAL_HOST=your.domain.com --network=proxy --name test-web httpd:alpine
```
or simply run:
```bash
./test.sh your.domain.com
```

Use your own domain name when testing this proxy and make sure your DNS is correctly configured.

## Video Tutorial 🎥

I made a tutorial video to walk you through this project:

[![youtube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/channel/UCN5wb0eA3ZLlvJNYo23qBRQ)

### AWS EC2
<p align="center">
   <a target="_blank" href="https://www.youtube.com/watch?v=agg1VxAyoUQ"><img src="https://img.youtube.com/vi/agg1VxAyoUQ/0.jpg" /></a>
</p>

### Digital Ocean Droplet
<p align="center">
   <a target="_blank" href="https://www.youtube.com/watch?v=iXQPaY5xd3I"><img src="https://img.youtube.com/vi/iXQPaY5xd3I/0.jpg" /></a>
</p>

### OVH
<p align="center">
   <a target="_blank" href="https://www.youtube.com/watch?v=eiTivLeIkm0"><img src="https://img.youtube.com/vi/eiTivLeIkm0/0.jpg" /></a>
</p>

## Server Automation 🚀

Make user you try our [Server Automation](https://github.com/evertramos/server-automation)

[https://github.com/evertramos/server-automation](https://github.com/evertramos/server-automation)

## Further information 📓

For more installation details please [click here](/docs/).

## Supporting ♥️
[![Patreon](https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white)](https://www.patreon.com/evertramos)
[![image](https://img.shields.io/badge/picpay-21C25E?style=for-the-badge&logo=picpay&logoColor=white)](https://picpay.me/evert.ramos)

[List of all supporters](https://github.com/evertramos/evertramos/blob/main/pages/supporters.md).

## Code Contributors

[<img src="https://opencollective.com/nginx-proxy-automation/contributors.svg?width=890&button=false" />](https://opencollective.com/nginx-proxy-automation)

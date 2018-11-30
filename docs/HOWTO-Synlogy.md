## Port mapping
Synology default installs a web server on port 80 blocking certificate generation. 

To circumvent this - if you do not need external access to the default web server (and you should not expose it anyway) configure your .env to use alternative ports and your router to forward the external official port to the alternative internal ports:

#
# Set the local exposed ports for http and https - this will allow you to run with a legacy web 
# server already installed for local use
#
# NOTE: For this to function your internet router must forward the official ports to the mapped ports - 
#       in this example external port 80 to docker host 81 and external port 443 to docker host 444
#
DOCKER_HTTP=81
DOCKER_HTTPS=444

## File permissions
To setup the needed configuration directoties and proper permissions run the below commands (assuming default ./data is where you have your catalog for persistent files)

mkdir -p data/certs
mkdir data/htpasswd
mkdir data/conf.d
mkdir data/vhost.d
mkdir data/html
chgrp -R 101 data
chmod -R g+rwx data

Contributed by https://github.com/nicolailang/

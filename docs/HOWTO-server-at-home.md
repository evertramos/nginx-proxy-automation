# Home Server Testing
This document provides basic troubleshooting for setting up `nginx-proxy-automation` on a home server. This includes the most common issues, but does not include all possible issues.

Before following these steps, be sure to understand and follow all instructions in the primary [README](https://github.com/evertramos/nginx-proxy-automation/blob/master/docs/README.md) documentation.

## Debugging Failed Connections

Start diagnosing as close to the server as possible, then move outwards.

For testing ports, here is a list of common network command line (cli) tools for use:
 - [nmap](https://nmap.org)
 - [netcat](https://sectools.org/tool/netcat/)
 - [telnet](https://manpages.org/telnet)

1. Without using `nginx-proxy-automation`, run the container on the server, open the port as you normally would (i.e. `-p 9000:9000`), and attempt to see if the port is available (on the server) after running. You can test if the port is open using one of the common network cli tools, or other possible tools (i.e. [netstat](https://linux.die.net/man/8/netstat)). For example if you have exposed port 9000, running `nmap -p 9000 localhost` on the same server as the running Docker container, and it should return an open port. This tests if you may have a general issue with your docker setup. On failure, double check if you have setup any custom firewall rules or have setup `ufw` with Docker.
2. Perform the same steps as 1, but try testing the port from a different machine on the same subnet / LAN if possible. For example, running `nmap -p 9000 {SERVER-IP-ADDRESS}` should show an open connection. This tests if the server is exposing ports at all. This tests if you may have a firewall issue on the server that needs diagnosed. On failure, double check if you have setup any custom firewall rules or have setup `ufw` with Docker.
3. If you are using port forwarding on a router: Without using `nginx-proxy-automation`, run the container on the server, open the port as you normally would, and forwarding the port from the router to specified open port. Then you can run `nmap -p 9000 {PUBLIC-ROUTER-IP-ADDRESS-OR-DOMAIN-NAME}`, and it should show an open connection. This will test if you have properly forwarded the port. On failure, you will need to diagnose your port forwarding rules, and may need to consult your router manual. Be sure you are **not** using the local IP address of your router (i.e. 192.168.1.1 is a common local IP address, and that will not work for this test).

## Port Forwarding
If you are using port forwarding, it is highly recommended to connect via your own registered domain using [DDNS](https://en.wikipedia.org/wiki/Dynamic_DNS). There is a chance your ISP will change the public address of your router. Using DDNS will ensure that the domain pointing to your router is using the latest public IP address of your router.

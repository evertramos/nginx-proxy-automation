# Upgrading guide

Here we will try to cover all aspects we faced in a real production environment when migrating from the previous version of this project to the newst version.

## From v0.4 to v0.5

The version v0.5 was a big step into automation. We 'conquer the world'!

> I update one of the production server and got a _96 seconds_ of downtime, with no complaint from clients. 
> Some of them did not even notice, but all were advised about the update and the possible downtime in case of failure.

> If you can not afford this downtime there is a couple way around on this but you will need
a couple things... new server (temporary), set a dns rules to create the new certificates 
copy all files to the new server and do the following, after all is ready, redirect the dns 
to the new server and than copy the temp server to the production, fire all services, test 
and redirect the dns to the new server. Be aware that changes made during this proccess might
need to be updated in the containers when syncing files from one server to another.

So, let's go. First thing first!

1. Backup EVERYTHING! I would suggest backup in the server and somewhere else (not in the server)

2. Update the git repo with the new version (:warning:)

   2.1 Copy _docker-compose.yml_ (or the _docker-compose-multiple-networks.yml_ if you used this option) and _.env_ file

   ```bash
   $ cp docker-compose.yml docker-compose-old.yml
   $ cp .env .env-old
   ```
   
   > We will use this do stop the current services 

   2.2 Reset all changes in the repo

   This is required to update to the latest version
   
   ```bash
   $ git reset --hard
   ```
   
   2.3 Pull and Checkout master

   ```bash
   $ git pull origin master
   $ git checkout master
   ```
   
   2.4 Set the **basescript** submodule

   If you notice the submodule folder used in this project ([basescript](https://github.com/evertramos/basescript/)) 
   is present in the master branch we just checkout, but it is empty, so we need to fix it (init and update).

   ```bash
   $ git submodule init
   $ git submodule update
   ```

    > The _basescript_ folder should not be empty after the commands above

3. Run the _fresh-start.sh_ script (:construction:)

    Here we will run the _fresh-start.sh_ script in order to create all new settings that we will use.
    Please do it carefully. You might use different names for proxy services.
    
    ```bash
    $ cd bin
    $ ./fresh-start.sh
    ```
    
    In most cases you will get the following _'error'_, which is expected:
    
    ![fresh-start-expected-error](https://user-images.githubusercontent.com/905951/113016796-33aaa080-9155-11eb-845d-aa712294236d.png)

    The error above is related to port binding, once port 80 is already binded to the current nginx-proxy container.
    
    > [IMPORTANT] If you use the *same service name* for all containers and the same network name you might not receive the error above
    > and you should be ready to go at this point. Check the your running sites at the browser to see if everything is up and running.

    ⚠️ if you do not get the error above and your sites are NOT working, you might checkthe network name and go for the next item.

4. Adding the running containers to the new network

    If you keep the same network name you might skip this item, but if not, you must add all running containers to the new network 
    created by the _fresh-start.sh_ script.
    
    ```bash
    $ docker network connect [YOUR_NEW_NETWORK_NAME] [CONTAINER_NAME]
    ```
    
    > Run the command above for all containers connected to the proxy and remember to update the network name in the docker-compose file 
    > for the all sites 

5. Restart proxy with new service

    At this point all sites should be still up and running, so keep it cool and let's see if all will work as expected.
    
    After all containers are connected to the new proxy network (if the case) you will stop the current proxy services and start the new one.
    We did it in one command line to reduce the downtime. 

    ```bash
    $ docker-compose --file docker-compose-old.yml down && docker-compose up -d
    ```
    
    Check your sites to see if it is all running, if some of them are not working, you might check the letsencrypt container logs to see if
    there was a problem issuing new certificates. 
    
    If something else happen and you must reverse it quickly just follow the next step. But try to check the logs first, it might take a few
    minutes to fire new certificates with Let's Encrypt so, depending on the quantity of sites you are running in your server it might take 
    some time to issue it all. 
   
6. Reverting to the old proxy

    You can retore backup files and start the same exact environmen you had previously this upgrade guide, but there is a quicker way to restore your sites. 
    Just run the following:
        
    ```bash
    $ docker-compose down && docker-compose --file docker-compose-old.yml --env-file .env-old up -d
    ```
    
    > The command above will stop the new version and fire the previous version of your proxy, so, after this command evertyhing should 'be back to normal'
    > as it was before the update, but keep in mind to find the errors if they occured and update it.

7. Clean up

    After having all work done you might remove unused file such as:
    

    ```bash
    $ rm docker-compose-old.yml .env-old
    ```

> If you get any erros when updating please post on the [**upgrade discussion**](https://github.com/evertramos/basescript/discussions/5) (avoid creating new issues). 

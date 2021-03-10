#!/bin/bash
echo "script not in use..."
exit 0

# Stop and remove test enviornment
docker stop test-web && docker rm test-web 

exit 0

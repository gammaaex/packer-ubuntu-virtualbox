#!/bin/sh

echo "--------------------- Start: deploy.sh ---------------------"

# Stop and Remove containers
docker-compose down
# Pull new image
docker-compose pull
# Create and Start containers
docker-compose up -d

echo -e "\nhooked\n"

echo "--------------------- Finish: deploy.sh ---------------------"

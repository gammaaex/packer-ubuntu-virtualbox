#!/bin/sh

echo "--------------------- Start: deploy.sh ---------------------"

DOCKER_COMPOSE=/usr/local/bin/docker-compose

# Stop and Remove containers
$DOCKER_COMPOSE down
# Pull new image
$DOCKER_COMPOSE pull
# Create and Start containers
$DOCKER_COMPOSE up -d
# Execute database migration
$DOCKER_COMPOSE exec -T apache /bin/bash -c "dbmate wait && dbmate up"
# Write deploy log
date >> deploy.log

echo "--------------------- Finish: deploy.sh ---------------------"

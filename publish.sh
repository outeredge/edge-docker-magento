#!/bin/bash

if [ -z "$1" ]; then
    echo "No version specified, exiting!"
    exit
fi;

if [ -z "$MAGENTO_COMPOSER_AUTH" ]; then
    echo "No \$MAGENTO_COMPOSER_AUTH value set, exiting!"
    exit
fi;

if [ ! -z "$DOCKER_PASS" ]; then
    echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
fi;

echo "Building image outeredge/edge-docker-magento:$1 with Dockerfile.$1"
DOCKER_BUILDKIT=1 docker build --build-arg COMPOSER_AUTH=$MAGENTO_COMPOSER_AUTH --pull . -t outeredge/edge-docker-magento:$1 -f Dockerfile.$1 && \
docker push outeredge/edge-docker-magento:$1 && \
echo "Complete!"

#!/bin/bash

baseimage="ghcr.io/hotio/sonarr:release"

docker pull ghcr.io/$GITHUB_REPOSITORY
docker pull $baseimage

image_baseimage=`docker inspect ghcr.io/$GITHUB_REPOSITORY --format '{{ index .Config.Labels "org.opencontainers.image.base.digest"}}'`
image_sma_ref=`docker inspect ghcr.io/$GITHUB_REPOSITORY --format '{{ index .Config.Labels "sma_revision"}}'`

current_baseimage_ref=`docker inspect $baseimage --format '{{ index .Config.Labels "org.opencontainers.image.revision"}}'`
current_sma_ref=`curl -sX GET "https://api.github.com/repos/mdhiggins/sickbeard_mp4_automator/commits/master" | jq '.sha' | tr -d '"'`


if [ $image_baseimage != $current_baseimage_ref ]
then
    echo "New base image is available."
    build=1
fi
if [ $image_sma_ref != $current_sma_ref ]
then
    echo "New version of sickbeard_mp4_automator is available."
    build=1
fi

if [[ $build ]]
then
    echo "Triggering build."
    echo "::set-output name=build::true"
else
    echo "No build needed."
    echo "::set-output name=build::false"
fi

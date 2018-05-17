#!/usr/bin/env bash
set -x -e

if [ $# -ne 3 ]
then
    echo "$0 [dockerhub account] [dockerhub password] [imageid]"
    exit
fi
echo "docker account name=$1"
echo "docker account passwd=$2"
echo "image id=$3"

{
docker login -u "$1" -p "$2"
version=`cat ./VERSION`
tag="$version"
echo "tag=$tag"
docker tag $3 "$1"/wildfly-ticketmonster-ha:$tag
docker push "$1"/wildfly-ticketmonster-ha:$tag
docker logout
} 2>&1 | tee push.log 

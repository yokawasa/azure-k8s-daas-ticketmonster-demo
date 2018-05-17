#!/usr/bin/env bash
set -x -e

cwd=`dirname "$0"`
expr "$0" : "/.*" > /dev/null || cwd=`(cd "$cwd" && pwd)`

{
version=`cat VERSION`
tag="$version"
echo "tag=$tag"
docker build -t mod_cluster-dockerhub:$tag $cwd/.
} 2>&1 | tee build.log

#!/bin/sh
set -x -e

cwd=`dirname "$0"`
expr "$0" : "/.*" > /dev/null || cwd=`(cd "$cwd" && pwd)`

version=`cat $cwd/VERSION`
tag="$version"
docker run -d -P -i mod_cluster-dockerhub:0.0.1

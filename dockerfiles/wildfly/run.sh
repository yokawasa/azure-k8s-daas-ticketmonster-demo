#!/bin/bash

cwd=`dirname "$0"`
expr "$0" : "/.*" > /dev/null || cwd=`(cd "$cwd" && pwd)`

version=`cat $cwd/VERSION`
tag="$version"

## locally run with executing bash
docker run --rm \
    -v $cwd/.:/var/tmp \
    -it wildfly-ticketmonster-ha:$tag /bin/bash

## locally run wildfly
#docker run --rm \
#    -v $cwd/.:/var/tmp \
#    -it wildfly-ticketmonster-ha:$tag

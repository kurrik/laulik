#!/usr/bin/env bash

source `git rev-parse --show-toplevel`/scripts/common.sh

method=${1:-server}
project=${2:-voluja}

name=laulik

args=""
if [ "${MAP_SRC:-yes}" == "yes" ]; then
  green "[run]" "Mapping src path"
  args="$args -v `pwd`/src:/opt/laulik/src:ro"
fi
if [ "${MAP_DATA:-yes}" == "yes" ]; then
  green "[run]" "Mapping data and build paths"
  args="$args -v `pwd`:/opt/laulik-repo:rw"
fi

docker rm -f $name

if [ "$method" == "shell" ]; then
  docker run \
    -it \
    --entrypoint /bin/bash \
    laulik
else
  PORT=8080
  docker run \
    -it \
    -p $PORT:5000 \
    -e "METHOD=$method" \
    -e "PROJECT=$project" \
    -e "DEBUG=true" \
    -e "PORT=5000" \
    --name=$name \
    $args \
    laulik
fi
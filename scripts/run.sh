#!/usr/bin/env bash

source `git rev-parse --show-toplevel`/scripts/common.sh

method=${1:-server}

name=laulik

args=""
if [ "${MAP_SRC:-yes}" == "yes" ]; then
  green "[run]" "Mapping src path"
  args="$args -v `pwd`/src:/opt/laulik/src:ro"
fi
if [ "${MAP_DATA:-yes}" == "yes" ]; then
  green "[run]" "Mapping data and build paths"
  args="$args -v `pwd`/build:/opt/laulik-repo/build:rw"
  args="$args -v `pwd`/data:/opt/laulik-repo/data:rw"
fi

docker rm -f $name

docker run \
  -it \
  -p 80:5000 \
  -e "METHOD=$method" \
  --name=$name \
  $args \
  laulik

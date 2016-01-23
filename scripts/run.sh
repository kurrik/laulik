#!/usr/bin/env bash

source `git rev-parse --show-toplevel`/scripts/common.sh

method=${1:-server}

name=laulik

docker rm -f $name

docker run \
  -it \
  -p 80:5000 \
  -e "METHOD=$method" \
  --name=$name \
  -v `pwd`/data:/opt/laulik/data:ro \
  -v `pwd`/build:/opt/laulik/build:rw \
  -v `pwd`/src/server:/opt/laulik/server:ro \
  -v `pwd`/src/common:/opt/laulik/common:ro \
  laulik

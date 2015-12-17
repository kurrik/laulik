#/usr/bin/env bash

source `git rev-parse --show-toplevel`/scripts/common.sh

name=laulik

docker rm $name

docker run \
  -it \
  --name=$name \
  -v `pwd`/data:/opt/laulik/data:ro \
  -v `pwd`/build:/opt/laulik/build:rw \
  laulik

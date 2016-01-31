#!/usr/bin/env bash

source ./src/common/common.sh

METHOD=${METHOD:-server}

case "$METHOD" in
  server)
    output "[main] Running server"
    ./src/server/server.sh
    ;;
  laulik)
    output "[main] Running laulik"
    ./src/compiler/laulik.sh
    ;;
  *)
    output "[main] Unknown method $METHOD"
    exit 1
esac
